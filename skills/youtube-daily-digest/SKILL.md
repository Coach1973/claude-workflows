---
name: youtube-daily-digest
description: 管理每日 YouTube 頻道摘要系統。包含 31 個監測頻道，每天早上 8:00 自動抓取新影片並發送到 Telegram。用於新增頻道、修改關鍵字、排查問題、重新執行摘要。
triggers:
  - "新增 YouTube 頻道"
  - "YouTube 摘要"
  - "每日摘要沒收到"
  - "頻道清單"
  - "新增頻道"
  - "youtube digest"
---

# YouTube 每日摘要技能

## 系統概覽

- **腳本位置（Windows備份）：** `C:\Users\bymyw\.claude\scheduled-tasks\youtube-daily-digest\fetch_rss.ps1`
- **執行時間：** 每天 08:00（台北時間）
- **發送管道：** Telegram Bot
- **Telegram Token：** `8570992742:AAGR_swFNzjopUuaAkWYZa-h8U9oHn5jlZk`
- **Chat ID：** `6124913915`
- **監測頻道數：** 31 個

## ⚠️ 執行狀態（2026-04-10）
- **Windows（聯想）：暫停執行**
- **Mac mini M4：目前負責執行**（已交由小龍蝦管理）
- Windows 腳本保留作備份，若 Mac 出問題可隨時切回

---

## 31 個監測頻道

| # | 頻道 Handle | Channel ID |
|---|------------|------------|
| 1 | @inspiredcanvas_m | UC17zrOCuDUXmtREyx9G2tCQ |
| 2 | @LuluTechnology1 | UCPwCUeMO9EB-kFno2zKsm9w |
| 3 | @greentrainpodcast | UCJhUtNsR5pvU_gWWkxxUXUQ |
| 4 | @Teacher_Kong | UCpnBpREMjMNFvLTLnc2iLPQ |
| 5 | @applefans520 | UCCC_m0Lw7Z4IT6IjoPb0ZLg |
| 6 | @kocpc | UCcQA-MzQxCvET1S-BekQdAA |
| 7 | @panscischool | UCATnB3v_NkTTd9iD_4W2A-g |
| 8 | @apple-dad | UCt757ZhOr3vrvSxKT96b6vA |
| 9 | @rickhau99 | UCKMtbQbyhpBgyKaNX5vJUsw |
| 10 | @MeticsMediaChinese | UC7Qp52WIwke2P3l1Xh6k74Q |
| 11 | @AlanChen | UCaIIFXfdQUYf3OHPIFNDdrQ |
| 12 | @PH-WorkFlow | UCpXOvRzWW0lJhYrUeWBlNmA |
| 13 | @TuTu | UCuhAUKCdKrjYoMiJQc74ZkQ |
| 14 | @lichangzhanglaile | UC0v9b0Z00wWED_vGy-Q6ibg |
| 15 | @Macro_Alpha_cn | UC9oosAco7nIVZwuGhnC0FKg |
| 16 | @AIPractitioners123 | UCfMXQ45Ch5EnT2jokiHuysw |
| 17 | @SFReality | UCCzf5FvUaAurIuY-YGmWJyQ |
| 18 | @mage291 | UCG_qhxmgI1E0wO4x11TiI5w |
| 19 | @ami.moment | UCGs_cktFPCgN8ggJJVon84g |
| 20 | @TackyTechy | UC3YHFDbkHcqVxg4w20YYC7A |
| 21 | @martinz2025 | UC1HhvtQd_yTBJAGYNYffmSQ |
| 22 | @BizofFame | UCQT2N6N_Jay8nWS_0h7muyw |
| 23 | @Petersunreview | UCl9BPXjyEmA0q6IrQvsEazA |
| 24 | @techbang3c | UC9IyDJ6vlG50iYjXGQpwwOQ |
| 25 | @aaron-1215 | UCKHHtxWYOg15Gsrsa9ZDfrA |
| 26 | @talkspg | UCUa8Meh6_eFq7v1h_CCa9fQ |
| 27 | @AI-Short-Taipei | UClrAAcpCv06f4Z7hXo7SXiw |
| 28 | @digitalxu | UCGQPLvp98hRrzTG14AiTfUQ |
| 29 | @austinchou888 | UC3hsgc8SHJs1RDMEZBCAccA |
| 30 | @HarryLee | UCEA4ZfPzWDHp72mlq7IvUcw |
| 31 | @sensebar | UCI2YklLazU9tB_Kh_9nMpKA |

---

## AI 過濾關鍵字

AI、人工智能、ChatGPT、Claude、效率、自動化、automation、workflow、productivity、工作流、工具、tool、GPT、LLM、大模型

---

## 新增頻道 SOP

1. 取得頻道的 Channel ID（用戶提供 handle，我去查 ID）
2. 在 `fetch_rss.ps1` 的 `$channels` 陣列新增一行：
   ```
   @{h="@頻道handle"; id="UCxxxxxxxxx"},
   ```
3. 更新 `project_youtube_channels.md` 記憶檔，頻道數 +1
4. 更新本技能的頻道清單
5. 更新 `user_profile.md` 的技能數量（若有變動）

---

## 手動觸發摘要

在原視窗輸入（立即執行一次）：
```powershell
powershell -File "C:\Users\bymyw\.claude\scheduled-tasks\youtube-daily-digest\fetch_rss.ps1"
```

---

## 排查問題

| 問題 | 可能原因 | 解法 |
|------|----------|------|
| Telegram 沒收到 | 排程未執行 / Token 失效 | 手動觸發確認，檢查 Token |
| 某頻道沒出現 | Channel ID 錯誤 | 重新查詢正確 ID |
| 影片太多/太少 | 關鍵字過濾太嚴/太鬆 | 修改 `$AI_KEYWORDS` |

---

## 已排除頻道

- @Jelenas-zr3es：404 頻道不存在
- @applemei：與 @apple-dad 同一 Channel ID，已合併
