#!/bin/bash
# 02_context_backup.sh
# 功能：每次心跳前，先把 HEARTBEAT.md 做一次快照，防止 context overflow 造成斷裂
# 觸發：每 30 分鐘心跳前自動執行（由 cron 調用）

HEARTBEAT="/Users/bymyway/.openclaw/workspace/HEARTBEAT.md"
BACKUP_DIR="/Users/bymyway/.openclaw/workspace/memory/snapshots"
TIMESTAMP=$(date '+%Y-%m-%d_%H%M%S')

mkdir -p "$BACKUP_DIR"

# 當前對話摘要快照（500行，够輕量）
HEAD_COUNT=$(wc -l < "$HEARTBEAT")
if [ "$HEAD_COUNT" -gt 100 ]; then
  # 保留最新的 100 行作為快照
  tail -100 "$HEARTBEAT" > "$BACKUP_DIR/snapshot_${TIMESTAMP}.txt"

  # 若檔案大於 30KB，主動標記 warning
  SIZE_KB=$(du -k "$HEARTBEAT" | cut -f1)
  if [ "$SIZE_KB" -gt 30 ]; then
    echo "[WARNING] HEARTBEAT.md = ${SIZE_KB}KB（>30KB）已快照 snapshot_${TIMESTAMP}.txt" >> "$BACKUP_DIR/.log"
  fi
fi

echo "Snapshot done at $TIMESTAMP"