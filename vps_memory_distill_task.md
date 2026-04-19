# vps_memory_distill_task.md — 記憶蒸餾系統升級任務
> 由 Claude 助教產出（2026-04-19）
> 終端機助教：請讀完後自己執行，遇到錯誤自己診斷修正，完成後回報結果。

---

## 執行前必讀（建立背景）

```
/Users/bymyway/.openclaw/workspace/HEARTBEAT.md
/Users/bymyway/Desktop/HANDOFF_VPS_Memory.md
```

讀完後你會知道：
- 第一版蒸餾架構已設計完成（client-memory hook + 每晚 23:30 cron job）
- 本任務是升級：解決「日誌太大讀不完」和「跨午夜延遲」兩個風險

---

## 任務說明

將蒸餾機制從「每日一次、讀全份日誌」升級為「每 2 小時一次、只讀新增部分（增量蒸餾）」。

---

## Step 1：確認第一版是否已安裝

```bash
# 確認 client-memory hook 存在
ls /Users/bymyway/.openclaw/hooks/client-memory/handler.js

# 確認 CLIENT_PROFILE.md 存在
ls /Users/bymyway/.openclaw/workspace/CLIENT_PROFILE.md

# 確認原本的每晚蒸餾 cron job 是否存在
node -e "
const cfg = require('/Users/bymyway/.openclaw/cron/jobs.json');
const job = cfg.jobs.find(j => j.name.includes('記憶蒸餾'));
console.log('舊版蒸餾 job:', job ? '✅ 存在，ID=' + job.id : '❌ 不存在');
"
```

如果第一版尚未安裝，先執行 HANDOFF_VPS_Memory.md 的完整步驟，再回來繼續。

---

## Step 2：更新 CLIENT_PROFILE.md，加入蒸餾時間戳記

在 CLIENT_PROFILE.md 的最頂部加入蒸餾進度追蹤區塊：

```bash
node -e "
const fs = require('fs');
const p = '/Users/bymyway/.openclaw/workspace/CLIENT_PROFILE.md';
const existing = fs.readFileSync(p, 'utf-8');

// 如果已經有時間戳記區塊就不重複加
if (existing.includes('DISTILL_CHECKPOINT')) {
  console.log('✅ 時間戳記區塊已存在，跳過');
  process.exit(0);
}

const checkpoint = \`<!-- DISTILL_CHECKPOINT: 1970-01-01T00:00:00.000Z -->
\`;
fs.writeFileSync(p, checkpoint + existing);
console.log('✅ 已加入蒸餾時間戳記區塊');
"
```

---

## Step 3：建立增量蒸餾腳本

```bash
cat > /Users/bymyway/.openclaw/workspace/scripts/distill_incremental.js << 'SCRIPT'
#!/usr/bin/env node
/**
 * 增量記憶蒸餾腳本
 * 只讀取上次蒸餾後的新對話，避免重複處理整份日誌
 */

const fs = require('fs');
const path = require('path');
const os = require('os');

const WORKSPACE = path.join(os.homedir(), '.openclaw', 'workspace');
const PROFILE_PATH = path.join(WORKSPACE, 'CLIENT_PROFILE.md');

// 讀取上次蒸餾時間
function getLastDistillTime() {
  try {
    const content = fs.readFileSync(PROFILE_PATH, 'utf-8');
    const match = content.match(/<!-- DISTILL_CHECKPOINT: (.+?) -->/);
    if (match) return new Date(match[1]);
  } catch (e) {}
  return new Date(0); // 從未蒸餾過，從頭開始
}

// 更新蒸餾時間戳記
function updateCheckpoint(time) {
  const content = fs.readFileSync(PROFILE_PATH, 'utf-8');
  const updated = content.replace(
    /<!-- DISTILL_CHECKPOINT: .+? -->/,
    \`<!-- DISTILL_CHECKPOINT: \${time.toISOString()} -->\`
  );
  fs.writeFileSync(PROFILE_PATH, updated);
}

// 取得今天的 daily log 路徑（台灣時區）
function getTodayLogPath() {
  const now = new Date();
  const tz = 'Asia/Taipei';
  const dateStr = now.toLocaleDateString('zh-TW', { timeZone: tz })
    .replace(/\//g, '-')
    .split('-').map(s => s.padStart(2, '0')).join('-');
  // 格式：2026-04-19
  const formatted = new Date(now.toLocaleString('en-US', { timeZone: tz }));
  const y = formatted.getFullYear();
  const m = String(formatted.getMonth() + 1).padStart(2, '0');
  const d = String(formatted.getDate()).padStart(2, '0');
  return path.join(WORKSPACE, \`daily_\${y}-\${m}-\${d}.md\`);
}

// 從 daily log 中截取指定時間點之後的段落
function extractNewEntries(logPath, since) {
  if (!fs.existsSync(logPath)) return '';

  const content = fs.readFileSync(logPath, 'utf-8');
  const lines = content.split('\n');
  const result = [];
  let capturing = false;
  const sinceMs = since.getTime();

  for (const line of lines) {
    // 偵測段落標題，例如：## 📨 對話記錄 14:30 或 ## ⚠️ 緊急存檔（Context Overflow 前） 14:30
    const timeMatch = line.match(/##.*?(\d{2}):(\d{2})（/);
    if (timeMatch) {
      const now = new Date();
      const entryTime = new Date(now.getFullYear(), now.getMonth(), now.getDate(),
        parseInt(timeMatch[1]), parseInt(timeMatch[2]));
      capturing = entryTime.getTime() > sinceMs;
    }
    if (capturing) result.push(line);
  }

  return result.join('\n').trim();
}

// 主程式：輸出需要蒸餾的原始文字
const lastDistill = getLastDistillTime();
const logPath = getTodayLogPath();
const newEntries = extractNewEntries(logPath, lastDistill);

if (!newEntries) {
  console.log('NO_NEW_ENTRIES');
  process.exit(0);
}

// 輸出供 agentTurn 使用的提示詞
console.log(\`=== 增量蒸餾原始資料（\${lastDistill.toISOString()} 之後） ===\n\`);
console.log(newEntries);
console.log(\`\n=== 資料結束 ===\`);

// 更新時間戳記
updateCheckpoint(new Date());
console.log(\`\nCHECKPOINT_UPDATED\`);
SCRIPT

chmod +x /Users/bymyway/.openclaw/workspace/scripts/distill_incremental.js
echo "✅ 增量蒸餾腳本已建立"
```

---

## Step 4：停用舊版每晚蒸餾 Job，新增每 2 小時增量蒸餾 Job

```bash
node -e "
const fs = require('fs');
const { randomUUID } = require('crypto');
const p = '/Users/bymyway/.openclaw/cron/jobs.json';
const cfg = JSON.parse(fs.readFileSync(p, 'utf-8'));

// 停用舊版（不刪除，只是 enabled: false）
const oldJob = cfg.jobs.find(j => j.name.includes('記憶蒸餾') && j.schedule.expr === '30 23 * * *');
if (oldJob) {
  oldJob.enabled = false;
  console.log('⏸️  舊版每晚蒸餾 Job 已停用');
} else {
  console.log('ℹ️  找不到舊版 Job，可能尚未安裝');
}

// 新增每 2 小時增量蒸餾 Job
const newJob = {
  id: randomUUID(),
  agentId: 'main',
  sessionKey: 'agent:main:telegram:direct:6124913915',
  name: '每2小時增量記憶蒸餾',
  enabled: true,
  createdAtMs: Date.now(),
  updatedAtMs: Date.now(),
  schedule: {
    kind: 'cron',
    expr: '0 */2 * * *',
    tz: 'Asia/Taipei'
  },
  sessionTarget: 'isolated',
  wakeMode: 'now',
  payload: {
    kind: 'agentTurn',
    message: \`你現在是「增量記憶蒸餾助理」，請安靜執行以下任務，不需要通知教練：

1. 執行以下指令，取得需要蒸餾的新對話片段：
   node /Users/bymyway/.openclaw/workspace/scripts/distill_incremental.js

2. 如果輸出是 NO_NEW_ENTRIES，代表沒有新對話，任務結束。

3. 如果有內容輸出，從「=== 增量蒸餾原始資料 ===」到「=== 資料結束 ===」之間的文字就是需要蒸餾的對話片段。

4. 從這段對話中提取有長期價值的資訊：
   - 新的承諾或待辦事項
   - 重要商業決策或背景
   - 用戶表達的偏好或習慣
   - 需要長期記住的事實

5. 讀取現有的 /Users/bymyway/.openclaw/workspace/CLIENT_PROFILE.md

6. 合併更新：只新增或修改有變化的部分，保留舊資料，更新「最後更新」日期

7. 將更新後的完整內容寫回 CLIENT_PROFILE.md（保留頂部的 DISTILL_CHECKPOINT 標記不動）

任務完成，不需要回覆教練。\`,
    timeoutSeconds: 300
  },
  delivery: {
    mode: 'none'
  },
  state: {
    nextRunAtMs: Date.now() + 7200000
  }
};

cfg.jobs.push(newJob);
fs.writeFileSync(p, JSON.stringify(cfg, null, 2));
console.log('✅ 每2小時增量蒸餾 Job 已新增，ID:', newJob.id);
"
```

---

## Step 5：驗證

```bash
# 確認腳本存在且可執行
node /Users/bymyway/.openclaw/workspace/scripts/distill_incremental.js | head -5

# 確認新 cron job 已新增
node -e "
const cfg = require('/Users/bymyway/.openclaw/cron/jobs.json');
const job = cfg.jobs.find(j => j.name.includes('每2小時增量'));
console.log('新版增量蒸餾 job:', job ? '✅ 存在，下次執行: ' + new Date(job.state.nextRunAtMs).toLocaleString('zh-TW') : '❌ 不存在');
const old = cfg.jobs.find(j => j.name.includes('每日記憶蒸餾'));
console.log('舊版每晚蒸餾 job:', old ? (old.enabled ? '⚠️ 還在啟用中' : '✅ 已停用') : 'ℹ️ 不存在');
"

# 確認 CLIENT_PROFILE.md 有 DISTILL_CHECKPOINT
grep 'DISTILL_CHECKPOINT' /Users/bymyway/.openclaw/workspace/CLIENT_PROFILE.md
```

---

## 錯誤處理

遇到任何錯誤，寫入 `/Users/bymyway/Desktop/vps_memory_distill_error.txt`：

```
[時間] 步驟：Step N
[時間] 錯誤：（完整訊息）
[時間] 指令：（那行指令）
```

寫完後繼續等待，不需要通知教練。

---

## 回報格式

完成後回報：

```
✅ 記憶蒸餾系統升級完成

- 增量蒸餾腳本：✅
- CLIENT_PROFILE.md 加入時間戳記：✅
- 舊版每晚 Job 停用：✅ / ℹ️（原本不存在）
- 新版每2小時 Job：✅（下次執行：XX:XX）

系統現在每2小時自動蒸餾新增對話，不再讀整份日誌。
```
