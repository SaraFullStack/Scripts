Clear-Host

#Tama�o de paginaci�n segun la unidad en megas
$Tama�oPaginacion= (Get-WmiObject -Class Win32_PageFileusage | Select-Object -Property AllocatedBaseSize).AllocatedBaseSize
 
#RAM del equipo
[int]$Tama�oRAM= ((Get-WmiObject -Class Win32_ComputerSystem).TotalPhysicalMemory)/(1024*1024)

Write-Host "El tama�o de fichero de paginacion es: $Tama�oPaginacion Megas"
Write-Host "El tama�o de la ram es: $Tama�oRAM Megas"

if($Tama�oRAM -le 1024){

	if(($Tama�oPaginacion -ge (3.5*$Tama�oRAM)) -Or ($Tama�oPaginacion -le (1.5*$Tama�oRAM))){ Write-Host "Tama�o de fichero de paginaci�n no es optimo" }

}
elseif($Tama�oRAM -ge 1024){

	if(($Tama�oPaginacion -ge (3.5*$Tama�oRAM)) -Or ($Tama�oPaginacion -le (400+$Tama�oRAM))){ Write-Host "Tama�o de fichero de paginaci�n no es optimo" }

}
else{ Write-Host "el fichero de paginacion principal C:\PAGEFILE.SYS con tama�o:$Tama�oPaginacion esta dentro del rango optimo" }

do{

	Write-Host "Quieres crear un nuevo fichero de paginacion?"
	$opcion= Read-Host "S/N:_ "

	if(($opcion -eq "S") -or ($opcion -eq "s")){

		Write-Host "En que unidad quieres crear el fichero de paginacion?"
		$Unidad= Read-Host "Unidad:_"

		if ("\DosDevices\$Unidad" -in (Get-Item -Path HKLM:\SYSTEM\MountedDevices).Property){
        		
			$Minimo = Read-Host "Tama�o minimo de fichero de paginacion en Mb"
        	$Maximo = Read-Host "Tama�o maximo de fichero de paginacion en Mb"
            Set-WmiInstance -Class Win32_PageFileSetting -Arguments @{
                Name        = "$Unidad\pagefile.sys"
                InitialSize = $Minimo
                MaximumSize = $Maximo
            }
            Write-Host "Fichero de paginacion creado en $Unidad "
       
       		}else{ Write-Host "Unidad no encontrada." }

       Write-Host "Finalizo el programa, adios!"
       break

	}elseif(($opcion -eq "N") -or ($opcion -eq "n")){

		Write-Host "Programa finalizado, adios!"
		break
	
    }else{

		Write-Host Opcion insertada invalida, vuelva a intentarlo
	}

}While($true)