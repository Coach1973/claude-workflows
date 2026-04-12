---
name: Live Session Model Switch 致命缺陷（壓力測試實錄 2026-04-12）
description: 壓力測試揭露 OpenClaw fallback 鏈有根本性設計缺陷，12 條備援在 live session 中全部無效
type: feedback
date: 2026-04-12
---

# 壓力測試實錄：Fallback 鏈在 Live Session 中完全失效

## 測試背景

大樹教練刻意對小龍蝦進行壓力測試，在短時間內耗盡 Google API 週配額，
目的是驗證「額度耗盡 → 自動切換 → 無縫接軌」的流程是否真的可行。

**測試結果：失敗。小龍蝦已讀不回，完全無法回應。**

---

## 根本原因：Live Session Model Switch 機制

### 關鍵日誌證據

```
[agent/embedded] live session model switch detected before attempt for XXX:
  sambanova/Meta-Llama-3.3-70B-Instruct -> google/gemini-3.1-pro-preview
  cerebras/qwen-3-235b-a22b-instruct-2507 -> google/gemini-3.1-pro-preview
  openrouter/google/gemma-4-31b-it:free -> google/gemini-3.1-pro-preview
  anthropic/claude-sonnet-4-6 -> google/gemini-3.1-pro-preview
  groq/llama-3.3-70b-versatile -> google/gemini-3.1-pro-preview
  （共 11 個 fallback，全部被強制切回 gemini-3.1-pro-preview）
```

### 原理解析

OpenClaw 有一個「live session model switch」保護機制：
- **session 建立時**，會記住當時的 primary model（例如 gemini-3.1-pro-preview）
- **session 存活期間**，如果 fallback 嘗試切換到「不同的 model」，系統會判定這是「live session model switch」
- 系統**拒絕這個切換**，把它強制拉回原本的 primary model
- 結果：fallback 候選模型被 reject，繼續嘗試下一個 fallback，每個都失敗，最終整個 fallback 鏈 12 個全部無效

### 三層問題疊加

| 層級 | 問題 |
|------|------|
| L1 | Google API 配額耗盡（429 quota exceeded，非暫時限流） |
| L2 | Live Session Model Switch：11 個 fallback 全被強制拉回 Google → 無效 |
| L3 | Auto-fix 腳本每 2 分鐘清 session 重啟，但重啟後立刻收到訊息又重蹈覆轍 |

---

## 核心結論（必須記住）

> **OpenClaw 的 fallback 鏈只對「新 session 的啟動時刻」有效。**
> **對「正在進行中的 live session」，fallback 鏈完全無效。**

這意味著我們之前設計的「12 層 Pro-first fallback 鏈」，
在「Google 配額耗盡但 session 還活著」的情境下，完全是假的保護。

---

## 正確的解決方案

### 治標（臨時，已於 2026-04-12 晚上執行）

把 primary 改成非 Google 模型（例如 `groq/llama-3.3-70b-versatile`），
清除所有 session，重啟 gateway。
新 session 從 Groq 啟動，live session switch 不再指向 Google，問題消失。

### 治本（需要加入 auto-fix-session-lock.sh）

在 `auto-fix-session-lock.sh` 中加入第三種偵測：

**C. 偵測 Google 配額耗盡（429 quota exceeded）**

正確處理順序：
1. 偵測 gateway.log 中出現 `"quota"` + `"google"` 的 429 錯誤
2. 備份 openclaw.json
3. 將 primary 改為首個非 Google 的 fallback（如 `groq/llama-3.3-70b-versatile`）
4. 清除所有 sessions（含 JSONL）
5. 重啟 gateway
6. 通知 Telegram：「Google 配額已耗盡，已自動切換至備援模型 Groq，明天額度重置後自動恢復」

### 待辦：每日自動復原 primary

Google 配額是以天為單位重置（或週配額視方案而定）。
需要一個每日 cron 任務，在配額重置後把 primary 自動換回 `google/gemini-3.1-pro-preview`。

---

## 暫時配置（Google 配額耗盡期間）

```json
{
  "primary": "groq/llama-3.3-70b-versatile",
  "fallbacks": [
    "cerebras/qwen-3-235b-a22b-instruct-2507",
    "sambanova/Meta-Llama-3.3-70B-Instruct",
    "anthropic/claude-sonnet-4-6",
    "openrouter/google/gemma-4-31b-it:free",
    "google/gemini-3.1-pro-preview",
    ...
  ]
}
```

---

## 給小龍蝦的操作指引（配額恢復後）

明天 Google 配額重置後，執行：
1. 把 `openclaw.json` 的 primary 改回 `google/gemini-3.1-pro-preview`
2. fallbacks 排序恢復 Pro-first 順序
3. 重啟 gateway

---

## 教訓總結

1. **壓力測試是必要的**，理論設計要用實測驗證，「想像中的美好」不能當護城河
2. **Live Session 是 fallback 的死角**，未來設計 failover 必須考慮這個邊界條件
3. **治本方案 > 治標方案**：每次都靠人工救火不是頂級特助系統
4. **通知機制**：配額耗盡時，應主動通知教練，不是讓他發現「已讀不回」才來求救
