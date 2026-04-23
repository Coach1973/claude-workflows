---
name: 先查原生功能再動手
description: 遇到功能需求時，應先查 OpenClaw 原生指令與設定，避免浪費 Token 和時間
type: feedback
---

先確認 OpenClaw 原生是否支援，再動手實作或搜尋。

**Why:** 2026-04-22 處理「開關語音」需求時，花了大量 Token 翻 dist/*.js 原始碼，最後才發現 `/tts on` / `/tts off` 是 OpenClaw 內建指令，根本不需要任何額外設定。這次浪費了教練的錢與時間。

**How to apply:**
1. 老闆提出任何功能需求（指令、開關、設定）時，**第一步**先執行：
   - `docker exec openclaw grep -rn '"<關鍵字>"' /app/dist/commands-registry.data-*.js`
   - 或直接問小龍蝦：「你有沒有內建 /xxx 指令？」
2. 確認沒有原生支援後，才開始找設定或寫自訂方案。
3. 這個原則適用於所有 OpenClaw 功能：TTS、圖片生成、語音、指令、工具等。
