#!/bin/bash

clear
n= 3
activo= ps aux | grep vsftpd

if($activo)
then
{
	RUTA= readlink -f vsftpd.conf
}
else
{
	RUTA= /etc/vsftpd.conf
}
fi
while [ $opcion -ne $n ]
do
	  clear
	  echo -e "1.Habilitar ACCESO ANONIMO"
	  echo -e "2.Habilitar ACCESO CUENTAS LOCALES del sistema"
	  echo -e "3.SALIR"
	  read -p "Opcion: " opcion
	  case $opcion in

	1)echo "Habilitando acceso anonimo"
		if ["`grep -e "^anonymous_enable=NO" $RUTA`"]
		then
		echo "Cambiando valor ANONYMOUS_ENABLE a YES"
		sed -i 's/anonymous_enable=NO/anonymous_enable=YES/g' $RUTA

		echo "Configurando el directorio de acceso publico como usuario anonimo"
		sed -i 's/anon_root=*/anon_root=srv/ftp/acceso_publico/g' $RUTA

		echo "Cambiando permiso para solo poder descargar"
		if ["`grep -e "^write_enable=YES" $RUTA`"]
		then
		echo "Cambiando valor WRITE_ENABLE a NO"
		sed -i 's/write_enable=YES/write_enable=NO/g' $RUTA
		else
		echo "write_enable ya estaba correcto"
		fi
		echo "Reiniciando el servidor para comprobar si funciona correctamente"
		/sbin/service vsftpd restart
		if($activo)
		then
		echo "Servidor reiniciado y en ejecucion"
		else
		echo "Hay error de escritura"
		fi
		else
		echo "El acceso anonimo ya esta activado"
		fi
		;;
		#--------------------------------------------------------------------------------
	2)echo "Habilitando acceso cuentas locales del sistema"
		num=0
		while true
		do
		read -p "Nombre de usuario [EN BLANCO para finalizar]:" usuario
		["$usuario" = ""] && break
		[ $num -eq 0 ] && op="-c" || op=""
		htpasswd $op $ficheroUsers $usuario
		num=$( $num+1 )
		done

		if ["`grep -e "^chroot_local_user=NO" $RUTA`"]
		then
		echo "Cambiando valor chroot_local_user a YES"
		sed -i 's/chroot_local_user=NO/chroot_local_user=YES/g' $RUTA
		else
		echo "Valor de chroot_local_user correcto"
		fi

		if ["`grep -e "^chroot_list_enable=NO" $RUTA`"]
		then
		echo "Cambiando valor chroot_list_enable a YES"
		sed -i 's/chroot_list_enable=NO/chroot_list_enable=YES/g' $RUTA
		else
		echo "Valor de chroot_list_enable correcto"
		fi

		echo "Reiniciando el servidor para comprobar si funciona correctamente"
		/sbin/service vsftpd restart
		if($activo)
		then
		echo "Servidor reiniciado y en ejecucion"
		else
		echo "Hay error de escritura"
		fi
		;;
		#---------------------------------------------------------------------------------
		3) exit 0 ;;
		*) echo -e "Opcion no valida" ;;
		esac
done