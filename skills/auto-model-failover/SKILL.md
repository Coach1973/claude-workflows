---
name: auto-model-failover
displayName: 大樹頂級特助 — 自動模型切換與防失憶系統
version: 2.0.0
description: |
  壓力測試實戰版（2026-04-12）。
  發現 OpenClaw fallback 鏈在 live session 中完全無效的致命缺陷，
  並找到正確的手動修復流程。自動化偵測已寫入 auto-fix-session-lock.sh。
license: MIT-0
tags:
  - openclaw
  - model
  - failover
  - quota
  - anti-amnesia
  - gemini
  - pro
---

# 大樹頂級特助 — 自動模型切換與防失憶系統 v2.0

## ⚠️ v1.0 的致命謊言（壓力測試揭露）

v1.0 宣稱「12 層 fallback，額度耗盡自動無縫切換」。
2026-04-12 壓力測試證明：**這是錯的。**

---

## 核心缺陷：Live Session Model Switch

### 現象
小龍蝦已讀不回，gateway log 大量出現：
```
[agent/embedded] live session model switch detected before attempt:
  anthropic/claude-sonnet-4-6 -> google/gemini-3.1-pro-preview
  groq/llama-3.3-70b-versatile -> google/gemini-3.1-pro-preview
  （所有 fallback 全被強制拉回原始 primary）
```

### 根本原因
OpenClaw 的 live session 保護機制：
- session 建立時記住當時的 primary model
- session 存活期間，所有切換到「不同 model」的嘗試，一律被拒絕並強制拉回原始 primary
- 結果：**fallback 鏈只在「新 session 啟動瞬間」有效，對 live session 完全無效**

### 三層疊加問題
| 層 | 問題 |
|----|------|
| L1 | Google API 配額耗盡（429 quota exceeded） |
| L2 | Live Session Model Switch：所有 fallback 被拉回 → 全部無效 |
| L3 | Auto-fix 每 2 分鐘重啟 → 新訊息立刻重蹈覆轍 → 死循環 |

---

## 正確解法：改 Primary + 清 Session + 重啟

**fallback 鏈無法救你。唯一有效的方法是：**

```bash
# 步驟 1：把 primary 改成還有配額的模型
# 編輯 /Users/bymyway/.openclaw/openclaw.json
# "primary": "google/gemini-2.5-pro"  ← 改這裡

# 步驟 2：清除所有 sessions 和 cooldown
python3 << 'PYEOF'
import json, os, glob
sf = '/Users/bymyway/.openclaw/agents/main/sessions/sessions.json'
af = '/Users/bymyway/.openclaw/agents/main/agent/auth-profiles.json'
for f in glob.glob('/Users/bymyway/.openclaw/agents/main/sessions/*.jsonl'):
    os.remove(f)
json.dump({}, open(sf, 'w'), indent=2)
d = json.load(open(af))
for k in d.get('usageStats', {}): d['usageStats'][k] = {}
json.dump(d, open(af, 'w'), indent=2)
PYEOF

# 步驟 3：重啟 gateway
launchctl kickstart -k gui/$(id -u)/ai.openclaw.gateway
```

---

## 如何找到還有配額的模型

```bash
GOOGLE_KEY=$(python3 -c "
import json
d = json.load(open('/Users/bymyway/.openclaw/agents/main/agent/auth-profiles.json'))
for k,v in d.get('profiles',{}).items():
    if 'google' in k:
        print(v.get('key',''))
        break
")

for model in gemini-2.5-pro gemini-2.5-flash gemini-2.5-flash-lite gemini-3.1-pro-preview gemini-3-pro-preview; do
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
    -X POST "https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${GOOGLE_KEY}" \
    -H "Content-Type: application/json" \
    -d '{"contents":[{"parts":[{"text":"hi"}]}]}')
  [ "$STATUS" = "200" ] && echo "✅ $model 有配額" || echo "❌ $model ($STATUS)"
done
```

---

## 正確的模型優先順序（Pro 優先原則）

教練守則：**非 Pro 不用，Flash 是最後手段**

```json
{
  "primary": "google/gemini-2.5-pro",
  "fallbacks": [
    "google/gemini-3.1-pro-preview",
    "google/gemini-3-pro-preview",
    "google/gemini-3.1-pro-preview-customtools",
    "google/gemini-2.5-flash",
    "google/gemini-2.5-flash-lite",
    "google/gemini-3-flash-preview",
    "google/gemini-3.1-flash-lite-preview"
  ]
}
```

**重要：** fallback 鏈的設計，只有在系統重啟後才生效（新 session 啟動時）。

---

## 免費模型為何不能用

系統提示（workspace 所有 .md 檔）啟動時需要約 **82,000 tokens**。
Groq/Cerebras/SambaNova 等免費模型 TPM 上限 12,000，啟動就直接爆掉。
**不要把這些模型加入 fallback 鏈，浪費重試次數。**

---

## 各 Google 模型配額的關鍵知識

1. **每個模型配額完全獨立** — gemini-2.5-pro 和 gemini-3.1-pro-preview 是不同的配額桶
2. **切換模型 = 立刻有新配額** — 不需要等隔天重置
3. **壓測只打了 3.x 系列** — 2.5 系列配額完整保留（今日驗證）
4. **正確策略** — 把最少用到的模型留在 fallback，讓配額分散在不同世代

---

## 自動化狀態

### ✅ 已有（v1.0）
- Session Lock 自動修復（每 2 分鐘）
- Context Overflow 自動存檔重啟
- 設定備份 + 重啟輪詢確認

### 🔧 v2.0 新增（已寫入 auto-fix-session-lock.sh）
- 偵測 Google 429 quota exhausted → 自動改 primary → 清 session → 重啟

### ❌ 尚未實現（待開發）
- 每日 cron：自動掃描各模型配額，動態調整 primary 為最佳可用 Pro 模型

---

## 踩坑全紀錄（v1.0 + v2.0 合計）

1. `gemini-2.5-pro` 強制 thinking mode，OpenClaw 預設 thinking=off 報 400
2. `groupPolicy` 有效值只有 `open/allowlist/disabled`，不是 `all`
3. Telegram bot 群組需先 BotFather `/setprivacy` → Disable
4. Gemini memory 檔超過 50KB → 空白回應，HEARTBEAT 禁讀大型 memory
5. Session Lock 清 sessions.json 不夠，還要刪 JSONL 檔
6. **（新）Live Session Model Switch：fallback 鏈對 live session 完全無效**
7. **（新）免費模型 TPM 遠低於系統提示大小，加進去只是浪費重試次數**
8. **（新）各 Google 模型配額獨立，壓測策略應分散在不同模型**
9. **（新）「配額明天重置」是錯的，切換模型就立刻有新配額**

---

## 設計哲學

> 「沒試之前都是理想，試過之後才知道行不行。
> 我們頂級特助系統，是不能讓客戶去感受到這麼多無奈。」
> — 大樹教練，2026-04-12

**v1.0 的理想遇上了現實。v2.0 是被壓力測試逼出來的真相。**
