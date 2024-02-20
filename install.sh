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
            read -p "Please Indicate which modules to include in your base install
            Then press 4 to install:

            [0] ALL

            [1] Custom Shell Prompt w/ Repo Branch Embed
            [2] Ranger CLI file manager
            [3] Pacstall - The AUR for Ubuntu

            [4] Install Modules
            [5] Exit Prompt
            " COMMONFLAG
            case "${COMMONFLAG}" in
                0 ) COMMONFLAG=All; ALLCOMMONGET=true; ENDCOMMONFLAG=true; ;;
                1 ) COMMONFLAG=Yakuake; SHELLPROMPTGET=true; ;;
                2 ) COMMONFLAG=Firefox; RANGERGET=true; ;;
                3 ) COMMONFLAG=Programming; PACSTALLGET=true; ;;
                4 ) COMMONFLAG=Install; ENDCOMMONFLAG=true; continue;;
                5 ) COMMONFLAG=Exit; return;
            esac

            #Feedback to the user
            if [ "$SHELLPROMPTGET" == true ] || [ "$ALLCOMMONGET" == true ]; then
                echo "The Custom Shell Prompt w/ Repo Branch Embed will be Installed"
            fi
            if [ "$RANGERGET" == true ] || [ "$ALLCOMMONGET" == true ]; then
                echo "Ranger CLI file manager will be Installed"
            fi
            if [ "$PACSTALLGET" == true ] || [ "$ALLCOMMONGET" == true ]; then
                echo "Pacstall - The AUR for Ubuntu will be Installed"
            fi
            if [ "$SHELLPROMPTGET" == true ] && [ "$RANGERGET" == true ] && [ "$PACSTALLGET" == true ]; then
                echo "All Common Modules will be Installed"
                ENDCOMMONFLAG=true
            fi
        done

        echo "Installing Nala..."
        apt install -y nala
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
    }

    function getGaming() {
        echo "Installing wine & winetricks"
        nala install -y wine
        nala install -y winetricks
        echo "Installing steam & dxvk compatibility layer"
        nala install -y steam
        nala install -y dxvk
        getProtonGE
        echo "Installing Lutris..."
        nala install -y lutris
        echo "Installing Minecraft..."
        wget -qO Minecraft.deb https://launcher.mojang.com/download/Minecraft.deb
        nala install -y ./Minecraft.deb
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
        install/jetbrains-install.sh
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
        echo "Installing Blockbech..."
        wget -qO blockbench.deb https://github.com/JannisX11/blockbench/releases/download/v4.9.4/Blockbench_4.9.4.deb
        nala install -y ./blockbench.deb
    }

    function getMultiMedia() {
        #Installing youtube-dl
        add-apt-repository ppa:tomtomtom/yt-dlp
        echo "Installing yt-dlp..."
        nala update && nala install -y yt-dlp
        echo "Installing vlc..."
        nala install -y vlc
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
        #echo "Installing Zotero..."
        #apt install zotero
        echo "Installing Calibre..."
        nala install -y calibre
    }

    #Server Enviorment Suite
    function serverEn() {
        getDocker
    }

    #Desktop Enviorment Suite
    function desktopEn() {
        ENDFLAG=false
        while [ "$ENDFLAG" == false ] 
        do
            read -p "Please Indicate which module suites' to include in your install
            Then press 9 to install:

            [0] ALL

            [1] Yakuake Consol
            [2] Firefox Extensions
            [3] Programming Suite
            [4] Gaming Suite
            [5] Media Editing Suite
            [6] Multi-Media Suite
            [7] Office Suite
            [8] Design Suite

            [9] Install Modules
            [x] Exit Prompt
            " FLAG
            case "${FLAG}" in
                0 ) FLAG=All; ALLGET=true; ENDFLAG=true; ;;
                1 ) FLAG=Yakuake; YAKUAKEGET=true; ;;
                2 ) FLAG=Firefox; EXTENSIONSGET=true; ;;
                3 ) FLAG=Programming; PROGRAMMINGGET=true; ;;
                4 ) FLAG=Gamming; GAMMINGGET=true; ;;
                5 ) FLAG=Media Editing; MEDIAEDITGET=true; ;;
                6 ) FLAG=Multi Media; MULTIMEDIAGET=true; ;;
                7 ) FLAG=Office; OFFICEGET=true; ;;
                8 ) FLAG=Design; DESIGNGET=true; ;;
                9 ) FLAG=Install; ENDFLAG=true; continue;;
                x ) FLAG=Exit; return;
            esac
            #Feedback to the user
            if [ "$YAKUAKEGET" == true ] || [ "$ALLGET" == true ]; then
                echo "The Yakuake Console will be Installed"
            fi
            if [ "$EXTENSIONSGET" == true ] || [ "$ALLGET" == true ]; then
                echo "Firefox Extensions will be Installed"
            fi
            if [ "$PROGRAMMINGGET" == true ] || [ "$ALLGET" == true ]; then
                echo "The Programming Suite will be Installed"
            fi
            if [ "$GAMMINGGET" == true ] || [ "$ALLGET" == true ]; then
                echo "The Gaming Suite will be Installed"
            fi
            if [ "$MEDIAEDITGET" == true ] || [ "$ALLGET" == true ]; then
                echo "The Media Editing Suite will be Installed"
            fi
            if [ "$MULTIMEDIAGET" == true ] || [ "$ALLGET" == true ]; then
                echo "The Multi-Media Suite will be Installed"
            fi
            if [ "$OFFICEGET" == true ] || [ "$ALLGET" == true ]; then
                echo "The Office Suite will be Installed"
            fi
            if [ "$DESIGNGET" == true ] || [ "$ALLGET" == true ]; then
                echo "The Design Suite will be Installed"
            fi
            if [ "$DESIGNGET" == true ] && [ "$OFFICEGET" == true ] && [ "$MULTIMEDIAGET" == true ] && [ "$MEDIAEDITGET" == true ] && [ "$GAMMINGGET" == true ] && [ "$PROGRAMMINGGET" == true ] && [ "$EXTENSIONSGET" == true ] && [ "$YAKUAKEGET" == true ]; then
                echo "All Desktop Modules Will be Installed"
                ENDFLAG=true
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
        apt upgrade
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