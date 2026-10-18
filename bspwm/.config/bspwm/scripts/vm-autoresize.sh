#!/bin/sh
# Ajusta la resolucion al tamaño de la ventana de la VM (VMware)
while true; do
    set -- $(xrandr | awk '/ connected/ {o=$1; f=1; next} /^[^ ]/ {f=0} f && /\+/ && !p {p=$1} f && /\*/ && !c {c=$1} END {print o, (p ? p : "-"), (c ? c : "-")}')
    out=$1; pref=$2; cur=$3
    if [ "$pref" != "-" ] && [ "$pref" != "$cur" ]; then
        xrandr --output "$out" --auto
        sleep 1
        ~/.config/bspwm/scripts/wallpaper.sh
        pkill -x polybar
        polybar -l error main &
    fi
    sleep 2
done
