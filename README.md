# dotfiles

## Setup new Ubuntu machines with just one command.

##### Nala is installed by default, along with its requisites aliases. The user is then prompted in stages:

## Common Suite
- Custom Shell Prompt W/ Repo Branch Embed
- [Ranger](https://github.com/ranger/ranger) - CLI File Manager
- [Pacstall](https://github.com/pacstall/pacstall) - AUR for Ubuntu
- [Neofetch](https://github.com/dylanaraps/neofetch) - System Information Shell Tool
## Server Sided Suite
------
- [Docker](https://www.docker.com/) - Open-source Software for Deploying & Running of Containerized Applications
- [Docker-Compose](https://github.com/docker/compose) - Docker Framework for Defining & Running Multi-Container Applications.
## Desktop Environment Suite
------
- [Yakuake](https://github.com/KDE/yakuake) - Dropdown Terminal Inspired by Quake
- [Discord](https://discord.com/) - Instant Messaging & VoIP Software
- Firefox Extension Preset
- [VSCodium](https://github.com/VSCodium/vscodium) - Open Source Release of Visual Studio Code
- [IntelliJ Idea](https://www.jetbrains.com/idea/) - Java & Kotlin IDE
### **Gaming Suite**
- [Wine](https://www.winehq.org/) - Windows API Compatibility Layer
- [Winetricks](https://github.com/Winetricks/winetricks) - Wine Optimizations & Improvements
- [Steam](https://store.steampowered.com) - Game Distribution Platform
- [DXVK](https://github.com/doitsujin/dxvk) - Direct X over Vulkan Compatibility Layer
- [ProtonGE](https://github.com/GloriousEggroll/proton-ge-custom) - Glorious Eggroll's Custom Implementation of Proton
- [Lutris](https://lutris.net/) - Gaming & Emulator Platform
- [Bottles](https://usebottles.com/) - Emulator For Windows Software

### **Media Editing Suite**
- [Inkscape](https://inkscape.org/) - Vector Graphics Editor
- [Handbrake](https://handbrake.fr/) - Video Transcoder
- [Gimp](https://www.gimp.org/) - Image Retouching & Editing Tool
- [Krita](https://krita.org/en/) - Digital Illustration & Animation Tool
### **Multi-Media Suite**
- [Youtube-dl](https://github.com/yt-dlp/yt-dlp) - Youtube Downloader W/ Sponsor Block Integration
- [vlc](https://www.videolan.org/vlc/) - Cross-Platform Media Player
### **Office Suite**
- [Zotero](https://www.zotero.org/) - Personal Research Assistant
- [Calibre](https://calibre-ebook.com/) - E-book Library Manager
- [Thunderbird](https://www.thunderbird.net/en-US/) - Email Client


## Asks what files should be sourced and whether you want to install various server/DE applications by symlinking.
```sh
    git clone https://git.salmans.dev/Guardian/dotfiles.git .dotfiles
    cd .dotfiles
    ./install.sh
```