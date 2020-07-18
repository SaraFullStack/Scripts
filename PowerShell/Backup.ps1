Clear-Host

$Usuario= [Security.Principal.WindowsIdentity]::GetCurrent()
#Con el usuario voy a la clase WindowsIdentity donde estan registrados los usuarios en otro archivo y crea un objeto que representa el usuario actual.
$UsuarioAdministrador= (New-Object Security.Principal.WindowsPrincipal $Usuario).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
#Crea un nuevo objeto sobre el objeto que ya teniamos como usuario y comprueba si su rol es administrador.

if ($UsuarioAdministrador){

	$action= new-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-File C:\Users\nombre_usuario'   
	#Ejecutar este SCRIPT entero en Powershell
	$trigger= new-ScheduledTaskTrigger -Daily -DaysInterval 7 -At 23:59
	#En este momento
	$trigger.startBoundary='3/3/2017T23:59:00'
	#T para separarlo
	Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Comprobar Hash" 

    $FicheroError= "C:\ERORES_EN_BACKUP"
    $Existe= Test-Path $FicheroError
    if ($Existe -ne $true){

	    New-Item -Path "C:\" -Name "ERORES_EN_BACKUP" -ItemType File

    }
	
    ($Usuario= (Get-ADUser -Filter *)) | ForEach-Object{

    $BackupHora= Get-Date -Date "-" -Month "-" -Year "-" -Hour "." -Minute
	$Backup= New-Item -Path "C:\" -Name "BACKUP-$Usuario-$BackupHora" -ItemType Directory

    $Directorio= Get-AdUser $Usuario -Properties HomeDirectory
	Copy-Item $Directorio $Backup -Recurse -ErrorVariable capturaDeErrores -ErrorAction SilentlyContinue
	
    $capturaDeErrores | ForEach-Object { Write-Output "Error al copiar $Directorio" >> C:\Errores_EN_BACKUP\Errores }
    
    }
    	}

else
	{
	Write-Host "No eres administrador losiento,adios"
	}