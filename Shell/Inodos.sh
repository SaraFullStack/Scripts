#! /bin/bash

clear
echo -e "\t\t 1.Mostrar información del superbloque"
echo -e "\t\t 2.Mostrar el volcado de un inodo de un fichero/directorio"
echo -e "\t\t 3. ---SALIR---"
read -p "opcion_" opcion

echo $opcion | grep -e "^[1-3]$" >/dev/null || { echo "mal..."; exit 0; }

particion=/dev/sda`parted /dev/sda print | grep -i "ex4" | awk '{print $1}'`
case $opcion in 

	1) 	
	echo -e "======================================="
	echo -e "El numero de bloques por particion es de "
	echo -e "======================================="

	echo -e "======================================="
	blocks_count=`dumpe2fs -h /dev/sda1 | grep -e "^Block count" | cut -d ":" -f 2 | tr -d " "`
	echo -e "El numero de groups por bloque es de:" $blocks_count
	echo -e "======================================="	

	echo -e "======================================="
	blocks_group=`dumpe2fs -h /dev/sda1 | grep -e "^Blocks per group" | cut -d ":" -f 2 | tr -d " "`
	echo -e "El tamaño del bloques por grupos es de " $blocks_group	
	echo -e "======================================="


	echo  "========================================"
	inode_group=`dumpe2fs -h /dev/sda1 | grep -e "^Inodes per group" | cut -d ":" -f 2 | tr -d " \t \t"`
	echo -e "El tamaño de inodos por grupos es de" $inode_group
	echo "========================================"

	echo -e "========================================="
	inodetam=`dumpe2fs -h /dev/sda1 | grep -e "^Inode size" | cut -d ":" -f 2 | tr -d " "`
	echo -e "El tamaño del inodo es de " $inodetam
	echo -e "========================================="

	echo -e "=========================================="
	tamano_bloque=`dumpe2fs -h /dev/sda1 | grep -e "^Block size" |cut -d ":" -f 2 | tr -d " "`
	echo -e "El tamaño del bloque es de " $tamano_bloque
	echo -e "=========================================="
		;;


	2)
echo -e "\t\t 1.Fichero"
echo -e "\t\t 2.Directorio"
read -p "opcion:_" opcion


case $opcion in
	1)
	read -p "Introduce la ruta del fichero (completa please)" var
	[ ! -f $var ] && { echo "....no existe el fichero..."; exit 0; } #test para ver si existe el fichero
	opciones_ls=-i	
		;;	

	2)
	read -p "ruta y nombre del directorio_" var
	[ ! -f $var ] && { echo "....no existe el directorio..."; exit 0; }
	opcion_ls=-id		
		;;

	*) echo -e "opcion no valida";;
esac

	inodo=`ls $opciones_ls $var | cut -d " " -f 1`
		echo "el numero de particion de i-nodo es: $inodo \n\n y su contenido:\n"
	#disco=`parted /dev/sda print | grep -i -e "^disco" | cut -d " " -f 2 | cut -d ":" -f 1`
	numparticion=`parted /dev/sda print | grep -i -e ".*ext[34].*" | cut -d " " -f 2`

	[ -z "numparticion" ] && { echo "no hay particiones"; }
	istat /dev/sda$numparticion $inodo


# -- preguntamos si quiere volcado en hex del inodo

	read -p "---quieres volcado en hexadecimal del inodo [s/n]:_" resp
		if [ "$resp" = "s" -o "$resp" = "S" ]
		then
			echo "Welcome to M A T R I X"
			linea=`debugfs -R "imap <$inodo>" /dev/sda$numparticion | grep "located"`
			bloque=`echo $linea | cut -d " " -f 4 | cut -d "," -f 1`
			offset=`echo "ibase=16;$(echo $linea | cut -d ' ' -f 6 | cut -d 'x' -f 2 | tr 'a-z' 'A-Z')"`

		dd if=/dev/sda$numparticion bs=4096 count=1 skip=$bloque 2>/dev/null | xxd -g 8 -l 256 -s $offset 	

		fi
esac










