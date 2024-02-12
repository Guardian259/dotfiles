#!/bin/bash

    function ask() {
        read -p "$1 (Y/n): " response
        [ -z "$response" ] || [ "$response" = "y" ] || [ "$response" = "Y" ]
    }
    function commonProgams() {
    echo "Installing Nala..."
    apt install nala

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

    commonProgams

    if ask "Would you like to install Server Enviorment programs?"; then
        if ask "Would you like to install the Docker Suite?"; then
            getDocker
        fi
        apt upgrade
    fi

    if ask "would you like to install Desktop Enviorment programs?"; then
        if ask "Would you like to install Yakuake console?"; then
            apt install Yakuake
        fi
        #Installing Discord
        wget -O discord.deb "https://discord.com/api/download/development?platform=linux&format=deb"
        apt install ./discord.deb
        #Installing Firefox Extensions
        apt install firefox
        for file in firfox/*
            if ask "Would you like to install firefox extensions?"; then
                ln -s "$(realpath "policies.json")" /etc/firefox/
            fi
        done
        #Installing wine & winetricks
        apt install wine
        apt install winetricks
        #Installing steam & dxvk
        apt install steam
        apt install dxvk
        getProtonGE
        #Installing youtube-dl
        add-apt-repository ppa:tomtomtom/yt-dlp
        apt update && apt install yt-dlp
        #Add VSCodium GPG key:
        wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
        | gpg --dearmor \
        | dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
        #Add the repository
        echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
        | tee /etc/apt/sources.list.d/vscodium.list
        #Installing vscodium
        apt update && apt install codium
        apt upgrade
    fi
