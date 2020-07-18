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

[int]$UsoFichero= ((Get-WmiObject -Class Win32_PageFileUsage).PeakUsage)

if($UsoFichero -ge 80){

    Write-Host El porcentaje de uso del archivo de paginacion es: $UsoFichero %, es superior al 80 %, creamos archivo nuevo del mismo tamaño que el actual
	$unidad= Read-Host "¿Donde quieres crearlo?"
	if (\DosDevices\$unidad -in (HKEY_LOCAL_MACHINE\SYSTEM\MountedDevices).Property){

	[int]$TamañoMinimo= $TamañoPaginacion
	[int]$TamañoMaximo=$TamañoPaginacion

	$paginacionDos=(Set-WmiInstance -class Win32_PageFileSetting -Arguments @{Name="$unidad\PageFile.sys";InitialSize=$TamañoMinimo;MaximumSize=$TamañoMaximo;})
    }

	if($UsoFichero -le 10){
	
		$privilegios = Get-WmiObject -Class Win32_computersystem -EnableAllPrivileges
		$privilegios.AutomaticManagedPagefile = $false
		$privilegios.Put()
		$paginacionDos.Delete()
		}

}else{ Write-Host El porcentaje de uso del archivo de paginacion es: $UsoFichero %, es correcto, no creamos archivos }