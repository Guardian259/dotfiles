#!/bin/bash

echo "Installing steam..."
wget "https://cdn.akamai.steamstatic.com/client/installer/steam.deb" -O steam_latest.deb
nala install -y ./steam_latest.deb 
rm steam_latest.deb