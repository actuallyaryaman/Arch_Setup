#!/bin/bash

PACKAGE_LIST_FILE="$(pwd)/pkglist.txt"
# Get the directory of the script
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
PACKAGE_LIST_FILE="$SCRIPT_DIR/pkglist.txt"

# Function to install yay-bin
install_yay() {
    echo "Installing yay-bin..."

    if command -v yay &>/dev/null; then
        echo "yay is already installed."
    else
        sudo pacman -S --needed --noconfirm base-devel git
        git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
        cd /tmp/yay-bin || exit
        makepkg -si --noconfirm
        cd - || exit
        rm -rf /tmp/yay-bin
        echo "yay-bin installation completed."
    fi
    sleep 3
    show_menu
}
# Function to update the system
update_system() {
    echo "Updating the system..."
    yay -Syu --noconfirm --needed --removemake
    echo "System update completed."
    sleep 3
    show_menu
}

# Function to install packages and update the list
install_packages() {
    while true; do
        echo "Enter the package(s) you want to install (space-separated), or press 0 to return to the main menu:"
        read -rp "Packages: " packages

        if [[ $packages == "0" ]]; then
            show_menu
        elif [[ -z "$packages" ]]; then
            echo "No packages entered. Please try again."
        else
            echo "Installing packages: $packages"
            yay -S --noconfirm --needed --removemake $packages
            add_to_package_list $packages
            echo "Installation completed and package list updated."
        fi
    done
}

# Function to add packages to the tracking list without duplicates and sort alphabetically
add_to_package_list() {
    for package in "$@"; do
        if ! grep -qx "$package" "$PACKAGE_LIST_FILE"; then
            echo "$package" >> "$PACKAGE_LIST_FILE"
        fi
    done

    # Sort the package list alphabetically and remove duplicates
    sort -u -o "$PACKAGE_LIST_FILE" "$PACKAGE_LIST_FILE"
}

# Function to reinstall packages from the saved list
reinstall_from_exported_list() {
    if [[ ! -f $PACKAGE_LIST_FILE ]]; then
        echo "No package list found. Install some packages first."
        sleep 3
        show_menu
        return
    fi

    # Read package list into an array
    mapfile -t package_list < "$PACKAGE_LIST_FILE"

    if [[ ${#package_list[@]} -eq 0 ]]; then
        echo "The package list is empty."
        sleep 3
        show_menu
        return
    fi

    echo "Packages in the saved list:"
    for i in "${!package_list[@]}"; do
        echo "$((i+1))) ${package_list[$i]}"
    done

    echo "Enter the numbers of the packages you want to **exclude** (space-separated), or press Enter to install all:"
    read -rp "Exclude: " exclude_input

    # Process exclusions if the user entered numbers
    if [[ -n "$exclude_input" ]]; then
        # Convert input into an array of indexes to exclude
        exclude_indexes=($exclude_input)
        filtered_packages=()

        for i in "${!package_list[@]}"; do
            if [[ ! " ${exclude_indexes[@]} " =~ " $((i+1)) " ]]; then
                filtered_packages+=("${package_list[$i]}")
            else
                echo "Skipping: ${package_list[$i]}"
            fi
        done
    else
        filtered_packages=("${package_list[@]}")
    fi

    # Proceed with installation if there are remaining packages
    if [[ ${#filtered_packages[@]} -gt 0 ]]; then
        echo "Installing selected packages: ${filtered_packages[*]}"
        yay -S --noconfirm --needed --removemake "${filtered_packages[@]}"
        echo "Installation completed."
    else
        echo "No packages selected for installation."
    fi

    sleep 3
    show_menu
}


# Function to change default shell
change_shell() {
    echo "Available shells:"

    local shells=($(chsh -l))
    for i in "${!shells[@]}"; do
        echo "$((i+1))) ${shells[$i]}"
    done
    echo "0) Return to the main menu"

    read -rp "Enter the number of the shell you want to set, or press 0 to return: " shell_choice

    if [[ $shell_choice == "0" ]]; then
        show_menu
    elif [[ $shell_choice -ge 1 && $shell_choice -le ${#shells[@]} ]]; then
        selected_shell=${shells[$((shell_choice-1))]}
        echo "Changing the default shell to $selected_shell"
        chsh -s "$selected_shell"
        echo "Default shell changed successfully to $selected_shell. Please log out and log back in for changes to take effect."
    else
        echo "Invalid choice. Please try again."
        sleep 3
        change_shell
    fi

    sleep 3
    show_menu
}
# Function to fix plasma-meta package
fix_plasma_meta() {
    echo "Installing pacman-contrib to use pactree..."
    sudo pacman -S --needed --noconfirm pacman-contrib

    if ! command -v pactree &>/dev/null; then
        echo "Failed to install pacman-contrib. Cannot proceed."
        sleep 3
        show_menu
    fi

    echo "Fetching plasma-meta dependencies..."
    plasma_deps=$(pactree -d 1 -u plasma-meta | grep -v 'plasma-meta' | tr '\n' ' ')

    if pacman -Q plasma-meta &>/dev/null; then
        echo "Removing plasma-meta..."
        sudo pacman -Rns --noconfirm plasma-meta
    fi
    
    if [[ -n "$plasma_deps" ]]; then
        echo "Reinstalling plasma-meta dependencies..."
        sudo pacman -S --noconfirm $plasma_deps
    else
        echo "No plasma-meta dependencies found."
    fi

    if pacman -Q discover &>/dev/null; then
        echo "Removing discover..."
        sudo pacman -R --noconfirm discover
    fi

    sleep 3
    show_menu
}

# Function to set battery charging threshold
set_battery_threshold() {
    echo "Enter the maximum battery charge threshold (1-100), or press 0 to return to the main menu (Default: 80%):"
    read -rp "Threshold: " threshold

    # If the user presses Enter without entering anything, use the default value of 80
    if [[ -z "$threshold" ]]; then
        threshold=80
        echo "No input detected. Defaulting to 80%."
    fi

    if [[ "$threshold" == "0" ]]; then
        show_menu
    elif [[ ! "$threshold" =~ ^[0-9]+$ || "$threshold" -gt 100 || "$threshold" -le 0 ]]; then
        echo "Invalid input. Please enter a number between 1 and 100."
    else
        echo "Setting battery charge threshold to $threshold%..."
        for bat in /sys/class/power_supply/BAT?/charge_control_end_threshold; do
            if [[ -f $bat ]]; then
                echo $threshold | sudo tee $bat > /dev/null
                echo "Threshold applied instantly to $bat"
            fi
        done

        service_content="[Unit]
Description=Set battery charge threshold
After=multi-user.target suspend.target hibernate.target hybrid-sleep.target suspend-then-hibernate.target

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'echo $threshold > /sys/class/power_supply/BAT?/charge_control_end_threshold'

[Install]
WantedBy=multi-user.target suspend.target hibernate.target hybrid-sleep.target suspend-then-hibernate.target
"

        echo "$service_content" | sudo tee /etc/systemd/system/battery-manager.service > /dev/null
        sudo systemctl enable battery-manager.service
        sudo systemctl start battery-manager.service

        echo "Battery charging threshold set to $threshold% and will persist after reboot."
    fi
    sleep 3
    show_menu
}

# Function to configure Git user name and email
configure_git() {
    echo "Enter your Git user name:"
    read -rp "User Name: " git_user

    echo "Enter your Git email:"
    read -rp "Email: " git_email

    if [[ -n "$git_user" && -n "$git_email" ]]; then
        git config --global user.name "$git_user"
        git config --global user.email "$git_email"
        echo "Git configured globally with:"
        git config --global --list | grep 'user'
    else
        echo "Invalid input. Both user name and email are required."
    fi

    sleep 3
    show_menu
}

# Function to install ZimFW via curl
install_zimfw_online() {
    echo "Installing ZimFW using curl..."
    curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
    echo "ZimFW installation complete."
    sleep 3
    show_menu
}

organize_downloads() {
    local SCRIPT_NAME="organize_downloads"
    local SCRIPT_SOURCE="$SCRIPT_DIR/scripts/download_organizer.sh"
    local TARGET_DIR="/usr/local/bin"
    local TARGET_PATH="$TARGET_DIR/$SCRIPT_NAME"

    # Ensure script source exists
    if [[ ! -f "$SCRIPT_SOURCE" ]]; then
        echo "Error: Source script ($SCRIPT_SOURCE) not found!"
        return 1
    fi

    # Check if the script already exists
    if [[ -f "$TARGET_PATH" ]]; then
        echo "Script already exists at $TARGET_PATH. Not overwriting."
        return 1
    fi

    # Copy the script with sudo (since /usr/local/bin requires root permissions)
    echo "Copying script to $TARGET_PATH..."
    sudo cp "$SCRIPT_SOURCE" "$TARGET_PATH"

    # Make the script executable
    sudo chmod +x "$TARGET_PATH"

    echo "Script installed at $TARGET_PATH. Run it using: organize_downloads"
    sleep 3
    show_menu
}


# Menu function
show_menu() {
    clear
    echo "Arch Linux Setup Script"
    echo "======================="

    local options=()
    
    # Always available options
    options+=("Update system:update_system")
    
    # Only add "Install yay-bin" if yay is NOT installed
    if ! command -v yay &>/dev/null; then
        options+=("Install yay-bin:install_yay")
    fi

    options+=("Install packages:install_packages")

    # Only add "Install packages from saved list" if package list file exists and is not empty
    if [[ -f "$PACKAGE_LIST_FILE" && -s "$PACKAGE_LIST_FILE" ]]; then
        options+=("Install packages from saved list:reinstall_from_exported_list")
    fi

    options+=("Change default shell:change_shell")

    # Only add "Install ZimFW" if the current shell is Zsh
    if [[ "$SHELL" == "/bin/zsh" || "$SHELL" == "/usr/bin/zsh" ]]; then
        options+=("Install ZimFW:install_zimfw_online")
    fi

    options+=("Set battery charging threshold(Default 80%):set_battery_threshold")
    # Check if plasma-meta is installed
    if pacman -Q plasma-meta &>/dev/null; then
        options+=("Remove plasma-meta & discover:fix_plasma_meta")
    fi
    options+=("Configure Git user name and email:configure_git")
    
    # Add install script option if the script is not installed in /usr/local/bin
    if [[ ! -f "/usr/local/bin/organize_downloads" ]]; then
        options+=("Install Downloads Organizer Script:organize_downloads")
    fi

    # Display dynamic menu
    local index=1
    for option in "${options[@]}"; do
        echo "$index) ${option%%:*}"
        ((index++))
    done
    echo "0) Exit"
    echo "======================="

    # Get user input
    read -rp "Enter your choice: " choice

    # Execute corresponding function based on user input
    if [[ "$choice" -ge 1 && "$choice" -le ${#options[@]} ]]; then
        eval "${options[$((choice - 1))]#*:}"
    elif [[ "$choice" == "0" ]]; then
        echo "Exiting..."
        exit 0
    else
        echo "Invalid choice. Please try again."
        sleep 2
        show_menu
    fi
}
# Start the script by calling the menu
show_menu
