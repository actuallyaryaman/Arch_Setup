# Arch Linux Setup Script
Use at your discretion. Enjoy!
## Features

- **Install yay-bin**: Installs the AUR helper `yay-bin`.
- **Update system**: Updates the system using `yay`.
- **Install packages**: Installs one or more packages from the AUR and saves them to a list.
- **Reinstall packages from list**: Reinstalls all previously installed packages from a saved list.
- **Change default shell**: Allows you to choose and change the default shell.
- **Set battery charging threshold**: Set the battery charging threshold to extend the battery lifespan.
- **Fix plasma-meta package**: Removes and reinstalls the dependencies for the `plasma-meta` package.
- **Configure Git**: Set up Git username and email for global configuration.
- **Install ZimFW**: Installs the Zim Framework for Zsh for an enhanced shell experience.

## Usage

1. Clone the repository or download the script to your system.
   ```bash
   git clone https://github.com/actuallyaryaman/Arch-Setup && cd Arch-Setup
   ```
3. Make the script executable by running:
   ```bash
   chmod +x arch-setup.sh
   ```
4. Run the script:
   ```bash
   ./arch-setup.sh
   ```

## Menu Options

The script provides a menu with the following options:

1. **Install yay-bin**  
   Installs `yay-bin` if it's not already installed.

2. **Update system**  
   Updates the system packages using `yay`.

3. **Install packages**  
   Install packages from the AUR. You can enter one or more package names, and they will be installed.

4. **Change default shell**  
   Change your default shell to one of the available shells on the system.

5. **Set battery charging threshold**  
   Set a maximum battery charge percentage (1-100%) to preserve battery health.

6. **Fix plasma-meta package**  
   Reinstalls the dependencies for the `plasma-meta` package by removing and reinstalling required dependencies.

7. **Install packages from saved list**  
   Reinstalls all packages listed in the `installed_packages.txt` file.

8. **Configure Git**  
   Set up your Git user name and email globally.

9. **Install ZimFW**  
   Installs the Zim Framework for Zsh to enhance the shell experience.

0. **Exit**  
   Exit the script.

## License
This project is licensed under the WTFPL License - see the [LICENSE](LICENSE) file for details.
