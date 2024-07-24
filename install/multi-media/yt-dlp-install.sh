#!/bin/bash

add-apt-repository ppa:tomtomtom/yt-dlp
echo "Installing yt-dlp..."
nala update && nala install -y yt-dlp