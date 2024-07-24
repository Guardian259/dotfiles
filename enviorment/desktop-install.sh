#!/bin/bash

    $EXTENSIONSGET
    $YAKUAKEGET
    $PROGRAMMINGGET
    $GAMMINGGET
    $MEDIAEDITGET
    $MULTIMEDIAGET
    $OFFICEGET
    $DESIGNGET

    $INSTALLING_USER
    $USERID
    $GROUPID
    $HOME_DIR
    $DISTRO_VER

    function ask() {
        read -r -p "$1 (Y/n): " response
        [ -z "$response" ] || [ "$response" = "y" ] || [ "$response" = "Y" ]
    }

    function processSuite() {
        for file in install/"$1"/*
        do
            bash "$file"
        done
    }

ENDFLAG=false
while [ "$ENDFLAG" == false ] 
do
    clear
    #Feedback to the user
    if [ "$YAKUAKEGET" == true ] || [ "$ALLGET" == true ]; then
        YAKUAKE="\e[1;30;42m[Installing]\e[0m"
    else
        YAKUAKE="\e[30;1;40m[Not Installing]\e[0m"
    fi
    if [ "$EXTENSIONSGET" == true ] || [ "$ALLGET" == true ]; then
        EXTENSIONS="\e[1;30;42m[Installing]\e[0m"
    else
        EXTENSIONS="\e[30;1;40m[Not Installing]\e[0m"
    fi
    if [ "$PROGRAMMINGGET" == true ] || [ "$ALLGET" == true ]; then
        PROGRAMMING="\e[1;30;42m[Installing]\e[0m"
    else
        PROGRAMMING="\e[30;1;40m[Not Installing]\e[0m"
    fi
    if [ "$GAMMINGGET" == true ] || [ "$ALLGET" == true ]; then
        GAMING="\e[1;30;42m[Installing]\e[0m"
    else
        GAMING="\e[30;1;40m[Not Installing]\e[0m"
    fi
    if [ "$MEDIAEDITGET" == true ] || [ "$ALLGET" == true ]; then
        MEDIA="\e[1;30;42m[Installing]\e[0m"
    else
        MEDIA="\e[30;1;40m[Not Installing]\e[0m"
    fi
    if [ "$MULTIMEDIAGET" == true ] || [ "$ALLGET" == true ]; then
        MULTIMEDIA="\e[1;30;42m[Installing]\e[0m"
    else
        MULTIMEDIA="\e[30;1;40m[Not Installing]\e[0m"
    fi
    if [ "$OFFICEGET" == true ] || [ "$ALLGET" == true ]; then
        OFFICE="\e[1;30;42m[Installing]\e[0m"
    else
        OFFICE="\e[30;1;40m[Not Installing]\e[0m"
    fi
    if [ "$DESIGNGET" == true ] || [ "$ALLGET" == true ]; then
        DESIGN="\e[1;30;42m[Installing]\e[0m"
    else
        DESIGN="\e[30;1;40m[Not Installing]\e[0m"
    fi
    if [ "$DESIGNGET" == true ] && [ "$OFFICEGET" == true ] && [ "$MULTIMEDIAGET" == true ] && [ "$MEDIAEDITGET" == true ] && [ "$GAMMINGGET" == true ] && [ "$PROGRAMMINGGET" == true ] && [ "$EXTENSIONSGET" == true ] && [ "$YAKUAKEGET" == true ]; then
        ENDFLAG=true
    fi

    PROMPT="\e[5m>\e[0m"

    echo -e "Please Indicate which module suites' to include in your install
    Then press 9 to install:
    
    [0] ALL

    [1] Yakuake Console $YAKUAKE
    [2] Firefox Extensions $EXTENSIONS
    [3] Programming Suite $PROGRAMMING
    [4] Gaming Suite $GAMING
    [5] Media Editing Suite $MEDIA
    [6] Multi-Media Suite $MULTIMEDIA
    [7] Office Suite $OFFICE
    [8] Design Suite $DESIGN

    [9] Install Modules
    [x] Exit Prompt
    \e[5m>\e[0m" 
    read -r FLAG

    case "${FLAG}" in
        0 ) FLAG=All; ALLGET=true; ENDFLAG=true; ;;
        1 ) FLAG=Yakuake; 
            if [ "$YAKUAKEGET" == true ]; then 
                YAKUAKEGET=false
            else
                YAKUAKEGET=true
            fi ;;
        2 ) FLAG=Firefox;
            if [ "$EXTENSIONSGET" == true ]; then 
                EXTENSIONSGET=false
            else
                EXTENSIONSGET=true
            fi ;;
        3 ) FLAG=Programming;
            if [ "$PROGRAMMINGGET" == true ]; then 
                PROGRAMMINGGET=false
            else
                PROGRAMMINGGET=true
            fi ;;
        4 ) FLAG=Gamming;
            if [ "$GAMMINGGET" == true ]; then 
                GAMMINGGET=false
            else
                GAMMINGGET=true
            fi ;;
        5 ) FLAG=Media Editing; 
            if [ "$MEDIAEDITGET" == true ]; then 
                MEDIAEDITGET=false
            else
                MEDIAEDITGET=true
            fi ;;
        6 ) FLAG=Multi Media; 
            if [ "$MULTIMEDIAGET" == true ]; then 
                MULTIMEDIAGET=false
            else
                MULTIMEDIAGET=true
            fi ;;
        7 ) FLAG=Office; 
            if [ "$OFFICEGET" == true ]; then 
                OFFICEGET=false
            else
                OFFICEGET=true
            fi ;;
        8 ) FLAG=Design; 
            if [ "$DESIGNGET" == true ]; then 
                DESIGNGET=false
            else
                DESIGNGET=true
            fi ;;
        9 ) FLAG=Install; ENDFLAG=true; continue;;
        x ) FLAG=Exit; EXITFLAG=true;
    esac
    if [ "$EXITFLAG" == true ]; then
    echo "Exiting Install..."
    exit 1;
    fi

done
DISCORDENDFLAG=false
while [ "$DISCORDENDFLAG" == false ]
do
    clear
    #Feedback to the user
    if [ "$WEBCORDGET" == true ] || [ "$ALLDISCORDGET" == true ]; then
        WEBCORD="\e[1;30;42m[Installing]\e[0m"
    else
        WEBCORD="\e[30;1;40m[Not Installing]\e[0m"
    fi
    if [ "$CANARYGET" == true ] || [ "$ALLDISCORDGET" == true ]; then
        CANARY="\e[1;30;42m[Installing]\e[0m"
    else
        CANARY="\e[30;1;40m[Not Installing]\e[0m"
    fi
    if [ "$DEVELOPMENTGET" == true ] || [ "$ALLDISCORDGET" == true ]; then
        DEVELOPMENT="\e[1;30;42m[Installing]\e[0m"
    else
        DEVELOPMENT="\e[30;1;40m[Not Installing]\e[0m"
    fi
    if [ "$DEVELOPMENTGET" == true ] && [ "$CANARYGET" == true ]; then
        DISCORDENDFLAG=true
    fi

    # shellcheck disable=SC2034
    PROMPT="\e[5m>\e[0m"

    echo -e "Please Indicate which Version of Discord to include in your install
    Then press 9 to install:

    **Warning Discord Development is bleadin edge and can/will be unstable **
    **Only install if you are comfortable working around any issues**
    **WebCord has Compatibility with both Spacebar Servers, as well as,**
    **Discord and allows audio streaming, however it can be viewed as breaking TOS. It is unlikely but you have been warned**

    [0] ALL

    [1] WebCord $WEBCORD
    [2] Discord Canary $CANARY
    [3] Discord Development $DEVELOPMENT

    [9] Install Discord
    [x] Exit Prompt
    \e[5m>\e[0m"
    read -r FLAG

    case "${FLAG}" in
        0 ) FLAG=All; ALLDISCORDGET=true; ENDFLAG=true; ;;
        1 ) FLAG=webcord;
            if [ "$WEBCORD" == true ]; then
                WEBCORDGET=false
            else
                WEBCORDGET=true
            fi ;;
        2 ) FLAG=canary;
            if [ "$CANARY" == true ]; then
                CANARYGET=false
            else
                CANARYGET=true
            fi ;;
        3 ) FLAG=development;
            if [ "$DEVELOPMENT" == true ]; then
                DEVELOPMENTGET=false
            else
                DEVELOPMENTGET=true
            fi ;;
        9 ) FLAG=Install; DISCORDENDFLAG=true; continue;;
        x ) FLAG=Exit; EXITFLAG=true;
    esac
    if [ "$EXITFLAG" == true ]; then
    echo "Exiting Install..."
    exit 1;
    fi
done
#Installing Yakuake
if [ "$YAKUAKEGET" == true ] || [ "$ALLGET" == true ]; then
    echo "Installing Yakuake Console"
    nala install -y yakuake
fi
#Installing Discord
if [ "$WEBCORDGET" == true ] || [ "$ALLDISCORDGET" == true ]; then
    echo "Installing WebCord..."
    webcord_version=$(curl --head https://github.com/SpacingBat3/WebCord/releases/latest | tr -d '\r' | grep '^location' | sed 's/.*\/v//g')
    wget -qO webcord.deb "https://github.com/SpacingBat3/WebCord/releases/download/v${webcord_version}/webcord_${webcord_version}_amd64.deb"
    nala install -y ./webcord.deb
fi
if [ "$CANARYGET" == true ] || [ "$ALLDISCORDGET" == true ]; then
    echo "Installing Discord Canary..."
    wget -qO discord-canary.deb "https://discord.com/api/download/canary?platform=linux&format=deb"
    nala install -y ./discord-canary.deb
fi
if [ "$DEVELOPMENTGET" == true ] || [ "$ALLDISCORDGET" == true ]; then
    echo "Installing Discord Development..."
    wget -qO discord-development.deb "https://discord.com/api/download/development?platform=linux&format=deb"
    nala install -y ./discord-development.deb
fi

#Installing Nordvpn
if ask "Would you like to install Nordvpn? (Y/n)"; then
    echo "Installing Nordvpn..."
    sh <(wget -qO - https://downloads.nordcdn.com/apps/linux/install.sh)
fi
processSuite desktop
#Installing Tor-Browser
if ask "Would you like to install the Tor-Browser? (Y/n)"; then
    echo "Installing Tor-Browser..."
    bash "$HOME_DIR"/.dotfiles/install/tor-browser-install.sh
fi
if [ "$EXTENSIONSGET" == true ] || [ "$ALLGET" == true ]; then
    #bash firefox-extensions.sh
    echo "Symlinking Firefox Extensions List into /etc/firefox/policies ..."
    mkdir -p /etc/firefox/policies
    for file in firefox/*
    do
        fullpath=$(realpath "$file")
        if [ "$file" = firefox/policies.json ]; then
            ln -s "$fullpath" /etc/firefox/policies
        fi
    done
fi    
if [ "$PROGRAMMINGGET" == true ] || [ "$ALLGET" == true ]; then
    processSuite coding
fi
if [ "$GAMMINGGET" == true ] || [ "$ALLGET" == true ]; then
    processSuite gaming
fi
if ask "Would you like to install Wallpaper Engine Plugin For KDE? (Y/n)"; then
    if [ "$DESKTOP_SESSION" == "plasma" ]; then 
        echo "Installing Wallpaper Engine Plugin for KDE..."
        bash "$HOME_DIR"/.dotfiles/install/wallpaper-engine-kde-install.sh
    else 
        echo "KDE Plasma Desktop Not Identified Skipping Plugin Install..."
    fi
fi
if [ "$MEDIAEDITGET" == true ] || [ "$ALLGET" == true ]; then
    processSuite media
fi
if [ "$MULTIMEDIAGET" == true ] || [ "$ALLGET" == true ]; then
    processSuite multi-media
fi
if [ "$OFFICEGET" == true ] || [ "$ALLGET" == true ]; then
    processSuite office
fi
if [ "$DESIGNGET" == true ] || [ "$ALLGET" == true ]; then
    processSuite design
fi