# HANDOFF_VPS_Memory.md — VPS 記憶蒸餾底層架構
> 由 Claude 助教設計（2026-04-19）
> 交給終端機助教實裝

---

## 執行前必讀

先讀這些檔案建立背景，再開始任何操作：
```
/Users/bymyway/.openclaw/workspace/HEARTBEAT.md
/Users/bymyway/.openclaw/workspace/memory/project_vps_day1_fullreport_20260419.md
```

---

## 架構說明（三道防線）

### 第一道防線：物理隔離
→ 已有計畫（MAX01~MAX10），每個用戶一個獨立 OpenClaw 實例，本次不處理。

### 第二道防線：每日記憶蒸餾（本次實裝重點）
- **機制**：OpenClaw Cron Job（`agentTurn` 格式）
- **每晚 23:30**，Agent 自動讀取當天 `daily_YYYY-MM-DD.md`，提煉重要資訊，寫入 `CLIENT_PROFILE.md`
- **Hook**：`client-memory`，每次對話啟動時自動把 `CLIENT_PROFILE.md` 注入系統 prompt

### 第三道防線：RAG 精準提取
→ 進階功能，本次暫不實裝，留待之後擴充。

---

## 實裝步驟

### Step 1：建立 `client-memory` Hook（本機 Mac 先測試）

建立目錄與三個檔案：

```bash
mkdir -p /Users/bymyway/.openclaw/hooks/client-memory
```

**檔案一：HOOK.md**

```bash
cat > /Users/bymyway/.openclaw/hooks/client-memory/HOOK.md << 'EOF'
---
name: client-memory
description: "在對話啟動時自動注入 CLIENT_PROFILE.md，讓 Agent 記住用戶背景"
metadata: {"openclaw":{"emoji":"🧠","events":["agent:bootstrap"]}}
---

# Client Memory Hook

每次 Agent 啟動時，自動把 CLIENT_PROFILE.md 的內容注入系統記憶，讓 Agent 無論對話多久都記得用戶是誰。

## 啟用方式

```bash
openclaw hooks enable client-memory
```
EOF
```

**檔案二：handler.js**

```bash
cat > /Users/bymyway/.openclaw/hooks/client-memory/handler.js << 'EOF'
"use strict";

const fs = require('fs');
const path = require('path');

// 從 hook 所在位置推導 workspace 路徑
// handler.js 在 .openclaw/hooks/client-memory/ 下
// ../../ 回到 .openclaw/，再加 workspace/
const OPENCLAW_DIR = path.resolve(__dirname, '../../');
const PROFILE_PATH = path.join(OPENCLAW_DIR, 'workspace', 'CLIENT_PROFILE.md');

const handler = async (event) => {
  if (!event || typeof event !== 'object') return;
  if (event.type !== 'agent' || event.action !== 'bootstrap') return;
  if (!event.context || typeof event.context !== 'object') return;

  try {
    if (!fs.existsSync(PROFILE_PATH)) return;
    const profileContent = fs.readFileSync(PROFILE_PATH, 'utf-8');
    if (!profileContent.trim()) return;

    const block = [
      '---',
      '# 📋 用戶記憶檔案（CLIENT_PROFILE）',
      '> 以下是這位用戶的背景資料，請在整個對話中牢記。',
      '',
      profileContent,
      '---',
    ].join('\n');

    if (!event.context.inject) {
      event.context.inject = [];
    }
    if (Array.isArray(event.context.inject)) {
      event.context.inject.unshift({ role: 'system', content: block });
    }
  } catch (err) {
    // 靜默失敗，不影響正常對話
  }
};

module.exports = handler;
module.exports.default = handler;
EOF
```

**檔案三：handler.ts（型別定義用，不執行）**

```bash
cat > /Users/bymyway/.openclaw/hooks/client-memory/handler.ts << 'EOF'
// TypeScript source — compiled to handler.js above
// See handler.js for the actual implementation
export default async function handler(event: any): Promise<void> {
  // See handler.js
}
EOF
```

### Step 2：啟用 Hook

在 `/Users/bymyway/.openclaw/openclaw.json` 的 `hooks.internal.entries` 區塊新增：

```json
"client-memory": {
  "enabled": true
}
```

用 node 腳本修改（避免手動編輯 JSON 出錯）：

```bash
node -e "
const fs = require('fs');
const p = '/Users/bymyway/.openclaw/openclaw.json';
const cfg = JSON.parse(fs.readFileSync(p, 'utf-8'));
cfg.hooks.internal.entries['client-memory'] = { enabled: true };
fs.writeFileSync(p, JSON.stringify(cfg, null, 2));
console.log('✅ client-memory hook 已啟用');
"
```

### Step 3：建立 CLIENT_PROFILE.md 範本

```bash
cat > /Users/bymyway/.openclaw/workspace/CLIENT_PROFILE.md << 'EOF'
# CLIENT PROFILE
> 最後更新：2026-04-19
> 說明：此檔案由每日蒸餾 Cron Job 自動維護，記錄用戶的長期背景資訊。

## 基本資訊
- 姓名/暱稱：大樹教練
- Telegram ID：6124913915
- 主要身份：海餅乾俱樂部創辦人、BNI 分會教練、AI 賦能商業教練

## 重要商業背景
- 海餅乾俱樂部：2007年創立，2026年5月14日19週年慶
- BNI 分工：管理多個分會（真誠、真愛、真鑫）
- 三助教系統：小龍蝦（VPS/Gemini）、Claude 助教（Mac桌面）、終端機助教（API）

## 偏好與習慣
- 喜歡直接說結論，不喜歡繞圈子
- 技術細節由助教處理，教練只需動嘴
- 偏好繁體中文溝通

## 重要承諾與待辦
- 海餅乾19週年慶策劃（2026-05-14）
- NotebookLM 雙向搬家（進行中）

## 對話風格
- 稱呼：大樹教練
- 語氣：頂級特助，積極主動，不廢話
EOF
```

### Step 4：新增每日蒸餾 Cron Job

用 node 腳本新增到 `cron/jobs.json`：

```bash
node -e "
const fs = require('fs');
const { randomUUID } = require('crypto');
const p = '/Users/bymyway/.openclaw/cron/jobs.json';
const cfg = JSON.parse(fs.readFileSync(p, 'utf-8'));

const newJob = {
  id: randomUUID(),
  agentId: 'main',
  sessionKey: 'agent:main:telegram:direct:6124913915',
  name: '每日記憶蒸餾 — 更新 CLIENT_PROFILE',
  enabled: true,
  createdAtMs: Date.now(),
  updatedAtMs: Date.now(),
  schedule: {
    kind: 'cron',
    expr: '30 23 * * *',
    tz: 'Asia/Taipei'
  },
  sessionTarget: 'isolated',
  wakeMode: 'now',
  payload: {
    kind: 'agentTurn',
    message: \`你現在扮演「記憶蒸餾助理」，請安靜執行以下任務，不需要通知教練：

1. 取得今天日期（台灣時區），找到對應的對話日誌：workspace/daily_\${new Date().toISOString().slice(0,10)}.md
2. 讀取該檔案，從對話中找出以下有長期價值的資訊：
   - 用戶提到的新承諾或待辦事項
   - 新的商業背景或決策
   - 用戶表達的偏好或習慣
   - 需要長期記住的重要事實
3. 讀取現有的 workspace/CLIENT_PROFILE.md
4. 合併更新：只新增或修改有變化的部分，不刪除舊資料，更新「最後更新」日期
5. 將更新後的完整內容寫回 workspace/CLIENT_PROFILE.md
6. 任務完成，不需要回覆教練

注意：如果今天的 daily 檔案不存在，直接結束，不報錯。\`,
    timeoutSeconds: 300
  },
  delivery: {
    mode: 'none'
  },
  state: {
    nextRunAtMs: new Date().setHours(23, 30, 0, 0)
  }
};

cfg.jobs.push(newJob);
fs.writeFileSync(p, JSON.stringify(cfg, null, 2));
console.log('✅ 每日記憶蒸餾 Cron Job 已新增，ID:', newJob.id);
"
```

### Step 5：驗證安裝

```bash
# 確認 hook 檔案存在
ls -la /Users/bymyway/.openclaw/hooks/client-memory/

# 確認 openclaw.json 已更新
node -e "
const cfg = require('/Users/bymyway/.openclaw/openclaw.json');
console.log('client-memory enabled:', cfg.hooks.internal.entries['client-memory']?.enabled);
"

# 確認 cron job 已新增
node -e "
const cfg = require('/Users/bymyway/.openclaw/cron/jobs.json');
const job = cfg.jobs.find(j => j.name.includes('記憶蒸餾'));
console.log('蒸餾 job:', job ? '✅ 存在' : '❌ 不存在');
if (job) console.log('  下次執行：', new Date(job.state.nextRunAtMs).toLocaleString('zh-TW'));
"
```

---

## VPS 部署方法（本機驗證後再做）

測試沒問題後，用以下指令把 hook 複製到 VPS MAX01：

```bash
# 1. 把 handler.js 傳到 VPS
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 \
  "mkdir -p ~/.openclaw/hooks/client-memory"

sshpass -p '9kdxvQN2' scp \
  /Users/bymyway/.openclaw/hooks/client-memory/handler.js \
  root@43.245.60.200:~/.openclaw/hooks/client-memory/handler.js

sshpass -p '9kdxvQN2' scp \
  /Users/bymyway/.openclaw/hooks/client-memory/HOOK.md \
  root@43.245.60.200:~/.openclaw/hooks/client-memory/HOOK.md

# 2. 在 VPS 啟用 hook
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 \
  "node -e \"
const fs = require('fs');
const p = '/root/.openclaw/openclaw.json';
const cfg = JSON.parse(fs.readFileSync(p, 'utf-8'));
if (!cfg.hooks) cfg.hooks = { internal: { enabled: true, entries: {} } };
cfg.hooks.internal.entries['client-memory'] = { enabled: true };
fs.writeFileSync(p, JSON.stringify(cfg, null, 2));
console.log('VPS client-memory hook 已啟用');
\""

# 3. 在 VPS 新增蒸餾 Cron Job（從 Mac 執行的遠端指令）
# 同 Step 4，但改 sessionKey 為 VPS 的 Telegram 用戶 ID
```

---

## 錯誤處理

遇到任何錯誤，寫入：
```
/Users/bymyway/Desktop/vps_memory_error.txt
```

格式：
```
[時間] 步驟：Step N
[時間] 錯誤：（完整錯誤訊息）
[時間] 指令：（執行的那行指令）
```

寫完後繼續等待。

---

## 回報格式

全部完成後回報：
```
✅ VPS 記憶蒸餾架構安裝完成

已安裝：
- client-memory hook：✅
- openclaw.json 已更新：✅
- CLIENT_PROFILE.md 初始版本：✅
- 每日蒸餾 Cron Job：✅（每晚 23:30 執行）

下一步：等下次對話啟動時驗證 hook 是否有注入 CLIENT_PROFILE 內容。
```
