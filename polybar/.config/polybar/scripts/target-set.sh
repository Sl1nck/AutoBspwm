#!/bin/sh
f="${XDG_STATE_HOME:-$HOME/.local/state}/target"
if [ "$1" = "--clear" ]; then rm -f "$f"; exit 0; fi
mkdir -p "$(dirname "$f")"
t=$(rofi -dmenu -p "Target" < /dev/null | cut -c1-40)
[ -n "$t" ] && printf '%s\n' "$t" > "$f"
