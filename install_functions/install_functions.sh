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
# Define function to install Filebrowser if not installed
install_filebrowser() {
    if ! command -v filebrowser &> /dev/null; then
        # Download and execute the Filebrowser installation script
        curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash
    else
        echo "Filebrowser is already installed."
    fi
}

# Define function to install Make
install_make() {
    if ! command -v make &> /dev/null; then
        sudo apt-get update
        sudo apt-get install make -y
    else
        echo "Make is already installed."
    fi
}

# Define function to install Java 11
install_java11() {
    if ! command -v java &> /dev/null; then
        sudo apt-get update
        sudo apt-get install openjdk-11-jdk -y
    else
        echo "Java 11 is already installed."
    fi
}


# Define function to install latest version of Google Chrome
install_chrome() {
    # Download and install Chrome
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
    sudo apt-get update
    sudo apt-get install google-chrome-stable -y
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

# Define function to install LXDE and configure for VNC
install_lxde_and_setup_vnc() {
    install_software "lxde"
    install_tightvncserver

    # Start VNC server to create initial configuration
    vncserver

    # Stop the VNC server to configure it
    vncserver -kill :1

    # Configure VNC server
    cat <<EOF > ~/.vnc/xstartup
#!/bin/bash
xrdb \$HOME/.Xresources
startlxde &
EOF

    # Set permissions for the startup script
    chmod +x ~/.vnc/xstartup

    # Restart VNC server
    vncserver
}

# Define associative array
declare -A install_functions=(
    ["Transmission"]="install_transmission"
    ["Plex"]="install_plex"
    ["Apache2"]="install_apache2"
    ["rclone"]="install_rclone"
    ["TightVNCServer"]="install_tightvncserver"
    ["LXDE"]="install_lxde_and_setup_vnc"
)

install_functions+=(["Chrome"]="install_chrome")
install_functions+=(["Make"]="install_make")
install_functions+=(["Java 11"]="install_java11")
install_functions+=(["Filebrowser"]="install_filebrowser")
