#!/bin/sh
f="${XDG_STATE_HOME:-$HOME/.local/state}/target"
if [ -s "$f" ]; then cat "$f"; else echo "sin definir"; fi
