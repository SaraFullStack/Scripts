Clear-Host

#Listado de procesos del usuario que inicio sesion y llevan mas de 1'
Get-Process | Where-Object { $_.StartInfo.EnvironmentVariables["USERNAME"] -eq $env:USERNAME } | Where-Object {($_.StartTime.Hour*60*60)+($_.StartTime.Minute*60)+($_.StartTime.Second) -gt 1}

#Solo se crea si ejecutas como administracion
if ([System.Diagnostics.EventLog]::SourceExists("Info") -eq $false){

        	New-EventLog -LogName Application -Source "Info"
	}

do{

    Write-Host "Escoja una opcion:"
    Write-Host "1. Aumentar su prioridad a High"
    Write-Host "2. Matar el proceso"
    Write-Host "3. Salir"

    $opcion= Read-Host "Opcion:_ "

    if($opcion -eq "1"){

	    $ProcesoAumentar = Read-Host "Que proceso deseas poner a High?"
	    if(Get-Process -Name $ProcesoAumentar){

    		$ProcesoAumentado= Get-Process -Name $ProcesoAumentar
            $ProcesoAumentado.PriorityClass= [System.Diagnostics.ProcessPriorityClass]::High
	    	Write-EventLog -LogName Application -Source "Info" -Message "Proceso: $ProcesoAumentar a aumentado su prioridad a las Get-Date -Format H:M:S" -EventId 1
		    Get-Process -Name $ProcesoAumentar

		}else{ Write-Host "No existe ningun proceso con ese nombre" }

	}elseif($opcion -eq "2"){

	    $ProcesoMatar = Read-Host "Que proceso deseas matar?"
	    if(Get-Process -Name $ProcesoMatar){

	    	Write-EventLog -LogName Application -Source "Info" -Message "Proceso: $ProcesoMatar a finalizado a las Get-Date -Format H:M:S" -EventId 1
		    TASKKILL /F /IM "$ProcesoMatar.exe"

		}else{ Write-Host "No existe ningun proceso con ese nombre" }

	}elseif($opcion -eq "3"){

    	Write-Host "Adios"
	    break
	}

}While($true)