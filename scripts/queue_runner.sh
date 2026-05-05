#!/bin/bash
# queue_runner.sh — 從 TASK_QUEUE.txt 逐行執行任務
# 用法：bash scripts/queue_runner.sh [任務檔案路徑（預設 TASK_QUEUE.txt）]
# 格式：每行 AI:提示詞 或 SH:shell指令，# 開頭為註解

WORKSPACE="/Users/bymyway/.openclaw/workspace"
QUEUE_FILE="${1:-$WORKSPACE/TASK_QUEUE.txt}"
OUTPUT="$WORKSPACE/terminal-notes/relay_output.md"
BOT_TOKEN="8758843664:AAE4W-hGh2mPxNt89b2donZ0Q--YZ9uwdsA"
GROUP_ID="-1003877502911"

# MiniMax 設定（claude --print 需要指定 model 和 API）
export ANTHROPIC_API_KEY="sk-cp-0_iW72rvuoBmDucQXmRaSAUmcrjXTzZCpIxQt7xgKX_ImdeMkhGmgEV9QBzMNwH87jP-VLIXDNC8VqdgJmntnj5M9gJfTJFiveu9fWuXyQHnW9Z8EQnvlC8"
export ANTHROPIC_BASE_URL="https://api.minimax.io/anthropic"
CLAUDE_CMD="claude --model MiniMax-M2.7 --print"

notify() {
  curl -s "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
    -d "chat_id=${GROUP_ID}" \
    -d "text=$1" \
    -d "parse_mode=HTML" > /dev/null 2>&1
}

if [ ! -f "$QUEUE_FILE" ]; then
  echo "❌ 找不到任務清單：$QUEUE_FILE"
  notify "❌ 找不到任務清單：$QUEUE_FILE"
  exit 1
fi

TOTAL=$(grep -c "^[AS][IH]:" "$QUEUE_FILE" 2>/dev/null || echo 0)
DONE=0

notify "📋 <b>任務清單開始執行</b>
共 $TOTAL 個任務，開始逐一處理..."
echo "📋 開始執行，共 $TOTAL 個任務"

while IFS= read -r line; do
  [[ -z "$line" || "$line" == "#"* ]] && continue

  TYPE="${line%%:*}"
  CONTENT="${line#*:}"
  DONE=$((DONE+1))
  TS=$(date '+%H:%M:%S')

  echo "▶ 任務 $DONE/$TOTAL [$TYPE] $TS"

  if [ "$TYPE" = "AI" ]; then
    echo "## [$TS] AI任務 $DONE/$TOTAL: ${CONTENT:0:50}..." >> "$OUTPUT"
    $CLAUDE_CMD "$CONTENT" >> "$OUTPUT"
    echo "---" >> "$OUTPUT"
  elif [ "$TYPE" = "SH" ]; then
    eval "$CONTENT"
  fi

  cd "$WORKSPACE" && git add -A && git commit -m "auto: 任務$DONE/$TOTAL 完成 [$TS]" 2>/dev/null || true

  SHORT=$(echo "$CONTENT" | head -c 80)
  notify "✅ <b>任務 $DONE/$TOTAL 完成</b>（$TS）
$SHORT"

done < "$QUEUE_FILE"

notify "🎉 <b>所有任務完成！</b>
共完成 $DONE 個任務
結果：terminal-notes/relay_output.md"
echo "🎉 全部完成，共 $DONE 個任務"
