#!/bin/bash
# SwiftBar の見張り（launchd が1分ごとに呼ぶ）
# - 動いていなければ立ち上げる（ログイン直後・落ちたとき）
# - スリープから戻ったら立ち上げ直す（アイコンが消えることがあるため）
# - 6時間ごとに立ち上げ直す（スリープしなくても消えることがあるため）
STATE_DIR="$HOME/.config/nosleep"
mkdir -p "$STATE_DIR"
WAKE_FILE="$STATE_DIR/last_wake"
RESTART_FILE="$STATE_DIR/last_restart"
INTERVAL=$((6 * 3600))

restart() {
  osascript -e 'quit app "SwiftBar"' >/dev/null 2>&1
  for _ in 1 2 3 4 5; do pgrep -xq SwiftBar || break; sleep 1; done
  open -a SwiftBar
  date +%s > "$RESTART_FILE"
}

now=$(date +%s)
wake=$(sysctl -n kern.waketime 2>/dev/null)
last_wake=$(cat "$WAKE_FILE" 2>/dev/null)
last_restart=$(cat "$RESTART_FILE" 2>/dev/null || echo 0)
echo "$wake" > "$WAKE_FILE"

if ! pgrep -xq SwiftBar; then
  open -a SwiftBar; date +%s > "$RESTART_FILE"
elif [ -n "$last_wake" ] && [ "$wake" != "$last_wake" ]; then
  restart
elif [ $((now - last_restart)) -ge $INTERVAL ]; then
  restart
fi
