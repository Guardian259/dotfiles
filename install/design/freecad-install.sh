#!/bin/bash

HOME_DIR=/home/guardian

echo "Installing FreeCAD..."
mkdir "$HOME_DIR"/Programs/FreeCAD
cd "$HOME_DIR"/Programs/FreeCAD || return
freecad_version=$(curl --head https://github.com/FreeCAD/FreeCAD/releases/latest | tr -d '\r' | grep '^location' | sed 's/.*\/v//g' | cut -d"/" -f8)
echo "Installing FreeCAD $freecad_version..."
wget "https://github.com/FreeCAD/FreeCAD/releases/download/$freecad_version/FreeCAD-$freecad_version-Linux-x86_64.AppImage" -O FreeCAD-"$freecad_version"-Linux-x86_64.AppImage
cd ..