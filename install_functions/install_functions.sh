#!/bin/bash

# Define function to install software
install_software() {
    package_name="$1"
    if ! dpkg -l | grep -q "$package_name"; then
        sudo apt-get update
        sudo apt-get install "$package_name" -y
    else
        echo "$package_name is already installed."
    fi
}

# Define installation functions for each software
install_transmission() {
    install_software "transmission-daemon"
}

install_plex() {
    install_software "plexmediaserver"
}

install_apache2() {
    install_software "apache2"
    sudo systemctl enable apache2
    sudo systemctl start apache2
}

install_rclone() {
    if ! command -v rclone &> /dev/null; then
        curl https://rclone.org/install.sh | sudo bash
    else
        echo "rclone is already installed."
    fi
}

install_tightvncserver() {
    install_software "tightvncserver"
}

# Define associative array
declare -A install_functions=(
    ["Transmission"]="install_transmission"
    ["Plex"]="install_plex"
    ["Apache2"]="install_apache2"
    ["rclone"]="install_rclone"
    ["TightVNCServer"]="install_tightvncserver"
)
