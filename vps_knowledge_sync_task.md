# vps_knowledge_sync_task.md — VPS 智慧血肉同步任務
> 由 Claude 助教產出（2026-04-19）
> 終端機助教：請讀完後自己執行，遇到錯誤自己診斷修正，完成後回報結果。

---

## 任務說明

把 Mac 端的實戰案例庫同步到 VPS，並更新 VPS SOUL.md，讓 VPS 小龍蝦在回答「具體怎麼做」時知道去讀案例庫。

---

## Step 1：確認來源檔案存在

```bash
ls /Users/bymyway/.openclaw/workspace/seabiscuit_case_studies.md
echo "✅ 來源檔案確認"
```

---

## Step 2：同步案例庫到 VPS

```bash
sshpass -p '9kdxvQN2' scp \
  /Users/bymyway/.openclaw/workspace/seabiscuit_case_studies.md \
  root@43.245.60.200:/root/.openclaw/workspace/seabiscuit_case_studies.md

echo "✅ seabiscuit_case_studies.md 已同步到 VPS"
```

---

## Step 3：確認 VPS SOUL.md 路徑

```bash
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 \
  "find /root -name 'SOUL.md' 2>/dev/null"
```

記下路徑，以下步驟用 `/root/.openclaw/workspace/SOUL.md`（若不同請自行替換）。

---

## Step 4：在 VPS SOUL.md 末尾追加案例庫讀取鐵律

```bash
cat << 'EOF' | sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 \
  "cat >> /root/.openclaw/workspace/SOUL.md"

## 📚 【實戰案例庫強制讀取鐵律】
當用戶詢問以下任何類型的問題時，**必須先執行 `read /root/.openclaw/workspace/seabiscuit_case_studies.md`**，再用裡面的真實案例回答：
- 「實戰怎麼做」、「具體應用」、「舉個例子」
- 「這個守則在生活/工作中怎麼用」
- 「有沒有真實案例」、「教練有沒有遇過」

**絕對禁止**在未讀取案例庫的情況下自行編造案例。
若案例庫中無對應案例，回答：「這個案例教練還沒有整理進來，建議您直接向教練請教。」
EOF

echo "✅ 案例庫讀取鐵律已追加到 VPS SOUL.md"
```

---

## Step 5：設定每日自動同步 Cron Job（Mac 端）

讓 Mac 每天早上 8 點自動把最新案例庫推送到 VPS：

```bash
node -e "
const fs = require('fs');
const { randomUUID } = require('crypto');
const p = '/Users/bymyway/.openclaw/cron/jobs.json';
const cfg = JSON.parse(fs.readFileSync(p, 'utf-8'));

if (cfg.jobs.find(j => j.name.includes('案例庫同步'))) {
  console.log('ℹ️  Job 已存在，跳過');
  process.exit(0);
}

cfg.jobs.push({
  id: randomUUID(),
  agentId: 'main',
  sessionKey: 'agent:main:telegram:direct:6124913915',
  name: '每日案例庫同步到 VPS',
  enabled: true,
  createdAtMs: Date.now(),
  updatedAtMs: Date.now(),
  schedule: { kind: 'cron', expr: '0 8 * * *', tz: 'Asia/Taipei' },
  sessionTarget: 'isolated',
  wakeMode: 'now',
  payload: {
    kind: 'agentTurn',
    message: '請安靜執行：sshpass -p \'9kdxvQN2\' scp /Users/bymyway/.openclaw/workspace/seabiscuit_case_studies.md root@43.245.60.200:/root/.openclaw/workspace/seabiscuit_case_studies.md && echo 同步完成',
    timeoutSeconds: 60
  },
  delivery: { mode: 'none' },
  state: { nextRunAtMs: Date.now() + 86400000 }
});

fs.writeFileSync(p, JSON.stringify(cfg, null, 2));
console.log('✅ 每日案例庫同步 Job 已新增');
"
```

---

## Step 6：驗證

```bash
# 確認 VPS 上的案例庫存在
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 \
  "ls -la /root/.openclaw/workspace/seabiscuit_case_studies.md && head -5 /root/.openclaw/workspace/seabiscuit_case_studies.md"

# 確認 VPS SOUL.md 末尾有案例庫鐵律
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 \
  "tail -15 /root/.openclaw/workspace/SOUL.md"

# 確認 Mac 端 cron job
node -e "
const cfg = require('/Users/bymyway/.openclaw/cron/jobs.json');
const j = cfg.jobs.find(x => x.name.includes('案例庫同步'));
console.log('同步 Job:', j ? '✅ 存在' : '❌ 不存在');
"
```

---

## 錯誤處理

遇到錯誤寫入 `/Users/bymyway/Desktop/vps_knowledge_sync_error.txt`，自己診斷修正，不需要通知教練。

---

## 回報格式

```
✅ VPS 智慧血肉同步完成

- seabiscuit_case_studies.md 同步到 VPS：✅
- VPS SOUL.md 案例庫鐵律：✅
- Mac 每日自動同步 Job：✅（每天早上 8:00）

備註：案例庫目前是範本格式，等教練補充實際案例後，
再次執行 Step 2 同步即可更新 VPS。
```
