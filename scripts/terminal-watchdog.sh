#!/bin/bash
# terminal-watchdog.sh — 每 5 分鐘執行
# 功能：偵測終端機 claude 是否卡住，自動送出 Enter 讓它繼續
# 原理：若超過 25 分鐘沒有新 git commit，且 claude process 存在但 CPU 接近 0，
#       代表它在等待輸入，用 osascript 自動送 Enter

WORKSPACE="/Users/bymyway/.openclaw/workspace"
LOG="/tmp/terminal-watchdog.log"
STATE="/tmp/terminal-watchdog.state"
HEARTBEAT="$WORKSPACE/HEARTBEAT.md"
IDLE_THRESHOLD=25  # 分鐘
DEDUP_WINDOW=$((24 * 3600))  # 失敗訊息去重視窗：24 小時
HEARTBEAT_FAIL_THRESHOLD=3   # 連續失敗幾次寫入 HEARTBEAT

timestamp() { date '+%H:%M:%S'; }
now_epoch() { date +%s; }

# ── state 讀寫（純 shell，避免外部依賴）──
state_get() {
    local key="$1"
    [ -f "$STATE" ] || return
    grep "^${key}=" "$STATE" 2>/dev/null | tail -1 | cut -d'=' -f2-
}

state_set() {
    local key="$1" val="$2"
    touch "$STATE"
    local tmp
    tmp=$(mktemp)
    grep -v "^${key}=" "$STATE" 2>/dev/null > "$tmp"
    echo "${key}=${val}" >> "$tmp"
    mv "$tmp" "$STATE"
}

# ── 1. 確認 claude 終端機 process 存在 ──
CLAUDE_PID=$(ps aux | grep -E '^\S+\s+[0-9]+.*[^/]claude$' | grep -v grep | awk '{print $2}' | head -1)
if [ -z "$CLAUDE_PID" ]; then
    exit 0  # claude 沒在跑，不處理
fi

# ── 2. 確認最後一次 git commit 距現在多久 ──
cd "$WORKSPACE" || exit 0
LAST_COMMIT_TIME=$(git log -1 --format="%ct" 2>/dev/null)
NOW=$(now_epoch)
ELAPSED_MIN=$(( (NOW - LAST_COMMIT_TIME) / 60 ))

if [ "$ELAPSED_MIN" -lt "$IDLE_THRESHOLD" ]; then
    exit 0  # 最近有 commit，不干預
fi

# ── 3. 確認 claude process CPU 低（在等輸入）──
CPU=$(ps -p "$CLAUDE_PID" -o %cpu= 2>/dev/null | tr -d ' ')
CPU_INT=$(echo "$CPU" | cut -d'.' -f1)
if [ "${CPU_INT:-99}" -gt 10 ]; then
    exit 0  # 還在跑，不干預
fi

# ── 4. 卡住了，用 osascript 送 Enter 讓它繼續 ──
echo "$(timestamp) [watchdog] claude 卡住 ${ELAPSED_MIN} 分鐘（PID $CLAUDE_PID, CPU ${CPU}%），送出 Enter" >> "$LOG"

# 第一次：送 Enter
ERR1=$(osascript 2>&1 >/dev/null << 'APPLESCRIPT'
tell application "Terminal"
    activate
    tell application "System Events"
        tell process "Terminal"
            keystroke return
        end tell
    end tell
end tell
APPLESCRIPT
)
RC1=$?

sleep 3

# 第二次：送 "繼續\n"
ERR2=$(osascript 2>&1 >/dev/null << 'APPLESCRIPT'
tell application "Terminal"
    tell application "System Events"
        tell process "Terminal"
            keystroke "繼續"
            keystroke return
        end tell
    end tell
end tell
APPLESCRIPT
)
RC2=$?

# ── 5. 判斷成敗 ──
if [ "$RC1" -eq 0 ] && [ "$RC2" -eq 0 ] && [ -z "$ERR1" ] && [ -z "$ERR2" ]; then
    echo "$(timestamp) [watchdog] ✅ 已送出繼續指令" >> "$LOG"
    state_set "fail_count" "0"
    exit 0
fi

# ── 6. 失敗處理：去重 + 計數 + HEARTBEAT 推播 ──
FAIL_MSG="${ERR1}${ERR2}"
# 偵測權限錯誤特徵
if echo "$FAIL_MSG" | grep -qE '不允許|not allowed|1002|errAEEventNotPermitted'; then
    REASON="osascript 權限被拒，請去『系統設定 → 隱私權與安全性 → 輔助使用』把 Terminal 加入"
else
    REASON="osascript 失敗（rc1=$RC1 rc2=$RC2）：$(echo "$FAIL_MSG" | head -1)"
fi

# 失敗計數 +1
FAIL_COUNT=$(state_get "fail_count")
FAIL_COUNT=$((${FAIL_COUNT:-0} + 1))
state_set "fail_count" "$FAIL_COUNT"

# 去重：同一原因 24 小時內只寫一次 log
LAST_LOG_TS=$(state_get "last_fail_log_ts")
LAST_LOG_REASON=$(state_get "last_fail_log_reason")
SHOULD_LOG=1
if [ -n "$LAST_LOG_TS" ] && [ "$LAST_LOG_REASON" = "$REASON" ]; then
    AGE=$((NOW - LAST_LOG_TS))
    if [ "$AGE" -lt "$DEDUP_WINDOW" ]; then
        SHOULD_LOG=0
    fi
fi

if [ "$SHOULD_LOG" -eq 1 ]; then
    echo "$(timestamp) [watchdog] ❌ ${REASON}（連續失敗 ${FAIL_COUNT} 次）" >> "$LOG"
    state_set "last_fail_log_ts" "$NOW"
    state_set "last_fail_log_reason" "$REASON"
fi

# ── 7. 連續失敗達門檻 → 寫入 HEARTBEAT.md ──
if [ "$FAIL_COUNT" -ge "$HEARTBEAT_FAIL_THRESHOLD" ] && [ -f "$HEARTBEAT" ]; then
    HB_LAST_TS=$(state_get "last_heartbeat_ts")
    HB_AGE=$((NOW - ${HB_LAST_TS:-0}))
    # HEARTBEAT 也走 24h 去重，避免灌爆
    if [ -z "$HB_LAST_TS" ] || [ "$HB_AGE" -ge "$DEDUP_WINDOW" ]; then
        DATE_STR=$(date '+%Y-%m-%d %H:%M')
        BLOCK="## 🚨 watchdog 連續失敗 ${FAIL_COUNT} 次（${DATE_STR}）
- 原因：${REASON}
- 影響：終端機卡住已無法自動恢復，請教練處理
- 修復：系統設定 → 隱私權與安全性 → 輔助使用 → 把 Terminal 加入並打勾

"
        # 把告警插到檔案最前面（最新優先）
        TMP=$(mktemp)
        printf '%s' "$BLOCK" > "$TMP"
        cat "$HEARTBEAT" >> "$TMP"
        mv "$TMP" "$HEARTBEAT"
        state_set "last_heartbeat_ts" "$NOW"
    fi
fi

exit 1
