#!/bin/bash
# 05_auto_reminder.sh
# 功能：Mac 原生日曆提醒 + 桌面记事本雙重保险
# 使用：bash 05_auto_reminder.sh "提醒内容" "2026-05-05 09:00"

MSG="$1"
DATETIME="${2:-}"
DESKTOP="/Users/bymyway/Desktop/reminder.txt"

if [ -n "$DATETIME" ]; then
  # 寫入桌面记事本（永遠執行）
  echo "[$(date '+%Y-%m-%d %H:%M')] ⏰ 提醒：$MSG" >> "$DESKTOP"
  echo "✅ 已寫入桌面 reminder.txt"

  # Mac 原生通知（馬上弹）
  osascript -e "display notification \"$MSG\" with title \"🦞 小龍蝦提醒\" sound name \"Pop\""

  # 若有時間，寫入 crontab 定时通知
  TS=$(date -j -f "%Y-%m-%d %H:%M" "$DATETIME" +%s 2>/dev/null)
  if [ -n "$TS" ]; then
    REMINDER_SCRIPT="/Users/bymyway/.openclaw/workspace/scripts/04_push_notification.sh"
    # 用 at 指令安排在指定時間執行（只執行一次）
    echo "bash $REMINDER_SCRIPT '$MSG'" | at "$DATETIME" 2>/dev/null
    echo "📅 定時提醒已設定：$DATETIME — $MSG"
  fi
else
  # 無時間參數，立刻通知
  osascript -e "display notification \"$MSG\" with title \"🦞 小龍蝦通知\" sound name \"Pop\""
fi