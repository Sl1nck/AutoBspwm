#!/bin/sh
read -r _ u1 n1 s1 i1 w1 q1 sq1 st1 _ < /proc/stat
sleep 0.5
read -r _ u2 n2 s2 i2 w2 q2 sq2 st2 _ < /proc/stat
idle=$(( (i2 + w2) - (i1 + w1) ))
total=$(( (u2 + n2 + s2 + i2 + w2 + q2 + sq2 + st2) - (u1 + n1 + s1 + i1 + w1 + q1 + sq1 + st1) ))
if [ "$total" -gt 0 ]; then cpu=$(( 100 * (total - idle) / total )); else cpu=0; fi
mem=$(awk '/MemTotal/ {t=$2} /MemAvailable/ {a=$2} END {printf "%d", (t-a)/1024}' /proc/meminfo)
echo "%{T2} %{T-}${cpu}%  %{T2}󰍛 %{T-}${mem} MiB"
