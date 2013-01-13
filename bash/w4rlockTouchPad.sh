#!/bin/bash
#===============================================================================
#
#          FILE:  w4rlockTouchPad.sh
# 
#         USAGE:  ./w4rlockTouchPad.sh 
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
#       CREATED:  01/07/2011 12:06:53 AM ART
#      REVISION:  ---
#===============================================================================

#!/bin/sh

ESTADO=`synclient -l | grep TouchpadOff | cut -d '=' -f 2`

if [ $ESTADO = 0 ]; then
   synclient TouchpadOff=1
   xdotool mousemove 1366 0 
else
   synclient TouchpadOff=0
fi

