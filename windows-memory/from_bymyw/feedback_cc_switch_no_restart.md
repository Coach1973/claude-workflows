---
name: CC Switch 切換不需重啟 CLI
description: 在 CC Switch UI 切換 provider 後，當前正在跑的 Claude CLI 立即生效，不需關閉對話框重開
type: feedback
originSessionId: e08504ad-23a4-4a10-ab3a-2b905e47bc7d
---
CC Switch 切換 provider 後，不要建議教練「關掉 CLI 重開」。

**Why:** 教練 2026-05-11 在同一個 Claude CLI 對話框內，只在 CC Switch UI 切換 provider（從 synterolink 切回 EasyClaude），對話框立即接上新的 API Key 繼續工作，全程沒有關閉視窗。這就是 CC Switch 應該提供的能力。我之前根據「process 啟動時 snapshot env」的常識推論說必須重啟，被教練糾正：實作上 CC Switch 改寫 `.claude\settings.json` 後，CLI 會即時重新讀取。

**How to apply:**
- 切換指引只說「在 CC Switch 切過去」，不要加「然後關掉 CLI 重開」。
- 如果切換後沒生效，第一個假設是「DB 或 settings.json 內容本身有誤」（例如 KEY 名稱用錯、URL 多了 /v1），不是「需要重啟」。
- 把 CC Switch 當熱切換工具用，這也是教練把不同 provider 加進 CC Switch（包含把我這顆模型登記進去）的設計意圖：任何 provider 出問題都能秒切回工作。
