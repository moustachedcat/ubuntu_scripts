#!/bin/bash

# Source installation functions
source ./install_functions/install_functions.sh


# Main script
echo "Choose software to install:"
choices=("Transmission" "Plex" "Apache2" "rclone")

# Display menu
for i in "${!choices[@]}"; do
    echo "$((i+1)). ${choices[$i]}"
done

# Read user input
read -p "Enter your choice (separate by spaces for multiple choices): " choices_input

# Process user choices
IFS=' ' read -ra choices_array <<< "$choices_input"
for choice_index in "${choices_array[@]}"; do
    choice_index=$((choice_index-1))
    if [[ "$choice_index" -ge 0 && "$choice_index" -lt "${#choices[@]}" ]]; then
        choice="${choices[$choice_index]}"
        if [[ -n "${install_functions[$choice]}" ]]; then
            if type "${install_functions[$choice]}" &>/dev/null; then
                echo "$choice is already installed."
            else
                "${install_functions[$choice]}"
            fi
        else
            echo "Invalid choice: $choice"
        fi
    else
        echo "Invalid choice: $choice_index"
    fi
done
