#!/bin/bash
# Total traffic (down/up, bytes) of the active NekoBox profile via the Clash API.
# Accumulated between core restarts and PC reboots.
# RESET: on the 9th day of every month the counter starts over (new period).
# Clash API: Settings -> Advanced -> Clash API,
#   External Controller: 127.0.0.1:9090, Secret: neko (change it here if needed).
PORT=9090
TOKEN=neko
STATE="$HOME/.config/conky/proxy_traffic.state"

fmt() {
  awk -v b="$1" 'BEGIN{
    u[1]="B";u[2]="KB";u[3]="MB";u[4]="GB";u[5]="TB";
    i=1; while (b+0>=1024 && i<5){ b/=1024; i++ }
    printf "%.1f%s", b, u[i]
  }'
}

# Reset period: starting on the 9th of each month the counter starts over
day=$((10#$(date +%d)))
if [ "$day" -ge 9 ]; then
  period=$(date +%Y-%m)
else
  period=$(date -d "last month" +%Y-%m)
fi

cur=$(curl -sN --max-time 2 -H "Accept: text/event-stream" \
      -H "Authorization: Bearer ${TOKEN}" \
      "http://127.0.0.1:${PORT}/traffic" 2>/dev/null | grep -m1 -oE '\{[^}]*\}')

if [ -z "$cur" ]; then
  if [ -f "$STATE" ]; then
    read -r sp pd pu ad au < "$STATE"
    echo "↓$(fmt "${ad:-0}") ↑$(fmt "${au:-0}")"
  else
    echo "↓— ↑—"
  fi
  exit 0
fi

cd=$(printf '%s' "$cur" | grep -ioE '"down"[[:space:]]*:[[:space:]]*[0-9]+' | grep -oE '[0-9]+')
cu=$(printf '%s' "$cur" | grep -ioE '"up"[[:space:]]*:[[:space:]]*[0-9]+'   | grep -oE '[0-9]+')
cd=${cd:-0}; cu=${cu:-0}

if [ -f "$STATE" ]; then
  read -r sp pd pu ad au < "$STATE"
  pd=${pd:-0}; pu=${pu:-0}; ad=${ad:-0}; au=${au:-0}
  if [ "$sp" != "$period" ]; then
    # new period reached (9th day) -> reset the accumulated totals
    ad=0; au=0
    pd=$cd; pu=$cu
  else
    if [ "$cd" -ge "$pd" ]; then ad=$((ad + cd - pd)); else ad=$((ad + cd)); fi
    if [ "$cu" -ge "$pu" ]; then au=$((au + cu - pu)); else au=$((au + cu)); fi
  fi
else
  ad=$cd; au=$cu
fi

echo "$period $cd $cu $ad $au" > "$STATE"
echo "↓$(fmt "$ad") ↑$(fmt "$au")"
