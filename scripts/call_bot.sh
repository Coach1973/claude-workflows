#!/bin/bash
# 呼叫指定 bot 的 relay endpoint，觸發它在群組回應
# 用法: ./call_bot.sh <bot_number> "<message>"
# 例如: ./call_bot.sh 2 "2號機，請說明目前任務狀態"
#
# 原理：透過 Telegram Bot API 發送訊息到群組，目標 bot 在群組內收到 @mention 後自動回應
#
# 全部都在 Mac 電腦裡（不同 port、不同 workspace）：
#   1號機（.openclaw）：port 18789，bot @openclaw_macbook4_bot
#   2號機（.openclaw-peipei）：port 18793，bot @coachwu_lenovo_bot
#   3號機（.openclaw-kong）：port 18790，bot @CoachWu_openclaw_bot
#
# Token 對照（教練提供，2026-04-24）：
#   2號機（peipei）：8705446823:AAHDA0wvjdxXsaB3yX3PRiEkG_wO2N-BWa8
#   3號機（kong）：8555923043:AAEOoI2ZWIyKW69Z32IMaM0sYajG6D9HkeQ
#
# 測試結果（2026-04-24）：
#   - HTTP /relay/botX endpoint → 404 Not Found（不是 REST API）
#   - peipei/kong 跨 bot 群組mention → ✅ 成功（群組內可見）
#   - 1號機 token → ❌ Unauthorized（bot token 被 mask，無法驗證）

BOT=$1
MSG=$2
GROUP_ID="-1003877502911"

case $BOT in
  1) echo "1號機使用本機 OpenClaw，請直接透過 Telegram 發送訊息至群組"
     exit 1 ;;
  2) BOT_TOKEN="8705446823:AAHDA0wvjdxXsaB3yX3PRiEkG_wO2N-BWa8"
     MENTION="@coachwu_lenovo_bot" ;;
  3) BOT_TOKEN="8555923043:AAEOoI2ZWIyKW69Z32IMaM0sYajG6D9HkeQ"
     MENTION="@CoachWu_openclaw_bot" ;;
  *) echo "未知 bot 號碼"; exit 1 ;;
esac

curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
  -d "chat_id=${GROUP_ID}" \
  -d "text=${MENTION} ${MSG}" \
  -d "parse_mode=HTML"

echo ""
