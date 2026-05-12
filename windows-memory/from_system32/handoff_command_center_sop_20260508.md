---
name: 交接檔 — 指揮所 SOP（考古路線，2026-05-08 第二版）
description: 路線從「寫全新 SOP」改為「考古現有 relay + 補缺」；下次用「軍師，接續指揮所考古」喚醒
type: project
originSessionId: e3f4beeb-3f1c-4f5f-b1b3-597e7737bce4
---

# 交接內容：指揮所 SOP — 考古路線

## 📅 日期與狀態
- 第一版日期：2026-05-08（早上）— 路線：寫全新 SOP
- **第二版日期：2026-05-08（傍晚）— 路線改為「考古 + 補缺」**
- 改路線原因：開工前掃 repo，發現 `.clawhub/` + relay 腳本系統已存在
- 當前狀態：方向已二度確認，初稿尚未產出，原因是當日額度剩 4.92 元

---

## 🎯 核心目標（不變）

**讓教練不再當 AI 之間的人肉訊息搬運工。**

SOUL.md 第一章終極任務：「老闆動嘴，AI 全自動執行。」我們要把這句話落地。

---

## 🔍 重大發現（第二版核心）

`E:\Claude-Data\mac-openclaw-workflows` 裡已經有 12 個跨機通訊相關檔案，
詳見記憶 `project_clawhub_archaeology.md`。

**結論：不要從零寫新 SOP，要從考古開始。**

---

## 🚧 進度狀態（2026-05-08 晚間更新）

### ✅ A 階段完成：考古
- 讀完 4 份關鍵檔案（USER_GUIDE、SETUP、TASK_SHARED_QUEUE_RELAY、5/5 實際輸出）
- 考古報告已存成 `project_command_center_archaeology_report.md`
- 五大根因假設已寫好，最強假設是「relay 沒有 Windows 軍師大腦的位置」

### 🚧 B 階段待做：補缺（明天從這裡開始）
**直接看記憶 `project_command_center_archaeology_report.md` 的「第四節」，已有四步行動清單：**
1. 驗證假設 C：Mac 上 cron 是否在跑（最便宜、最關鍵）
2. 補軍師大腦的位置（給教練 A/B/C 三條路選）
3. 擴展 task type（軍師審 / 桌面版規劃 / 小龍蝦回報）
4. 寫端到端示範

---

## 🔑 關鍵注意事項（下輪必讀）

1. **絕對不要從零寫新 SOP**——會跟現有 relay 打架，浪費 token
2. **不要再讀今天讀過的 5 份檔**：SOUL.md、CLI_DIVISION.md、MACHINE_PATHS.md、HEARTBEAT.md、TEAM_IDENTITY.md
3. **先給教練看初稿再細修**，不要自己繞太久
4. **如果教練問模型為什麼燒得兇**，看 `feedback_model_assignment.md`，已有完整分析

---

## 🎙️ 下次對話喚醒口令

教練只需對新軍師大腦說：

> **「軍師，接續指揮所考古。」**

軍師會從本檔的「下輪對話直接開始這裡」第一步開始工作。

如果 4.92 元還夠用、教練想當下續做，也是這句喚醒——軍師會自動切到考古路線。
