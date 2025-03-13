## Arch Linux Setup Script

> ⚠️ **Important:** This script is primarily for **Arch Linux**. Package management for other systems is currently not supported.

This is primarily for my personal use, but why not let you have it? 

A simple script to manage an Arch Linux installation with a **menu-driven interface**.

### **Features**

| Option                     | Action                           |
| -------------------------- | -------------------------------- |
| **Update system**          | Updates all packages             |
| **Install yay-bin**        | Installs the AUR helper `yay`    |
| **Install packages**       | Installs user-specified packages |
| **Restore saved packages** | Installs from `pkglist.txt`      |
| **Change shell**           | Switches to Bash or Zsh          |
| **Add aliases**            | Adds custom command aliases      |
| **Fix plasma-meta**        | Repairs KDE dependencies         |
| **Set battery limit**      | Adjusts charging threshold       |
| **Configure Git**          | Sets Git name & email            |
| **Install ZimFW**          | Installs Zsh framework           |
| **Organize Downloads**     | Sorts downloaded files           |

---

### **Usage**

> **🚨 Warning**
> This script installs and removes packages. Make sure you **review** the commands before running it.

#### **1. Download & Run**

bash
        
    git clone https://github.com/yourusername/arch-setup-script.git 
    
    cd arch-setup-script 
    
    chmod +x arch-setup.sh 
    
    ./arch-setup.sh

---

### **Notes**

- Restart the shell after adding an alias:
    
bash
        
    source ~/.bashrc   # For Bash
    source ~/.zshrc    # For Zsh
    
- Package tracking is saved in `pkglist.txt`. Be sure to back it up!
---

### **License**


---


## More features on the way!