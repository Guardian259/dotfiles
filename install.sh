#!/bin/bash


    $SHELLPROMPTGET
    $RANGERGET
    $PACSTALLGET

    $EXTENSIONSGET
    $YAKUAKEGET
    $PROGRAMMINGGET
    $GAMMINGGET
    $MEDIAEDITGET
    $MULTIMEDIAGET
    $OFFICEGET
    $DESIGNGET

    function ask() {
        read -p "$1 (Y/n): " response
        [ -z "$response" ] || [ "$response" = "y" ] || [ "$response" = "Y" ]
    }
    #Base Install Function
    function commonProgams() {
    
    ENDFLAG=false
        while [ "$ENDCOMMONFLAG" == false ] 
        do
            read -p "Please Indicate which modules to include in your base install
            Then press 4 to install:

            [0] ALL

            [1] Custom Shell Prompt w/ Repo Branch Embed
            [2] Ranger CLI file manager
            [3] Pacstall - The AUR for Ubuntu

            [4] Exit Prompt
            " COMMONFLAG
            case "${COMMONFLAG}" in
                0 ) FLAG=All Suites; ALLCOMMONGET=true ENDCOMMONFLAG=true continue;;
                1 ) FLAG=Yakuake Console; SHELLPROMPTGET=true continue;;
                2 ) FLAG=Firefox Extensions; RANGERGET=true continue;;
                3 ) FLAG=Programming Suite; PACSTALLGET=true continue;;
                4 ) FLAG=Exit; ENDFLAG=true continue;
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
        done

    echo "Installing Nala..."
    apt install nala
    echo "Installing Neofetch..."
    apt install neofetch
    echo "installing Htop..."
    apt install htop   

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
        #
        if [ "$file" != shell/nala.sh ] && [ "$SHELLPROMPTGET" == true ]; then
            echo "Appending ${file} into ~/.bashrc..."
            echo "source $fullpath" >> ~/.bashrc
        fi
    done
    if [ "$RANGERGET" == true ]; then
        echo "Installing Ranger..."
        apt install ranger
    fi

    if [ "$PACSTALLGET" == true ]; then
        echo "Installing PacStall..."
        bash -c "$(curl -fsSL https://pacstall.dev/q/install)"
    fi
    }

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

    function getDocker() {
        # Docker Engine's Instalation
        # Add Docker's official GPG key:
        apt update
        apt install ca-certificates curl
        install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
        chmod a+r /etc/apt/keyrings/docker.asc

        # Add the repository to Apt sources:
        echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        tee /etc/apt/sources.list.d/docker.list > /dev/null
        apt update
        apt install docker-compose
        apt install docker-ce docker-ce-cli docker-compose-plugin
    }

    function getGaming() {
        echo "Installing wine & winetricks"
        apt install wine
        apt install winetricks
        echo "Installing steam & dxvk compatibility layer"
        apt install steam
        apt install dxvk
        getProtonGE
        echo "Installing Lutris..."
        apt install lutris
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
        apt update && apt install codium
    }
    function getCoding() {
        echo "Installing VS Code..."
        getVSCodium
        echo "Installing IntelliJ Idea"
        install/jetbrains-install.sh
    }

    function getMediaEditing() {
        echo "Installing Inkscape"
        apt install inkscape
        echo "Installing Handbrake"
        apt install handbrake
        echo "Installing GIMP..."
        apt install gimp
        echo "Installing Krita..."
        apt install krita
        echo "Installing Blockbech..."
        apt install blockbench
    }

    function getMultiMedia() {
        #Installing youtube-dl
        add-apt-repository ppa:tomtomtom/yt-dlp
        echo "Installing yt-dlp..."
        apt update && apt install yt-dlp
        echo "Installing vlc..."
        apt install vlc
    }

    function getDesigning() {
        echo "Installing LibreCAD..."
        apt install librecad
        echo "Installing FreeCAD..."
        apt install freecad
        echo "Installing Blender..."
        apt install blender
    }

    function getOffice() {
        echo "Installing Zotero..."
        apt install zotero
        echo "Installing Calibre..."
        apt install calibre
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

            [9] Exit Prompt
            " FLAG
            case "${FLAG}" in
                0 ) FLAG=All Suites; ALLGET=true ENDFLAG=true continue;;
                1 ) FLAG=Yakuake Console; YAKUAKEGET=true continue;;
                2 ) FLAG=Firefox Extensions; EXTENSIONSGET=true continue;;
                3 ) FLAG=Programming Suite; PROGRAMMINGGET=true continue;;
                4 ) FLAG=Gamming Suite; GAMMINGGET=true continue;;
                5 ) FLAG=Media Editing Suite; MEDIAEDITGET=true continue;;
                6 ) FLAG=Multi Media Suite; MULTIMEDIAGET=true continue;;
                7 ) FLAG=Office Suite; OFFICEGET=true continue;;
                8 ) FLAG=Design Suite; DESIGNGET=true continue;;
                9 ) FLAG=Exit; ENDFLAG=true continue;
            esac
            #Feedback to the user
            if [ "$YAKUAKEGET" == true ] || [ "$ALLGET" == true ]; then
                echo "The Yakuake Console will be Installed"
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
        done

        if [ "$YAKUAKEGET" == true ] || [ "$ALLGET" == true ]; then
            echo "Installing Yakuake Console"
            apt install Yakuake
        fi
        #Installing Discord
        echo "Installing Discord..."
        wget -O discord.deb "https://discord.com/api/download/development?platform=linux&format=deb"
        apt install ./discord.deb
        #Installing Thunderbird
        echo "Installing Thunderbird..."
        #Installing Firefox Extensions
        echo "Installing Firefox..."
        apt install firefox
        if [ "$EXTENSIONSGET" == true ] || [ "$ALLGET" == true ]; then
            for file in firfox/*
            do
                echo "Symlinking Firefox Extensions List into /etc/firefox/ ..."
                ln -s "$(realpath "policies.json")" /etc/firefox/
            done
        fi
        apt install thunderbird
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

        if $ENVIORMENT != 4; then
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
        prompt
    else
        prompt
    fi