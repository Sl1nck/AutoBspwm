#!/bin/sh
dir="$HOME/dotfiles/wallpapers"
state="$HOME/.local/state/wallpaper"
mkdir -p "$(dirname "$state")"

lista=$(ls "$dir"/*.png "$dir"/*.jpg 2>/dev/null)
[ -z "$lista" ] && exit 1

actual=$(cat "$state" 2>/dev/null)
[ -f "$actual" ] || actual=$(echo "$lista" | head -n 1)

case "$1" in
    path)
        echo "$actual"
        exit 0
        ;;
    next)
        siguiente=$(echo "$lista" | awk -v cur="$actual" 'found {print; exit} $0 == cur {found=1}')
        [ -n "$siguiente" ] && actual="$siguiente" || actual=$(echo "$lista" | head -n 1)
        ;;
esac

echo "$actual" > "$state"
feh --bg-fill "$actual"
