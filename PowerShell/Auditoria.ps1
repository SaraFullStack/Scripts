Clear-Host

$action= new-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-File C:\Documentos\Scripts\Auditoria.ps1'   
#Ejecutar este SCRIPT entero en Powershell
$trigger= new-ScheduledTaskTrigger -Daily -DaysInterval 15 -At 23:59
#En este momento
$trigger.startBoundary='1/3/2017T23:59:00'
#T para separarlo
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Comprobar Hash" 

#Recogemos todos los *.exe con sus deferentes Hash en el formato especificado
Get-ChildItem -Path "C:\Windows\System32\*.exe" | ForEach-Object {

	$Hash256= (Get-FileHash -Path $_.FullName -Algorithm SHA256 )
	$Hash512= (Get-FileHash -Path $_.FullName -Algorithm SHA512  ) 
	$HashMD5= (Get-FileHash -Path $_.FullName -Algorithm MD5 )
	Write-OutPut ($_.FullName + ":" + $HashMD5.Hash + ":" + $Hash256.Hash + ":" + $Hash512.Hash) >> C:\Users\Motoko\Documents\h\HASH_EXE.TXT

}

#Comprobamos la existencia de la carpeta Cuarentena, y de no existir se crea
$Cuarentena= "C:\CUARENTENA"
$Existe= Test-Path $Cuarentena
if ($Existe -ne $true){

	New-Item -Path "C:\" -Name "CUARENTENA" -ItemType "directory" 

}

#Escribimos las diferencias en un tercer archivo
Write-Output (Compare-Object -ReferenceObject $(Get-Content 'C:\Users\Motoko\Documents\h\HASH1.TXT') -DifferenceObject $(Get-Content 'C:\Users\Motoko\Documents\h\HASH_EXE.TXT')) >> 'C:\Users\Motoko\Documents\h\HASH_EXE2.TXT'

#Si el contenido no es nulo, llevamos los archivos dañados a Cuarentena, si es nulo no hay diferencias
if((Get-Content C:\Users\Motoko\Documents\h\HASH_EXE2.TXT) -ne $null){

	#Comprobamos la existencia del EventLog, de no existir lo creamos para poder enviar el mensaje
	if ([System.Diagnostics.EventLog]::SourceExists("Analisis de auditoria") -eq $false){

        	New-EventLog -LogName Application -Source "Analisis de auditoria"
	}
   
	
     #Dividimos el archivo para recoger unicamente las direcciones del archivo diferente	
    (Get-Content C:\Users\Motoko\Documents\h\HASH_EXE2.TXT).Split("`n") | ForEach-Object { 

        $Ruta= ($_.Split("\")[0] + $_.Split(":")[1]) 

        if($Ruta.Chars(0) -eq "C"){

	    #Cambiamos permisos para poder mover el archivo, lo movemos y mandamos el mensaje al EventLog
            $acl = (Get-Item $Ruta).GetAccessControl('Access')
            $ace = New-Object System.Security.AccessControl.FileSystemAccessRule ($env:USERNAME , "FullControl","Allow")
            $acl.AddAccessRule($ace)
            Set-Acl -AclObject $acl -Path $Ruta

            Move-Item $Ruta 'C:\CUARENTENA' -ErrorAction SilentlyContinue
            Write-EventLog -LogName Application -Source "Analisis de auditoria" -EntryType Information -EventId 1 -Message "$Ruta : Hash Modificado"
             
	}

        else{ Write-Host Direccion no valida }
    }
}

else{ Write-Host "No hay ninguna diferencia" }