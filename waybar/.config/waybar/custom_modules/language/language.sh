#!/usr/bin/env bash
map=$(hyprctl devices -j | jq -r '[.keyboards[] | select(.main == true) | .active_keymap][0]')

case "$map" in
  *"Latin American"*) echo "{\"text\": \"ES\", \"tooltip\": \"Layout: $map\"}" ;;
  *) echo "{\"text\": \"US\", \"tooltip\": \"Layout: $map\"}" ;;
esac
