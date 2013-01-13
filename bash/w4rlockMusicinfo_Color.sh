#!/bin/bash
#===============================================================================
#
#          FILE:  musicinfo.sh
# 
#         USAGE:  ./musicinfo.sh 
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
#       CREATED:  12/19/2010 04:25:30 AM ART
#      REVISION:  ---
#===============================================================================

#musicinfo.sh

echo "<span foreground='#0FFFFF'>Title:</span>  `mpc current -f %title%`"
echo "<span foreground='#0FFFFF'>Artist:</span> `mpc current -f %artist%`"
echo "<span foreground='#0FFFFF'>Album:</span>  `mpc current -f %album%`"
echo "<span foreground='#0FFFFF'>Genre:</span>  `mpc current -f %genre%`"
echo "<span foreground='#0FFFFF'>Year:</span>   `mpc current -f %date%`"
echo "<span foreground='#0FFFFF'>Time:</span>   `mpc current -f %time%`"
