#!/usr/bin/env bash
# Pull installed (third-party) apps from an Android phone over adb and scan each one in MobSF.
# Usage: ./scan-phone.sh [package-filter]     e.g. ./scan-phone.sh bank
# Needs: adb (USB debugging on), curl, jq, MobSF running from this folder.
set -euo pipefail
cd "$(dirname "$0")"
set -a; . ./.env; set +a
URL="http://127.0.0.1:${MOBSF_PORT:-8000}/api/v1"
AUTH="Authorization: ${MOBSF_API_KEY}"
FILTER="${1:-}"
mkdir -p apks
OUT="results-$(date +%F).tsv"
printf 'package\tscore\thigh\twarning\ttrackers\n' > "$OUT"

curl -fsS -o /dev/null -H "$AUTH" "$URL/scans" || { echo "MobSF is not reachable at $URL"; exit 1; }
adb get-state >/dev/null

adb shell pm list packages -3 | sed 's/^package://' | tr -d '\r' | grep -i -- "$FILTER" | sort | while read -r pkg; do
  # split apps have several APKs; the code that matters is in base.apk
  path=$(adb shell pm path "$pkg" </dev/null | tr -d '\r' | sed -n 's/^package://p' | grep -m1 'base.apk' || true)
  [ -n "$path" ] || { echo "skip $pkg: no base.apk"; continue; }
  apk="apks/$pkg.apk"
  [ -s "$apk" ] || adb pull "$path" "$apk" </dev/null >/dev/null
  echo "scan $pkg ($(du -h "$apk" | cut -f1))"
  hash=$(curl -fsS -H "$AUTH" -F "file=@$apk" "$URL/upload" | jq -r .hash)
  curl -fsS -o /dev/null --max-time 3600 -H "$AUTH" -d "hash=$hash" "$URL/scan" || { echo "  scan failed"; continue; }
  curl -fsS -H "$AUTH" -d "hash=$hash" "$URL/scorecard" |
    jq -r --arg p "$pkg" '[$p, .security_score, (.high|length), (.warning|length), (.total_trackers // 0)] | @tsv' >> "$OUT"
done

echo; column -t -s $'\t' "$OUT" | (read -r h; echo "$h"; sort -k2 -n)
echo; echo "Saved to $OUT. Full reports: http://127.0.0.1:${MOBSF_PORT:-8000}/recent_scans/"
