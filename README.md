# Arch Linux Setup Script
A user friendly post installation setup script.
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

## License
This project is licensed under the WTFPL License - see the [LICENSE](LICENSE) file for details.
