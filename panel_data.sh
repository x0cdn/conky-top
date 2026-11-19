#!/usr/bin/env bash
# Refresh all process caches in one place. Conky calls this every 2 seconds
# from an invisible ${execi} at the start of the text; the visible lines read
# the cache files through panel.lua without spawning extra processes.
set -u
cfg="$HOME/.config/conky"
bash "$cfg/cpu_procs.sh" 1 >/dev/null
bash "$cfg/mem_procs.sh" 1 >/dev/null
bash "$cfg/swap_procs.sh" 1 >/dev/null
