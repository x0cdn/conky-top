#!/usr/bin/env bash
# Print one line of per-application proxy traffic (GB) for Conky.
# Source: Throne Traffic Statistics (hourly + minute buckets, no overlap).
# Usage: proxy_apps.sh N   (N = 1..10)
set -u
n="${1:-1}"
DB="${THRONE_STATS_DB:-/home/topsh/AppImage/Throne/config/throne_stats.db}"
STATE="$HOME/.config/conky/proxy_apps.state"
TMP="$(mktemp)"

# Reset period: starting on the 12th of each month the counter starts over.
day=$((10#$(date +%d)))
if [ "$day" -ge 12 ]; then
  period=$(date +%Y-%m)
else
  period=$(date -d "last month" +%Y-%m)
fi
start=$(date -d "${period}-12 00:00:00" +%s)

first_minute=$(sqlite3 "$DB" "SELECT min(bucket_start) FROM app_traffic_minute;" 2>/dev/null)
[ -n "$first_minute" ] || first_minute=9999999999

if [ -f "$DB" ]; then
  sqlite3 -separator ' ' "$DB" \
    "SELECT process_name, sum(up), sum(down) FROM (
       SELECT process_name, up, down FROM app_traffic_hour
        WHERE bucket_start >= ${start} AND bucket_start < ${first_minute}
       UNION ALL
       SELECT process_name, up, down FROM app_traffic_minute
        WHERE bucket_start >= ${start}
     ) GROUP BY process_name ORDER BY sum(up+down) DESC LIMIT 10;" 2>/dev/null |
    awk '{printf "%-12s %5.2fG\n", substr($1, 1, 12), ($2+$3)/1024/1024/1024}' > "$TMP"
  [ -s "$TMP" ] && mv -f "$TMP" "$STATE"
fi
rm -f "$TMP"

sed -n "${n}p" "$STATE" 2>/dev/null || true
