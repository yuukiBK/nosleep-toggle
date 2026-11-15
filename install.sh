#!/bin/bash
# NoSleep スイッチのインストール
# 使い方: curl -fsSL https://raw.githubusercontent.com/yuukiBK/nosleep-toggle/main/install.sh | bash
set -euo pipefail
RAW="${NOSLEEP_RAW:-https://raw.githubusercontent.com/yuukiBK/nosleep-toggle/main}"
USER_NAME="$(id -un)"
SUDOERS_DEST=/etc/sudoers.d/pmset-nosleep

[ "$(uname)" = "Darwin" ] || { echo "Mac 専用です"; exit 1; }

# 1. Homebrew と SwiftBar
if [ ! -d /Applications/SwiftBar.app ]; then
  if ! command -v brew >/dev/null 2>&1; then
    for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do [ -x "$b" ] && eval "$("$b" shellenv)"; done
  fi
  command -v brew >/dev/null 2>&1 || {
    echo "Homebrew が入っていません。先に https://brew.sh の1行を実行してから、もう一度このコマンドを貼ってください。"; exit 1; }
  echo "▶ SwiftBar を入れています…"
  brew install --cask swiftbar
fi

# 2. プラグイン（すでに SwiftBar のフォルダが決まっていればそこへ）
PLUGIN_DIR="$(defaults read com.ameba.SwiftBar PluginDirectory 2>/dev/null || true)"
[ -n "$PLUGIN_DIR" ] || PLUGIN_DIR="$HOME/swiftbar-plugins"
mkdir -p "$PLUGIN_DIR"
echo "▶ スイッチを置いています: $PLUGIN_DIR"
curl -fsSL "$RAW/nosleep.30s.sh" -o "$PLUGIN_DIR/nosleep.30s.sh"
chmod +x "$PLUGIN_DIR/nosleep.30s.sh"
defaults write com.ameba.SwiftBar PluginDirectory "$PLUGIN_DIR"

# 3. この切り替えだけパスワードなしで動かす許可
TMP="$(mktemp)"
printf '%s ALL=(root) NOPASSWD: /usr/bin/pmset -a disablesleep 0, /usr/bin/pmset -a disablesleep 1\n' "$USER_NAME" > "$TMP"
echo "▶ 許可を入れます。Mac のパスワードを入れてください（文字は表示されません）"
sudo /usr/sbin/visudo -cf "$TMP" >/dev/null
sudo install -m 0440 -o root -g wheel "$TMP" "$SUDOERS_DEST"
rm -f "$TMP"

# 4. 再起動・電源が落ちたあとも SwiftBar を自動で立ち上げる
AGENT="$HOME/Library/LaunchAgents/com.nosleep-toggle.swiftbar.plist"
mkdir -p "$HOME/Library/LaunchAgents"
cat > "$AGENT" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>com.nosleep-toggle.swiftbar</string>
  <key>ProgramArguments</key>
  <array><string>/usr/bin/open</string><string>-a</string><string>SwiftBar</string></array>
  <key>RunAtLoad</key><true/>
</dict>
</plist>
PLIST
launchctl bootout "gui/$(id -u)" "$AGENT" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$AGENT" 2>/dev/null || true

# 5. 起動
open -a SwiftBar
sleep 2
open -g "swiftbar://refreshallplugins" || true
echo "✅ 完了。メニューバーに月のマークが出ていれば使えます（再起動後も自動で出ます）。"
