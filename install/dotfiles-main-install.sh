#!/bin/bash

    function ask() {
        read -r -p "$1 (Y/n): " response
        [ -z "$response" ] || [ "$response" = "y" ] || [ "$response" = "Y" ]
    }

    function installPrompt() {
        read -r -p " Which Enviorment Would you like to Install??
        [1] Server Sided Enviorment: 
        [2] Desktop Enviorment:
        [3] Server & Desktop Enviorments:

        [4] Exit Install   
        >" ENVIORMENT

        if [ "$ENVIORMENT" != 4 ]; then
            if ask "You have chosen $ENVIORMENT are you sure?"; then
                echo "Installing $ENVIORMENT Enviorment..."
                bash /home/"$INSTALLING_USER"/.dotfiles/enviorment/common-install.sh
                case "${ENVIORMENT}" in
                    1 ) ENVIORMENT=Server; bash /home/"$INSTALLING_USER"/.dotfiles/enviorment/server-install.sh return;;
                    2 ) ENVIORMENT=Desktop; bash /home/"$INSTALLING_USER"/.dotfiles/enviorment/desktop-install.sh return;;
                    3 ) ENVIORMENT=All; bash /home/"$INSTALLING_USER"/.dotfiles/enviorment/server-install.sh && bash "$HOME_DIR"/.dotfiles/enviorment/desktop-install.sh return;;
                esac
            else
                installPrompt
            fi
        else
            echo "Exiting Install..."
            exit 1;
        fi
        nala upgrade -y
        echo "Install Complete!"
        exit 0;
    }

    ####################################
    ####### Install Starts Here ########
    ####################################
    # We need root to install
    if [ "$(id -u)" != "0" ]; then
        if ask "root is required to preform install, allow root elevation?"; then
            echo "Elevating to root..."
            exec sudo bash "$0" "$@"
        else 
            echo "sudo privileges were not given exiting..."
            exit 1
        fi
        installPrompt
    else
        INSTALLING_USER=$(cut userdata -d" " -f1)
        USERID=$(cut userdata -d" " -f2)
        GROUPID=$(cut userdata -d" " -f3)
        HOME_DIR=$(cut userdata -d" " -f4)
        DISTRO_VER=$(cut userdata -d" " -f5)
        rm userdata
        export INSTALLING_USER
        export USERID
        export GROUPID
        export HOME_DIR
        export DISTRO_VER
        installPrompt
    fi