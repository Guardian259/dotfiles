#!/bin/bash

    function ask() {
        read -p "$1 (Y/n): " response
        [ -z "$response" ] || [ "$response" = "y" ] || [ "$response" = "Y" ]
    }
    function commonProgams() {
    echo "Installing Nala..."
    apt install nala
    echo "Installing Neofetch..."
    apt install neofetch

    for file in shell/*
    do
        fullpath=$(realpath $file)
        if ask "Source ${file}?"; then
            echo "Appending ${file} into ~/.bashrc..."
            echo "source $fullpath" >> ~/.bashrc
            if [ $file = shell/nala.sh ]; then
                echo "Appending ${file} into /root/.bashrc..."
                echo "source $fullpath" >> /etc/bash.bashrc
            fi
        fi
    done
    if ask "Would you like to install Ranger CLI file manager?"; then
        apt install ranger
    fi

    if ask "Would you like to install Pacstall - The AUR for Ubuntu?"; then
        bash -c "$(curl -fsSL https://pacstall.dev/q/install)"
    fi
    }

    function getProtonGE() {
        echo "Installing GE-Proton..."
        # make temp working directory
        mkdir /tmp/proton-ge-custom
        cd /tmp/proton-ge-custom
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
        if ask "Would you like to install the Docker Suite?"; then   
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
        fi
    }

    function getGamming() {
        if ask "Would you like to install the gamming suite?"; then
            echo "Installing wine & winetricks"
            apt install wine
            apt install winetricks
            echo "Installing steam & dxvk compatibility layer"
            apt install steam
            apt install dxvk
            getProtonGE
            echo "Installing Lutris..."
            apt install lutris
        fi
     
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
        apt update && apt install codium
    }
    function getCoding() {
        echo "Installing VS Code..."
        getVSCodium
        echo "Installing IntelliJ Idea"
        source install/jetbrains-install.sh
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
        true
    }

    function getOffice() {
        echo "Installing Zotero..."
        apt install zotero
        echo "Installing Calibre..."
        apt install calibre
        #Installing Thunderbird
        echo "Installing Thunderbird..."
        apt install thunderbird
    }

    function serverEn() {
        #Server Enviorment Suite
        if ask "Would you like to install Server Enviorment programs?"; then
            getDocker
            apt upgrade
        fi
    }

    function desktopEn() {
    #   Desktop Enviorment Suite
        if ask "would you like to install Desktop Enviorment programs?"; then
            if ask "Would you like to install Yakuake console?"; then
                apt install Yakuake
            fi
            #Installing Discord
            echo "Installing Discord..."
            wget -O discord.deb "https://discord.com/api/download/development?platform=linux&format=deb"
            apt install ./discord.deb
            #Installing Firefox Extensions
            echo "Installing Firefox..."
            apt install firefox
            if ask "Would you like to install firefox extensions?"; then
                for file in firfox/*
                do
                    echo "Symlinking Firefox Extensions List..."
                    ln -s "$(realpath "policies.json")" /etc/firefox/
                done
            fi
            getCoding
            getGamming
            getMediaEditing
            getMultiMedia
            getOffice
            apt upgrade
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
        fi