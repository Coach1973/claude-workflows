---
name: 全自動 API 鑰匙獲取藍圖
description: 幫助小白老闆零門檻接入各大 AI 免費額度的完整方案設計（已驗證 Groq 流程）
type: project
---

## 核心洞察

> 「讓不懂英文、不懂程式碼的老闆自己去後台申請 API Key，是會引發恐慌跟退貨的！」

**唯一無法繞過的人工步驟：** SMS 手機簡訊驗證碼（防機器人機制）。AI 無法代收。

## 分工模式

- **老闆做（唯一需要動手）**：登入平台帳號 → 收簡訊驗證碼 → 複製 API Key → 貼給 AI
- **AI 做（全自動）**：寫入設定檔 → 重啟系統 → 確認生效

## Groq 申請步驟（已驗證，可作為學員範本）

1. 前往 `console.groq.com/keys`
2. 點「Continue with Google」或 GitHub
3. 點「Create API Key」
4. 名稱輸入：`openclaw`（或學員名字）
5. EXPIRATION：選「90天」或「Never」
6. 按「Submit」→ 複製 `gsk_` 開頭的 Key
7. 貼給 AI：「這是 Groq 的鑰匙，幫我接上去」
8. AI 自動完成：寫入 auth-profiles.json → 更新 openclaw.json → 重啟系統

整個流程約 5 分鐘，零代碼，零終端機。

## API 軍火庫狀態（Mac 端，截至 2026-04-10）

| 服務 | 狀態 | 備注 |
|------|------|------|
| Groq | ✅ 完成 | llama-3.3-70b，128k context |
| DeepSeek | ✅ 完成 | 無每日次數限制，適合 Primary |
| Google Gemini | ✅ 完成 | 每日 250 次免費 |
| Kimi (Moonshot) | ⏳ 待辦 | 台灣無法直接申請，需大陸朋友代申請 |

## Kimi API 申請說明

`platform.moonshot.cn` 申請頁面台灣無法存取。
解決方案：請大陸朋友幫申請 API Key。
- API Key 不需要綁定帳號，朋友生成後直接傳 Key 給教練即可
- API 呼叫本身沒有 IP 地區限制，台灣可正常使用

## 技能包交付給學員的流程設計

1. 學員授權（唯一需要動手）：「請您點這個連結登入 Google，完成後告訴我一聲」
2. AI 代勞：背景自動進開發者後台，點 Create API Key，複製密碼
3. 無痛接入：AI 自己打開設定檔，安裝鑰匙，重啟系統
4. 回報完成：「報告老闆，XXX 的免費額度已為您安裝完畢！」

**安全承諾**：所有操作在學員自己的 Mac 上執行，API Key 不經過任何第三方伺服器。

**Why:** 這是偉大任務「零門檻讓老闆用 AI」的關鍵最後一哩路方案。
**How to apply:** 學員接入 AI 模型時，直接用這套分工流程，不要讓學員自己看英文後台。
