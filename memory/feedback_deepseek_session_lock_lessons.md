---
name: DeepSeek 接入失敗試錯總結（2026-04-11 凌晨 1~3 點）
description: 花 2 小時試錯的完整記錄——什麼方法沒用、什麼才是根本解
type: feedback
---

## 背景

Gemini 每日 250 次免費配額在凌晨 1 點耗盡。嘗試讓 DeepSeek 作為 fallback 接管 Telegram 小龍蝦，結果花了約 2 小時才搞清楚根本原因。

---

## 試過但沒用的方法（不要再重複）

### ❌ 方法 1：把 DeepSeek 加入 fallbacks 就以為能用
- 做了什麼：在 openclaw.json 加入 `deepseek/deepseek-chat` 到 fallbacks
- 結果：還是 "All models failed"
- 原因：光加 fallbacks 不夠，session lock 問題才是根本

### ❌ 方法 2：重啟 OpenClaw
- 做了什麼：`launchctl kickstart` 重啟 gateway
- 結果：無效
- 原因：session lock 存在於 sessions.json，重啟不會清除

### ❌ 方法 3：手動刪除 sessions.json 中的 session key
- 做了什麼：用 python3 刪除 `agent:main:telegram:direct:6124913915` 這個 key
- 結果：短暫有效，但下次 Gemini 嘗試失敗後又鎖死
- 原因：每次新 session 建立，OpenClaw 立即把 Gemini 寫入 model_change → 再次鎖死

### ❌ 方法 4：在 sessions.json 設定 providerOverride 指向 DeepSeek
- 做了什麼：手動修改 sessions.json，把 providerOverride 設為 deepseek
- 結果：部分有效但不穩定
- 原因：OpenClaw 在下次 run 時會覆蓋這個值

### ❌ 方法 5：建立 LaunchAgent 每 2 分鐘自動清除
- 做了什麼：建立 `ai.openclaw.session-fix` LaunchAgent
- 結果：邏輯正確但治標不治本
- 原因：每次 Gemini 限流就會再次觸發，user 需要重發訊息

---

## 根本原因（最重要，必須記住）

**OpenClaw 的 Live Session Model Lock 機制（`live-model-switch.ts`）：**
1. 每個 Session 啟動時，OpenClaw 把 Primary 模型（Gemini）寫入 JSONL 的 `model_change` 事件
2. 當 Gemini 失敗，fallback（Groq/DeepSeek）嘗試接管
3. OpenClaw 偵測到「這個 session 的模型應該是 Gemini」→ 要求切回 Gemini
4. Gemini 不可用（rate_limit）→ 切換失敗，error=unknown
5. 所有模型都失敗

**這個機制沒有設定開關，無法透過 config 關閉。**

---

## 真正的永久解法（下次直接做這個，不要繞路）

### ✅ 把 Primary 改成 DeepSeek（一行改動，一勞永逸）

在 `/Users/bymyway/.openclaw/openclaw.json`：
```json
"model": {
  "primary": "deepseek/deepseek-chat",
  "fallbacks": [
    "google/gemini-3.1-pro-preview",
    "groq/llama-3.3-70b-versatile",
    "anthropic/claude-sonnet-4-6"
  ]
}
```

**為什麼有效：** Session 從 DeepSeek 開始 → lock 是 DeepSeek → DeepSeek 可用 → 成功。
Gemini 變成 fallback，250 次/天的配額節省給高品質任務。

**Why:** DeepSeek 免費額度、無每日次數限制，適合作為主力。Gemini 每日 250 次應留給重要任務。
**How to apply:** 下次遇到「All models failed」且 Gemini 限流，直接做這個改動，不要再繞路試其他方法。

---

## 時間損失統計
- 浪費時間：約 2 小時（凌晨 1:00 ~ 2:44）
- 根本原因理解後，正確解法只需：**1 分鐘改一行 config + 重啟**
