#!/bin/bash

echo "Installing Sonixd Media Player..."
sonixd_version=$(curl --head https://github.com/jeffvli/sonixd/releases/latest | tr -d '\r' | grep '^location' | sed 's/.*\/v//g')
wget "https://github.com/jeffvli/sonixd/releases/download/v$sonixd_version/Sonixd-$sonixd_version-linux-x86_64.AppImage" -O Sonixd-linux-x86_64.AppImage
mkdir "$HOME_DIR"/Programs/Sonixd
mv Sonixd-linux-x86_64.AppImage "$HOME_DIR"/Programs/Sonixd
ln -s "$HOME_DIR"/.dotfiles/desktop/sonixd.desktop "$HOME_DIR"/.local/share/applications/
ln -s "$HOME_DIR"/.dotfiles/desktop/sonixd.desktop "$HOME_DIR"/Programs/Sonixd/
sed -i "3 c\Exec=${HOME_DIR}/Programs/Sonixd/Sonixd-0.15.5-linux-x86_64.AppImage" "$HOME_DIR"/.dotfiles/desktop/sonixd.desktop
desktop-file-install --dir="$HOME_DIR"/.local/share/applications/ sonixd.desktop