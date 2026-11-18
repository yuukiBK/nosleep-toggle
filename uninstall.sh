#!/bin/bash
# NoSleep スイッチを外して、普通のスリープ設定に戻す
set -uo pipefail
echo "▶ スリープを普通に戻して、許可を外します。Mac のパスワードを入れてください"
sudo /usr/bin/pmset -a disablesleep 0
sudo rm -f /etc/sudoers.d/pmset-nosleep
PLUGIN_DIR="$(defaults read com.ameba.SwiftBar PluginDirectory 2>/dev/null || echo "$HOME/swiftbar-plugins")"
rm -f "$PLUGIN_DIR/nosleep.30s.sh"
AGENT="$HOME/Library/LaunchAgents/com.nosleep-toggle.swiftbar.plist"
launchctl bootout "gui/$(id -u)" "$AGENT" 2>/dev/null || true
rm -f "$AGENT"
rm -rf "$HOME/.config/nosleep"
open -g "swiftbar://refreshallplugins" 2>/dev/null || true
echo "✅ 外しました。SwiftBar 自体も消すなら: brew uninstall --cask swiftbar"
