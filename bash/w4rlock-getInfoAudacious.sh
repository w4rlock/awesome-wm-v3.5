#!/bin/bash
#===============================================================================
#
#          FILE:  audSoung.sh
# 
#         USAGE:  ./audSoung.sh 
# 
#   DESCRIPTION:  
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  
#         EMAIL:  warlock.gpl@gmail.com 
#       VERSION:  1.0
#       CREATED:  09/09/2010 05:08:49 AM UTC
#      REVISION:  ---
#===============================================================================

#STATUS=$(audtool playback-status)
close="No song playing."
title=$(audtool current-song) 
if [ "$title" != "$close" ]; then 
	echo $title
	echo "$(audtool current-song-tuple-data artist)"
	echo "$(audtool current-song-tuple-data album)"
	echo "$(audtool current-song-tuple-data genre)"
    echo "$(audtool current-song-tuple-data year)"
	echo "$(audtool current-song-length)"

	path=$(audtool current-song-tuple-data file-path)
	path=${path:7}
	cant=$(ls "$path" | egrep -i '*.jpg|*.png|*.gif' | egrep -i 'front' | wc -l)

	if [ $cant != "0" ]; then
	 	echo "$path"$(ls "$path" | egrep -i '*.jpg|*.png|*.gif' | egrep -i 'front' | tail -n 1)
	else
		cant=$(ls "$path" | egrep -i '*.jpg|*.png|*.gif' |  wc -l)
		if [ $cant != "0" ]; then
			echo "$path"$(ls "$path" | egrep -i '*.jpg|*.png|*.gif' | tail -n 1)
		else
			echo "--"
		fi
	fi
else
echo "--"
fi
exit 0
