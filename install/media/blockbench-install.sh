#!/bin/bash

blockbench_version=$(curl --head https://github.com/JannisX11/blockbench/releases/latest | tr -d '\r' | grep '^location' | sed 's/.*\/v//g')
echo "Installing Blockbech $blockbench_version..."
wget "https://github.com/JannisX11/blockbench/releases/download/v$blockbench_version/Blockbench_$blockbench_version.deb" -O blockbench-"$blockbench_version".deb
nala install -y ./blockbench-"$blockbench_version".deb
rm blockbench-"$blockbench_version".deb