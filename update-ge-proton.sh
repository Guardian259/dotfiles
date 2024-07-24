#!/bin/bash

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
    ####################################
    ####### Updater Starts Here ########
    ####################################
    PROTONGE_VERSION=$(curl -s https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest | grep tag_name | grep 'GE-Proton' | cut -d'n' -f3 | cut -d'"' -f1)
    #pulls the previous ProtonGE Version number for comparision
    PREVIOUS_VERSION_STRING=$( ls ~/.steam/root/compatibilitytools.d/ | grep -v ".tar.gz" | grep 'GE-Proton' | cut -d'n' -f2 | sort -n -r )
    read -r -a PREVIOUS_VERSION_ARRAY <<< "$PREVIOUS_VERSION_STRING"
    CURRENT_VERSION=${PREVIOUS_VERSION_ARRAY[0]}
    CURRENT_MAJOR_VERSION=$($CURRENT_VERSION | cut -d'-' -f1)
    CURRENT_MINOR_VERSION=$($CURRENT_VERSION | cut -d'-' -f2)
    PROTONGE_MAJOR_VERSION=$($PROTONGE_VERSION | cut -d'-' -f1)
    PROTONGE_MINOR_VERSION=$($PROTONGE_VERSION | cut -d'-' -f2)
    if [ "$PROTONGE_MAJOR_VERSION" -gt "$CURRENT_MAJOR_VERSION" ]; then
        getProtonGE
        exit 1
    elif [ "$PROTONGE_MAJOR_VERSION" == "$CURRENT_MAJOR_VERSION" ]; then
        if [ "$PROTONGE_MINOR_VERSION" -gt "$CURRENT_MINOR_VERSION" ]; then
            getProtonGE
            exit 1
        fi
    fi