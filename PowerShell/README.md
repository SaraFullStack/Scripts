# SCRIPTS POWERSHELL
Tan solo es necesario tener Windows10 y en los cuales se usen directorios cambiar las rutas.

## Auditoria 🚀
Quieres comprobar la integridad de tus ficheros .exe del sistema y quieres realizar un analisis de auditoria de estos ficheros. Tienes un fichero con el siguiente formato:  ruta_fichero_exe:hash_MD5:hash_SHA256:hash_SHA512:
	(como el que os paso)

	Tienes que hacer un script que origine de nuevo los hash para los *.exe del sistema y que leyendo linea a linea el fichero de HASH_EXE.TXT compare cada fichero con su HASH y si existen diferencias, se debe poner en cuarentena dicho fichero
	 moviendolo a un directorio que estara en C:\ llamado CUARENTENA (si no existe se debe crear). Ademas se mandara un mensaje al LOG APPLICATION del sistema avisando de esta incidencia con el nombre del fichero posiblemente infectado.

	Este script se progamara para que se ejecute el 1,15 y 30 dias del  mes.

## Backup 🚀
Haz un script que solo pueda ejecutar el ADMINISTRADOR y que se ejecute todos los viernes a las 23:59 que sirva para hacer un BACKUP TOTAL del directorio personal de los usuarios cuyo RID de su SID sea mayor que 1000. 
		Tienes que copiar todos los ficheros que contiene su directorio personal; generalmente el directorio del usuario es: C:\Users\nombre_usuario, pero se puede cambiar cuando se crea la cuenta, 
	asi que tendras que averiguar cual es su directorio personal antes de crear el backup (si el campo directorio personal esta vacio de la salida del comando para averiguarlo quiere decir que se 
	almacena en C:\Users\nombre_usuario)

	Los backups los deberas almacenar en un directorio en C:\ que vas a llamar BACKUP-nombreUsuario-fecha_en_que_se_hizo_backup _hora (por ejemplo: BACKUP-alumnoT-13-10-2013-22.10) y ahi 
	copias todos los ficheros/directorios de su directorio personal (Ojo q en la fecha tienes q sustituir las / por – y en la hora, los : por el . ) Si hay errores durante la copia (por no poder acceder a ficheros que estan siendo utilizados,etc),
	 se deben mandar dichos mensajes de error a un fichero llamado ERRORES_EN_BACKUP para cada usuario.

## Paginacion 🚀
Hacer un script q te muestre el tamaño del fichero de paginacion que por defecto tiene definido el sistema c:\pagefile.sys
y comprobar que esta entre los limites recomendados en funcion de la memoria RAM de tu sistema. Te debera pedir despues si
quieres crear un nuevo fichero de paginacion, y si es que SI te debera pedir: 

	-en que unidad quieres crearlo <---deberas comprobar q existe la unidad y esta en clave 
	-tamaño minimo						HKEY_LOCAL_MACHINE\SYSTEM\MountedDevices  como \DosDevices\letra: 
	-tamaño maximo


## Paginacion2 🚀
Hacer un script que :
			- te muestre el tamaño del fichero de paginacion actual del sistema C:\PAGEFILE.SYS  y comprobar si esta dentro del rango de tamaño optimo en funcion de la memoria RAM de tu sistema
				Si esta OK mostrar el mensaje siguiente: "el fichero de paginacion principal C:\PAGEFILE.SYS con tamaño:..... esta dentro del rango optimo"

			 -Comprobar el uso actual del fichero de paginacion por defecto del sistema C:\PAGEFILE.SYS (prop.PeakUsage de PAGEFILE dentro de WMIC, te lo da en % del total de su tamaño)
			  Si esta cifra alcanza el 80% crear un nuevo fichero de paginacion con el mismo tamaño del existente. Cuando baje por debajo del 10% eliminar dicho archivo

## procesos 🚀
Hacer un script que muestre un listado de cada uno de los procesos que pertenezcan al usuario que ha iniciado sesion y llevan mas de 1' en ejecucion.
Despues de mostrar el listado, mostrar este menu:

        1.aumentar su prioridad a High (comprobar que la ha cambiado, por defecto esta a NORMAL)
        2.matar el proceso.
        3---SALIR----

Se mandara un mensaje al log Applicaton de tipo Info indicando que:

	"se ha elevado la prioridad del proceso/finalizado el proceso con PID: CMD: .....a las ..... del dia ....."'

## procesos2 🚀
Igual que el anterior pero..

Se mandara un mensaje al log Applicaton de tipo Info indicando que se ha elevado la prioridad del proceso/finalizado el proceso .....a las ..... del dia .....

## servicios 🚀
Hacer un script que para todos los servicios que son de tipo SHARED o compartidos que esten EJECUTANDOSE en este momento(el ejecutable del servicio es SVCHOSTS.EXE) 
muestre el NOMBRE_DEL_SERVICIO , la DLL q se ejecuta de forma diferente para cada servicio por el ejecutable SVCHOSTS.exe, el PID del proceso que corre el servicio
numero de hilos q tiene, algo asi:

				SERVICIOS SHARED RUNNING...
		nombre_servicio		DLL		PID-proceso		num.threads
		-------------------------------------------------------
			...				...			...

## sesiones 🚀
Eres el admin del sistema y te han pedido un informe diario de las sesiones de cada usuario (que no sean del sistema,RID>1000) en el servidor;
mas o menos quieren saber quien se ha logueado en el sistema, cuando han acabado la sesion y durante cuanto tiempo ha tenido la sesion abierta. 
Cada inicio o cierre de sesion se registra en el log del sistema "SECURITY" con (id-evento incio 4624) y (id-evento cierre 4647).
 
 Habria q mostrar una salida resumen asi:
 
			DIA: Miercoles, 7 de diciembre de 2016 
			--------------------------------------
		usuario            inicio-sesion  cierre-sesion  duracion
		----------------------------------------------------------
		... 				....			....		...
		....				....			....		...

Este resultado habra que almacenarlo en un fichero con el nombre SESIONES-DIA-dd-mm-aaaa.txt en un directorio llamado SEGUIMIENTO-SESIONES
(comprobar que esta creado, y sino habra que crearlo)




## Usuarios 🚀
 -Eres el administrador del sistema y te pasan un fichero llamado GRUPOS_USUARIOS_NUEVOS.txt con este formato: 

		_nombre_grupo_$usuario1:PASSWORD,usuario2:PASSWORD,usuario3:PASSWORD,....   <--- el num.de usuarios por cada grupo es variable

  Ej:
	administracion$juliaMaria:july123,pedroPablo:pP666
	informaticaDesarrollo$santiago:santi.es90,gemaMengual:gemMM,cristinaMendez:1975Cristi
	...

tienes que hacer un script que leyendo el fichero linea a linea:
			- genere el grupo en el sistema con el nombre especificado en la primera columna mostrando el SID del grupo 
			- añadir al mismo los usuarios que hay a continuacion del nombre del grupo (creandolos antes si estos no existen en el sistema,
			 mostrando sus SID) con las contraseñas q se especifican.		
			- Sus directorios personales estaran dentro de USERS\nombre_grupo\usuarios\nombre_usuario
			  (Si no existe el directorio habra que crearlo)

