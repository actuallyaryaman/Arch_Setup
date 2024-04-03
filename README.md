# My Arch Setup
## This repository is a work in progress.
> [!Warning]
> This is personal use repository and I am not responsible for anything you do with your system.

To run the below commands clone this repo

```shell
git clone https://github.com/actuallyaryaman/Arch-Setup && cd Arch-Setup
```

### Pacman Configuration

```shell
sudo cp -r pacman.conf /etc/pacman.conf
```

<!-- ### For KDE users (for users installing via arch-install)
Arch installs the [`plasma-meta`](https://archlinux.org/packages/extra/any/plasma-meta/) package which is a meta package to install KDE Plasma.
Currently removing `Discover` uninstalls all the other package dependendencies.

So to remove discover:

```shell
sudo pacman -Rs discover && sudo pacman -S 
``` -->


### Xorg Config

By default Nvidia driver on hybrid mode uses the `/usr/lib/Xorg` process which I do not want.

So we'll simply explictly tell Xorg to use the integrated drivers.

```shell
sudo cp xorg.conf /etc/X11/xorg.conf
```

### JamesDSP Configuration

I use [JamesDSP](https://github.com/Audio4Linux/JDSP4Linux/) to tweak my audio output as the default output on linux sucks.

Here are the [config files](dsp/).

### Wallpapers

Some of my recent [walls](walls/).

Currently setup(I like to keep it simple, sue me.)

![alt text](desktop.png)