#!/usr/bin/env bash
# Print one line of the top swap-using processes for Conky.
# Usage: swap_procs.sh N   (N = 1..15)
# The full ranked list is cached in swap_procs.state so every Conky line can
# read its own row without reparsing the whole /proc scan.
set -u
n="${1:-1}"
state="$HOME/.config/conky/swap_procs.state"
tmp="$(mktemp)"

for p in /proc/[0-9]*; do
  swap="$(awk '/^VmSwap:/{print $2}' "$p/status" 2>/dev/null)"
  [ -n "$swap" ] || continue
  [ "$swap" -gt 0 ] 2>/dev/null || continue
  name="$(cat "$p/comm" 2>/dev/null)"
  printf '%s %s\n' "$swap" "$name"
done | sort -rn | head -15 |
  awk '{printf "%-16s %5.1fM\n", $2, $1/1024}' > "$tmp"

mv -f "$tmp" "$state"
sed -n "${n}p" "$state"
