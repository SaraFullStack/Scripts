#!/bin/bash/

while [ $opcion -ne 3 ]
do
   clear
   echo -e "\t\t HERRAMIENTAS DE DIAGNOSTICO ICMP"
   echo -e "\t\t 1. Disponibilidad de un host remoto"
   echo -e "\t\t 2. Averiguar los routers hasta alcanzar un host remoto"
   echo -e "\t\t 3. SALIR"
   read -p "Opcion: " opcion
   case $opcion in
	1) read -p "Añadir IP del host remoto" ip 
	read -p "Añadir el nº paquetes a mandar" numero
	read -p "Añadir tiempo de espera" tiempo 
	read -p "tamaño en bytes de los paquetes" tama
	if [ -z $numero ]
	then
	num = "-c 4"
	else
	num = "-c $numero"
	fi
	if [ -z $tiempo ]
	then
	tiem = ""
	else
	tiem = "-i $tiempo"
	fi
	if [ -z $tama ]
	then
	tam = ""
	else
	if [ tamaño gt 65500 ];
	then	
	:<<EOF
	El tamaño maximo del datagrama que podemos mandar es de tanto 65535 si le restamos el tamaño de las cabeceras ip y 
	icmp nos da 65507 que es el maximo que podemos mandar por el paquete. Redondeando 65500.  

			tamaño max datagrama = 65535 
				menos cabecera-ip     20 bytes
				menos cabecera icmp    8 bytes
						-------------------
				tamaño max paquete --->  65507 bytes (65535-28)
	EOF
	echo "La cabecera de la capa de transporte tiene un tamaño maximo de 65500 bytes"
	else
	ping $ip $numero $tiem $tama
	fi	
	fi
	;;
	2) read -p "Añadir IP del host remoto" host
	TTL=1
	echo -e "...routers hasta $host..... \n\n"

	while [ $host -lt 256 ]
	do
	mensaje=`ping -c 1 -t $TTL $destino | grep -i "time to live exceedeed"`

	if [ ! -z "$mensaje" ] 
	then 
		router=`echo $mensaje | cut -d " " -f 2`
		echo "router $TTL .... $router"

	else 
		echo "... se llego al destino o comando PING fallo..."	
		break
	fi
		TTL=$(( $TTL+1 ))
	done

	traceroute $host
	;;
	#Traceroute es mucho mas preciso porque describe la routa que los paquetes toman realmente hasta llegar a su destino
	#El ping es mucho mas rapido por que solo te dará el resultado final
	3) exit 0 ;;
   esac
done
