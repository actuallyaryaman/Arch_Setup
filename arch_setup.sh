#!/bin/bash

PACKAGE_LIST_FILE="$(pwd)/installed_packages.txt"

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
    sleep 1
    show_menu
}
# Function to update the system
update_system() {
    echo "Updating the system..."
    yay -Syu --noconfirm --needed --removemake
    echo "System update completed."
    sleep 1
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

# Function to add packages to the tracking list without duplicates
add_to_package_list() {
    for package in "$@"; do
        if ! grep -qx "$package" "$PACKAGE_LIST_FILE"; then
            echo "$package" >> "$PACKAGE_LIST_FILE"
        fi
    done
}

# Function to reinstall packages from the saved list
reinstall_from_exported_list() {
    if [[ ! -f $PACKAGE_LIST_FILE ]]; then
        echo "No package list found. Install some packages first."
    else
        echo "Reinstalling packages from '$PACKAGE_LIST_FILE'..."
        yay -S --noconfirm --needed --removemake $(cat "$PACKAGE_LIST_FILE")
        echo "All packages from the list have been installed."
    fi
    sleep 1
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
        sleep 1
        change_shell
    fi

    sleep 1
    show_menu
}

# Function to fix plasma-meta package
fix_plasma_meta() {
    echo "Installing pacman-contrib to use pactree..."
    sudo pacman -S --needed --noconfirm pacman-contrib

    if ! command -v pactree &>/dev/null; then
        echo "Failed to install pacman-contrib. Cannot proceed."
        sleep 1
        show_menu
    fi

    echo "Fetching plasma-meta dependencies..."
    plasma_deps=$(pactree -d 1 -u plasma-meta | grep -v 'plasma-meta' | tr '\n' ' ')

    if pacman -Q plasma-meta &>/dev/null; then
        echo "Removing plasma-meta..."
        sudo pacman -Rns --noconfirm plasma-meta
    fi

    if pacman -Q discover &>/dev/null; then
        echo "Removing discover..."
        sudo pacman -Rns --noconfirm discover
    fi

    if [[ -n "$plasma_deps" ]]; then
        echo "Reinstalling plasma-meta dependencies..."
        sudo pacman -S --noconfirm $plasma_deps
    else
        echo "No plasma-meta dependencies found."
    fi

    sleep 1
    show_menu
}

# Function to set battery charging threshold
set_battery_threshold() {
    echo "Enter the maximum battery charge threshold (1-100), or press 0 to return to the main menu:"
    read -rp "Threshold: " threshold

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
    sleep 1
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

    sleep 1
    show_menu
}

# Function to install ZimFW via curl
install_zimfw_online() {
    echo "Installing ZimFW using curl..."
    curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
    echo "ZimFW installation complete."
    sleep 1
    show_menu
}

# Menu function
show_menu() {
    clear
    echo "Arch Linux Setup Script"
    echo "======================="
    echo "1) Install yay-bin"
    echo "2) Update system"
    echo "3) Install packages"
    echo "4) Change default shell"
    echo "5) Set battery charging threshold"
    echo "6) Fix plasma-meta package"
    echo "7) Install packages from saved list"
    echo "8) Configure Git user name and email"
    echo "9) Install ZimFW"
    echo "0) Exit"
    echo "======================="
    read -rp "Enter your choice: " choice

    case $choice in
        1) install_yay ;;
        2) update_system ;;
        3) install_packages ;;
        4) change_shell ;;
        5) set_battery_threshold ;;
        6) fix_plasma_meta ;;
        7) reinstall_from_exported_list ;;
        8) configure_git ;;
        9) install_zimfw_online ;;
        0) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid choice."; sleep 2; show_menu ;;
    esac
}

# Start the script by calling the menu
show_menu
