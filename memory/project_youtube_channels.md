---
name: YouTube 監測頻道清單
description: 每日 RSS 監測的 YouTube 頻道列表，用戶隨時會新增頻道
type: project
---

## 說明
- 每天早上 8:00 AM（台北時間）自動執行
- 過濾重點：AI 工具、效率工作法、自動化、Claude、ChatGPT
- 結果發送到用戶 Telegram
- 用戶隨時可新增頻道，更新後需同步更新 RemoteTrigger 設定

## 頻道清單（30 個，去除重複）

| 頻道 handle | Channel ID |
|------------|------------|
| @inspiredcanvas_m | UC17zrOCuDUXmtREyx9G2tCQ |
| @LuluTechnology1 | UCPwCUeMO9EB-kFno2zKsm9w |
| @greentrainpodcast | UCJhUtNsR5pvU_gWWkxxUXUQ |
| @Teacher_Kong | UCpnBpREMjMNFvLTLnc2iLPQ |
| @applefans520 | UCCC_m0Lw7Z4IT6IjoPb0ZLg |
| @kocpc | UCcQA-MzQxCvET1S-BekQdAA |
| @panscischool | UCATnB3v_NkTTd9iD_4W2A-g |
| @apple-dad（同 @applemei） | UCIpZAGl9xHcuzmHW0AAJs7g |
| @rickhau99 | UCKMtbQbyhpBgyKaNX5vJUsw |
| @MeticsMediaChinese | UC7Qp52WIwke2P3l1Xh6k74Q |
| @AlanChen | UCfB2JYduVCYdHcoxlEWGw4w |
| @PH-WorkFlow | UCpXOvRzWW0lJhYrUeWBlNmA |
| @TuTu | UCuhAUKCdKrjYoMiJQc74ZkQ |
| @lichangzhanglaile | UC0v9b0Z00wWED_vGy-Q6ibg |
| @Macro_Alpha_cn | UC9oosAco7nIVZwuGhnC0FKg |
| @AIPractitioners123 | UCfMXQ45Ch5EnT2jokiHuysw |
| @SFReality | UCCzf5FvUaAurIuY-YGmWJyQ |
| @mage291 | UCG_qhxmgI1E0wO4x11TiI5w |
| @ami.moment | UCGs_cktFPCgN8ggJJVon84g |
| @TackyTechy | UC3YHFDbkHcqVxg4w20YYC7A |
| @martinz2025 | UC1HhvtQd_yTBJAGYNYffmSQ |
| @BizofFame | UCQT2N6N_Jay8nWS_0h7muyw |
| @Petersunreview | UCl9BPXjyEmA0q6IrQvsEazA |
| @techbang3c | UC9IyDJ6vlG50iYjXGQpwwOQ |
| @aaron-1215 | UCKHHtxWYOg15Gsrsa9ZDfrA |
| @talkspg | UCUa8Meh6_eFq7v1h_CCa9fQ |
| @AI-Short-Taipei | UC1Ld3B4Y1NBam9BTk9tMThR |
| @digitalxu | UCGQPLvp98hRrzTG14AiTfUQ |
| @austinchou888 | UC3hsgc8SHJs1RDMEZBCAccA |
| @HarryLee | UCEA4ZfPzWDHp72mlq7IvUcw |
| @sensebar | UCI2YklLazU9tB_Kh_9nMpKA |

## 已排除
- @Jelenas-zr3es：404 頻道不存在
- @applemei：與 @apple-dad 同一 Channel ID，合併為一個

## RemoteTrigger 設定（待建立）
- Trigger ID：待填入
- 排程：0 0 * * *（UTC）= 每天 08:00 台北時間
- 輸出方式：Telegram
- 狀態：尚未執行，需正式建立排程
