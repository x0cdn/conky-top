#!/usr/bin/env bash
# Print one line of the top 20 CPU-consuming processes.
# Usage: cpu_procs.sh N   (N = 1..20)
# The ranked list is cached in cpu_procs.state for the Lua reader.
set -u
n="${1:-1}"
state="$HOME/.config/conky/cpu_procs.state"
tmp="$(mktemp)"

ps -eo %cpu,comm --no-headers --sort=-%cpu 2>/dev/null | head -20 |
  awk '{printf "%-16s %5.1f%%\n", $2, $1}' > "$tmp"

mv -f "$tmp" "$state"
sed -n "${n}p" "$state"
