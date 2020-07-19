# SCRIPTS 
## POWERSHELL
## SHELL
## -------REDES

## Autentificacion
Quieres hacer q la autentificacion de tu sistema no se haga contra los ficheros /etc/passwd,/etc/shadow,... sino q se haga contra un servidor externo LDAP
para lo cual tienes q pasar la info de dichos ficheros a este servidor. El problema, es q este servidor para coger la info de las cuentas, se le debe dar
en un formato especial, en un fichero .LDIF q debe tener este formato por cada usuario y grupo del sistema:

dn: uid=<nombre_user>,ou=<grupo_principal>,dc=servidorLDAP,dc=es    <---por cada usuario Q NO SEA DEL SISTEMA!!! debes generar un conjunto de lineas asi  
objectClass: account			 			todo lo q va entre <...> son atributos cuyo valor debes rellenar sacandolos de /etc/passwd,...
objectClass: posixAccount		 		CADA BLOQUE DE LINEAS DE UN USUARIO SE SEPARA DEL SIGUIENTE POR UNA LINEA EN BLANCO, no pueden ir seguidas.
objectClass: shadowAccount
objectClass: top
cn: <nombre_user>				                                                             	
uid: <nombre_user>				                                                                    
uidNumber: <uid>							                                       
gidNumber: <gid>							             
homeDirectory: <home>
loginShell: <shell>
userPassword: {SHA256}<password_shadow>
gecos: <user>
description: <description>


Para los grupos Q NO SEAN DEL SISTEMA el conjunto de lineas q debes generar por cada grupo es el siguiente:

dn: cn=<nombre_del_grupo>,ou=group,dc=servidorLDAP,dc=es
objectClass: posixGroup
objectClass: top
cn: <nombre_del_grupo>
gidNumber: <gid>

El script debe generar un fichero llamado VOLCADO_CUENTAS.LDIF q tenga todas las lineas con esa estructura por cada usuario y grupo (q no sean del sistema)
Debe ir mostrando por pantalla:
			USUARIOS:
				generando bloque de lineas para el usuario: ..... <--- y cuando las tenga mostrarlas
				...
			GRUPOS:
				generando bloque de lineas para el grupo: .... <----y cuando las tenga mostrarlas
				...

y al final, te preguntara: QUIERES VER TODO EL FICHERO .LDIF? [S/N] si es q SI te lo debera mostrar por pantalla

# Inodos
Tienes q hacer un script q haga esto:
					1.Mostrar informacion del superbloque 
					2.Mostrar el volcado de un inodo de un fichero/directorio
					3. ---SALIR---
					  Opcion:

En la opcion 1 te debe pedir de que grupo-bloque quieres leer el superbloque (por defecto, se leera del primero) y se debe mostrar esta info del mismo:

		- num.bloques particion
		- numero de grupos-bloque
		- bloques por grupo-bloque
		- inodos por grupo-bloque
		- tamaño inodo
		- tamaño bloque

En la opcion 2 te pedira si quieres el volcado de un fichero o un directorio, comprobaras q existe, y si existe debes sacar el i-nodo en el q se encuentra
y mostrar su volcado.

# Ubuntu 

Hacer un script q muestre el siguiente menu (la url para la descarga es: ftp://ftp.rediris.es/sites/releases.ubuntu.com/releases/)

	!!!!ojo!!! tienes q utilizar este array:  declare -a versiones=( 14.04  14.04.3  14.04.4  15.04  15.10 )

					DOWNLOAD ISO UBUNTU
					==================
					1.version 14.04
					2.version 14.04.3	un vez elegida una version, te preguntara dos cosas:  
					3.version 14.04.4  ----> - si quieres la imagen de la distro de 32-bits(i386.iso) o la de 64-bits(amd64.iso)
					4.version 15.04		 - si quieres la version de escritorio(desktop) o para servidores(server)	
					5.version 15.10
					6.---SALIR----		 
					  opcion:_		

Una vez introducidos estos datos procederas a descargar la imagen .iso de Ubuntu desde esta url:
(Para la descarga de ficheros desde consola necesitas el comando: wget)

	ftp://ftp.rediris.es/sites/releases.ubuntu.com/releases/<...version...>/ubuntu-<...version..>-<desktop|server>-<i386|amd64>.iso

Dentro de cada directorio ftp://ftp.rediris.es/sites/releases.ubuntu.com/releases/<...version...>/   hay un fichero llamado MD5SUMS,SHA1SUMS,SHA256SUMS 
q contiene los hashes de todos los ficheros .iso de esa version segun algoritmo MD5,SHA1,SHA256. Deberas tb descargarlos y comprobar si estos hashes
 del fichero .iso q te descargas coinciden con los que tienen esos fichero en esa version. P.e, el fichero MD5SUMS para la version 15.10 contiene lo siguiente:

ece816e12f97018fa3d4974b5fd27337 *ubuntu-15.10-desktop-amd64.iso
7d483b990de4e1369b76b7b693737191 *ubuntu-15.10-desktop-i386.iso
fb4eef05edcabfc5cccd4cb44f3f9b48 *ubuntu-15.10-server-amd64.iso
0d9ee8b0b0205a8487d6ed8785ee63a8 *ubuntu-15.10-server-i386.iso

el SHA256SUMS para esa version contiene lo siguiente:

cc991993e3d9f57f27199877ac416157228fe6896212968d6e8c5aebd74e7ab0 *ubuntu-15.10-desktop-amd64.iso
33873f5312261f858d212a47f2344073a6d0366c9607cef3b3f593e87e3aa8de *ubuntu-15.10-desktop-i386.iso
86aa35a986eba6e5ad30e3d486d57efe6803ae7ea4859b0216953e9e62871131 *ubuntu-15.10-server-amd64.iso
fa97768bdc3f198b82180d39bf0c26f021ab716f5da98094cd220771095e3394 *ubuntu-15.10-server-i386.iso

Ejemplo, quiero descargar la distro de ubuntu 15.10 para 64-bits en version server, pues tendria q descargar el fichero:

	ftp://ftp.rediris.es/sites/releases.ubuntu.com/releases/15.10/ubuntu-15.10-server-amd64.iso

luego deberias calcular su hash-MD5, hash-SHA1 y hash-SHA256 y compararlo con el q tiene el fichero MD5SUMS para ese fichero;
 si esta todo OK mostraras un mensaje de OK!!! fichero seguro, de lo contrario mostraras un mensaje de q el fichero no es seguro.
