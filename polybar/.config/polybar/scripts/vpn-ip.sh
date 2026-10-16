#!/bin/sh
ip -4 -o addr show 2>/dev/null | awk '$2 ~ /^(tun|tap|wg|ppp)/ {split($4,a,"/"); print a[1]; exit}'
