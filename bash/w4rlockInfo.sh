#!/bin/bash
#===============================================================================
#
#          FILE:  info.sh
# 
#         USAGE:  ./info.sh 
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
#       CREATED:  02/20/2011 04:42:11 PM ART
#      REVISION:  ---
#===============================================================================
#echo -e ${LBLUE}
LBLUE="\033[1;34m"
LGREEN="\033[1;32m"
LRED="\033[1;31m"    
LNONE="\033[0m"

BAT='/usr/bin/acpitool'
TEMP='/usr/bin/sensors'
MPD='/usr/bin/mpc'

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- HELP
function getHelp()
{   echo -e ${LBLUE} "\nOPTIONS:" ${LGREEN}
    echo -e "\t-a : Muestra toda la informacion."
    echo -e "\t-b : Muestra informacion de la batteria."
    echo -e "\t-m : Muestra informacion de mpd."
    echo -e "\t-t : Muestra informacion de la temperatura (cores)\n"
    exit 0
}

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- BATTERY
function getBat()
{
    if [ ! -e $BAT ]; then
      echo -e "\n${LRED}ERROR: ${LGREEN} '$BAT' command not found.\n ${LNONE}"
      exit 1
    fi

    CARGADA="Charged,"
    CARGANDO="Charging,"
    STATE=`acpitool -b | awk '{print $4}'`

    if [[ $STATE == $CARGANDO ]]; then
        RES='+'
    elif [[ $STATE != $CARGADA ]]; then
        RES='-' 
    fi

    RES=${RES}`acpitool -b | awk '{print $5}'`
    CANT=$(expr length $RES) 
    echo ${RES:0:$CANT-1} #elimino la , que tiene al final
}

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- MPD
function getMpd()
{
    if [ ! -e $MPD ]; then
      echo -e "\n${LRED}ERROR: ${LGREEN} '$MPD' command not found.\n ${LNONE}"
      exit 1
    fi

    ARTIST=`mpc current -f %artist%`
    TITLE=`mpc current -f %title%`
    echo ${ARTIST}' - '${TITLE}
}

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- TEMP
function getTemp()
{
    if [ ! -e $TEMP ]; then
      echo -e "\n${LRED}ERROR: ${LGREEN} '$TEMP' command not found.\n ${LNONE}"
      exit 1
    fi

    TEMPS=`sensors | grep 'Core' | awk '{print $3}'`
    echo $TEMPS
}


# MAIN
if [[ $# -lt 1 ]]; then
    #getError
    getHelp
fi

for param in "$@"
do
  case $param in
             -b|--bat) getBat  ;;
             -m|--mpd) getMpd  ;;
            -t|--temp) getTemp ;;
            -h|--help) getHelp ;;
  esac
done
