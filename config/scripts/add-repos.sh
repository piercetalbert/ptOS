#!/usr/bin/bash
set -euo pipefail

echo "Adding external repositories..."

# Google Chrome
cat > /etc/yum.repos.d/google-chrome.repo <<EOF
[google-chrome]
name=google-chrome
baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl.google.com/linux/linux_signing_key.pub
EOF

# VS Code
cat > /etc/yum.repos.d/vscode.repo <<EOF
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

# Terra (Discord)
curl -Lo /etc/yum.repos.d/terra.repo https://repos.fyralabs.com/terra$releasever.repo

# Negativo17 (Spotify) - using fedora-spotify ID manually
cat > /etc/yum.repos.d/fedora-spotify.repo <<EOF
[fedora-spotify]
name=negativo17 - Spotify
baseurl=https://negativo17.org/repos/spotify/fedora/\$releasever/\$basearch/
enabled=1
skip_if_unavailable=1
gpgkey=https://negativo17.org/repos/RPM-GPG-KEY-slaanesh
gpgcheck=1
enabled_metadata=1
metadata_expire=6h
type=rpm-md
repo_gpgcheck=0
EOF

# Heroic Games Launcher (COPR) - using atim repo which is currently maintained
curl -Lo /etc/yum.repos.d/atim-heroic-games-launcher-fedora-41.repo https://copr.fedorainfracloud.org/coprs/atim/heroic-games-launcher/repo/fedora-41/atim-heroic-games-launcher-fedora-41.repo

echo "Repositories added successfully."
