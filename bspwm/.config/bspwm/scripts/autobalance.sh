#!/bin/sh
# Reparte el espacio por igual entre las ventanas del escritorio actual
bspc subscribe node_add node_remove node_transfer desktop_focus | while read -r _; do
    bspc node @/ -B
done
