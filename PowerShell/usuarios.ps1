Clear-Host

$Usuario= [Security.Principal.WindowsIdentity]::GetCurrent()
#Con el usuario voy a la clase WindowsIdentity donde estan registrados los usuarios en otro archivo y crea un objeto que representa el usuario actual.
$UsuarioAdministrador= (New-Object Security.Principal.WindowsPrincipal $Usuario).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
#Crea un nuevo objeto sobre el objeto que ya teniamos como usuario y comprueba si su rol es administrador.

if ($UsuarioAdministrador){

	$archivo= Get-Childitem C:\GRUPOS_USUARIOS_NUEVOS.txt
	#Separamos el archivo linea a linea

	(Get-Content $archivo).Split("`n") | ForEach-Object{
		$maquina=[ADSI]"WinNT://$env:COMPUTERNAME,computer"
		#Obtenemos el nombre del grupo
		$nombre_grupo= $_.Split("$")[0]
		$nuevogrupo= $maquina.Create("group",$nombre_grupo)
		Write-Host "Grupo $nombre_grupo ha sido creado con SID:" (Get-StringSID -SID $nombre_grupo)
		
		#Sacamos la segunda parte para obtener todos los usuarios y contraseñas	
		$usuario = $_.Split("$")[1]
		#Separamos la linea para tener las parejas de usuario y contraseña
		$usuario.Split(",") | Foreach-Object{
			#Separamos para obtener en [0] el usuario y en [1] la contraseña
			$nombre=$_.Split(":")[0]
			$contrasena=$_.Split(":")[1]

			#Obtenemos todos los usuarios del sistema para compararlos con los obtenidos y ver si existen
			$UsuariosSistema=Get-ADUser -Filter * -Properties Name
			#Variable para que, si existe un usuario no se cree otra vez
			$EsIgual = $False
			$UsuarioSistema | ForEach-Object{
				if($nombre -eq $UsuarioSistema){
					$EsIgual = $true
				}	
			}
			if($EsIgual){
				Write-Host "El usuario $nombre ya existe en el sistema"
			}
			#Si no existe el usuario lo creamos
			else{
				#Creamos la maquin para ir creando el usurio y metiendolo en el grupo etc
				$Creacion=$maquina.Create("user",$nombre)
				$nuevogrupo.Add("WinNT://$env:COMPUTERNAME/$nombre,user")
				$Creacion.SetPassWord($contrasena)
				Write-Host "Usuario $nombre ha sido creada con SID:" (Get-StringSID -SID $nombre)
				$Creacion.SetInfo()
				#Creamos los directorios personales
				if ((Get-Childitem C:\USERS\$nombre_grupo\usuarios\$nombre) -eq $null 2>$null){
					Create-HomeDirectory -Path C:\USERS\$nombre_grupo\usuarios\$nombre
				}
	
			}
		}
	}
}

else{ Write-Host "No eres el administrador del sistema" }