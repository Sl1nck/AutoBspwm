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
    local color=0 n i r g b
    local -a l0=() l1=() l2=()
    local letra a b2 c
    if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then color=1; fi
    for letra in "┏━┓|┣━┫|╹ ╹" "   |╻ ╻|┗━┛" "   |╺╋╸| ╹ " "   |┏━┓|┗━┛" "┏┓ |┣┻┓|┗━┛" "   |┏━╸|╺━┛" "   |┏━┓|┣━┛" "   |┃╻┃|┗┻┛" "   |┏┳┓|╹╹╹"; do
        IFS='|' read -r a b2 c <<< "$letra"
        l0+=("$a"); l1+=("$b2"); l2+=("$c")
    done
    local borde='' fin=''
    if [ "$color" = 1 ]; then
        borde=$'\033[38;2;108;112;134m'; fin=$'\033[0m'
    fi
    local barra='──────────────────────────────────────────────────'
    echo
    printf '%s╭%s╮%s\n' "$borde" "$barra" "$fin"
    printf '%s│%s%50s%s│%s\n' "$borde" "$fin" "" "$borde" "$fin"
    local fila linea
    for fila in 0 1 2; do
        linea=''
        for n in 0 1 2 3 4 5 6 7 8; do
            if [ "$color" = 1 ]; then
                if [ "$n" -le 4 ]; then
                    r=$((203 - 66 * n / 4)); g=$((166 + 14 * n / 4)); b=$((247 + 3 * n / 4))
                else
                    i=$((n - 4))
                    r=$((137 + 11 * i / 4)); g=$((180 + 46 * i / 4)); b=$((250 - 37 * i / 4))
                fi
                linea+=$(printf '\033[38;2;%d;%d;%dm' "$r" "$g" "$b")
            fi
            case "$fila" in
                0) linea+="${l0[$n]}" ;;
                1) linea+="${l1[$n]}" ;;
                2) linea+="${l2[$n]}" ;;
            esac
            [ "$n" -lt 8 ] && linea+=' '
        done
        printf '%s│%s       %s%s        %s│%s\n' "$borde" "$fin" "$linea" "$fin" "$borde" "$fin"
    done
    printf '%s│%s%50s%s│%s\n' "$borde" "$fin" "" "$borde" "$fin"
    if [ "$color" = 1 ]; then
        printf '%s│%s          \033[38;2;137;180;250mEntorno BSPWM para Kali Linux\033[0m           %s│%s\n' "$borde" "$fin" "$borde" "$fin"
        printf '%s│%s     \033[38;2;108;112;134mpor Sl1nck · github.com/Sl1nck/AutoBspwm\033[0m     %s│%s\n' "$borde" "$fin" "$borde" "$fin"
    else
        printf '│          Entorno BSPWM para Kali Linux           │\n'
        printf '│     por Sl1nck · github.com/Sl1nck/AutoBspwm     │\n'
    fi
    printf '%s│%s%50s%s│%s\n' "$borde" "$fin" "" "$borde" "$fin"
    printf '%s╰%s╯%s\n\n' "$borde" "$barra" "$fin"
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
