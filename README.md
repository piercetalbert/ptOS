# ptOS

A custom Fedora Atomic image designed for gaming, development and daily use.

## Base System

- Built on Fedora 43
- Uses [Bazzite](https://bazzite.gg/) as the base image
- KDE Plasma with Valve's themes from SteamOS
- Optimized for AMD and Intel GPUs

## Features

- [Bazzite features](https://github.com/ublue-os/bazzite#about--features)
- ADB, Fastboot and [Waydroid](https://docs.bazzite.gg/Installing_and_Managing_Software/Waydroid_Setup_Guide/)
- Audacious with Winamp skins
- Brave Browser
- Cloudflare WARP
- Curated list of [Flatpaks](https://github.com/piercetalbert/ptos/blob/main/repo_files/flatpaks), [Homebrews](https://github.com/piercetalbert/ptos/blob/main/repo_files/brews) and [AppImages](https://github.com/piercetalbert/ptos/blob/main/repo_files/appimages)
- DNS over TLS, DNSSEC and MAC address randomization enabled
- Podman, Distrobox and Toolbx
- Fixed Plasma integration with Google Drive
- Ghostty terminal, Starship prompt, Zsh, `fuck` alias and Atuin history search (Ctrl+R)
- OpenRGB and CoolerControl
- Sonic Adventure mods (SADX and SA2) setup script
- Switch to standalone SteamOS session from login screen
- Virtual Machine Manager, libvirt and QEMU
- VLC, mpv, HandBrake and Audacity
- VSCode, Cursor (with Remote Tunnels fixed), Neovim

## Install

From existing Fedora Atomic/Universal Blue installation switch to ptOS image:

```bash
sudo bootc switch --enforce-container-sigpolicy ghcr.io/piercetalbert/ptos:latest
```

If you want to install the image on a new system download and install Bazzite ISO first:

<https://download.bazzite.gg/bazzite-stable-amd64.iso>

## Custom commands

The following `ujust` commands are available:

```bash
# Clean up old packages and Docker/Podman images and volumes
ujust pt-clean

# Install all ptOS apps
ujust pt-install

# Install only Flatpaks
ujust pt-install-flatpaks

# Install only Homebrews
ujust pt-install-brews

# Install only AppImages
ujust pt-install-appimages

# Setup ptOS settings for Cursor and VSCode
ujust pt-setup-editors

# Setup Ghostty terminal configuration
ujust pt-setup-ghostty

# Setup shell configurations (zsh, bash)
ujust pt-setup-shells

# Setup Sonic Adventure mods (SADX and SA2)
ujust pt-setup-samods

# Restart Bluetooth to fix issues
ujust pt-fix-bt

# Manage SSD encryption optimizations (Workqueue and TRIM)
ujust pt-ssd-crypto
```

## Package management

GUI apps can be found as Flatpaks in the Discover app or [FlatHub](https://flathub.org/) and installed with `flatpak install ...`.

CLI apps are available from [Homebrew](https://formulae.brew.sh/) using `brew install ...`.

## Acknowledgments

This project is based on the [Universal Blue image template](https://github.com/ublue-os/image-template) and builds upon the excellent work of the Universal Blue community.
