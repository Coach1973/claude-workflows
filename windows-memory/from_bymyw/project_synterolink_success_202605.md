---
name: Synterolink 接入已成功（2026-05 釐清）
description: Synterolink 問題已釐清：模型名稱與後台分組必須一致；教練已升級 120 美金不限時間方案並測通
type: project
date: 2026-05-12
originSessionId: e08504ad-23a4-4a10-ab3a-2b905e47bc7d
---
**結論更新：Synterolink 已測試成功，先前 403/503 不是服務必然不可用，而是模型名稱與後台分組沒有對齊造成的烏龍。**

# 已釐清的關鍵

教練 2026-05-12 回報：在 Synterolink 客服引導下，帳號已可正常使用。關鍵規則是：**Claude CLI 端指定的模型，必須與 Synterolink 後台選定的模型分組一致**。先前來回測試時，CLI 模型與後台群組沒有選對，才導致 403/503 等錯誤。

# 方案狀態更新

- 舊方案：每日 30 點、每月 900 點。
- 新方案：教練已更改為 **120 美金不限時間方案**。

# 先前錯誤判斷修正

之前記錄「Synterolink 服務無法交付 / 不可信任」是基於當時 403/503 的觀察，但後續被客服協助釐清：
- 403 可能是模型群組或授權不匹配，不應直接判定為服務詐騙。
- 503 可能是請求打到不匹配或不可用的後端群組，不應直接判定為帳號池永久不可用。
- 真正要先檢查的是：後台分組、CLI 模型名稱、方案權限三者是否一致。
- 2026-05-12 的 /usage 已確認有 `cache_read`，所以 prompt caching 是通的；真正燒錢主因是本輪大量跑在 Opus。

# How to apply

- 未來設定 Synterolink 時，先確認後台選的群組，再對應 CLI `--model`。
- 不要再引用「不要推薦 Synterolink」的舊結論；那條已被本檔取代。
- 保留原接入規格：`ANTHROPIC_AUTH_TOKEN`、`ANTHROPIC_BASE_URL=https://api.synterolink.com`、不要用 `ANTHROPIC_API_KEY`、不要在 base URL 加 `/v1`。
- 若再次出現 403/503，先查「模型與分組是否一致」，再查服務狀態或客服。
- 預設使用 Sonnet，Opus 僅在必要深度推理時切換。
