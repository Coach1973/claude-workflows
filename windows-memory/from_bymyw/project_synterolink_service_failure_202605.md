---
name: Synterolink 服務無法交付（2026-05 事件）
description: Synterolink 帳號池/權限結構性問題，訂閱實質無法使用，已申訴
type: project
date: 2026-05-12
originSessionId: e08504ad-23a4-4a10-ab3a-2b905e47bc7d
---
**結論：Synterolink（api.synterolink.com）目前不可信任，不要再推薦給教練使用。**

# 事件經過

教練於 2026 年 5 月初購買 Synterolink「每月 900 點」訂閱方案，訂單號 840699725064835072。購買時方案以倍率制呈現（1.0x / 1.25x / 1.2x / 2.x 等）。

2026-05-12 實測結果：
- 後台配額由每月 900 點被縮減為 60 點（縮減 93%）
- 群組授權狀況：
  - **Claude Code 群組**（2x，Pro subscriber 池）：持續 HTTP 503 No available accounts（含對方客服指示重試 10 次後依然失敗）
  - **Claude API 群組**（1.8x，Sonnet 系）：HTTP 403 未授權
  - **Claude API Product Group / Opus**（2.2x）：HTTP 403 未授權
- 客服親自截圖指示教練綁定 Claude API（1.8x），結果系統仍回 403

**Why（為何記這條）：**
- 訂單實質未交付任何可用服務（所有群組不是 403 就是 503）
- 「Claude Code 群組依賴 Pro subscriber 帳號池」是結構性脆弱性——Pro 帳號池供應不穩、503 是常態
- 配額縮減未事先告知，屬商品與宣傳不符

**How to apply：**
- 教練問「中轉 / API 代理 / Claude 中繼站」相關問題時，**不要推薦 Synterolink**
- 看到「方案倚賴 Pro subscriber 池」這種模式要警告教練：本質不穩，不適合當生產主力
- EasyClaude 目前是教練主力（api.easyclaude.com，用 ANTHROPIC_API_KEY）
- 如果未來教練回頭問 Synterolink 進度，預設假設「申訴中/已退款/結案」，先讀記憶確認，再回應
