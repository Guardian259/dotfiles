#!/bin/bash

echo "Installing VS Code..."
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