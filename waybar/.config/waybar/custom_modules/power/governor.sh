#!/usr/bin/env bash
gov=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)

case "$gov" in
  performance) icon="󰓅"; tooltip="CPU governor: performance" ;;
  schedutil)   icon="󰾅"; tooltip="CPU governor: schedutil" ;;
  powersave)   icon="󰾆"; tooltip="CPU governor: powersave" ;;
  *)           icon="󰾅"; tooltip="CPU governor: $gov" ;;
esac

echo "{\"text\": \"$icon\", \"tooltip\": \"$tooltip\", \"class\": \"$gov\"}"
