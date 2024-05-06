#!/bin/bash

# Function to install Transmission
install_transmission() {
    if ! dpkg -l | grep -q transmission-daemon; then
        sudo apt-get update
        sudo apt-get install transmission-daemon -y
    fi
}

# Function to install Plex
install_plex() {
    if ! dpkg -l | grep -q plexmediaserver; then
        sudo apt-get update
        sudo apt-get install apt-transport-https -y
        sudo wget -O /tmp/plex.deb https://downloads.plex.tv/plex-media-server-new/1.24.1.4933-8e604f69a/debian/plexmediaserver_1.24.1.4933-8e604f69a_amd64.deb
        sudo dpkg -i /tmp/plex.deb
        sudo systemctl enable plexmediaserver
        sudo systemctl start plexmediaserver
    fi
}

# Function to install Apache2
install_apache2() {
    if ! dpkg -l | grep -q apache2; then
        sudo apt-get update
        sudo apt-get install apache2 -y
        sudo systemctl enable apache2
        sudo systemctl start apache2
    fi
}

# Function to install rclone
install_rclone() {
    if ! command -v rclone &> /dev/null; then
        curl https://rclone.org/install.sh | sudo bash
    fi
}

# Define associative array
declare -A install_functions=(
    ["Transmission"]="install_transmission"
    ["Plex"]="install_plex"
    ["Apache2"]="install_apache2"
    ["rclone"]="install_rclone"
)
