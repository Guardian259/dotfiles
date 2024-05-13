#!/bin/bash

    $EXTENSIONSGET
    $YAKUAKEGET
    $PROGRAMMINGGET
    $GAMMINGGET
    $MEDIAEDITGET
    $MULTIMEDIAGET
    $OFFICEGET
    $DESIGNGET

    ####################################
    ######### Common Functions #########
    ####################################

    function ask() {
        read -p "$1 (Y/n): " response
        [ -z "$response" ] || [ "$response" = "y" ] || [ "$response" = "Y" ]
    }
    #Base Install Function
    function commonProgams() {
        ENDCOMMONFLAG=false
        while [ "$ENDCOMMONFLAG" == false ] 
        do
            clear
            #Feedback to the user
            if [ "$SHELLPROMPTGET" == true ] || [ "$ALLCOMMONGET" == true ]; then
                SHELLPROMPT="\e[1;30;42m[Installing]\e[0m"
            else
                SHELLPROMPT="\e[30;1;40m[Not Installing]\e[0m"
            fi
            if [ "$RANGERGET" == true ] || [ "$ALLCOMMONGET" == true ]; then
                RANGER="\e[1;30;42m[Installing]\e[0m"
            else
                RANGER="\e[30;1;40m[Not Installing]\e[0m"
            fi
            if [ "$PACSTALLGET" == true ] || [ "$ALLCOMMONGET" == true ]; then
                PACSTALL="\e[1;30;42m[Installing]\e[0m"
            else
                PACSTALL="\e[30;1;40m[Not Installing]\e[0m"
            fi
            if [ "$SHELLPROMPTGET" == true ] && [ "$RANGERGET" == true ] && [ "$PACSTALLGET" == true ]; then
                ENDCOMMONFLAG=true
            fi
            PROMPT="\e[5m>\e[0m"
            echo -e "Please Indicate which modules to include in your base install
            Then press 4 to install:

            [0] ALL

            [1] Custom Shell Prompt w/ Git Repo Branch Version $SHELLPROMPT
            [2] Ranger CLI file manager $RANGER
            [3] Pacstall - The AUR for Ubuntu $PACSTALL

            [4] Install Modules
            [5] Exit Prompt
            $PROMPT"
            read COMMONFLAG
            case "${COMMONFLAG}" in
                0 ) COMMONFLAG=All; ALLCOMMONGET=true; ENDCOMMONFLAG=true; ;;
                1 ) COMMONFLAG=Yakuake;
                    if [ "$SHELLPROMPTGET" == true ]; then 
                        SHELLPROMPTGET=false
                    else
                        SHELLPROMPTGET=true
                    fi ;;
                2 ) COMMONFLAG=Firefox;
                    if [ "$RANGERGET" == true ]; then 
                        RANGERGET=false
                    else
                        RANGERGET=true
                    fi ;;
                3 ) COMMONFLAG=Programming;
                    if [ "$PACSTALLGET" == true ]; then 
                        PACSTALLGET=false
                    else
                        PACSTALLGET=true
                    fi ;;
                4 ) COMMONFLAG=Install; ENDCOMMONFLAG=true; continue;;
                5 ) COMMONFLAG=Exit; return;
            esac
        done

        echo "Installing Nala..."
        apt install -y nala
        echo "Fetching Mirrors..."
        nala fetch && nala update
        echo "Installing Neofetch..."
        nala install -y neofetch
        echo "installing Htop..."
        nala install -y htop   

        for file in shell/*
        do
            fullpath=$(realpath "$file")
            #Appending Nala onto bashrc
            if [ "$file" = shell/nala.sh ]; then
                echo "Appending ${file} into ~/.bashrc..."
                echo "source $fullpath" >> ~/.bashrc
                echo "Appending ${file} into /root/.bashrc..."
                echo "source $fullpath" >> /etc/bash.bashrc
            fi
            #Appending Shell Prompt onto bashrc
            if [ "$file" != shell/nala.sh ] && [ "$SHELLPROMPTGET" == true ]; then
                echo "Appending ${file} into ~/.bashrc..."
                echo "source $fullpath" >> ~/.bashrc
            fi
        done
        if [ "$RANGERGET" == true ]; then
            echo "Installing Ranger..."
            apt install -y ranger
        fi

        if [ "$PACSTALLGET" == true ]; then
            echo "Installing PacStall..."
            bash -c "$(curl -fsSL https://pacstall.dev/q/install)"
        fi
    }

    ####################################
    ######### Server Functions #########
    ####################################

    function getDocker() {
        # Docker Engine's Instalation
        # Add Docker's official GPG key:
        nala update
        nala install -y ca-certificates curl
        install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
        chmod a+r /etc/apt/keyrings/docker.asc

        # Add the repository to Apt sources:
        echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        tee /etc/apt/sources.list.d/docker.list > /dev/null
        nala update
        nala install -y docker-compose
        nala install -y docker-ce docker-ce-cli docker-compose-plugin
    }

    ####################################
    ######## Desktop Functions #########
    ####################################

    function getProtonGE() {
        echo "Installing GE-Proton..."
        # make temp working directory
        mkdir /tmp/proton-ge-custom
        cd /tmp/proton-ge-custom || return
        # download  tarball
        curl -sLOJ "$(curl -s https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest | grep browser_download_url | cut -d\" -f4 | grep .tar.gz)"
        # download checksum
        curl -sLOJ "$(curl -s https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest | grep browser_download_url | cut -d\" -f4 | grep .sha512sum)"
        # check tarball with checksum
        if sha512sum -c ./*.sha512sum; then # if result is ok, continue
            # make steam directory if it does not exist
            mkdir -p ~/.steam/root/compatibilitytools.d
            # extract proton tarball to steam directory
            tar -xf GE-Proton*.tar.gz -C ~/.steam/root/compatibilitytools.d/
            cd ..
            echo "All done :)"
        else
            echo "Checksum mismatch exiting..."
        fi
        #CUR_DIR=$(pwd)
        #[ ! -h "/root/.scripts/update-ge-proton.sh" ] && ln -s "$CUR_DIR"/update-ge-proton.sh /root/.scripts/
    }

    function getGaming() {
        echo "Installing wine & winetricks"
        nala install -y wine
        nala install -y winetricks
        echo "Installing steam & dxvk compatibility layer"
        wget "https://cdn.akamai.steamstatic.com/client/installer/steam.deb" -O steam_latest.deb
        nala install -y ./steam_latest.deb 
        rm steam_latest.deb
        #dxvk_version=$(curl --head https://github.com/doitsujin/dxvk/releases/latest | tr -d '\r' | grep '^location' | sed 's/.*\/v//g')
        #echo "Installing dxvk $dxvk_version..."
        #wget "https://github.com/doitsujin/dxvk/releases/download/v$dxvk_version/dxvk-$dxvk_version.tar.gz" -O dxvk-"$dxvk_version".tar.gz
        #export WINEPREFIX=/path/to/wineprefix
        #cp x64/*.dll $WINEPREFIX/drive_c/windows/system32
        #cp x32/*.dll $WINEPREFIX/drive_c/windows/syswow64
        #winecfg
        getProtonGE
        echo "Installing Lutris..."
        nala install -y lutris
        echo "Installing Minecraft..."
        wget -qO Minecraft.deb https://launcher.mojang.com/download/Minecraft.deb
        nala install -y ./Minecraft.deb
        rm Minecraft.deb
    }

    function getVSCodium() {
        #Add VSCodium GPG key:
        wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
        | gpg --dearmor \
        | dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
        #Add the repository
        echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
        | tee /etc/apt/sources.list.d/vscodium.list
        #Installing vscodium
        echo "Installing VSCodium..."
        nala update && nala install -y codium
    }
    function getCoding() {
        echo "Installing VS Code..."
        getVSCodium
        echo "Installing IntelliJ Idea"
        CUR_DIR=$(pwd)
        bash "$CUR_DIR"/install/jetbrains-install.sh
        #Adding Github-Desktop-Linux Repo
        wget -qO - https://apt.packages.shiftkey.dev/gpg.key | gpg --dearmor | sudo tee /usr/share/keyrings/shiftkey-packages.gpg > /dev/null
        sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/shiftkey-packages.gpg] https://apt.packages.shiftkey.dev/ubuntu/ any main" > /etc/apt/sources.list.d/shiftkey-packages.list'
        #Installing Github Desktop Linux...
        echo "Installing Github Desktop..."
        nala update
        nala install -y github-desktop
        #Installing Adoptium JDK...
        echo "Installing Adoptium JDK..."
        nala install -y wget apt-transport-https gpg
        wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor | tee /etc/apt/trusted.gpg.d/adoptium.gpg > /dev/null
        echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list
        nala update
        nala install -y temurin-17-jdk
    }

    function getMediaEditing() {
        echo "Installing Inkscape"
        nala install -y inkscape
        echo "Installing Handbrake"
        nala install -y handbrake
        echo "Installing GIMP..."
        nala install -y gimp
        echo "Installing Krita..."
        nala install -y krita
        blockbench_version=$(curl --head https://github.com/JannisX11/blockbench/releases/latest | tr -d '\r' | grep '^location' | sed 's/.*\/v//g')
        echo "Installing Blockbech $blockbench_version..."
        wget "https://github.com/JannisX11/blockbench/releases/download/v$blockbench_version/Blockbench_$blockbench_version.deb" -O blockbench-"$blockbench_version".deb
        nala install -y ./blockbench-"$blockbench_version".deb
        rm blockbench-"$blockbench_version".deb
    }

    function getMultiMedia() {
        #Installing youtube-dl
        add-apt-repository ppa:tomtomtom/yt-dlp
        echo "Installing yt-dlp..."
        nala update && nala install -y yt-dlp
        echo "Installing vlc..."
        nala install -y vlc
        #Installing Jellyfin Media Player
        echo "Installing Jellyfin Mdeia Player..."
        jellyfin_version=$(curl --head https://github.com/jellyfin/jellyfin-media-player/releases/latest | tr -d '\r' | grep '^location' | sed 's/.*\/v//g')
        echo "Installing Jellyfin Mdeia Player $jellyfin_version..."
        wget "https://github.com/jellyfin/jellyfin-media-player/releases/download/v$jellyfin_version/jellyfin-media-player_$jellyfin_version-1_amd64-jammy.deb" -O jellyfin-media-player-"$jellyfin_version".deb
        nala install -y ./jellyfin-media-player-"$jellyfin_version".deb
        rm jellyfin-media-player-"$jellyfin_version".deb
        #Installing Sonixd
        #echo "Installing Sonixd Media Player..."
        #sonixd_version=$(curl --head https://github.com/jeffvli/sonixd/releases/latest | tr -d '\r' | grep '^location' | sed 's/.*\/v//g')
        #wget "https://github.com/jeffvli/sonixd/releases/download/v$sonixd_version/Sonixd-$sonixd_version-linux-arm64.tar.xz" -O Sonixd-"$sonixd_version".tar.xz
        #apt install -y ./jellyfin-media-player.deb
        #rm Sonixd-"$sonixd_version".tar.xz
    }

    function getDesigning() {
        echo "Installing LibreCAD..."
        nala install -y librecad
        echo "Installing FreeCAD..."
        nala install -y freecad
        echo "Installing Blender..."
        nala install -y blender
    }

    function getOffice() {
        echo "Installing Zotero..."
        wget -qO zotero-install.sh https://raw.githubusercontent.com/retorquere/zotero-deb/master/install.sh | bash
        nala update
        nala install zotero 
        echo "Installing Calibre..."
        nala install -y calibre
    }

    #Server Enviorment Suite
    function serverEn() {
    
        ENDFLAG=false
        while [ "$ENDFLAG" == false ] 
        do
            clear
            #Feedback to the user
            if [ "$DOCKERGET" == true ] || [ "$ALLGET" == true ]; then
                DOCKER="\e[1;30;42m[Installing]\e[0m"
            else
                DOCKER="\e[30;1;40m[Not Installing]\e[0m"
            fi
            if [ "$DESIGNGET" == true ]; then
                ENDFLAG=true
            fi

            PROMPT="\e[5m>\e[0m"

            echo -e "Please Indicate which module suites' to include in your install
            Then press 2 to install:
            
            [0] ALL

            [1] Docker Suite $DOCKER

            [2] Install Modules
            [x] Exit Prompt
            \e[5m>\e[0m" 
            read FLAG

            case "${FLAG}" in
                0 ) FLAG=All; ALLGET=true; ENDFLAG=true; ;;
                1 ) FLAG=Docker; 
                    if [ "$DOCKERGET" == true ]; then 
                        DOCKERGET=false
                    else
                        DOCKERGET=true
                    fi ;;
                2 ) FLAG=Install; ENDFLAG=true; continue;;
                x ) FLAG=Exit; EXITFLAG=true;
            esac
            if [ "$EXITFLAG" == true ]; then
            echo "Exiting Install..."
            exit 1;
            fi
        done
        if [ "$DOCKERGET" == true ] || [ "$ALLGET" == true ]; then
            getDocker
        fi
    }

    #Desktop Enviorment Suite
    function desktopEn() {
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
            read FLAG

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
           if [ "$YAKUAKEGET" == true ] || [ "$ALLGET" == true ]; then
            echo "Installing Yakuake Console"
            nala install -y yakuake
        fi
        #Installing Discord
        echo "Installing Discord..."
        wget -qO discord.deb "https://discord.com/api/download/development?platform=linux&format=deb"
        nala install -y ./discord.deb
        #Installing Thunderbird
        echo "Installing Thunderbird..."
        nala install -y thunderbird
        #echo "Installing Birdtray..."
        #nala install -y birdtray
        #Installing Firefox Extensions
        echo "Installing Firefox..."
        nala install -y firefox
        #Installing Nordvpn
        if ask "Would you like to install Nordvpn? (Y/n)"; then
            echo "Installing Nordvpn..."
            sh <(wget -qO - https://downloads.nordcdn.com/apps/linux/install.sh)
        fi
        if [ "$EXTENSIONSGET" == true ] || [ "$ALLGET" == true ]; then
            for file in firfox/*
            do
                echo "Symlinking Firefox Extensions List into /etc/firefox/ ..."
                ln -s "$(realpath "$file")" /etc/firefox/
            done
        fi    
        if [ "$PROGRAMMINGGET" == true ] || [ "$ALLGET" == true ]; then
            getCoding
        fi
        if [ "$GAMMINGGET" == true ] || [ "$ALLGET" == true ]; then
            getGaming
        fi
        if [ "$MEDIAEDITGET" == true ] || [ "$ALLGET" == true ]; then
            getMediaEditing
        fi
        if [ "$MULTIMEDIAGET" == true ] || [ "$ALLGET" == true ]; then
            getMultiMedia
        fi
        if [ "$OFFICEGET" == true ] || [ "$ALLGET" == true ]; then
            getOffice
        fi
        if [ "$DESIGNGET" == true ] || [ "$ALLGET" == true ]; then
            getDesigning
        fi
        
    }

    function installPrompt() {
        read -p " Which Enviorment Would you like to Install??
        [1] Server Sided Enviorment: 
        [2] Desktop Enviorment:
        [3] Server & Desktop Enviorments:

        [4] Exit Install   
        >" ENVIORMENT

        if [ "$ENVIORMENT" != 4 ]; then
            if ask "You have chosen $ENVIORMENT are you sure?"; then
                echo "Installing $ENVIORMENT Enviorment..."
                commonProgams
                case "${ENVIORMENT}" in
                    1 ) ENVIORMENT=Server; serverEn return;;
                    2 ) ENVIORMENT=Desktop; desktopEn return;;
                    3 ) ENVIORMENT=All; serverEn && desktopEn return;;
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
            exec sudo "$0" "$@"
        else 
            echo "sudo privileges were not given exiting..."
            exit 1
        fi
        installPrompt
    else
        installPrompt
    fi