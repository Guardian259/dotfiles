#!/bin/bash

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
CUR_DIR=$(pwd)
if [ ! -h "/etc/systemd/system/ge_proton_updater.service" ]; then
    ln -s "$CUR_DIR"/systemd/ge_proton_updater.service /etc/systemd/system/
    sed -i "7 c\ExecStart=/usr/bin/bash $CUR_DIR/update-ge-proton.sh" "$CUR_DIR"/systemd/ge_proton_updater.service
    ln -s "$CUR_DIR"/systemd/ge_proton_updater.timer /etc/systemd/system/
fi
if [ -h "/etc/systemd/system/ge_proton_updater.service" ]; then
    systemctl daemon-reload
    systemctl start ge_proton_updater.service
    systemctl start ge_proton_updater.timer
fi