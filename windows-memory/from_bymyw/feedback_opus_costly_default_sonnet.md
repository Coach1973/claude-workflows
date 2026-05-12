---
name: Opus 4.7 在 Synterolink 上極燒錢，預設用 Sonnet
description: Synterolink 上 Opus 4.7 倍率高 + 推理長，單輪對話可燒 10 美金；預設用 Sonnet 4.6
type: feedback
date: 2026-05-12
originSessionId: e08504ad-23a4-4a10-ab3a-2b905e47bc7d
---
**規則：在 Synterolink 上，預設用 `claude-sonnet-4-6`，不要主動用 `claude-opus-4-7`。Opus 只在教練明確要求或任務確實需要深度推理時才用。**

**Why：**
- 教練 2026-05-12 親測：120 美金不限時間方案，光是一輪 Opus 4.7 對話與測試就燒掉約 10 美金（130 → 120）。
- 原因有二：(1) Synterolink 上 Opus product group 倍率是 2.2x，比 Sonnet 的 1.8x 高；(2) Opus 推理長、輸出多 token。
- 「不限時間方案」不等於「無限額度」——是時間沒限制，但點數還是會燒完，120 美金以這個速度大約只能跑十幾輪 Opus 對話。
- 2026-05-12 的 /usage 已確認有 `cache_read`，所以 Synterolink 的 prompt caching 是通的；真正燒錢主因不是 cache 沒開，而是本輪大量跑在 Opus。

**How to apply：**
- 軍師本人預設使用 `claude-sonnet-4-6`（包含跑命令、做測試、寫文件、修記憶）。
- 只有教練說「用 Opus」「這個用最強的」「給我深度分析」「複雜任務」之類明確訊號時，才切 Opus 4.7。
- 不要主動拿 Opus 跑連線測試、語法檢查、檔案讀寫等輕量任務。
- 若預期單輪會跑很久（長文寫作、大量檔案處理），先和教練確認模型選擇，避免「沒講就燒一輪 Opus」。
- 提醒：`.claude/settings.json` 裡的 `"model"` 欄位是 Claude Code 的預設啟動模型，若教練希望進一步省，可改成 `"sonnet"`。
