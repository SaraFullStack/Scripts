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

[int]$UsoFichero= ((Get-WmiObject -Class Win32_PageFileUsage).PeakUsage)

if($UsoFichero -ge 80){

    Write-Host El porcentaje de uso del archivo de paginacion es: $UsoFichero %, es superior al 80 %, creamos archivo nuevo del mismo tama�o que el actual
	$unidad= Read-Host "�Donde quieres crearlo?"
	if (\DosDevices\$unidad -in (HKEY_LOCAL_MACHINE\SYSTEM\MountedDevices).Property){

	[int]$Tama�oMinimo= $Tama�oPaginacion
	[int]$Tama�oMaximo=$Tama�oPaginacion

	$paginacionDos=(Set-WmiInstance -class Win32_PageFileSetting -Arguments @{Name="$unidad\PageFile.sys";InitialSize=$Tama�oMinimo;MaximumSize=$Tama�oMaximo;})
    }

	if($UsoFichero -le 10){
	
		$privilegios = Get-WmiObject -Class Win32_computersystem -EnableAllPrivileges
		$privilegios.AutomaticManagedPagefile = $false
		$privilegios.Put()
		$paginacionDos.Delete()
		}

}else{ Write-Host El porcentaje de uso del archivo de paginacion es: $UsoFichero %, es correcto, no creamos archivos }