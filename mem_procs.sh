#!/usr/bin/env bash
# Print one line of the top 30 processes by resident memory (RSS).
# Usage: mem_procs.sh N   (N = 1..30)
# The ranked list is cached in mem_procs.state for the Lua reader.
set -u
n="${1:-1}"
state="$HOME/.config/conky/mem_procs.state"
tmp="$(mktemp)"

ps -eo rss,comm --no-headers --sort=-rss 2>/dev/null | head -30 |
  awk '{printf "%-16s %6.1fM\n", $2, $1/1024}' > "$tmp"

mv -f "$tmp" "$state"
sed -n "${n}p" "$state"
