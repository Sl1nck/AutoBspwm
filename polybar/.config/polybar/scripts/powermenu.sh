#!/bin/sh
choice=$(printf 'Cancelar\nApagar\nReiniciar\nCerrar sesión\n' | rofi -dmenu -i -p "Energía")
case "$choice" in
    "Apagar") systemctl poweroff ;;
    "Reiniciar") systemctl reboot ;;
    "Cerrar sesión") bspc quit ;;
esac
