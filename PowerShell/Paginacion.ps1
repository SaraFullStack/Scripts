Clear-Host

#Tamaño de paginación segun la unidad en megas
$TamañoPaginacion= (Get-WmiObject -Class Win32_PageFileusage | Select-Object -Property AllocatedBaseSize).AllocatedBaseSize
 
#RAM del equipo
[int]$TamañoRAM= ((Get-WmiObject -Class Win32_ComputerSystem).TotalPhysicalMemory)/(1024*1024)

Write-Host "El tamaño de fichero de paginacion es: $TamañoPaginacion Megas"
Write-Host "El tamaño de la ram es: $TamañoRAM Megas"

if($TamañoRAM -le 1024){

	if(($TamañoPaginacion -ge (3.5*$TamañoRAM)) -Or ($TamañoPaginacion -le (1.5*$TamañoRAM))){ Write-Host "Tamaño de fichero de paginación no es optimo" }

}
elseif($TamañoRAM -ge 1024){

	if(($TamañoPaginacion -ge (3.5*$TamañoRAM)) -Or ($TamañoPaginacion -le (400+$TamañoRAM))){ Write-Host "Tamaño de fichero de paginación no es optimo" }

}
else{ Write-Host "el fichero de paginacion principal C:\PAGEFILE.SYS con tamaño:$TamañoPaginacion esta dentro del rango optimo" }

do{

	Write-Host "Quieres crear un nuevo fichero de paginacion?"
	$opcion= Read-Host "S/N:_ "

	if(($opcion -eq "S") -or ($opcion -eq "s")){

		Write-Host "En que unidad quieres crear el fichero de paginacion?"
		$Unidad= Read-Host "Unidad:_"

		if ("\DosDevices\$Unidad" -in (Get-Item -Path HKLM:\SYSTEM\MountedDevices).Property){
        		
			$Minimo = Read-Host "Tamaño minimo de fichero de paginacion en Mb"
        	$Maximo = Read-Host "Tamaño maximo de fichero de paginacion en Mb"
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