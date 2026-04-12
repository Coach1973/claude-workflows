---
name: 頂級特助防失憶完整架構（部署必讀）
description: 2026-04-12 確立的完整防失憶機制：30分鐘備份+HEARTBEAT熱上下文+重啟後繼續的全套設計，以及常見失誤診斷
type: project
---

## 核心洞見（教練 2026-04-11/12 親身踩坑總結）

> 「備份有做、記錄有存，但重啟後沒有『現在在哪裡』——這就是失憶感的根源。」

系統設計必須區分兩件事：
1. **長期記憶**（memory/*.md）：全量對話紀錄，供事後回溯
2. **熱上下文**（HEARTBEAT.md）：「現在在做什麼」，供重啟後立即接手

兩者缺一不可。只有長期記憶，沒有熱上下文 → 重啟後看著 124KB 大檔不敢讀 → 失憶。

---

## 完整防失憶架構（四層）

```
Layer 1：每 30 分鐘
  sync-telegram-memory.sh  →  memory/YYYY-MM-DD.md  →  GitHub

Layer 2：每次完成任務
  小龍蝦更新 HEARTBEAT.md「上次對話摘要」區塊（<500字）→ Git push

Layer 3：Context Overflow 觸發
  sync --force → memory/今天.md 緊急存檔 → 更新 HEARTBEAT → 重啟 gateway

Layer 4：重啟後第一件事
  讀 HEARTBEAT.md → 告訴教練「重啟完成，繼續 [摘要主題]」
```

---

## 關鍵檔案與職責

| 檔案 | 大小限制 | 職責 |
|------|----------|------|
| `HEARTBEAT.md` | **必須 <5KB** | 熱上下文：現在在做什麼、系統狀態、重啟守則 |
| `memory/YYYY-MM-DD.md` | 可以很大 | 長期備份：全量對話紀錄（只用來回溯，不在心跳讀） |
| `IDENTITY.md` | — | 行為守則，含第26條防失憶規則 |
| `USER.md` | — | 教練個人資料（絕對不能空白！） |

---

## HEARTBEAT.md 正確結構（模板）

```markdown
# HEARTBEAT.md — 熱上下文

## ⚡ 系統狀態
- Primary 模型：[當前模型]
- 備援順序：[列出]

## 📌 上次對話摘要（重啟後第一件事：讀這裡）
> 最後更新：YYYY-MM-DD HH:MM
> 最近完成：[3句話]
> 目前進行中：[1-2項]
> 教練狀態：[滿意/等待/有疑問]

## 🔴 重啟後行動規則
[固定守則]

## ⚠️ 永久守則
[固定守則]
```

---

## 部署新機器的必做清單

新機器安裝完 OpenClaw 後，必須在 workspace/ 確認：

- [ ] `HEARTBEAT.md` 存在且有「上次對話摘要」區塊
- [ ] `USER.md` 已填入用戶姓名、稱呼、Telegram Chat ID、設備、溝通偏好
- [ ] `IDENTITY.md` 第26條防失憶規則存在
- [ ] `scripts/sync-telegram-memory.sh` 存在且可執行
- [ ] `scripts/parse-session.py` 存在
- [ ] LaunchAgent `ai.openclaw.memory-sync.plist` 已載入（每 1800 秒）
- [ ] `scripts/.sync-checkpoint.json` 存在（初始值：`{"file":"","line":0}`）
- [ ] workspace 是 git repo 並已設定 remote（GitHub 備份）

---

## 常見失誤診斷

### 症狀：「小龍蝦好像失憶，不記得昨天說的話」
**根因**：HEARTBEAT.md 沒有「上次對話摘要」，或摘要是空的
**修法**：更新 HEARTBEAT.md，加入昨天的進度摘要（<500字）

### 症狀：「備份有做，但重啟後還是失憶」
**根因**：memory/*.md 太大（>50KB），Gemini 讀了會空白回應
**修法**：禁止心跳讀大型 memory 檔；只靠 HEARTBEAT.md 傳遞熱上下文

### 症狀：「USER.md 是空的，小龍蝦不認識教練」
**根因**：USER.md 從未填寫（OpenClaw 預設是空模板）
**修法**：必須在安裝時立即填入用戶資料

### 症狀：「30分鐘備份沒在跑」
**根因**：LaunchAgent 沒載入，或 .sync-checkpoint.json 指向舊 session
**診斷**：`launchctl list | grep openclaw`；看 checkpoint 的 file 路徑是否是當前 session
**修法**：`launchctl load ~/Library/LaunchAgents/ai.openclaw.memory-sync.plist`

---

## 設計哲學（給未來開發者）

**Why:** 教練 2026-04-11 建立了30分鐘備份機制，第二天仍感覺失憶。追查後發現：
備份是存的，但 HEARTBEAT.md 沒有「現在在做什麼」的摘要。
就像一個人每天寫日記，但醒來從不讀日記——記錄存在，但沒有「讀」的動作。

**How to apply:** 
部署新的頂級特助系統時，先確保這四層全部到位，再交給用戶。
缺任何一層，用戶就會在某個早晨感覺助理「忘了所有事」。
