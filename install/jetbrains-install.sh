#!/bin/bash

echo "Installing IntelliJ Idea..."

# Prepend base URL for download
URL="https://data.services.jetbrains.com/products/download?platform=linux&code=IIC"

# Get location header for file URL
HEADERS=$(wget -qS --max-redirect 0 --spider "$URL" 2>&1)
LOCATION=$(echo "$HEADERS" | tac | grep -m 1 "Location: ")
FILE_URL=$(echo "$LOCATION" | sed 's/.*Location: //')
VERSION=$(echo "$FILE_URL" | sed -En 's/.*\/(.*).tar.gz/\1/p')
echo "File to be downloaded: $FILE_URL"
echo "Latest stable version: $VERSION"

# Set install directory
INSTALL_DIR="/opt/$VERSION"

# Check if latest version has been installed
if [ -d "$INSTALL_DIR" ]; then
   echo "Found an existing install directory: $INSTALL_DIR"
   echo "$VERSION may have previously been installed."
   while true; do
       read -p "Would you like to reinstall? (Y/N) > " REPLY
       case $REPLY in
           [yY] ) echo "Reinstalling $VERSION..."; break;;
           [nN] ) echo "Aborted install."; exit 1; break;;
       esac
   done
fi

# Set download directory
DEST_DIR=$(mktemp)

# Download binary
echo "Downloading $VERSION from $FILE_URL to $DEST_DIR"
wget -cO ${DEST_DIR} ${FILE_URL} --read-timeout=5 --tries=0
echo "Download complete."

# Overwrite installation directory if it exists
if [ -d "$INSTALL_DIR" ]; then
   echo "Removing existing installation in $INSTALL_DIR"
   rm -rf ${INSTALL_DIR}
fi

# Untar file
if mkdir ${INSTALL_DIR}; then
   echo "Extracting $DEST_DIR to $INSTALL_DIR"
   tar -xzf ${DEST_DIR} -C ${INSTALL_DIR} --strip-components=1
fi

# Grab executable folder
BIN=${INSTALL_DIR}/bin

# Add permissions to install directory
echo "Adding permissions to $INSTALL_DIR"
chmod -R +rwx ${INSTALL_DIR}

# Enable to add desktop shortcut
DESK=/usr/share/applications/${IDE}.desktop
echo "[Desktop Entry]\nEncoding=UTF-8\nName=${IDE}\nComment=${IDE}\nExec=${BIN}/${IDE}.sh\nIcon=${BIN}/${IDE}.png\nTerminal=false\nStartupNotify=true\nType=Application" -e > ${DESK}

# Create symlink entry
TARGET=${BIN}/idea.sh
echo "Placing symbolic link to $TARGET in /usr/local/bin/"
ln -sf ${TARGET} /usr/local/bin/idea