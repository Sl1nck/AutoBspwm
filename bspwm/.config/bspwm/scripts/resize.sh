#!/bin/sh
size=20
case "$1" in
    west)  bspc node -z left -$size 0  || bspc node -z right -$size 0 ;;
    east)  bspc node -z right $size 0  || bspc node -z left $size 0 ;;
    north) bspc node -z top 0 -$size   || bspc node -z bottom 0 -$size ;;
    south) bspc node -z bottom 0 $size || bspc node -z top 0 $size ;;
esac
