Clear-Host
#_. -> del sistema
$UserName = Read-Host "¿Cuál es el usuario que inició sesion?"
Get-Process -IncludeUserName | Where-Object {$_.UserName -eq "$UserName"} | Where-Object {$_.StartTime -gt 1}
#Listado de procesos del usuario que inicio sesion y llevan mas de 1'

do{
Write-host "1.aumentar su prioridad a High (comprobar que la ha cambiado, por defecto esta a NORMAL)"
Write-Host "2.matar el proceso."
Write-Host "3---SALIR----"
$opcion=Read-Host "Elije opcion"
if($opcion -eq "1")
{
$ProcesoAumentar = Read-Host "Que proceso deseas poner a High?"
if(Get-Process -Name $ProcesoAumentar)
{
$ProcesoAumentado= Get-Process -Name $ProcesoAumentar CALL setpriority "High"
Write-EventLog -LogName Aplication -Message "$ProcesoAumentado a las Get-Date -Format HH:MM:SS" -EventId 1
Get-Process -Name $ProcesoAumentado
}
else{Write-Host "No existe ningun proceso con ese nombre"}
}
elseif($opcion -eq "2")
{
$ProcesoMatar = Read-Host "Que proceso deseas matar?"
if(Get-Process -Name $ProcesoMatar)
{
$ProcesoMuerto = Get-Process -Name $ProcesoMatar
Write-EventLog -LogName Aplication -Message "$ProcesoMuerto a las Get-Date -Format HH:MM:SS" -EventId 1
$ProcesoMuerto.Kill()
}
else{Write-Host "No existe ningun proceso con ese nombre"}
}
elseif($opcion -eq "3")
{
Write-Host "Adios"
break
}
else
{
Write-Host "te has equivocado"
}
}While(True)