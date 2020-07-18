Clear-Host

$servicioShared= Get-WmiObject - svchosts.exe -Class Win32_Service -Filter "state= 'running'" 
#Conseguimos los servicios de Win32 de tipo Shared con ese ejecutable, el where-Object saca solo los que se estén ejecutando

Write-Host "SERVICIOS SHARED RUNNING..."
Write-Host "nombre_servicio -> DLL -> PID-proceso -> num.threads"
Write-Host "----------------------------------------------------"

$servicioShared | ForEach-Object{

	$DLL= (Get-ItemProperty -Path ("Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\$servicioShared\parameters")).ServiceDLL
	#Abreme la dirección del registro, devuelveme del archivo la propiedad del servicio DLL
	$PID= $_.ProcessID
	#otra manera: (Get-WmiObject -class -Win32_Service -Filter 'ServicioShared = "SVCHOSTS.exe"' | Where-Object $_.Name).ProcessID
	$Hilos= ((Get-Process -Id $PID).Threads).Count
	# Recoger el proceso pasandole el PID para sacar sus hilos

	Write-Host "$servicioShared -> $DLL -> $PID -> $Hilos"

	}