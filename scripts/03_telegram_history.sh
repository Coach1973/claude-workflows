#!/bin/bash
# 03_telegram_history.sh
# 功能：主動讀取教練的 Telegram 歷史訊息，存入 daily 檔供小龍蝦讀取
# 使用：bash 03_telegram_history.sh [offset_message_id] [limit]

BOT_TOKEN="8123873594:AAH0xjMlh1h4jZ6kP8YqVvN2wL4mR9tU3xYz"
CHAT_ID="6124913915"
LIMIT=${2:-20}
OFFSET=${1:-0}

# 抓最新訊息
RESPONSE=$(curl -s "https://api.telegram.org/bot${BOT_TOKEN}/getMessages?chat_id=${CHAT_ID}&offset=${OFFSET}&limit=${LIMIT}")

echo "$RESPONSE" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if data.get('ok'):
    msgs = data['result']
    for m in msgs:
        mid = m.get('message_id',0)
        text = m.get('text', m.get('caption','[非文字]'))
        date = m.get('date','')
        sender = m.get('from',{}).get('first_name','?')
        print(f'[{date}] #{mid} {sender}: {text[:100]}')
else:
    print('Error:', data)
"