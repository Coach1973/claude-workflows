#!/bin/bash
# 呼叫指定 bot 的 relay endpoint，觸發它在群組回應
# 用法: ./call_bot.sh <bot_number> "<message>"
# 例如: ./call_bot.sh 2 "2號機，請說明目前任務狀態"
#
# 原理：透過 Telegram Bot API（使用1號機token）發送訊息到群組
#       目標 bot 在群組內收到訊息（提及該 bot）後自動回應
#
# 注意：跨 bot 發訊息需使用願景物級的 Telegram Bot API
#       目標 bot 需在群組中並設有 requireMention=true

BOT=$1
MSG=$2
GROUP_ID="-1003877502911"

# 1號機 token（用於發送群組訊息）
BOT_TOKEN="8187345328:AAEMxNvFzZLKQPV4ck-GizI0W-oTY7_Xjbc"

# 目標 bot @mention
case $BOT in
  1) MENTION="@openclaw_macbook4_bot" ;;
  2) MENTION="@CoachWu_openclaw_bot" ;;
  3) MENTION="@coachwu_lenovo_bot" ;;
  *) echo "未知 bot 號碼"; exit 1 ;;
esac

curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
  -d "chat_id=${GROUP_ID}" \
  -d "text=${MENTION} ${MSG}" \
  -d "parse_mode=HTML"

echo ""
