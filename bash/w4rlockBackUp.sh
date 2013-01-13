#!/bin/bash
#===============================================================================
#
#          FILE:  backup2.sh
# 
#         USAGE:  ./backup2.sh 
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
#       CREATED:  10/02/2011 08:21:48 PM PDT
#      REVISION:  ---
#===============================================================================

#echo -e ${LBLUE}
LBLUE="\033[1;34m"
LGREEN="\033[1;32m"
LRED="\033[1;31m"  
LNONE="\033[0m"


STORED_DIR=git
PKG_BACK=`date +%Y-%m-%d-%H%M`
PATH_BACK=$HOME/$STORED_DIR/$PKG_BACK
CONF_DIR='.config'

RSYNC='rsync --archive 
             --backup 
             --verbose 
             --human-readable '

HOME_DIRS=('.vim' '.mutt' '.lyrics' '.irssi' '.pentadactyl')
HOME_FILES=('.gtkrc-2.0' '.screenrc' '.Xdefaults' '.xinitrc' '.pentadactylrc'

ETC_FILES=('mpd.conf' '/iptables/iptables.rules')
CONF_DIRS=('awesome' 'Thunar' 'nitrogen' 'ranger' 'luakit')
USR_SHARE=('awesome')

function make_backup()
{
  mkdir -p $PATH_BACK
  cd /etc
  echo -e ${LBLUE}'\n>>>' ${LGREEN} Checking /etc files ...  ${LNONE}
  $RSYNC ${ETC_FILES[@]} $PATH_BACK'/'etc/

  cd $HOME
  echo -e ${LBLUE}'\n>>>' ${LGREEN} Checking home directories ...  ${LNONE}
  $RSYNC ${HOME_DIRS[@]} $PATH_BACK

  echo -e ${LBLUE}'\n>>>' ${LGREEN} Checking home files ...  ${LNONE}
  $RSYNC ${HOME_FILES[@]} $PATH_BACK

  cd $CONF_DIR
  echo -e ${LBLUE}'\n>>>' ${LGREEN} Checking home config directories ...  ${LNONE}
  $RSYNC ${CONF_DIRS[@]} $PATH_BACK'/'$CONF_DIR

  cd /usr/share
  mkdir -p $PATH_BACK'/'usr/share
  echo -e ${LBLUE}'\n>>>' ${LGREEN} Checking /usr/share directories ...  ${LNONE}
  $RSYNC ${USR_SHARE[@]} $PATH_BACK'/'usr/share
}

function empaquetar()
{
	cd $PATH_BACK && cd ../
	pwd
  echo -e ${LBLUE}'\n>>>' ${LGREEN} Empaquetando backup ...  ${LNONE}
  tar -cf $PKG_BACK'_backup.tar.gz'  $PKG_BACK

}

make_backup
empaquetar
