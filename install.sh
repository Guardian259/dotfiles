#!/bin/bash

    $INSTALLING_USER
    $USERID
    $GROUPID
    $HOME_DIR
    $DISTRO_VER

    if [ "$(id -u)" != "0" ]; then
        CUR_DIR=$(pwd)
        INSTALLING_USER="$( ls -ld "$CUR_DIR" | cut -d" " -f3 )"
        USERID="$(id -u "$USER")"
        GROUPID="$(id -g "$USER")"
        HOME_DIR=~
        DISTRO_VER="$( cat /etc/*-release | grep VERSION_CODENAME | cut -d"=" -f2 )"
        touch userdata
        echo "$INSTALLING_USER" "$USERID" "$GROUPID" "$HOME_DIR" "$DISTRO_VER" >> "$HOME_DIR"/.dotfiles/userdata
        bash "$CUR_DIR"/install/dotfiles-main-install.sh
    else
        echo "User is root, cannot determine home dir, please run as normal user. Exiting...."
        exit 1
    fi