#!/bin/bash

echo "Installing Minecraft Launcher..."
wget -qO Minecraft.deb https://launcher.mojang.com/download/Minecraft.deb
nala install -y ./Minecraft.deb
rm Minecraft.deb