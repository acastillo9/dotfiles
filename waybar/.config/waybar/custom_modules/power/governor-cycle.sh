#!/usr/bin/env bash
cur=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)

case "$cur" in
  performance) next="schedutil" ;;
  schedutil)   next="powersave" ;;
  powersave)   next="performance" ;;
  *)           next="schedutil" ;;
esac

sudo -n cpupower frequency-set -g "$next" >/dev/null 2>&1 \
  && notify-send "CPU governor" "Switched to $next" \
  || notify-send -u critical "CPU governor" "Failed to switch (sudo needed)"
