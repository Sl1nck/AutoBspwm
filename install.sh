#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

STOW_PACKAGES=(bspwm sxhkd x11 polybar rofi kitty starship zsh picom fastfetch ranger)

install_packages() {
    sudo apt update
    xargs -a packages/base.txt sudo apt install -y
}

install_vmware() {
    xargs -a packages/vmware.txt sudo apt install -y
}

install_font() {
    local dir="$HOME/.local/share/fonts/JetBrainsMono"
    if fc-list | grep -qi "JetBrainsMono Nerd"; then
        echo "Fuente ya instalada"
        return
    fi
    mkdir -p "$dir"
    curl -fL -o /tmp/JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
    unzip -o /tmp/JetBrainsMono.zip -d "$dir"
    fc-cache -f
}

install_starship() {
    if command -v starship > /dev/null; then
        echo "Starship ya instalado"
        return
    fi
    if apt-cache policy starship | grep -q "Candidate: [0-9]"; then
        sudo apt install -y starship
    else
        if [ "$(uname -m)" != "x86_64" ]; then
            echo "Starship no esta en los repositorios y este instalador solo descarga la version x86_64"
            return 1
        fi
        curl -fL -o /tmp/starship.tar.gz https://github.com/starship/starship/releases/latest/download/starship-x86_64-unknown-linux-gnu.tar.gz
        sudo tar -xzf /tmp/starship.tar.gz -C /usr/local/bin starship
    fi
}

link_configs() {
    # Si ya existe un .zshrc normal, se guarda una copia antes de enlazar
    if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
        mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
    fi
    stow --target="$HOME" --restow "${STOW_PACKAGES[@]}"
}

banner() {
    local color=0 linea i=0 r g b
    if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then color=1; fi
    echo
    while IFS= read -r linea; do
        if [ "$color" = 1 ]; then
            r=$((203 - 66 * i / 5)); g=$((166 + 14 * i / 5)); b=$((247 + 3 * i / 5))
            printf '\033[38;2;%d;%d;%dm%s\033[0m\n' "$r" "$g" "$b" "$linea"
        else
            printf '%s\n' "$linea"
        fi
        i=$((i + 1))
    done << 'EOF'
    ___         __        ____                             
   /   | __  __/ /_____  / __ )_________ _      ______ ___ 
  / /| |/ / / / __/ __ \/ __  / ___/ __ \ | /| / / __ `__ \
 / ___ / /_/ / /_/ /_/ / /_/ (__  ) /_/ / |/ |/ / / / / / /
/_/  |_\__,_/\__/\____/_____/____/ .___/|__/|__/_/ /_/ /_/ 
                                /_/                        
EOF
    if [ "$color" = 1 ]; then
        printf '\n  \033[38;2;137;180;250mEntorno BSPWM para Kali Linux\033[0m\n'
        printf '  \033[38;2;108;112;134mpor Sl1nck - github.com/Sl1nck/AutoBspwm\033[0m\n\n'
    else
        printf '\n  Entorno BSPWM para Kali Linux\n  por Sl1nck - github.com/Sl1nck/AutoBspwm\n\n'
    fi
}

banner

case "${1:-all}" in
    packages) install_packages ;;
    vmware)   install_vmware ;;
    font)     install_font ;;
    starship) install_starship ;;
    link)     link_configs ;;
    all)      install_packages; install_font; install_starship; link_configs ;;
    *) echo "Uso: $0 [packages|vmware|font|starship|link|all]"; exit 1 ;;
esac
