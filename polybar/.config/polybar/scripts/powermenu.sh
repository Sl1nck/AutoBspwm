#!/bin/sh
# Acciones del menú de apagado de la barra. Uso: powermenu.sh lock|suspend|logout|reboot|poweroff
# Primero cierra el menú desplegado en la barra
polybar-msg action "#power.close" > /dev/null 2>&1

case "$1" in
    lock)     ~/.config/bspwm/scripts/lock.sh ;;
    suspend)  systemctl suspend ;;
    logout)   bspc quit ;;
    reboot)   systemctl reboot ;;
    poweroff) systemctl poweroff ;;
esac
