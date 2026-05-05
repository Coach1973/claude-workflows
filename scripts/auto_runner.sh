#!/bin/bash
# auto_runner.sh — 全自動任務執行器
# 用法：bash scripts/auto_runner.sh
# 小龍蝦呼叫方式：bash /Users/bymyway/.openclaw/workspace/scripts/auto_runner.sh
#
# 執行流程：逐一跑任務 → 每完成一個 git commit → 發 Telegram 通知 → 繼續下一個

set -e

WORKSPACE="/Users/bymyway/.openclaw/workspace"
OUTPUT="$WORKSPACE/terminal-notes/relay_output.md"
BOT_TOKEN="8758843664:AAE4W-hGh2mPxNt89b2donZ0Q--YZ9uwdsA"
GROUP_ID="-1003877502911"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# ── Telegram 通知函式 ──
notify() {
  local msg="$1"
  curl -s "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
    -d "chat_id=${GROUP_ID}" \
    -d "text=${msg}" \
    -d "parse_mode=HTML" > /dev/null 2>&1
}

# ── AI 任務執行函式（用 claude --print）──
run_ai_task() {
  local task_name="$1"
  local prompt="$2"
  local ts=$(date '+%Y-%m-%d %H:%M:%S')
  echo "## [$ts] $task_name" >> "$OUTPUT"
  claude --print "$prompt" >> "$OUTPUT"
  echo "---" >> "$OUTPUT"
}

# ── Git commit 函式 ──
commit_progress() {
  local msg="$1"
  cd "$WORKSPACE"
  git add -A
  git commit -m "$msg" 2>/dev/null || true
}

# ════════════════════════════════════════════
# 開始執行
# ════════════════════════════════════════════
cd "$WORKSPACE"
notify "🚀 <b>自動任務執行器啟動</b>
時間：$TIMESTAMP
準備執行今晚任務清單，完成後回報"

echo "🚀 auto_runner.sh 啟動 — $TIMESTAMP"

# ════════════════════════════════════════════
# 任務 1：每日晨報生成腳本
# ════════════════════════════════════════════
echo "▶ 任務1：建立每日晨報生成腳本..."

cat > "$WORKSPACE/scripts/morning_brief.sh" << 'MORNING_EOF'
#!/bin/bash
# morning_brief.sh — 每日晨報
# 小龍蝦每天早上 8:00 自動執行，生成今日狀態摘要發到 Telegram
WORKSPACE="/Users/bymyway/.openclaw/workspace"
BOT_TOKEN="8758843664:AAE4W-hGh2mPxNt89b2donZ0Q--YZ9uwdsA"
GROUP_ID="-1003877502911"
DATE=$(date '+%Y-%m-%d')
WEEKDAY=$(date '+%A')

# 讀取 HEARTBEAT 最新狀態
HEARTBEAT_SUMMARY=$(head -50 "$WORKSPACE/HEARTBEAT.md" | tail -30)

# 生成晨報
BRIEF=$(claude --print "讀取以下 HEARTBEAT 內容，用繁體中文生成一份100字以內的晨報摘要，格式：今日重點任務（2條）、系統狀態（1句）、今日建議行動（1條）。HEARTBEAT內容：$HEARTBEAT_SUMMARY" 2>/dev/null)

MSG="🌅 <b>頂級特助系統 — $DATE ($WEEKDAY) 晨報</b>

$BRIEF

─────────────────
<i>自動生成 | 如需詳細請問我</i>"

curl -s "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
  -d "chat_id=${GROUP_ID}" \
  -d "text=${MSG}" \
  -d "parse_mode=HTML" > /dev/null 2>&1

echo "✅ 晨報已發送 $DATE"
MORNING_EOF

chmod +x "$WORKSPACE/scripts/morning_brief.sh"
commit_progress "feat: morning_brief.sh 每日晨報自動生成腳本"
notify "✅ 任務1完成：每日晨報腳本已建立
小龍蝦可執行：bash scripts/morning_brief.sh"
echo "✅ 任務1完成"

# ════════════════════════════════════════════
# 任務 2：建立「任務清單產生器」— 讓我（桌面版）的指令直接變成可執行的任務列
# ════════════════════════════════════════════
echo "▶ 任務2：建立任務清單產生器..."

cat > "$WORKSPACE/scripts/queue_runner.sh" << 'QUEUE_EOF'
#!/bin/bash
# queue_runner.sh — 從 TASK_QUEUE.txt 逐行執行任務
# 格式：每行一個任務，以 "AI:" 開頭代表 AI 任務，"SH:" 開頭代表 shell 任務
# 用法：bash scripts/queue_runner.sh [任務檔案路徑（預設 TASK_QUEUE.txt）]

WORKSPACE="/Users/bymyway/.openclaw/workspace"
QUEUE_FILE="${1:-$WORKSPACE/TASK_QUEUE.txt}"
OUTPUT="$WORKSPACE/terminal-notes/relay_output.md"
BOT_TOKEN="8758843664:AAE4W-hGh2mPxNt89b2donZ0Q--YZ9uwdsA"
GROUP_ID="-1003877502911"

notify() {
  curl -s "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
    -d "chat_id=${GROUP_ID}" -d "text=$1" -d "parse_mode=HTML" > /dev/null 2>&1
}

if [ ! -f "$QUEUE_FILE" ]; then
  echo "❌ 找不到任務清單：$QUEUE_FILE"
  exit 1
fi

TOTAL=$(grep -c "^[AS][IH]:" "$QUEUE_FILE" 2>/dev/null || echo 0)
DONE=0

notify "📋 <b>任務清單開始執行</b>
共 $TOTAL 個任務，開始逐一處理..."

while IFS= read -r line; do
  [[ -z "$line" || "$line" == "#"* ]] && continue

  TYPE="${line%%:*}"
  CONTENT="${line#*:}"
  DONE=$((DONE+1))
  TS=$(date '+%H:%M:%S')

  if [ "$TYPE" = "AI" ]; then
    echo "## [$TS] AI任務 $DONE/$TOTAL" >> "$OUTPUT"
    claude --print "$CONTENT" >> "$OUTPUT"
    echo "---" >> "$OUTPUT"
  elif [ "$TYPE" = "SH" ]; then
    eval "$CONTENT"
  fi

  cd "$WORKSPACE" && git add -A && git commit -m "auto: 任務$DONE/$TOTAL 完成" 2>/dev/null || true
  notify "✅ <b>任務 $DONE/$TOTAL 完成</b>（$TS）
$CONTENT" | head -c 200

done < "$QUEUE_FILE"

notify "🎉 <b>所有任務完成！</b>
共完成 $DONE 個任務
結果在 terminal-notes/relay_output.md"
echo "🎉 全部完成，共 $DONE 個任務"
QUEUE_EOF

chmod +x "$WORKSPACE/scripts/queue_runner.sh"
commit_progress "feat: queue_runner.sh 支援TASK_QUEUE.txt逐行執行+Telegram通知"
notify "✅ 任務2完成：任務清單執行器已建立"
echo "✅ 任務2完成"

# ════════════════════════════════════════════
# 任務 3：建立今晚示範用的 TASK_QUEUE.txt
# ════════════════════════════════════════════
echo "▶ 任務3：建立今晚示範任務清單..."

cat > "$WORKSPACE/TASK_QUEUE.txt" << 'TASKEOF'
# 頂級特助系統 — 示範任務清單
# 格式：AI:提示詞 或 SH:shell指令
# 這個檔案由桌面版Claude生成，小龍蝦執行一次就跑完全部

AI:用繁體中文，從 /Users/bymyway/.openclaw/workspace/terminal-notes/場景庫知識萃取報告.md 中提取最重要的3個洞察，每個洞察50字，輸出格式為：洞察標題+內容
SH:echo "洞察萃取完成" >> /Users/bymyway/.openclaw/workspace/terminal-notes/relay_output.md
AI:根據頂級特助系統的43條守則（/Users/bymyway/.openclaw/workspace/terminal-notes/TOP_ASSISTANT_RULES_v3_final.md），生成一段100字的「每日開工宣言」，讓助教每天啟動前朗讀，強化自我要求
SH:cd /Users/bymyway/.openclaw/workspace && git add -A && git commit -m "auto: 示範任務清單執行完成" 2>/dev/null || true
TASKEOF

commit_progress "feat: TASK_QUEUE.txt 示範任務清單 + 完整自動化架構建立"
notify "✅ 任務3完成：示範任務清單已建立

🔧 <b>完整自動化架構就緒</b>
使用方式：
1️⃣ 桌面版Claude寫好 TASK_QUEUE.txt
2️⃣ 告訴小龍蝦：執行 bash scripts/queue_runner.sh
3️⃣ 教練只收 Telegram 通知，不需要做任何事"
echo "✅ 任務3完成"

# ════════════════════════════════════════════
# 收尾
# ════════════════════════════════════════════
commit_progress "feat: auto_runner.sh 全自動任務執行器完整版"
FINAL_TS=$(date '+%Y-%m-%d %H:%M:%S')
notify "🏁 <b>auto_runner.sh 執行完畢</b>
完成時間：$FINAL_TS

今晚建立的工具：
• morning_brief.sh — 每日晨報自動發送
• queue_runner.sh — 任務清單執行器（核心）
• TASK_QUEUE.txt — 示範任務清單

<b>教練從今天起的工作流程：</b>
早上告訴桌面版今天要做什麼
→ 桌面版寫入 TASK_QUEUE.txt
→ 告訴小龍蝦：執行 queue_runner.sh
→ 去忙你的事，Telegram 收進度通知"
echo "🏁 auto_runner.sh 全部完成 — $FINAL_TS"
