# Hermes 任務：三機 Bot 跨進程互通設定

> 建立時間：2026-04-24
> 目標：讓 1號機、2號機、3號機在 Telegram 群組 -1003877502911 裡能互相觸發回應

---

## 背景說明

三台機器人各跑獨立 gateway 進程：
- 1號機：port 18789，`~/.openclaw/`，bot: @openclaw_macbook4_bot
- 2號機：port 18793，`~/.openclaw-peipei/`，bot: @CoachWu_openclaw_bot
- 3號機：port 18790，`~/.openclaw-kong/`，bot: @coachwu_lenovo_bot

relay token: `relay-secret-2026`
relay 路徑（各機 openclaw.json 內）：`/relay/bot1`, `/relay/bot2`, `/relay/bot3`

目前問題：`sessions_send` 只在同一 gateway 進程內有效，無法跨機呼叫。

---

## 任務步驟

### Step 1：找出 relay endpoint 正確格式

```bash
# 讀 openclaw source 找 relay route handler
grep -r "relay" /opt/homebrew/lib/node_modules/openclaw/dist/ --include="*.js" -l 2>/dev/null

# 找路由定義
grep -r "app\.\(post\|get\|use\)" /opt/homebrew/lib/node_modules/openclaw/dist/*.js 2>/dev/null | grep -i relay | head -20

# 或直接測試各種 payload
curl -v -X POST http://localhost:18793/relay/bot2 \
  -H "Authorization: Bearer relay-secret-2026" \
  -H "Content-Type: application/json" \
  -d '{"text":"test","chatId":"-1003877502911"}' 2>&1

curl -v -X POST http://localhost:18793/relay/bot2 \
  -H "Authorization: Bearer relay-secret-2026" \
  -H "Content-Type: application/json" \
  -d '{"message":{"text":"test from bot1"},"chatId":"-1003877502911"}' 2>&1
```

記錄成功的 payload 格式。

### Step 2：移除 allowFrom 限制（讓 bot 可以觸發彼此）

編輯 `/Users/bymyway/.openclaw-peipei/openclaw.json`：
```json
"groups": {
  "-1003877502911": {
    "requireMention": true
  }
}
```
（移除 `"allowFrom": ["6124913915"]`，讓任何人包含其他 bot 都可觸發）

同樣編輯 `/Users/bymyway/.openclaw-kong/openclaw.json`。

重啟 2號機和3號機：
```bash
launchctl unload ~/Library/LaunchAgents/ai.openclaw.peipei.plist && launchctl load ~/Library/LaunchAgents/ai.openclaw.peipei.plist
launchctl unload ~/Library/LaunchAgents/ai.openclaw.kong.plist && launchctl load ~/Library/LaunchAgents/ai.openclaw.kong.plist
```

### Step 3：在 workspace 建立跨機呼叫腳本

建立 `/Users/bymyway/.openclaw/workspace/scripts/call_bot.sh`：

```bash
#!/bin/bash
# 呼叫指定 bot 的 relay endpoint，觸發它在群組回應
# 用法: ./call_bot.sh <bot_number> "<message>"
# 例如: ./call_bot.sh 2 "2號機，請說明目前任務狀態"

BOT=$1
MSG=$2
TOKEN="relay-secret-2026"
GROUP_ID="-1003877502911"

case $BOT in
  1) PORT=18789; PATH_="/relay/bot1" ;;
  2) PORT=18793; PATH_="/relay/bot2" ;;
  3) PORT=18790; PATH_="/relay/bot3" ;;
  *) echo "未知 bot 號碼"; exit 1 ;;
esac

# 根據 Step 1 找到的正確格式填入
curl -s -X POST "http://localhost:${PORT}${PATH_}" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{\"text\":\"${MSG}\",\"chatId\":\"${GROUP_ID}\"}"
```

```bash
chmod +x /Users/bymyway/.openclaw/workspace/scripts/call_bot.sh
```

### Step 4：在 1號機 SOUL.md 補入呼叫指令知識

在 `/Users/bymyway/.openclaw/workspace/SOUL.md` 的「夥伴通訊系統」段落追加：

```markdown
### 主動呼叫夥伴（跨機觸發）

當需要讓 2號機或 3號機回應某個問題，執行：
```bash
bash /Users/bymyway/.openclaw/workspace/scripts/call_bot.sh 2 "你好，請回答XXX"
bash /Users/bymyway/.openclaw/workspace/scripts/call_bot.sh 3 "你好，請回答XXX"
```
```

### Step 5：測試

1. 在 1號機對話中說：「呼叫 2號機，請它自我介紹」
2. 觀察 2號機是否在 Telegram 群組發出回應
3. 確認 BOT_MESSAGES.md 有記錄

### Step 6：Git commit + 回報

```bash
cd /Users/bymyway/.openclaw/workspace
git add -A
git commit -m "feat: 三機 bot 跨進程互通設定完成（relay + call_bot.sh）"
git push origin main
```

完成後通報 Telegram Chat ID 6124913915，回報 commit hash。

---

## 注意事項

- Step 1 是關鍵：必須先找到正確的 relay payload 格式，其他步驟才有意義
- 若 relay endpoint 不支援直接 HTTP 觸發，改用 Telegram Bot API 發訊息到群組（1號機 call Bot API → 群組出現訊息 → 2號機的 mention hook 觸發）
- 不要動到 PROMISES.md，那是克勞德助教管的
