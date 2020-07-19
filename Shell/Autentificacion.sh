#!/bin/bash
clear

echo "USUARIOS"
echo "--------"

read -p "Introduce el nombre de usuario: " usu
read -p "Introduce el nombre del grupo: " gprin

#realizamos la busqueda del usuario

	usubus=`grep -e "^$usu" usuarios.txt | cut -d ":" -f 1` 
	#echo $usubus

	if [ -z $usubus ];then

		echo "el usuario no esta registrado en el sistema"
		echo "USUARIO" >> VOLCADO_CUENTAS.ldif
		echo "-------" >> VOLCADO_CUENTAS.ldif
		echo "dn: uid=$usu,ou=$gprin,dc=servidorLDAP,dc=es" > VOLCADO_CUENTAS.ldif
		echo "objectClass: account" >> VOLCADO_CUENTAS.ldif
		echo "objectClass: posixAccount" >> VOLCADO_CUENTAS.ldif
		echo "objectClass: shadowAccount" >> VOLCADO_CUENTAS.ldif
		echo "objectClass: top" >> VOLCADO_CUENTAS.ldif
		echo "cn:$usu" >> VOLCADO_CUENTAS.ldif
		echo "uid:$usu" >> VOLCADO_CUENTAS.ldif
		echo "uidNumber:1500" >> VOLCADO_CUENTAS.ldif
		echo "gidNumber: 1500" >> VOLCADO_CUENTAS.ldif
		echo "homeDirectory: /home/usuario/$usu" >> VOLCADO_CUENTAS.ldif
		echo "loginShell: /bin/bash" >> VOLCADO_CUENTAS.ldif                 			
		read -p "Introduce pass " pass
		echo "userPassword: {SHA256} $pass" | sha256sum >> VOLCADO_CUENTAS.ldif
		echo "gecos: $usu" >> usu.ldif
		echo "description: <description>" >> VOLCADO_CUENTAS.ldif

		echo "GENERANDO LINEAS DE BLOQUE PARA EL USUARIO:$usu..."
		sleep 3



		if [ $usubus == $usu ];then 

		echo "el usuario esxite"
		
		fi

	fi
#buscamos el grupo: volcamos /etc/group a grupos.txt

	dd if=/etc/group of=/media/andres/andres/scripts/exa2016/grupos.txt
	grupobus=`grep -e "^$gprin" grupos.txt | cut -d ":" -f 1`
	
	if [ -z $grupobus ];then

		echo "el grupo no esta registrado en el sistema"
		echo "GRUPO" >> VOLCADO_CUENTAS.ldif
		echo "-----" >> VOLCADO_CUENTAS.ldif
		echo "dn: cn=$gprin,ou=group,dc=servidorLDAP,dc=es" >> VOLCADO_CUENTAS.ldif
		echo "objectClass: posixGroup" >> VOLCADO_CUENTAS.ldif
		echo "objectClass: top" >> VOLCADO_CUENTAS.ldif
		echo "cn: $gprin" >> VOLCADO_CUENTAS.ldif
		echo "gidNumber: 1500" >> VOLCADO_CUENTAS.ldif
		
		echo "GENERANDO LINEAS DE BLOQUE PARA EL GRUPO:$gprin..."
		sleep 3

		if [ $grupobus == $gprin ];then 

		echo "el grupo esxite"
		
		fi

	fi
	
	read -p "deseas visualizar el fichero VOLCADO_CUENTAS.LDIF [S/N]:_" cont

	if [ $cont == "s" ];then

		cat VOLCADO_CUENTAS.ldif

	else

		echo "ok"
		echo "saliendo del programa"
		sleep 3
		exit 0
	fi