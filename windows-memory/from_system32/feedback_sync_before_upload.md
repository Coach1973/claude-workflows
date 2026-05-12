---
name: ""
description: 所有 AI 在 commit/push 前必須先 git pull，避免 Opus 額度耗盡後桌面版接手造成版本錯亂
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 0e798d57-0089-4091-a391-e887788d2a90
---

# 鐵律：上雲前，先讀雲

**規則：**
全團隊任何模型（Opus 軍師、Sonnet 終端機、桌面版、MiniMax 三機小龍蝦），在對共享 repo 做任何 commit/push 前，**務必先 git pull 拉最新版**，讀完再動手。

**Why:**
教練在 2026-05-13 點出一個痛點：Opus 軍師一次對話 20 元配額常常用到一半就斷，斷線後只能轉由 Claude 桌面版接手。兩邊狀態沒交接好，或彼此不知道對方改過哪些檔，導致 repo 版本互相覆蓋、記憶檔被舊內容蓋掉、心血白費。

這一條是 [[feedback_record_and_upload_supreme_rule]]（記錄上雲鐵律）的配套。光記錄上雲不夠，還要**確保上的是最新版**，否則記錄變成互相踩。

**How to apply:**

1. **任何 AI 動 commit/push 前的第一步**：先執行
   ```
   git fetch --all && git pull --rebase
   ```
   拉完再決定要寫什麼、改什麼。

2. **接手別人工作時更要先讀**：
   - 軍師斷線、桌面版接手 → 桌面版先 pull
   - Mac 終端機接到軍師指令稿 → 先 pull 再跑
   - 任何 AI 開工第一句話：「我已 pull 到最新版 commit XXX」

3. **共享交接文件位置**：
   - `OPUS_HANDOFF_*.md` 系列（repo 根目錄）——重大交接
   - `HEARTBEAT.md`（repo 根目錄）——每日狀態心跳
   - `terminal-notes/`——Mac 端工作筆記
   讀過這幾個位置，才知道別人最近動了什麼。

4. **如果 pull 有衝突**：
   - 不要自己硬解、不要 `--force`、不要 `reset --hard`
   - 把衝突記進對話，問教練或請終端機處理
   - 寧可慢，不可丟資料

5. **記憶檔特別注意**：
   `C:\Users\bymyw\.claude\projects\C--WINDOWS-system32\memory\` 是 Windows 端本地，不在 repo 裡。但重大記憶應同步寫一份到 repo 的 `shared-memory/` 或 `terminal-notes/`，讓 Mac 端 AI 也讀得到。

**反例（正在發生的問題）：**
- Opus 寫了一半對話斷掉 → 桌面版接手 → 桌面版用舊狀態繼續 → 推上去蓋掉 Opus 的半成品 → 教練下次回來發現心血消失
- 凌晨的指揮所考古產出，若桌面版不知道而覆蓋寫 HEARTBEAT.md，就白熬了

**配套行動（2026-05-13）：**
軍師下線前要把這條鐵律同步進：
- 本檔（Windows 軍師記憶）
- repo 的 `OPUS_HANDOFF_20260513.md`（給所有 AI 看）
- 後續可選：寫進 Mac 端 SOUL.md / CLAUDE.md 的 git 相關段落
