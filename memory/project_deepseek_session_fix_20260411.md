---
name: 2026-04-11 DeepSeek 接入 + Session Lock 永久修復
description: DeepSeek API 設定流程、Live Session Model Lock 根本原因與自動修復方案
type: project
---

## DeepSeek API 接入（已完成）

**配置檔案修改：**
- `auth-profiles.json`：新增 `deepseek:default` profile，key = `sk-d1cc076253d3403e889f8ab65dd97197`
- `models.json`：新增 deepseek provider，api=`openai-completions`，baseUrl=`https://api.deepseek.com`，模型：`deepseek-chat`、`deepseek-reasoner`
- `openclaw.json`：fallbacks 新增 `deepseek/deepseek-chat`，env 新增 `DEEPSEEK_API_KEY`

**Why:** Gemini 每日 250 次免費配額用完後，Groq 128k context 上限也常達到，需要第三條免費 AI 線路

**How to apply:** DeepSeek 是目前第三 fallback（Gemini→Groq→DeepSeek→Claude）

---

## Live Session Model Lock 根本原因（重要技術知識）

**問題描述：** 每次 Telegram 小龍蝦出現「All models failed: Live session model switch requested: google/gemini-3.1-pro-preview (unknown)」

**根本原因：**
- OpenClaw 在每次 Session 啟動時，把 Primary 模型（Gemini）寫入 session 的 `model_change` 事件
- 當 Gemini 限流後，Groq/DeepSeek 嘗試接管時，OpenClaw 偵測到「這個 session 應該用 Gemini」→ 要求切回 Gemini → Gemini 不可用 → error=unknown
- 這是 OpenClaw 的 `live-model-switch.ts` 機制，無法透過設定關閉

**永久修復方案：**
1. 建立 `/Users/bymyway/.openclaw/scripts/auto-fix-session-lock.sh`
2. 安裝 LaunchAgent `ai.openclaw.session-fix`（每 2 分鐘執行）
3. 邏輯：session=failed + Gemini cooldown → 重導向到 DeepSeek；Gemini 恢復 → 清除 session 讓它重啟

**Why:** 每次手動清除 session 非常麻煩，需要全自動處理
**How to apply:** 如果 Telegram 又不回應，先等 2 分鐘讓 LaunchAgent 自動修復，不用手動干預

---

## 待完成的根本解（8點後執行）

將 openclaw.json 的 Primary 從 Gemini 改為 DeepSeek：
```json
"primary": "deepseek/deepseek-chat",
"fallbacks": ["google/gemini-3.1-pro-preview", "groq/llama-3.3-70b-versatile", "anthropic/claude-sonnet-4-6"]
```
這樣 Session 預設鎖定 DeepSeek（有免費額度，無 250/天限制），Gemini 的每日配額節省給重要工作用。

---

## 讀取 Telegram 回應的最佳做法

**不要截圖！** 直接讀 session JSONL 檔案：
```bash
# 查 session 狀態
python3 -c "import json; d=json.load(open('/Users/bymyway/.openclaw/agents/main/sessions/sessions.json')); print(d.get('agent:main:telegram:direct:6124913915',{}).get('status'))"
# 讀最新對話
cat {sessionFile} | python3 -c "import json,sys; [print(json.loads(l).get('message',{}).get('content','')) for l in sys.stdin if l.strip()]"
```
Token 消耗趨近於零，比截圖省 100 倍。
