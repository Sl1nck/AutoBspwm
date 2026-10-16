#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

STOW_PACKAGES=(bspwm sxhkd x11 polybar rofi kitty starship zsh)

install_packages() {
    sudo apt update
    xargs -a packages/base.txt sudo apt install -y
}

install_vmware() {
    xargs -a packages/vmware.txt sudo apt install -y
}

link_configs() {
    # Si ya existe un .zshrc normal, se guarda una copia antes de enlazar
    if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
        mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
    fi
    stow --target="$HOME" --restow "${STOW_PACKAGES[@]}"
}

case "${1:-all}" in
    packages) install_packages ;;
    vmware)   install_vmware ;;
    link)     link_configs ;;
    all)      install_packages; link_configs ;;
    *) echo "Uso: $0 [packages|vmware|link|all]"; exit 1 ;;
esac
