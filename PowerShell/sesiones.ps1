Clear-Host

$seguimiento= "C:\SEGUIMIENTO-SESIONES"
$Existe= Test-Path $seguimiento

    if ($Existe -ne $true){

	    New-Item -Path "C:\" -Name "SEGUIMIENTO-SESIONES" -ItemType Directory
        New-Item -Path "C:\SEGUIMIENTO-SESIONES" -Name "SESIONES-DIA-dd-mm-aaaa.txt" -ItemType File

    }

$InicioSesion= Get-EventLog -LogName "SECURITY" -InstanceId "4624"
$CierreSesion= Get-EventLog -LogName "SECURITY" -InstanceId "4647"
$Hora= Get-Date

Write-Host "DIA: $Hora" 
Write-Host "--------------------------------------"
Write-Host "usuario->inicio-sesion->cierre-sesion->duracion"
Write-Host "-------------------------------------------------------------"

$Usuario= Get-WmiObject -Class Win32_UserAccount | ForEach-Object{
    
	if ($InicioSesion){
	    $HoraInicio = $_.TimeGenerated
	    Write-Output (" -- "+ $Usuario + "Inicio de Sesion: " + $HoraInicio) >> C:\SEGUIMIENTO-SESIONES\SESIONES-DIA-dd-mm-aaaa.txt
	}
	
	if ($CierreSesion){
	$HoraCierre = $_.TimeGenerated
	Write-Output (" -- "+ $Usuario + "Cierre de Sesion: " + $HoraCierre) >> C:\SEGUIMIENTO-SESIONES\SESIONES-DIA-dd-mm-aaaa.txt}
	

$Duracion= $HoraCierre - $HoraInicio

Write-Host  " $Usuario->$HoraInicio->$HoraCierre->$Duracion"
}