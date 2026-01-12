#!/usr/bin/bash
set -euo pipefail

trap '[[ $BASH_COMMAND != echo* ]] && [[ $BASH_COMMAND != log* ]] && echo "+ $BASH_COMMAND"' DEBUG

log() {
  echo "=== $* ==="
}

# RPM packages (system-level packages that need direct integration)
declare -A RPM_PACKAGES=(
  ["fedora"]="zsh"
)

# Flatpak applications
FLATPAK_APPS=(
  "com.google.Chrome"
  "com.spotify.Client"
  "com.discordapp.Discord"
  "org.videolan.VLC"
  "com.visualstudio.code"
  "com.heroicgameslauncher.hgl"
)

log "Starting ptOS build process"

log "Removing unwanted packages"
dnf5 -y remove sunshine lutris waydroid || true
flatpak uninstall -y --noninteractive org.mozilla.firefox com.github.Matoking.protontricks io.github.Jeoshin.protonplus || true

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

log "Installing Flatpak applications"
for app in "${FLATPAK_APPS[@]}"; do
  flatpak install -y --noninteractive flathub "$app"
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
