---
name: 全自動 API 鑰匙獲取藍圖（4/10 對話精華）
description: 幫助小白老闆零門檻接入各大 AI 免費額度的完整方案設計
type: project
---

## 核心洞察：最後一哩路的死穴

教練點出賣 AI 給小白老闆最大的障礙：
> 「讓不懂英文、不懂程式碼的老闆自己去後台申請 API Key，是會引發恐慌跟退貨的！」

**唯一無法繞過的人工步驟：** SMS 手機簡訊驗證碼（防機器人機制）。AI 無法代收手機簡訊。

---

## 已驗證的「老闆零門檻」API 接入流程

### 分工模式
- **老闆做（唯一需要動手）**：登入平台帳號 → 收簡訊驗證碼 → 複製 API Key → 貼給 AI
- **AI 做（全自動）**：寫入設定檔 → 重啟系統 → 確認生效

### Groq 申請完整步驟（已驗證，可作為學員範本）
1. 前往 `console.groq.com/keys`
2. 點「Continue with Google」（最簡單）或 GitHub
3. 點「Create API Key」
4. 名稱輸入：`openclaw`（或學員名字）
5. EXPIRATION（有效期）：選「90天」或「Never」
6. 按「Submit」→ 複製 `gsk_` 開頭的 Key
7. 貼給 AI：「這是 Groq 的鑰匙，幫我接上去」
8. **AI 自動完成**：寫入 auth-profiles.json → 更新 openclaw.json → 重啟系統

**Why:** 教練親自測試驗證，整個流程約 5 分鐘，零代碼，零終端機

---

## 待建立的 API 軍火庫清單
1. **Groq** ✅ 已完成（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）
2. **DeepSeek** ✅ 已完成（sk-d1cc076253d3403e889f8ab65dd97197）
3. **Kimi (Moonshot)** ⏳ 台灣無法直接申請，需大陸朋友代申請
4. **Google Gemini** ✅ 已有（AIzaSyDFLv-ec9nOBCl7lTsoIqmiH-3HsihM13Y）
5. 其他待補充...

---

## 技能包交付給學員的流程設計

1. **學員授權**（唯一需要做的一步）：「請您點這個連結登入 Google，完成後告訴我一聲」
2. **AI 代勞**：背景自動進開發者後台，點 Create API Key，複製密碼
3. **無痛接入**：AI 自己打開設定檔，安裝鑰匙，重啟系統
4. **回報完成**：「報告老闆，XXX 的免費額度已為您安裝完畢！」

**安全承諾**：所有操作在「學員自己的 Mac」上執行，API Key 不經過任何第三方伺服器

---

## 重要提醒：GitHub vs Google 登入

- **推薦**：GitHub 登入（API 工具的自然棲息地，公私分明）
- **可行**：Google 登入（日常方便，但混在私人帳號裡）
- **4/10 教訓**：分析太慢，教練已用 Google 登入 → 「將錯就錯，直接用」才是正確應對
