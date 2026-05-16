#!/bin/bash
# R18 強制機制：每 15 分鐘檢查 workspace 是否有未 commit 的變動
# 超過 60 分鐘沒 commit → 寫進 HEARTBEAT.md 警告區，學長下次心跳會看到
#
# Cron 註冊方式（之後叫終端機跑）：
#   每 15 分鐘觸發：*/15 * * * *
#   命令：bash /Users/bymyway/.openclaw/workspace/scripts/checkpoint_audit.sh

set -uo pipefail

WORKSPACE="/Users/bymyway/.openclaw/workspace"
HB="$WORKSPACE/HEARTBEAT.md"
LOG_DIR="$WORKSPACE/logs"
LOG="$LOG_DIR/checkpoint_audit.log"
NOW=$(date '+%Y-%m-%d %H:%M:%S')

mkdir -p "$LOG_DIR"
cd "$WORKSPACE" || exit 1

# 抓最後一次 commit 時間（epoch seconds）
LAST_COMMIT_EPOCH=$(git log -1 --format=%ct 2>/dev/null || echo 0)
NOW_EPOCH=$(date +%s)
DIFF_MIN=$(( (NOW_EPOCH - LAST_COMMIT_EPOCH) / 60 ))

# 看有沒有 uncommitted 變動
DIRTY=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')

# 情境 1：有未提交檔案 → 記 log
if [[ "$DIRTY" -gt 0 ]]; then
  echo "[$NOW] DIRTY=$DIRTY uncommitted, last_commit=${DIFF_MIN}min ago" >> "$LOG"
fi

# 情境 2：超過 60 分鐘沒 commit（無論有沒有 dirty）→ 警告區
if [[ "$DIFF_MIN" -gt 60 ]]; then
  # 防止重複寫入：檢查 HEARTBEAT.md 最後 5 行有沒有今天同一小時的警告
  HOUR_TAG=$(date '+%Y-%m-%d %H')
  if ! tail -5 "$HB" 2>/dev/null | grep -q "R18 警告（$HOUR_TAG"; then
    {
      echo ""
      echo "⚠️ R18 警告（$NOW）：workspace 已 ${DIFF_MIN} 分鐘沒 commit（dirty=$DIRTY），違反 15 分鐘 checkpoint 鐵律。學長請追終端機進度。"
    } >> "$HB"
    echo "[$NOW] WARN written to HEARTBEAT.md (${DIFF_MIN}min)" >> "$LOG"
  fi
fi

exit 0
