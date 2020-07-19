#!/bin/bash

declare -a versiones=( 14.04  14.04.3  14.04.4  15.04  16.10 )

function elegirDistribucion(){
	clear
	echo -e "\n "
	echo -e "\t Ahora elige la Distribución:"
	echo -e "\t =================="
	echo -e "1. Version 32 Bits"
	echo -e "2. Version 64 Bits"
	read -p "Opcion:" dis



if [ $dis = 1 ]
then
	distribucion="i386"
fi
if [ $dis = 2 ]
then
	distribucion="amd64"
fi
}



function elegirVersion(){

	clear
	echo -e "\n "
	echo -e "\t Ahora elige la Version:"
	echo -e "\t =================="
	echo -e "1. Desktop"
	echo -e "2. Server"
	read -p "Opcion:" ver


if [ $ver = 1 ]
then
	vers="desktop"
fi
if [ $ver = 2 ]
then
	vers="server"
fi
	
}

clear
opcion=0; # inicializamos la variable para que no falle
while [ $opcion -ne "6" ]
	do
		for ((a=0; a<${#versiones[*]}; a++))
		do
			echo "`expr $a + 1`. ubuntu-${versiones[$a]}"
		done
		read -p "Opcion:_" opcion
		if [ $opcion -ne "6" ]
		then
			elegirDistribucion
			elegirVersion
			nombreFichero=ubuntu-${versiones[`expr $opcion - 1`]}-$vers-$distribucion.iso
			wget ftp://ftp.rediris.es/sites/releases.ubuntu.com/releases/${versiones[`expr $opcion - 1`]}/$nombreFichero		#comentar esta linea 1 vez descargado (para evitar descargas)


			wget ftp://ftp.rediris.es/sites/releases.ubuntu.com/releases/${versiones[`expr $opcion - 1`]}/MD5SUMS
			wget ftp://ftp.rediris.es/sites/releases.ubuntu.com/releases/${versiones[`expr $opcion - 1`]}/SHA1SUMS
			wget ftp://ftp.rediris.es/sites/releases.ubuntu.com/releases/${versiones[`expr $opcion - 1`]}/SHA256SUMS
		


			declare -a hashes=( MD5SUM  SHA1SUM  SHA256SUM )	# con esto podemos hacer un for X in hashes -> que haga el hash de cada cosa

			for X in ${hashes[*]}
			do
				suma_hash_fichero=`grep -e "$nombreFichero" ./"$X"S | cut -d " " -f 1` 
				echo "--------REALIZANDO HASH: $X"
				echo "Valor que tiene: " $suma_hash_fichero
				mihash=`"${X,,}" ./$nombreFichero | cut -d " " -f 1`
				echo "Valor que deberia tener: " $mihash
				if [ $mihash = ${suma_hash_fichero} ]
				then
					 echo "el fichero tiene el hash $X bien, OK!!"
				else
					echo "no está bien el hash $X del fichero!!!"
				fi
			done

		fi
	done


