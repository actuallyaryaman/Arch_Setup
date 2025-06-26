## Arch Linux Setup Script

> ⚠️ **Important:** This script is intended for **Arch Linux** only. Package management for other Linux distributions is not supported at this time.

This script was made for my personal system management, but feel free to use or adapt it!

A simple, menu-driven Bash script for managing and enhancing your Arch Linux installation.

### **Features**

| Option | Action |
| :-- | :-- |
| **Update system** | Updates all system packages using pacman |
| **Install yay-bin** | Installs the AUR helper `yay` |
| **Install packages** | Installs user-specified packages via pacman or yay |
| **Restore saved packages** | Installs all packages listed in `pkglist.txt` |
| **Export package list** | Saves a list of all explicitly installed packages to `pkglist.txt` |
| **Change shell** | Switches between various shells |
| **Add aliases** | Adds custom command aliases to your shell configuration |
| **Fix plasma-meta** | Repairs KDE Plasma dependencies |
| **Set battery limit** | Sets and persists battery charging threshold (for supported hardware) |
| **Configure Git** | Sets global Git username and email |
| **Install ZimFW** | Installs and configures the Zsh framework [ZimFW](https://zimfw.sh) |
| **Organize Downloads** | Sorts files in your Downloads folder into subfolders by file type |
| **Enable parallel downloads** | Enables parallel downloads in pacman for faster package updates |

### **Usage**

> **🚨 Warning:**
> This script installs and removes packages, and modifies system configuration files. **Review all commands before running.**

#### **1. Download \& Run**

```bash
git clone https://github.com/actuallyaryaman/Arch_Setup
cd Arch_Setup
chmod +x arch-setup.sh
./arch-setup.sh
```


### **Notes**

- **Restart your shell after adding aliases:**

```bash
source ~/.bashrc   # For Bash
source ~/.zshrc    # For Zsh
```

- **Package tracking:**
All explicitly installed packages are saved to `pkglist.txt` when you export the package list. Back up this file if you want to restore your package selection later.
- **Battery threshold:**
The battery charge limit feature requires compatible hardware (e.g., ThinkPad, some ASUS laptops) and root privileges.
- **Parallel downloads:**
Enabling parallel downloads can significantly speed up system updates on fast connections.


### **License**

DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE (see LICENSE file for details)

## More features on the way!

**For any issues or suggestions, open an issue or pull request on GitHub.**

*This script is developed with Arch Linux users in mind.*