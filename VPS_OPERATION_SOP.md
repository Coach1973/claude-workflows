# VPS 操作安全 SOP
> 任何人（人類或 AI）要動 VPS 之前，必須逐條確認。沒過完這份清單，不准動手。

---

## 🔴 動手前強制檢查（缺一不可）

### 1. 確認 volume mount 存在
```bash
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 \
  "docker inspect openclaw --format='Binds:{{json .HostConfig.Binds}}'"
```
✅ 通過條件：看到 `openclaw_data:/home/node`
❌ 未通過：禁止任何重建操作，先補 volume mount

### 2. 備份關鍵資料
```bash
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 "
  BACKUP=/root/openclaw/backup/$(date +%Y%m%d_%H%M)
  mkdir -p \$BACKUP
  docker cp openclaw:/home/node/.openclaw/openclaw.json \$BACKUP/
  docker cp openclaw:/home/node/.openclaw/credentials \$BACKUP/
  docker cp openclaw:/home/node/.openclaw/agents/main/agent/auth-profiles.json \$BACKUP/
  docker cp openclaw:/home/node/.openclaw/devices \$BACKUP/
  echo \"備份完成：\$BACKUP\"
  ls \$BACKUP
"
```
✅ 通過條件：看到 openclaw.json、credentials/、auth-profiles.json、devices/

### 3. 記錄目前容器完整啟動參數
```bash
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 \
  "docker inspect openclaw --format='Image:{{.Config.Image}} Restart:{{.HostConfig.RestartPolicy.Name}} Ports:{{json .HostConfig.PortBindings}} Binds:{{json .HostConfig.Binds}} Env:{{json .Config.Env}}'"
```
✅ 通過條件：把輸出完整複製存下來，重建時照抄

---

## 🟡 容器重建標準指令（唯一正確版本）

```bash
# 停止並移除舊容器（資料在 volume，不會丟）
docker stop openclaw && docker rm openclaw

# 用正確參數重建（--volumes-from 或 -v 必須帶）
docker run -d \
  --name openclaw \
  --restart unless-stopped \
  -p 18789:18789 \
  -v openclaw_data:/home/node \
  ghcr.io/openclaw/openclaw:latest
```

⚠️ 禁止省略 `-v openclaw_data:/home/node`，省略 = 資料全失

---

## 🟡 重建後必做還原清單

重建完成後，依序確認以下項目：

| 項目 | 確認指令 | 通過條件 |
|------|---------|---------|
| Gateway 正常 | `curl -s http://localhost:18789/` | 回傳 HTML |
| Telegram 用戶授權 | `docker exec openclaw cat /home/node/.openclaw/credentials/telegram-default-allowFrom.json` | 顯示 allowFrom 清單 |
| API Key | `docker exec openclaw cat /home/node/.openclaw/agents/main/agent/auth-profiles.json` | 顯示 version:1, profiles |
| 設備配對 | `docker exec openclaw cat /home/node/.openclaw/devices/paired.json` | 有設備資料 |
| Telegram 實測 | 直接發訊息給小龍蝦 | 正常回覆 |

---

## 🟢 對話歷史備份（每日自動執行）

```bash
# 加入 VPS host 的 crontab（每天凌晨 2 點備份）
0 2 * * * tar -czf /root/openclaw/backup/sessions-$(date +\%Y\%m\%d).tar.gz \
  /root/openclaw/data/agents/main/sessions/ 2>/dev/null

# 保留最近 30 天
0 3 * * * find /root/openclaw/backup/sessions-*.tar.gz -mtime +30 -delete 2>/dev/null
```

---

## 🔵 版本升級 SOP

1. 先跑「動手前強制檢查」全部通過
2. 確認新映像的 gateway 版本：
   ```bash
   docker run --rm ghcr.io/openclaw/openclaw:latest \
     cat /app/package.json | python3 -c 'import sys,json; d=json.load(sys.stdin); print(d["version"])'
   ```
3. 確認版本符合預期後，才執行容器重建標準指令
4. 重建後跑「重建後必做還原清單」全部打勾

---

## 🚫 絕對禁止事項

- ❌ 省略 volume mount 重建容器
- ❌ 沒有備份就直接重建
- ❌ `docker restart` 之後不確認 Telegram 是否正常
- ❌ 任何「應該沒問題」的猜測——一定要實際測試才算完成

---

## 緊急救援快速指令

```bash
# 小龍蝦不回應時，30 秒確認問題在哪
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 "
  echo '=== 容器狀態 ===' && docker inspect openclaw --format='{{.State.Status}}'
  echo '=== Port ===' && curl -s --connect-timeout 3 http://localhost:18789/ | head -1
  echo '=== 最後10行 log ===' && docker logs openclaw --tail=10
  echo '=== Telegram 授權 ===' && docker exec openclaw cat /home/node/.openclaw/credentials/telegram-default-allowFrom.json | python3 -c 'import sys,json; d=json.load(sys.stdin); print(len(d[\"allowFrom\"]), \"個用戶\")'
"
```

---

*最後更新：2026-05-08 | 血淚來源：VPS 重建事故 commit 7f9dc712*
