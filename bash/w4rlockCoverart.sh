#!/bin/bash
#===============================================================================
#
#          FILE:  coverart.sh
# 
#         USAGE:  ./coverart.sh 
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
#       CREATED:  12/19/2010 04:22:32 AM ART
#      REVISION:  ---
#===============================================================================

# coverart.sh
IFS=$'\n'
DEFAULT_COVER="$HOME/.config/awesome/images/music.jpg"
#MUSICDIR="/home/w4rlock/myMusic"

MFILE=`mpc current -f %file%`
MFILE=${MFILE%/*}
MFILE=${MFILE%/$}

MUSICDIR=`cat /etc/mpd.conf | grep -v "#" | grep music_directory`
MUSICDIR="${MUSICDIR:17}"

CANT=$(expr length $MUSICDIR) #elimino el char "
FULLDIR="${MUSICDIR:0:$CANT-1}/$MFILE"

## for 'moc' users under Debian, not sure if other distros use the 'mocp' name for the program:
#MFILE=`mocp --format "%file"`
#[ -n "$MFILE" ] && FULLDIR=`dirname "$MFILE"`

[ -n "$FULLDIR" ] && COVERS=`ls "$FULLDIR" | grep "\.jpg\|\.png\|\.gif"`

if [ -z "$COVERS" ]; then
	COVERS="$DEFAULT_COVER"
else
	TRYCOVERS=`echo "$COVERS" | grep -i "cover\|front\|folder\|albumart" | head -n 1`

	if [ -z "$TRYCOVERS" ]; then
		TRYCOVERS=`echo "$COVERS" | head -n 1`
		if [ -z "$TRYCOVERS" ]; then
			TRYCOVERS="$DEFAULT_COVER"
		else
			TRYCOVERS="$FULLDIR/$TRYCOVERS"
		fi
	else
		TRYCOVERS="$FULLDIR/$TRYCOVERS"
	fi

	COVERS="$TRYCOVERS"
fi

echo -n "$COVERS"
