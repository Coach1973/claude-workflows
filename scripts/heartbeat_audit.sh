#!/bin/bash
# R19 強制機制：每天 23:50 跑，掃當天 HEARTBEAT.md 純 OK 條目數量
# 超過 3 條純 OK → 寫進 logs，並追加到隔天 HEARTBEAT.md 提醒區
#
# Cron 註冊方式（之後叫終端機跑）：
#   每天 23:50 觸發：50 23 * * *
#   命令：bash /Users/bymyway/.openclaw/workspace/scripts/heartbeat_audit.sh

set -uo pipefail

WORKSPACE="/Users/bymyway/.openclaw/workspace"
HB="$WORKSPACE/HEARTBEAT.md"
LOG_DIR="$WORKSPACE/logs"
LOG="$LOG_DIR/heartbeat_audit.log"
TODAY=$(date '+%Y-%m-%d')
NOW=$(date '+%Y-%m-%d %H:%M:%S')

mkdir -p "$LOG_DIR"

# 抓 HEARTBEAT.md 內含今天日期、且符合「純 OK」特徵的條目
# 純 OK 特徵：行內含 HEARTBEAT_OK / 系統正常待命 / 無待處理 / 無事可做
PURE_OK=$(grep -E "$TODAY.*(HEARTBEAT_OK|系統正常待命|無待處理任務|無事可做)" "$HB" 2>/dev/null | wc -l | tr -d ' ')

# 同日有具體進度的條目（含 commit hash、做了、發現、下一步）
WITH_PROGRESS=$(grep -E "$TODAY.*(commit|做了|發現|下一步|✅|完工|寫入|更新)" "$HB" 2>/dev/null | wc -l | tr -d ' ')

echo "[$NOW] TODAY=$TODAY PURE_OK=$PURE_OK WITH_PROGRESS=$WITH_PROGRESS" >> "$LOG"

# 純 OK > 3 條 → 違反 R19 警告
if [[ "$PURE_OK" -gt 3 ]]; then
  {
    echo ""
    echo "⚠️ R19 警告（$NOW）：$TODAY 心跳純 OK 條目 ${PURE_OK} 條（具體進度只 ${WITH_PROGRESS} 條），違反「禁純 HEARTBEAT_OK」鐵律。學長請檢討。"
  } >> "$HB"
  echo "[$NOW] WARN written to HEARTBEAT.md" >> "$LOG"
fi

exit 0
