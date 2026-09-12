#!/bin/sh
# Catppuccin Mocha palette for the Linux console.
# Runs before ly takes over the TTY (see `start_cmd` in config.ini).
#
# ly's start_cmd runs with stdout redirected to the journal, so the palette
# is written to the controlling terminal (/dev/tty) explicitly. No TERM guard:
# ly always runs on a kernel VT, which is where these escape codes apply.

set -- \
    1e1e2e f38ba8 a6e3a1 f9e2af 89b4fa cba6f7 94e2d5 bac2de \
    585b70 f38ba8 a6e3a1 f9e2af 89b4fa f5c2e7 94e2d5 cdd6f4

i=0
for color in "$@"; do
    printf '\033]P%x%s' "$i" "$color"
    i=$((i + 1))
done > /dev/tty 2>/dev/null || true
