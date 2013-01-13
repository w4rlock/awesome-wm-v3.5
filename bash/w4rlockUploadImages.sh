#!/bin/bash
#===============================================================================
#
#          FILE:  w4rlockUploadImages.sh
# 
#         USAGE:  ./w4rlockUploadImages.sh 
# 
#   DESCRIPTION:  
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  enki (2007) - w4rlock
#         EMAIL:  warlock.gpl@gmail.com 
#       VERSION:  1.0
#       CREATED:  01/12/2011 03:09:24 PM ART
#      REVISION:  ---
#===============================================================================
IFS=$'\n'
CURL=$(which curl)
TMPFILE=$(mktemp /tmp/imageshack.XXXXXXXXXX) || exit 1

#------------------------------------------------------------------
cleanup() {
	rm -rf $TMPFILE
	[ "$1" ] && exit $1
}

#------------------------------------------------------------------
subirImage(){
	$CURL -H Expect: -F fileupload="@${1}" -F xml=yes http://www.imageshack.us/index.php > $TMPFILE
	imgs=${imgs}${1}':  '$(cat $TMPFILE | grep -E "<image_link>(.*)</image_link>" | sed 's|<image_link>\(.*\)</image_link>|\1|')'\n'
	cleanup
}

#------------------------------------------------------------------
subirDirectorio(){
	cd $1
	clear
	CANT=$(ls | egrep -i '*.jpg|*.png|*.gif' | wc -l)
	let H=1
	for a in $(ls | egrep -i '*.jpg|*.png|*.gif');
	do 
		echo -e "\n:::::::: Subiendo imagen: $a             .......... ($H/$CANT)"
		echo
		subirImage $a;
		let H+=1		  
		clear
	done
}

#------------------------------------------------------------------
getHelp(){
  echo -e   "\nDESCRIPTION:"
  echo -e   "\tSube una imagen o un directorio con imagenes al servidor ImageShack."
  echo -e   "\nUSAGE:"
  echo -e   "\t$0  + /ruta/unaImagen.png"
  echo -e   "\t$0  + /ruta/misImagenes\n"
exit 1
}

#------------------------------------------------------------ MAIN
# Si los parametros son menor a 1
if [ $# -lt 1 ];
then
  	getHelp
fi

if [ -d $1 ]
then
	subirDirectorio $1
else
	if [ -e $1 ];
	then
		subirImage $1
	else
		echo -e "\n\tError: no se encuentra el archivo o directorio "$1
		exit 1
	fi
fi

echo -e "\nUrl of image on imageshack:"
echo -e $imgs
exit 0
