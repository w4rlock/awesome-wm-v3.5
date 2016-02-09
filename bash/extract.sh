#!/bin/bash
#===============================================================================
#
#          FILE:  extract.sh
# 
#         USAGE:  ./extract.sh 
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
#       CREATED:  02/13/2011 11:59:38 PM ART
#      REVISION:  ---
#===============================================================================

if [ -f $1 ] ; then
    case $1 in
        *.tar.bz2)  tar xjvf $1 ;;
        *.tar.bz)   tar xjvf $1 ;;
        *.tar.gz)   tar xvzf $1 ;;
        *.bz2)      bunzip2 $1  ;;
        *.rar)      unrar x $1  ;;
        *.gz)       gunzip $1   ;;
        *.tar)      tar xvf $1  ;;
        *.zip)      unzip $1    ;;
        *.Z)        uncompress $1   ;;
        *.7z)       7z x $1   ;;
        *)      echo "'$1' cannot be extracted via extract()" ;;
    esac
else
    echo "'$1' is not a valid file"
fi

