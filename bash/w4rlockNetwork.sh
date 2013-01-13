#!/bin/bash
#===============================================================================
#
#          FILE:  w4rlockNetwork.sh
# 
#         USAGE:  ./w4rlockNetwork.sh 
# 
#   DESCRIPTION:  
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  
#         EMAIL:   
#       VERSION:  1.0
#       CREATED:  11/19/2011 03:24:23 PM PST
#      REVISION:  ---
#===============================================================================
#echo -e ${LBLUE}
LBLUE="\033[1;34m"
LGREEN="\033[1;32m"
LRED="\033[1;31m"  
LNONE="\033[0m"


#------------------------------------------------------------------
getHelp(){
  echo -e   ${LBLUE} "\nDESCRIPTION:" ${LGREEN}
  echo -e   "\tStartup Network"
  echo -e   ${LBLUE} "\nUSAGE:" ${LGREEN}
  echo -e   "\tw4rlockNetwork.sh wlan0|eth0 up|down\n"
  echo -e   ${LBLUE} "\nEJ:" ${LGREEN}
  echo -e   "\tw4rlockNetwork.sh wlan0\n"
  exit 1
}

#------------------------------------------------------------------
# Si los parametros son menor a 1
if [ $# -lt 1 ];
then
  	getHelp
fi

#------------------------------------------------------------------
sudo rm /var/run/wpa_supplicant/${1} > /dev/null 2>&1

if [[ $2 = 'up' ]]; then
  sudo ifconfig $1 up
fi

sudo wpa_supplicant -B -i $1 -c /var/lib/wicd/configurations/f4ec38b87524 -D wext && sudo dhclient $1
