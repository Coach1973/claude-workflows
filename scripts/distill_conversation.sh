#!/bin/bash
# 對話蒸餾腳本
# 用途：從 daily_*.md 中萃取出教練的實質對話（去除 JSON metadata、程式碼、心跳噪聲）
# 輸出：教練的核心指示與對話精華

DAILY_DIR="/Users/bymyway/.openclaw/workspace"
OUTPUT="$DAILY_DIR/distilled_latest.md"

echo "# 對話蒸餾結果（自動生成）" > "$OUTPUT"
echo "生成時間：$(date '+%Y-%m-%d %H:%M')" >> "$OUTPUT"
echo "" >> "$OUTPUT"

# 處理的日期陣列
for day in 24 25 26 27; do
  file="$DAILY_DIR/daily_2026-04-${day}.md"
  if [ ! -f "$file" ]; then
    echo "### 2026-04-${day}: 檔案不存在，跳過" >> "$OUTPUT"
    continue
  fi
  
  echo "### 2026-04-${day} 對話精華" >> "$OUTPUT"
  echo "" >> "$OUTPUT"
  
  # 步驟1：找出教練直接對話（chat_id: 6124913915）區段
  # 跳過 Telegram group messages（chat_id: -1003877502911）
  # 跳過 cron 心跳任務
  # 跳過 System 訊息
  # 萃取出 👤 教練：之後的實質內容
  
  awk '
    BEGIN { in_directchat = 0; last_section = ""; buffer = "" }
    
    # 偵測 direct chat 開始（chat_id: 6124913915）
    /"chat_id": "telegram:6124913915"/ { in_directchat = 1; next }
    
    # 偵測 group chat 開始 → 停止萃取的內容
    /"chat_id": "telegram:-/ { in_directchat = 0; next }
    
    # 跳過 cron 心跳
    /\[cron:/ { next }
    
    # 跳過 System 訊息
    /^System \(untrusted\)/ { next }
    
    # 跳過 Exec completed 系統訊息
    /^An async command/ { next }
    /^🦞 小龍蝦/ { next }
    
    # 偵測新對話段落標題
    /^## 📨 對話記錄/ { 
      if (buffer != "" && in_directchat) {
        print buffer
        print ""
      }
      buffer = ""
      in_directchat = 1
      next 
    }
    
    # 偵測緊急存檔標題
    /^## ⚠️ 緊急存檔/ { 
      if (buffer != "" && in_directchat) {
        print buffer
        print ""
      }
      buffer = ""
      in_directchat = 1
      next 
    }
    
    # 教練的訊息內容（去除 JSON 包裝）
    in_directchat && /^👤 教練:/ {
      sub(/^👤 教練：/, "")
      sub(/^👤 教練: /, "")
      # 去除 JSON 格式殘留
      sub(/^"message_id".*/, "")
      sub(/^"chat_id".*/, "")
      sub(/^"sender".*/, "")
      sub(/^"timestamp".*/, "")
      sub(/^}$/, "")
      # 去除多餘空白
      gsub(/^[ \t]+/, "")
      if (length($0) > 10) {  # 只保留有意義的內容（>10字）
        buffer = buffer $0 "\n"
      }
      next
    }
    
    # 其他對話段落標題，則輸出並重置 buffer
    /^## / {
      if (buffer != "" && in_directchat) {
        print buffer
        print ""
      }
      buffer = ""
      in_directchat = 0
    }
  ' "$file" >> "$OUTPUT"
  
  echo "" >> "$OUTPUT"
  echo "---" >> "$OUTPUT"
  echo "" >> "$OUTPUT"
done

# 統計：多少行
LINES=$(wc -l < "$OUTPUT")
echo "" >> "$OUTPUT"
echo "## 蒸餾統計" >> "$OUTPUT"
echo "總行數：$LINES" >> "$OUTPUT"

echo "✅ 完成蒸餾，輸出至：$OUTPUT"
