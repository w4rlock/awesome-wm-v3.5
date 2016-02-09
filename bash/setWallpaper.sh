#!/bin/bash
#===============================================================================
#
#          FILE:  setWallpaper.sh
# 
#         USAGE:  ./setWallpaper.sh 
# 
#   DESCRIPTION:  
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  w4rlock
#         EMAIL:  warlock.gpl@gmail.com 
#       VERSION:  1.0
#       CREATED:  12/25/2010 04:14:56 PM ART
#      REVISION:  ---
#===============================================================================

#-------------------------------------------------------------------
# la imagen es copiada a la carpeta para despues leerla desde theme.lua
IFS=$'\n' #nombres de archivos con espacios en blancos
LBLUE="\033[1;34m"
LGREEN="\033[1;32m"
LRED="\033[1;31m"

setImage(){
    if [ ! -d $1 ];
    then
        #carpeta por defecto donde se va a guardar la imagen
        #para luego leerla de alli
        dir=$HOME/.config/awesome/images/ 
        if [ ! -d $dir ];
        then
            mkdir -p $dir
        fi
        Esetroot -s "$1" > /dev/null 2>&1
        cp $1 $HOME/.config/awesome/images/wallpaper.png
    fi
}

#-------------------------------------------------------------------
setVideoWallpaper(){
 if [[ ! -e $1 ]]; then
		echo -e ${LRED}"\n\tEl video no se encuentra.\n"
		exit 1
	else
		CANT=$(expr length $1) 
        EXT=${1:$CANT-3:$CANT}
		if [[ $EXT == 'avi' ]]; then
          mplayer $1 -rootwin -vf scale=1366:768 -noconsolecontrols
        else
		  echo -e ${LRED}"\n\tEl archivo no es un video.\n"
		fi
		exit 0
  fi
}

#-------------------------------------------------------------------
existImage(){
	if [ ! -e $1 ];
	then
		echo -e ${LRED}"\n\tLa imagen no se encuentra.\n"
		exit 1
	else
		setImage $1
		exit 0
	fi
}

#-------------------------------------------------------------------
randomImage(){
	if [ ! -d $1 ];
	then
		echo -e ${LRED} "\n\tError: el directorio no es valido.\n" 
		exit 1
	else
		cantImgs=`ls "$1" | grep -i "\.jpg\|\.png\|\.gif|\.jpeg" | wc -l`
		if [ $cantImgs -gt 0 ];
		then
			numImg=`expr $RANDOM % $cantImgs + 1`
			wallpaper="$1/`ls "$1"| sed -n ${numImg}p`"
			setImage $wallpaper
		else
			echo -e ${LRED} "\n\tError: el directorio '$1' no contiene imagenes.\n" ${LGREEN}
			exit 1
		fi
	fi
}

#------------------------------------------------------------------
getHelp(){
  echo -e   ${LBLUE} "\nDESCRIPTION:" ${LGREEN}
  echo -e   "\tEstablece una imagen de fondo utilizando awsetbg de awesome."
  echo -e   ${LBLUE} "\nUSAGE:" ${LGREEN}
  echo -e   "\t$0  -f /ruta/unaImagen.png"
  echo -e   "\t$0  -v /ruta/unVideo.avi"
  echo -e   "\t$0  -r /ruta/misImagenes"
  echo -e   "\t$0  -R /ruta/misImagenes xx segundos (opcional)"
  echo 
  echo -e   ${LBLUE}"OPTIONS:" ${LGREEN}
  echo -e "\t -f : Establece de fondo una imagen."
  echo -e "\t -v : Reproduce un video de fondo con mplayer."
  echo -e "\t -r : Establece de fondo una imagen aleatoria de una carpeta."
  echo -e "\t -R : Establece de fondo una imagen aleatoria de una carpeta cada xx segundos.\n"
  echo -e 	${LBLUE}"\nNOTES:" ${LGREEN}
  echo -e   "\tEl uso de los parametros -r o -R, el path solamente debe contener imagenes.\n"
  exit 1
}

#------------------------------------------------------------------
# Si los parametros son menor a 2
if [ $# -lt 2 ];
then
  	getHelp
fi

#------------------------------------------------------------------
if [ ! -e /usr/bin/Esetroot ];
then
	echo -e "\n\tError: debes tener instalado Esetroot.\n"
	exit 1
fi

case $1 in
	-f) existImage $2 ;;
	-h) getHelp ;;
	-v) setVideoWallpaper $2 ;;
	-r) randomImage $2
		  exit 0 ;;
	-R) 
		tim=27 #segundos por defecto para el cambio de imagenes
		if [ $# -eq 3 ] && [[ $3 = *[[:digit:]]* ]]; then
			if [ $3 -gt 0 ]; then #si los segundos son mayor a 0
				tim=$3
			fi
		fi
		while true;
		do
			randomImage $2
			sleep $tim
		done &
		;;
esac
