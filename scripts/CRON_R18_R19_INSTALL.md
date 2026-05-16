# R18 / R19 鐵律對應的系統 cron 註冊紀錄

> 系統 crontab 不在 git repo 內，本檔紀錄當前已註冊的條目，供下場軍師或新機器還原用。

## 目前在 Mac mini 已註冊的兩條 cron

```cron
# R18 鐵律：每 15 分鐘檢查 workspace uncommitted 是否超過 60 分（軍師 2026-05-16 立法）
*/15 * * * * /Users/bymyway/.openclaw/workspace/scripts/checkpoint_audit.sh >> /tmp/checkpoint_audit.log 2>&1

# R19 鐵律：每天 23:50 掃當天 HEARTBEAT.md 純 OK 心跳數（軍師 2026-05-16 立法）
50 23 * * * /Users/bymyway/.openclaw/workspace/scripts/heartbeat_audit.sh >> /tmp/heartbeat_audit.log 2>&1
```

## 還原步驟（新機器 / 換機）

```bash
# 1. 備份現有 crontab
crontab -l > /tmp/crontab.bak.$(date +%Y%m%d_%H%M%S)

# 2. 確認腳本存在
ls -la /Users/bymyway/.openclaw/workspace/scripts/checkpoint_audit.sh
ls -la /Users/bymyway/.openclaw/workspace/scripts/heartbeat_audit.sh

# 3. append 兩條（grep 先確認沒重複）
if ! crontab -l | grep -q "checkpoint_audit.sh"; then
  (crontab -l; echo ""; \
   echo "# R18 鐵律：每 15 分鐘檢查 workspace uncommitted 是否超過 60 分（軍師 2026-05-16 立法）"; \
   echo "*/15 * * * * /Users/bymyway/.openclaw/workspace/scripts/checkpoint_audit.sh >> /tmp/checkpoint_audit.log 2>&1"; \
   echo ""; \
   echo "# R19 鐵律：每天 23:50 掃當天 HEARTBEAT.md 純 OK 心跳數（軍師 2026-05-16 立法）"; \
   echo "50 23 * * * /Users/bymyway/.openclaw/workspace/scripts/heartbeat_audit.sh >> /tmp/heartbeat_audit.log 2>&1") | crontab -
fi

# 4. 驗證
crontab -l | grep -E "checkpoint_audit|heartbeat_audit"
```

## 驗證方法

```bash
# R18 手動跑一次
bash /Users/bymyway/.openclaw/workspace/scripts/checkpoint_audit.sh
tail -5 /Users/bymyway/.openclaw/workspace/logs/checkpoint_audit.log

# R19 手動跑一次
bash /Users/bymyway/.openclaw/workspace/scripts/heartbeat_audit.sh
tail -5 /Users/bymyway/.openclaw/workspace/logs/heartbeat_audit.log
```

## 撤銷（如需）

```bash
crontab -l | grep -v "checkpoint_audit\|heartbeat_audit\|R18 鐵律\|R19 鐵律" | crontab -
```

## 系統 cron log 位置

- `/tmp/checkpoint_audit.log`：每 15 分鐘 cron stdout/stderr
- `/tmp/heartbeat_audit.log`：每天 23:50 cron stdout/stderr
- `workspace/logs/checkpoint_audit.log`：腳本內自寫的 audit 紀錄
- `workspace/logs/heartbeat_audit.log`：同上

---

> **首次註冊**：2026-05-16 11:26（commit 預計 `8817b683` 之後的下一個 commit）
> **註冊人**：軍師（Claude Code CLI Opus 4.7）
> **依據**：CORE_RULES.md R18 / R19、教戰守則內化體檢表「補洞行動 1+2」
