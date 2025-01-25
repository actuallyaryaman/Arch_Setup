# Arch Linux Setup Script

A bash script to automate the installation and configuration of essential packages, system settings, and utilities for Arch Linux.

## Features

- **System Update:** Updates the entire system.
- **Install yay-bin:** Installs the AUR helper `yay-bin`.
- **Install Packages:** User-defined package installation with tracking.
- **Change Default Shell:** Select and set a new default shell.
- **Set Battery Threshold:** Set battery charge limits with persistence.
- **Fix Plasma-meta Package:** Remove `plasma-meta` and reinstall dependencies.
- **Reinstall Saved Packages:** Restore previously installed packages.
- **Exit:** Close the script.

## Usage

1. **Download the script:**
   ```bash
   wget https://example.com/arch_setup.sh
   ```

2. **Make the script executable:**
   ```bash
   chmod +x arch_setup.sh
   ```

3. **Run the script:**
   ```bash
   ./arch_setup.sh
   ```

## Options in the Script

Upon running the script, you'll be presented with a menu:

```
1) Update the system
2) Install yay-bin
3) Install packages
4) Change default shell
5) Set battery charging threshold
6) Fix plasma-meta package
7) Install packages from saved list
8) Exit
```

## Notes

- Ensure you have `sudo` privileges to run the script.
- The script creates an `installed_packages.txt` file to track installed packages.
- Battery threshold settings are applied instantly and persist after reboots.
- For Plasma-meta fix, dependencies are reinstalled individually after removal.

## License

This script is provided "as is" without any warranties.
