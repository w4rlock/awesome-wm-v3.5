#!/bin/bash
#===============================================================================
#
#          FILE:  vol.sh
# 
#         USAGE:  ./vol.sh 
# 
#   DESCRIPTION:  g
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  
#         EMAIL:  warlock.gpl@gmail.com 
#       VERSION:  1.0
#       CREATED:  09/10/2010 06:58:41 AM UTC
#      REVISION:  ---
#===============================================================================

#ESTADO="`amixer get PCM |awk '/Front\ Left:/ {print $7}'`"
#if test "$ESTADO" != "[on]" ; then
#echo " Mudo"
#else
#echo " `amixer get PCM |awk '/Front\ Left:/ {print $5}' | sed -e 's/\[//g'|sed -e 's/%\]//g'`%"
#fi
#ESTADO="`amixer get Master |awk '/Front\ Left:/ {print $7}'`"
#if test "$ESTADO" != "[on]" ; then
#echo " Mudo"
#else
#echo " `amixer get Master |awk '/Front\ Left:/ {print $5}' | sed -e 's/\[//g'|sed -e 's/%\]//g'`%"
#fi

echo " `amixer get Master |awk '/Mono:/ {print $4}' | sed -e 's/\[//g'|sed -e 's/%\]//g'`%"
echo " `amixer get Speaker |awk '/Front\ Left:/ {print $5}' | sed -e 's/\[//g'|sed -e 's/%\]//g'`%"
