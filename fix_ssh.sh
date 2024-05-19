#!/bin/bash


# Script to check and enable SSH password authentication

# Ensure the script is run with superuser privileges


SSHD_CONFIG="/etc/ssh/sshd_config"

INCLUDED_CONFIG_DIR="/etc/ssh/sshd_config.d"

LOG_FILE="/var/log/ssh-password-auth-enable.log"

PASSWORD_AUTHENTICATION_NO="PasswordAuthentication no"

PASSWORD_AUTHENTICATION_YES="PasswordAuthentication yes"


# Log the output

exec > >(tee -a $LOG_FILE) 2>&1


# Check if the main SSH configuration file contains PasswordAuthentication no

if grep -q "^$PASSWORD_AUTHENTICATION_NO" "$SSHD_CONFIG"; then

    echo "$(date) - PasswordAuthentication is disabled in $SSHD_CONFIG. Enabling..."

    sed -i "s/^$PASSWORD_AUTHENTICATION_NO/$PASSWORD_AUTHENTICATION_YES/" "$SSHD_CONFIG"

fi


# Check included configuration files for PasswordAuthentication no

if [ -d "$INCLUDED_CONFIG_DIR" ]; then

    echo "$(date) - Checking included SSH configuration files in $INCLUDED_CONFIG_DIR..."

    for config_file in "$INCLUDED_CONFIG_DIR"/*.conf; do

        if [ -f "$config_file" ]; then

            if grep -q "^$PASSWORD_AUTHENTICATION_NO" "$config_file"; then

                echo "$(date) - PasswordAuthentication is disabled in $config_file. Enabling..."

                sed -i "s/^$PASSWORD_AUTHENTICATION_NO/$PASSWORD_AUTHENTICATION_YES/" "$config_file"

            fi

        fi

    done

fi


# Restart SSH service

echo "$(date) - Restarting SSH service..."

sudo systemctl restart ssh


echo "$(date) - SSH password authentication check and enable complete."
