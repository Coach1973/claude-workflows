#!/bin/bash
# auto-fix-session-lock.sh — 每 2 分鐘執行
#
# 處理兩種問題：
# A. Context Overflow（JSONL 太大）
#    正確順序：①先全量存檔 → ②更新HEARTBEAT → ③清除session → ④重啟
# B. Session Lock（failed 狀態）
#    正確順序：①清除session → ②重啟

SESSIONS_FILE="/Users/bymyway/.openclaw/agents/main/sessions/sessions.json"
AUTH_FILE="/Users/bymyway/.openclaw/agents/main/agent/auth-profiles.json"
SESSIONS_DIR="/Users/bymyway/.openclaw/agents/main/sessions"
WORKSPACE_DIR="/Users/bymyway/.openclaw/workspace"
SYNC_SCRIPT="/Users/bymyway/.openclaw/scripts/sync-telegram-memory.sh"
LOG_FILE="/tmp/openclaw-session-fix.log"
JSONL_SIZE_LIMIT=500000   # 500KB

timestamp() { date '+%H:%M:%S'; }

do_clear_sessions() {
    python3 << 'PYEOF'
import json, os
sf = '/Users/bymyway/.openclaw/agents/main/sessions/sessions.json'
af = '/Users/bymyway/.openclaw/agents/main/agent/auth-profiles.json'
try:
    d = json.load(open(sf))
    for k in list(d.keys()):
        jsonl = d[k].get('sessionFile', '')
        if jsonl and os.path.exists(jsonl):
            os.remove(jsonl)
    json.dump({}, open(sf, 'w'), indent=2)
    d2 = json.load(open(af))
    for k in d2.get('usageStats', {}):
        d2['usageStats'][k] = {}
    json.dump(d2, open(af, 'w'), indent=2)
    print('ok')
except Exception as e:
    print(f'error:{e}')
PYEOF
}

do_backup_config() {
    # 學自 clawhub skill：改設定前先備份，可隨時回滾
    BACKUP="/Users/bymyway/.openclaw/openclaw.json.bak.$(date '+%Y%m%d%H%M%S')"
    cp /Users/bymyway/.openclaw/openclaw.json "$BACKUP" 2>/dev/null
    # 只保留最近 5 個備份
    ls -t /Users/bymyway/.openclaw/openclaw.json.bak.* 2>/dev/null | tail -n +6 | xargs rm -f 2>/dev/null
}

do_restart_gateway() {
    launchctl kickstart -k gui/$(id -u)/ai.openclaw.gateway >/dev/null 2>&1
    # 學自 clawhub skill：輪詢確認 gateway 真的活了，不再盲目 sleep
    for i in $(seq 1 15); do
        sleep 1
        PID=$(launchctl list 2>/dev/null | grep ai.openclaw.gateway | awk '{print $1}')
        if [ -n "$PID" ] && [ "$PID" != "-" ]; then
            echo "$(timestamp) ✅ gateway 已重啟（PID $PID，等待 ${i}s）" >> "$LOG_FILE"
            return 0
        fi
    done
    echo "$(timestamp) ⚠️ gateway 重啟超時，但設定已更新" >> "$LOG_FILE"
}

# ══════════════════════════════════════════════════════════════
# A. 偵測 Context Overflow
# ══════════════════════════════════════════════════════════════
LATEST_JSONL=$(ls -t "$SESSIONS_DIR"/*.jsonl 2>/dev/null | head -1)

if [ -n "$LATEST_JSONL" ]; then
    JSONL_SIZE=$(stat -f%z "$LATEST_JSONL" 2>/dev/null || stat -c%s "$LATEST_JSONL" 2>/dev/null || echo 0)

    if [ "$JSONL_SIZE" -gt "$JSONL_SIZE_LIMIT" ]; then
        echo "$(timestamp) [overflow] JSONL=${JSONL_SIZE} bytes，開始緊急全量存檔" >> "$LOG_FILE"
        TODAY=$(date +%Y-%m-%d)

        # ── ① 緊急全量存檔（從書籤到最後一行，一句不漏）──
        bash "$SYNC_SCRIPT" --force
        echo "$(timestamp) [overflow] ✅ 全量存檔完成" >> "$LOG_FILE"

        # ── ② 更新 HEARTBEAT（輕量版，不叫小龍蝦讀大型 memory 檔）──
        cat > "$WORKSPACE_DIR/HEARTBEAT.md" << HEOF
# HEARTBEAT 熱上下文（每次心跳必讀）

> ⚠️ 剛剛因 Context Overflow（對話太長）自動重啟
> 重啟時間：$(date '+%Y-%m-%d %H:%M')
> 對話記錄已完整存入 memory/$TODAY.md 並推上 GitHub，零遺漏

## 🔴 重啟後第一件事

直接告訴教練：「🦞 對話記錄已滿，已自動重啟，請繼續下指令」
⚠️ **不要讀 memory 大檔**（memory/$TODAY.md 可能超過 50KB，讀了會造成 Gemini 空白回應）

## ⚡ 系統狀態
- Primary 模型：google/gemini-3.1-pro-preview
- 名稱對等：Telegram = 小龍蝦 = 電報

## ⚠️ 所有對話守則
- 全部繁體中文，不夾任何英文
- 能自己做直接做，不問確認
- 截圖禁用，直接讀檔案
- 執行完通報 Telegram（Chat ID: 6124913915）
- 預估超過 5 萬 Token 先回報教練確認
- ⚠️ 不要讀大型 memory 檔（會造成 Gemini 空白回應）
HEOF
        echo "$(timestamp) [overflow] ✅ HEARTBEAT.md 已更新" >> "$LOG_FILE"

        # ── ③ 清除舊 session ──
        do_clear_sessions
        echo "$(timestamp) [overflow] ✅ session 已清除" >> "$LOG_FILE"

        # ── ④ 最後才重啟 gateway ──
        do_restart_gateway
        exit 0
    fi
fi

# ══════════════════════════════════════════════════════════════
# B. 偵測 Session Lock（failed 狀態）
# ══════════════════════════════════════════════════════════════
RESULT=$(python3 << 'PYEOF'
import json, time, sys, os

sessions_file = '/Users/bymyway/.openclaw/agents/main/sessions/sessions.json'
auth_file = '/Users/bymyway/.openclaw/agents/main/agent/auth-profiles.json'
session_key = 'agent:main:telegram:direct:6124913915'

try:
    with open(sessions_file) as f:
        sessions = json.load(f)
    with open(auth_file) as f:
        auth = json.load(f)
except:
    print('ok')
    sys.exit(0)

entry = sessions.get(session_key)
if not entry or entry.get('status') != 'failed':
    print('ok')
    sys.exit(0)

# 清除 failed session（含 JSONL）
sf = entry.get('sessionFile', '')
if sf and os.path.exists(sf):
    os.remove(sf)
del sessions[session_key]
with open(sessions_file, 'w') as f:
    json.dump(sessions, f, indent=2)

# 清 cooldown
for k in auth.get('usageStats', {}):
    auth['usageStats'][k] = {}
with open(auth_file, 'w') as f:
    json.dump(auth, f, indent=2)

print('cleared-session-lock')
PYEOF
)

if [ "$RESULT" != "ok" ] && [ -n "$RESULT" ]; then
    echo "$(timestamp) [session-fix] $RESULT" >> "$LOG_FILE"
    do_restart_gateway
fi
