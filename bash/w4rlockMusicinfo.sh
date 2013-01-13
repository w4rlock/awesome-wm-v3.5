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

mpc current -f %title%
mpc current -f %artist%
mpc current -f %album%
mpc current -f %genre%
mpc current -f %date%
mpc current -f %time%
