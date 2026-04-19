# vps_memory_distill_deploy.md — 記憶蒸餾系統部署到 VPS
> 本機 Mac 已安裝完畢，本任務是把同一套系統部署到 VPS

---

## 執行前確認

```bash
# 確認本機的 handler.js 存在（要複製過去的來源）
ls /Users/bymyway/.openclaw/hooks/client-memory/handler.js
```

---

## Step 1：在 VPS 建立 hook 目錄並上傳 handler.js

```bash
# 建立目錄
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 \
  "mkdir -p /root/.openclaw/hooks/client-memory"

# 上傳 handler.js
sshpass -p '9kdxvQN2' scp \
  /Users/bymyway/.openclaw/hooks/client-memory/handler.js \
  root@43.245.60.200:/root/.openclaw/hooks/client-memory/handler.js

# 上傳 HOOK.md
sshpass -p '9kdxvQN2' scp \
  /Users/bymyway/.openclaw/hooks/client-memory/HOOK.md \
  root@43.245.60.200:/root/.openclaw/hooks/client-memory/HOOK.md

echo "✅ hook 檔案上傳完成"
```

---

## Step 2：在 VPS 的 openclaw.json 啟用 client-memory hook

```bash
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 "node -e \"
const fs = require('fs');
const p = '/root/.openclaw/openclaw.json';
const cfg = JSON.parse(fs.readFileSync(p, 'utf-8'));
if (!cfg.hooks) cfg.hooks = { internal: { enabled: true, entries: {} } };
if (!cfg.hooks.internal) cfg.hooks.internal = { enabled: true, entries: {} };
if (!cfg.hooks.internal.entries) cfg.hooks.internal.entries = {};
cfg.hooks.internal.entries['client-memory'] = { enabled: true };
fs.writeFileSync(p, JSON.stringify(cfg, null, 2));
console.log('✅ client-memory hook 已在 VPS 啟用');
\""
```

---

## Step 3：在 VPS 建立 CLIENT_PROFILE.md

```bash
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 \
  "mkdir -p /root/.openclaw/workspace && cat > /root/.openclaw/workspace/CLIENT_PROFILE.md << 'EOF'
<!-- DISTILL_CHECKPOINT: 1970-01-01T00:00:00.000Z -->
# CLIENT PROFILE
> 最後更新：2026-04-19
> 說明：此檔案由每日蒸餾 Cron Job 自動維護，記錄用戶的長期背景資訊。

## 基本資訊
- 服務對象：大樹教練的 VPS 頂級特助體驗用戶
- 平台：Telegram @coach_bymyway_bot

## 對話風格
- 語氣：頂級特助，積極主動，不廢話
- 海餅乾守則：嚴格依照 SOUL.md 鐵律引用，絕不自行發想
EOF
echo '✅ CLIENT_PROFILE.md 建立完成'"
```

---

## Step 4：在 VPS 建立增量蒸餾腳本

```bash
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 \
  "mkdir -p /root/.openclaw/workspace/scripts"

# 上傳本機的蒸餾腳本
sshpass -p '9kdxvQN2' scp \
  /Users/bymyway/.openclaw/workspace/scripts/distill_incremental.js \
  root@43.245.60.200:/root/.openclaw/workspace/scripts/distill_incremental.js

echo "✅ 蒸餾腳本上傳完成"
```

---

## Step 5：在 VPS 新增每 2 小時蒸餾 Cron Job

```bash
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 "node -e \"
const fs = require('fs');
const { randomUUID } = require('crypto');
const p = '/root/.openclaw/cron/jobs.json';
if (!fs.existsSync(p)) {
  fs.mkdirSync('/root/.openclaw/cron', { recursive: true });
  fs.writeFileSync(p, JSON.stringify({ version: 1, jobs: [] }, null, 2));
}
const cfg = JSON.parse(fs.readFileSync(p, 'utf-8'));

// 避免重複新增
if (cfg.jobs.find(j => j.name.includes('每2小時增量'))) {
  console.log('ℹ️  Job 已存在，跳過');
  process.exit(0);
}

cfg.jobs.push({
  id: randomUUID(),
  agentId: 'main',
  name: '每2小時增量記憶蒸餾',
  enabled: true,
  createdAtMs: Date.now(),
  updatedAtMs: Date.now(),
  schedule: { kind: 'cron', expr: '0 */2 * * *', tz: 'Asia/Taipei' },
  sessionTarget: 'isolated',
  wakeMode: 'now',
  payload: {
    kind: 'agentTurn',
    message: '你現在是「增量記憶蒸餾助理」，請安靜執行：\n1. 執行 node /root/.openclaw/workspace/scripts/distill_incremental.js\n2. 如果輸出是 NO_NEW_ENTRIES，任務結束。\n3. 有內容的話，提取有長期價值的資訊，合併更新 /root/.openclaw/workspace/CLIENT_PROFILE.md（保留 DISTILL_CHECKPOINT 標記）。\n不需要通知用戶。',
    timeoutSeconds: 300
  },
  delivery: { mode: 'none' },
  state: { nextRunAtMs: Date.now() + 7200000 }
});
fs.writeFileSync(p, JSON.stringify(cfg, null, 2));
console.log('✅ VPS 每2小時增量蒸餾 Job 已新增');
\""
```

---

## Step 6：驗證全部安裝完成

```bash
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 "
echo '=== hook 檔案 ===' && ls /root/.openclaw/hooks/client-memory/
echo '=== CLIENT_PROFILE.md ===' && head -3 /root/.openclaw/workspace/CLIENT_PROFILE.md
echo '=== 蒸餾腳本 ===' && ls /root/.openclaw/workspace/scripts/distill_incremental.js
echo '=== openclaw.json hook 設定 ===' && node -e \"const c=require('/root/.openclaw/openclaw.json'); console.log('client-memory:', c.hooks?.internal?.entries?.['client-memory']?.enabled)\"
echo '=== cron job ===' && node -e \"const c=require('/root/.openclaw/cron/jobs.json'); const j=c.jobs.find(x=>x.name.includes('增量')); console.log(j ? '✅ 存在' : '❌ 不存在')\"
"
```

---

## 錯誤處理

遇到錯誤寫入 `/Users/bymyway/Desktop/vps_deploy_error.txt`，不需要通知教練。

---

## 回報格式

```
✅ VPS 記憶蒸餾系統部署完成

- client-memory hook：✅
- CLIENT_PROFILE.md：✅
- 增量蒸餾腳本：✅
- 每2小時蒸餾 Cron Job：✅

VPS 現在跟 Mac 本機有同樣的記憶蒸餾能力。
```
