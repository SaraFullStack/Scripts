# SCRIPTS REDES
# ICMP
Haz un script que utilizando la herramienta PING q usa el protocolo ICMP te sirva para diagnosticar el estado de la red hasta un destino, te debe mostrar este menu:
		
		HERRAMIENTAS DE DIAGNOSTICO ICMP
	1.Disponibilidad de un host remoto
	2.Averiguar los routers hasta alcanzar un host remoto 
	3.---SALIR---

En la opcion 1 te debe pedir la IP del host remoto, y con PING pedir el nº de paquetes a mandar, el tiempo de espera y el tamaño en bytes de los paquetes 
(no debe superar 65500, si pone un numero superior poner una explicacion en el script de porque no debe superar esta cantidad). Si se dejan en blanco se dejan parametros por defecto y un numero de paquetes de 4.

En la opcion 2 te debe pedir la IP del host remoto, y con el comando PING hay q averiguar los routers q hay hasta ese destino;
 cuando se complete el comando bien, se debe lanzar otra vez ya con TRACEROUTE para comparar los resultados.

# vsftpd

Hacer un script q modifique el fichero de configuracion de vsftpd y muestre este menu:
 (el fichero de configuracion de vsftpd sera: si el demonio esta ejecutandose, te lo dice el 2º argumento del ejecutable del proceso, y si no tomaremos
  por defecto /etc/vsftpd.conf)

 		1.habilitar ACCESO ANONIMO
		2.habilitar ACCESO CUENTAS LOCALES del sistema
		3.---SALIR...
		  Opcion:_

  en la opcion 1) -se habilitara el acceso anonimo (si no lo esta)
		  -el directorio de acceso publico como usuario anonimo sera: /srv/ftp/acceso_publico/
		  -solo se podra del mismo DESCARGAR documentos (no subir,ni borrar,ni crear directorios,...)

  en la opcion 2) -se habilitara el acceso a cuentas locales q te pidan por teclado, al resto se le denegara el acceso
		   (se hace por el modulo PAM q tiene activado por defecto vsftpd, mirarlo)
		  -se les enjaulara en su directorio personal
		  -se les permitira hacer todo tipo de operaciones por FTP: uploads,downloads,borrar,crear directorios,...

En cada opcion se reiniciara el servidor y se comprobara q se esta ejecutando, sino se informara de q hay algun error de sintaxis en el fichero