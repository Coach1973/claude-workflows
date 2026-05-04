#!/bin/bash
# 04_push_notification.sh
# 功能：Mac 原生推播通知（不依賴 LINE），由 cron 定時觸發
# 使用：bash 04_push_notification.sh "訊息內容"

MESSAGE="${1:-Hello from 小龍蝦}"

osascript -e "display notification \"$MESSAGE\" with title \"🦞 小龍蝦特助\" sound name \"Pop\""