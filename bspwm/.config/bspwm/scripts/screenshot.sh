#!/bin/sh
dir="$HOME/Pictures/capturas"
mkdir -p "$dir"
file="$dir/$(date +%Y-%m-%d_%H-%M-%S).png"

case "$1" in
    full) maim "$file" || exit 0 ;;
    *)    maim -s -u "$file" || exit 0 ;;
esac

[ -s "$file" ] && xclip -selection clipboard -t image/png -i "$file"
