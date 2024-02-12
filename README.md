# dotfiles

## Setup new machines with just one command.

Nala is installed by default, along with its requisites aliases.
The user is then prompted in stages:

## Common Suite
- Custom Shell Prompt W/ Repo Branch Embed
- Ranger CLI File Manager
## Server Sided Suite
- Docker
- Docker-Compose
## Desktop Environment Suite
- Yakuake Terminal
- Discord Development
- Firefox Extension Preset
- Wine
- Winetricks
- Steam
- DXVK
- ProtonGE
- Youtube-dl
- VSCodium

## Asks what files should be sourced and whether you want to install various server/DE applications by symlinking.

    git clone https://git.salmans.dev/Guardian/dotfiles.git .dotfiles
    cd .dotfiles
    sudo ./install.sh
