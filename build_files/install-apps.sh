#!/usr/bin/bash
set -euo pipefail

trap '[[ $BASH_COMMAND != echo* ]] && [[ $BASH_COMMAND != log* ]] && echo "+ $BASH_COMMAND"' DEBUG

log() {
  echo "=== $* ==="
}

# RPM packages (system-level packages that need direct integration)
declare -A RPM_PACKAGES=(
  ["fedora"]="zsh"
  ["google-chrome"]="google-chrome-stable"
  ["fedora-spotify"]="spotify-client"
  ["terra"]="discord"
  ["rpmfusion-free"]="vlc" # or fedora
  ["code"]="code"
  ["copr:atim/heroic-games-launcher"]="heroic-games-launcher-bin"
)

log "Starting ptOS build process"

log "Removing unwanted packages"
dnf5 -y remove sunshine lutris waydroid || true
flatpak uninstall -y --noninteractive org.mozilla.firefox com.github.Matoking.protontricks io.github.Jeoshin.protonplus || true

log "Adding external repositories"
# Google Chrome
if [ ! -f /etc/yum.repos.d/google-chrome.repo ]; then
  cat > /etc/yum.repos.d/google-chrome.repo <<EOF
[google-chrome]
name=google-chrome
baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl.google.com/linux/linux_signing_key.pub
EOF
fi

# VS Code
if [ ! -f /etc/yum.repos.d/vscode.repo ]; then
  cat > /etc/yum.repos.d/vscode.repo <<EOF
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
fi

# Terra (for Discord)
dnf5 config-manager --add-repo https://github.com/terrapkg/subatomic-repos/raw/main/terra.repo || true

# Negativo17 (for Spotify)
dnf5 config-manager --add-repo https://negativo17.org/repos/fedora-spotify.repo || true

log "Installing RPM packages"
mkdir -p /var/opt
for repo in "${!RPM_PACKAGES[@]}"; do
  read -ra pkg_array <<<"${RPM_PACKAGES[$repo]}"
  if [[ $repo == copr:* ]]; then
    # Handle COPR packages
    copr_repo=${repo#copr:}
    dnf5 -y copr enable "$copr_repo"
    dnf5 -y install "${pkg_array[@]}"
    dnf5 -y copr disable "$copr_repo"
  else
    # Handle regular packages
    [[ $repo != "fedora" ]] && enable_opt="--enable-repo=$repo" || enable_opt=""
    cmd=(dnf5 -y install)
    [[ -n "$enable_opt" ]] && cmd+=("$enable_opt")
    cmd+=("${pkg_array[@]}")
    "${cmd[@]}"
  fi
done

log "Enabling system services"
systemctl enable libvirtd.service

log "Adding ptOS just recipes"
echo "import \"/usr/share/ptos/just/pt.just\"" >>/usr/share/ublue-os/justfile

log "Hide incompatible Bazzite just recipes"
for recipe in "install-coolercontrol" "install-openrgb"; do
  if ! grep -l "^$recipe:" /usr/share/ublue-os/just/*.just | grep -q .; then
    echo "Error: Recipe $recipe not found in any just file"
    exit 1
  fi
  sed -i "s/^$recipe:/_$recipe:/" /usr/share/ublue-os/just/*.just
done

log "Build process completed"
