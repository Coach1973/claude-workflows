# Hermes 任務：修復 Relay Cron 發送失敗問題

> 建立：2026-04-24
> 問題：peipei / kong 的 relay cron job `lastDeliveryStatus: "not-delivered"`，回覆生成但沒發到群組

---

## 根本原因

`delivery` 設定缺少 `chatId`，OpenClaw 不知道要把 cron 回覆發到哪個群組。

---

## Step 1：修改 peipei 的 relay cron delivery

編輯 `/Users/bymyway/.openclaw-peipei/cron/jobs.json`：

找到 `id: "relay-poll-2a1b3c4d-5e6f-7890-abcd-ef1234567890"` 的那個 job，
把 `delivery` 區塊改成：

```json
"delivery": {
    "mode": "announce",
    "channel": "telegram",
    "chatId": "-1003877502911",
    "bestEffort": true
}
```

用 python3 執行（避免手動編輯出錯）：

```bash
python3 << 'EOF'
import json

path = '/Users/bymyway/.openclaw-peipei/cron/jobs.json'
d = json.load(open(path))
for job in d.get('jobs', []):
    if 'Relay' in job.get('name', ''):
        job['delivery'] = {
            "mode": "announce",
            "channel": "telegram",
            "chatId": "-1003877502911",
            "bestEffort": True
        }
        print(f"已修改: {job['name']}")
with open(path, 'w') as f:
    json.dump(d, f, indent=2, ensure_ascii=False)
print("peipei cron 寫入完成")
EOF
```

## Step 2：同樣修改 kong 的 relay cron delivery

```bash
python3 << 'EOF'
import json

path = '/Users/bymyway/.openclaw-kong/cron/jobs.json'
d = json.load(open(path))
for job in d.get('jobs', []):
    if 'Relay' in job.get('name', ''):
        job['delivery'] = {
            "mode": "announce",
            "channel": "telegram",
            "chatId": "-1003877502911",
            "bestEffort": True
        }
        print(f"已修改: {job['name']}")
with open(path, 'w') as f:
    json.dump(d, f, indent=2, ensure_ascii=False)
print("kong cron 寫入完成")
EOF
```

## Step 3：重啟 peipei 和 kong

```bash
launchctl unload ~/Library/LaunchAgents/ai.openclaw.peipei.plist && sleep 1 && launchctl load ~/Library/LaunchAgents/ai.openclaw.peipei.plist
launchctl unload ~/Library/LaunchAgents/ai.openclaw.kong.plist && sleep 1 && launchctl load ~/Library/LaunchAgents/ai.openclaw.kong.plist
sleep 10
lsof -nP -i :18793 | grep LISTEN && echo "peipei ✅" || echo "peipei ❌"
lsof -nP -i :18790 | grep LISTEN && echo "kong ✅" || echo "kong ❌"
```

## Step 4：寫一條測試任務到 BOT_RELAY.json

```bash
python3 << 'EOF'
import json, time

path = '/Users/bymyway/.openclaw/workspace/shared-context/BOT_RELAY.json'
d = json.load(open(path))
d['messages'].append({
    "id": "test-001",
    "bot": "2",
    "from": "1號機學長",
    "content": "學妹測試：請在群組回覆「relay 通訊測試成功」"
})
d['ts'] = time.strftime('%Y-%m-%dT%H:%M:%S.000Z', time.gmtime())
with open(path, 'w') as f:
    json.dump(d, f, indent=2, ensure_ascii=False)
print("測試任務已寫入")
EOF
```

等待約 1 分鐘，觀察 Telegram 頂級特助分工群是否出現 2號機的回覆。

## Step 5：如果 Step 4 失敗，改用備案（修改 payload）

如果加 chatId 後還是不行，改修 payload message，在結尾加：

```
你必須使用 sendMessage 工具，把你的回覆發送到 Telegram 群組 chat ID: -1003877502911。不能只輸出文字，必須真正呼叫工具發送。
```

用 python3 更新 payload：
```bash
python3 << 'EOF'
import json

for path in ['/Users/bymyway/.openclaw-peipei/cron/jobs.json', '/Users/bymyway/.openclaw-kong/cron/jobs.json']:
    d = json.load(open(path))
    for job in d.get('jobs', []):
        if 'Relay' in job.get('name', ''):
            msg = job['payload']['message']
            if '你必須使用 sendMessage' not in msg:
                job['payload']['message'] = msg + '\n\n你必須使用 sendMessage 工具，把你的回覆發送到 Telegram 群組 chat ID: -1003877502911。不能只輸出文字，必須真正呼叫工具發送。'
                print(f"已更新 payload: {job['name']} in {path}")
    with open(path, 'w') as f:
        json.dump(d, f, indent=2, ensure_ascii=False)
EOF
```

重啟 peipei 和 kong，再次測試。

## Step 6：Git commit + 回報

```bash
cd /Users/bymyway/.openclaw/workspace
git add -A
git commit -m "fix: relay cron delivery 加入 chatId，修復 not-delivered 問題"
git push origin main
```

完成後通報 Telegram Chat ID 6124913915，回報 commit hash 和測試結果（成功/失敗）。
