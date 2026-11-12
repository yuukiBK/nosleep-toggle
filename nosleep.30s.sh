#!/bin/bash
# <xbar.title>Lid NoSleep</xbar.title>
# <xbar.desc>ふたを閉じてもスリープしない設定（pmset disablesleep）をオンオフする</xbar.desc>
PMSET=/usr/bin/pmset
if [ "$1" = "on" ] || [ "$1" = "off" ]; then
  [ "$1" = "on" ] && v=1 || v=0
  if ! sudo -n "$PMSET" -a disablesleep "$v" 2>/dev/null; then
    osascript -e 'display notification "許可の設定が入っていません。install.sh をもう一度実行してください。" with title "NoSleep"'
  fi
  exit 0
fi
state=$("$PMSET" -g | awk '/SleepDisabled/{print $2}')
if [ "$state" = "1" ]; then
  echo " | sfimage=cup.and.saucer.fill"
  echo "---"
  echo "今：ふたを閉じても眠らない"
  echo "眠るように戻す | bash='$0' param1=off terminal=false refresh=true"
else
  echo " | sfimage=moon.zzz"
  echo "---"
  echo "今：ふたを閉じると眠る（普通）"
  echo "閉じても眠らないようにする | bash='$0' param1=on terminal=false refresh=true"
fi
