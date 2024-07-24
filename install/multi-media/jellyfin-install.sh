#!/bin/bash

echo "Installing Jellyfin Mdeia Player..."
jellyfin_version=$(curl --head https://github.com/jellyfin/jellyfin-media-player/releases/latest | tr -d '\r' | grep '^location' | sed 's/.*\/v//g')
echo "Installing Jellyfin Mdeia Player $jellyfin_version..."
wget "https://github.com/jellyfin/jellyfin-media-player/releases/download/v$jellyfin_version/jellyfin-media-player_$jellyfin_version-1_amd64-$DISTRO_VER.deb" -O jellyfin-media-player-"$jellyfin_version".deb
nala install -y ./jellyfin-media-player-"$jellyfin_version".deb
rm jellyfin-media-player-"$jellyfin_version".deb