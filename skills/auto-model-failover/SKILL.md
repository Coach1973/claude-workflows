---
name: auto-model-failover
displayName: 大樹頂級特助 — 自動模型切換與防失憶系統
version: 1.0.0
description: |
  完整的多模型自動 fallback 鏈 + 防失憶機制。
  Pro 等級模型優先，額度耗盡自動切換下一個，全程無感，上下文零遺失。
  實戰踩坑兩天提煉，比 clawhub 同類技能多三層保護。
license: MIT-0
tags:
  - openclaw
  - model
  - failover
  - auto-switch
  - memory
  - anti-amnesia
  - gemini
  - pro
---

# 大樹頂級特助 — 自動模型切換與防失憶系統

## 這套系統解決什麼問題？

市面上大多數模型切換方案需要「用戶說一句話才切換」。這套系統不需要。
**額度耗盡 → 自動切換 → 上下文不中斷 → 用戶完全無感。**

---

## 核心架構（三層）

### Layer 1：自動 Fallback 鏈（openclaw.json）

```json
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "google/gemini-3.1-pro-preview",
        "fallbacks": [
          "google/gemini-3-pro-preview",
          "google/gemini-3.1-pro-preview-customtools",
          "google/gemini-2.5-pro",
          "google/gemini-2.5-flash",
          "google/gemini-3-flash-preview",
          "google/gemini-3.1-flash-lite-preview",
          "openrouter/google/gemma-4-31b-it:free",
          "anthropic/claude-sonnet-4-6",
          "sambanova/Meta-Llama-3.3-70B-Instruct",
          "cerebras/qwen-3-235b-a22b-instruct-2507",
          "groq/llama-3.3-70b-versatile"
        ]
      }
    }
  }
}
```

**設計原則**：
- Pro 等級全部排前面，Flash 墊底，只有 Pro 全軍覆沒才用 Flash
- 最後三個（llama/cerebras/groq）是緊急備援，不計品質只求有回應

### Layer 2：Session Lock 自動修復（每 2 分鐘）

`scripts/auto-fix-session-lock.sh` 負責：
- 偵測 `failed` 狀態的 session → 自動清除 + 重啟 gateway
- 偵測 JSONL > 500KB（context overflow）→ 緊急存檔 → 更新 HEARTBEAT → 重啟
- 改設定前自動備份 openclaw.json（保留最近 5 份）
- 重啟後輪詢確認 gateway 真的活了（不盲目 sleep）

```bash
# 安裝 LaunchAgent
cp ai.openclaw.session-fix.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/ai.openclaw.session-fix.plist
```

### Layer 3：防失憶機制（HEARTBEAT.md + 30 分鐘同步）

`scripts/sync-telegram-memory.sh` 負責：
- 每 30 分鐘把對話存入 `memory/YYYY-MM-DD.md`
- Context overflow 時 `--force` 緊急全量存檔
- 雙向同步：對話記錄 → Claude 助教記憶庫（反向也同步）
- 全部 push 到 GitHub 永久備份

HEARTBEAT.md 是「熱上下文」，每次任務後更新摘要（<500字），重啟後讀這裡接任務，不靠大型 memory 檔。

---

## 與市面技能的比較

| 功能 | 一般切換技能 | 本系統 |
|------|------------|--------|
| 需要用戶下指令切換 | ✅ 需要 | ❌ 不需要 |
| 自動 fallback 鏈 | ❌ 沒有 | ✅ 12 層 |
| Session Lock 修復 | ❌ 沒有 | ✅ 每 2 分鐘 |
| Context Overflow 保護 | ❌ 沒有 | ✅ 500KB 觸發 |
| 防失憶機制 | ❌ 沒有 | ✅ HEARTBEAT + sync |
| 改設定前備份 | ✅ 有 | ✅ 有（學自社群） |
| 重啟輪詢確認 | ✅ 有 | ✅ 有（學自社群） |

---

## 踩坑紀錄（部署前必讀）

1. `gemini-2.5-pro`（純版）強制要求 thinking mode，OpenClaw 預設 thinking=off 會報 400 → 用 `gemini-3.1-pro-preview` 當 primary
2. `groupPolicy` 有效值只有 `open/allowlist/disabled`，不是 `all`
3. Telegram bot 在群組需先去 BotFather 執行 `/setprivacy` → Disable，才能收到群組訊息
4. Gemini memory 檔超過 50KB 會造成空白回應 → HEARTBEAT 禁止讀大型 memory 檔
5. Session Lock 清 `sessions.json` 不夠，還要刪對應的 JSONL 檔

---

## 設計哲學

> 「沒試之前都是理想，試過之後才知道行不行。
> 我們頂級特助系統，是不能讓客戶去感受到這麼多無奈。」
> — 大樹教練，2026-04-12

所有技術複雜度隱藏在系統層。客戶只需要一個動作：說話。
