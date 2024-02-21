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
    #PROTONGE_VERSION=$(curl --head https://github.com/JannisX11/blockbench/releases/latest | tr -d '\r' | grep '^location' | sed 's/.*\/v//g')
    #CUR_DIR=$(pwd)
    ##Checks if proton-ge-history.txt exists and generates it if not
    #if [ ! -f "$CUR_DIR/proton-ge-history.txt" ]; then
    #    touch "$CUR_DIR/proton-ge-history.txt"
    #    echo "$PROTONGE_VERSION" >> "$CUR_DIR"/proton-ge-history.txt
    #    getProtonGE
    #fi
    ##pulls the previous ProtonGE Version number for comparision
    #PREVIOUS_VERSION=$( tail -n 1 "$CUR_DIR"/proton-ge-history.txt ) 
    #if [ "$PROTONGE_VERSION" !=  "$PREVIOUS_VERSION" ] && [ "$PROTONGE_VERSION" -gt "$PREVIOUS_VERSION" ]; then
    #    getProtonGE
    #fi
    getProtonGE