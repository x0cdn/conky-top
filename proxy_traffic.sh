#!/bin/bash
# Total proxy traffic (down/up, bytes) for the whole period, from Throne's
# Traffic Statistics database. Old data lives in the hourly table, recent data
# in the minute table; both are combined without overlap.
# RESET: on the 12th day of every month the counter starts over (new period).
set -u
DB="${THRONE_STATS_DB:-/home/topsh/AppImage/Throne/config/throne_stats.db}"

fmt() {
  awk -v b="$1" 'BEGIN{
    u[1]="B";u[2]="KB";u[3]="MB";u[4]="GB";u[5]="TB";
    i=1; while (b+0>=1024 && i<5){ b/=1024; i++ }
    printf "%.1f%s", b, u[i]
  }'
}

# Reset period: starting on the 12th of each month the counter starts over.
day=$((10#$(date +%d)))
if [ "$day" -ge 12 ]; then
  period=$(date +%Y-%m)
else
  period=$(date -d "last month" +%Y-%m)
fi
start=$(date -d "${period}-12 00:00:00" +%s)

# The minute table only keeps recent days; older buckets are in the hourly
# table. Use hourly data only before the first available minute bucket.
first_minute=$(sqlite3 "$DB" "SELECT min(bucket_start) FROM config_traffic_minute;" 2>/dev/null)
[ -n "$first_minute" ] || first_minute=9999999999

hour_row=$(sqlite3 "$DB" \
  "SELECT sum(up), sum(down) FROM config_traffic_hour \
   WHERE bucket_start >= ${start} AND bucket_start < ${first_minute};" 2>/dev/null)
minute_row=$(sqlite3 "$DB" \
  "SELECT sum(up), sum(down) FROM config_traffic_minute \
   WHERE bucket_start >= ${start};" 2>/dev/null)

hu=$(printf '%s' "$hour_row"   | cut -d'|' -f1)
hd=$(printf '%s' "$hour_row"   | cut -d'|' -f2)
mu=$(printf '%s' "$minute_row" | cut -d'|' -f1)
md=$(printf '%s' "$minute_row" | cut -d'|' -f2)

up=$(( ${hu:-0} + ${mu:-0} ))
down=$(( ${hd:-0} + ${md:-0} ))

echo "↓$(fmt "$down") ↑$(fmt "$up")"
