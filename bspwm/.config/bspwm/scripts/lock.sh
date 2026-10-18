#!/bin/sh
res=$(xrandr | awk '/ connected/ {for (i=1; i<=NF; i++) if ($i ~ /^[0-9]+x[0-9]+\+/) {split($i, a, "+"); print a[1]; exit}}')
wall=$("$HOME/.config/bspwm/scripts/wallpaper.sh" path)
name=$(basename "$wall" | sed 's/\.[^.]*$//')
img="$HOME/.cache/lock-$name-$res.png"

if [ ! -f "$img" ] && [ -f "$wall" ]; then
    mkdir -p "$HOME/.cache"
    im=$(command -v magick || command -v convert)
    "$im" "$wall" -resize "${res}^" -gravity center -extent "$res" -blur 0x8 "$img"
fi

if [ -f "$img" ]; then
    bg="-i $img"
else
    bg="-c 1e1e2e"
fi

if i3lock --version 2>&1 | grep -q "Cassandra"; then
    i3lock -n -e $bg \
        --clock --indicator \
        --time-str="%H:%M" --date-str="%d/%m/%Y" \
        --time-font="JetBrainsMono Nerd Font" --date-font="JetBrainsMono Nerd Font" \
        --time-size=48 --date-size=16 \
        --time-color=cdd6f4ff --date-color=a6adc8ff \
        --radius=110 --ring-width=5 \
        --inside-color=1e1e2e99 --ring-color=cba6f7ff \
        --insidever-color=1e1e2e99 --ringver-color=89b4faff \
        --insidewrong-color=1e1e2e99 --ringwrong-color=f38ba8ff \
        --line-color=00000000 --separator-color=00000000 \
        --keyhl-color=f5c2e7ff --bshl-color=f38ba8ff \
        --verif-text="" --wrong-text="" --noinput-text=""
else
    i3lock -n -e -u $bg
fi
