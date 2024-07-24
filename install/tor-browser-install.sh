#!/bin/bash
    
echo "Installing Tor-Browser..."
# make temp working directory
mkdir /tmp/tor-browser
cd /tmp/tor-browser || return
TOR_VERSION=13.0.15
# download  tarball
wget "https://www.torproject.org/dist/torbrowser/$TOR_VERSION/tor-browser-linux-x86_64-$TOR_VERSION.tar.xz" -O tor-browser-"$TOR_VERSION".tar.xz
# download checksum
wget "https://www.torproject.org/dist/torbrowser/$TOR_VERSION/tor-browser-linux-x86_64-$TOR_VERSION.tar.xz.asc" -O tor-browser-"$TOR_VERSION".tar.xz.asc
gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org
gpg --output ./tor.keyring --export 0xEF6E286DDA85EA2A4BA7DE684E2C6E8793298290
# check tarball with checksum
if gpgv --keyring ./tor.keyring /tmp/tor-browser/tor-browser-"$TOR_VERSION".tar.xz.asc /tmp/tor-browser/tor-browser-"$TOR_VERSION".tar.xz; then # if result is ok, continue
    tar -xf tor-browser-"$TOR_VERSION".tar.xz -C "$HOME_DIR"/Programs/
    chown -R "$USERID":"$GROUPID" "$HOME_DIR"/Programs/tor-browser
    sed -i "33 c\Icon=${HOME_DIR}/Programs/tor-browser/Browser/browser/chrome/icons/default/default128.png" "$HOME_DIR"/Programs/tor-browser/start-tor-browser.desktop
    ln -s "$HOME_DIR"/Programs/Tor-Browser/start-tor-browser.desktop "$HOME_DIR"/.local/share/applications/
    desktop-file-install --dir="$HOME_DIR"/.local/share/applications/ start-tor-browser.desktop
    cd ..
    echo "All done :)"
else
    echo "Checksum mismatch exiting..."
fi