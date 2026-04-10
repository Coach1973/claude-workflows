---
name: DeepSeek Session Lock 試錯總結（Mac 端 OpenClaw）
description: 花 2 小時的失敗記錄——什麼方法沒用、什麼才是根本解（適用於 OpenClaw 模型切換問題）
type: feedback
---

## 根本原因（最重要）

OpenClaw 的 Live Session Model Lock 機制（`live-model-switch.ts`）：
1. 每個 Session 啟動時，OpenClaw 把 Primary 模型（如 Gemini）寫入 JSONL 的 `model_change` 事件
2. 當 Gemini 失敗，fallback 嘗試接管
3. OpenClaw 偵測到「這個 session 的模型應該是 Gemini」→ 要求切回 Gemini
4. Gemini 不可用（rate_limit）→ 切換失敗，error=unknown → 所有模型都失敗

**這個機制沒有設定開關，無法透過 config 關閉。**

## 試過但沒用的方法（不要再重複）

| 方法 | 為什麼沒用 |
|------|-----------|
| 在 openclaw.json 加 fallbacks | 光加 fallbacks 不夠，session lock 才是根本 |
| 重啟 OpenClaw | session lock 存在於 sessions.json，重啟不會清除 |
| 手動刪除 sessions.json 中的 session key | 短暫有效，下次 Gemini 嘗試失敗後又鎖死 |
| 手動設 providerOverride 指向 DeepSeek | OpenClaw 在下次 run 時會覆蓋這個值 |
| LaunchAgent 每 2 分鐘自動清除 | 治標不治本，每次 Gemini 限流就再次觸發 |

## 根本解（一行改動，一勞永逸）

在 `/Users/bymyway/.openclaw/openclaw.json` 把 Primary 改成 DeepSeek：

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

**Why:** DeepSeek 免費額度、無每日次數限制。Gemini 每日 250 次應留給高品質任務。
**How to apply:** 下次遇到「All models failed」且 Gemini 限流，直接改這個 config，不要繞路。

## 時間損失

浪費約 2 小時試錯。正確解法只需 1 分鐘改一行 + 重啟。
