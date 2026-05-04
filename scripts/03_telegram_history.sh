#!/bin/bash
# 03_telegram_history.sh
# 功能：從 daily_*.md 讀取教練的 Telegram 歷史訊息
# 使用：bash 03_telegram_history.sh [天數] [關鍵字]
#   天數：預設 7
#   關鍵字：選填，篩選訊息內容

DAYS=${1:-7}
KEYWORD=${2:-""}
DAILY_DIR="/Users/bymyway/.openclaw/workspace"

# 計算起始日期
START_DATE=$(date -v-${DAYS}d '+%Y-%m-%d')

echo "═══ 教練 Telegram 歷史 ═══"
echo "搜尋範圍：${START_DATE} 以來，共 ${DAYS} 天"
if [[ -n "$KEYWORD" ]]; then
  echo "關鍵字：${KEYWORD}"
fi
echo ""

# 建立臨時檔案收集結果
TEMP_FILE=$(mktemp)

for daily_file in $(ls ${DAILY_DIR}/daily_*.md 2>/dev/null | sort); do
  fname=$(basename "$daily_file")
  date_str=$(echo "$fname" | sed 's/daily_\([0-9-]*\).md/\1/')

  if [[ "$date_str" < "$START_DATE" ]]; then
    continue
  fi

  # 用 grep 找出教練的訊息行，再用 sed 處理
  grep -E '^👤|^󾠮.*教練：' "$daily_file" 2>/dev/null | while read -r line; do
    # 移除 emoji 前綴，取出時間和訊息
    text=$(echo "$line" | sed 's/^[👤󾠮]* 教練：\[//' | sed 's/\] //')

    # 跳過空行和系統訊息
    if [[ -z "$text" ]] || [[ "$text" == cron:* ]] || [[ "$text" == System:* ]]; then
      continue
    fi

    # 時間戳在 [...] 內，擷取日期時間
    timestamp=$(echo "$line" | grep -oE '\[[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}' | head -1)

    # 關鍵字篩選
    if [[ -n "$KEYWORD" ]]; then
      if ! echo "$text" | grep -qi "$KEYWORD"; then
        continue
      fi
    fi

    echo "${timestamp} | 教練: ${text}" >> "$TEMP_FILE"
  done
done

# 排序輸出
if [[ -s "$TEMP_FILE" ]]; then
  sort -r "$TEMP_FILE" | head -100
else
  echo "找不到符合條件的訊息"
fi

rm -f "$TEMP_FILE"