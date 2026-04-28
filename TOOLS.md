# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

## What Goes Here

Things like:

- Camera names and locations
- SSH hosts and aliases
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- Anything environment-specific

## Examples

```markdown
### Cameras

- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered

### SSH

- home-server → 192.168.1.100, user: admin

### TTS

- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod
```

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.

---

## 💻 終端機家族（2026-04-22 更新）

| 代號 | 位置 | 狀態 | API 額度 |
|------|------|------|---------|
| **終端機 1 號** | Mac mini | 🟢 使用中 | MiniMax 年度合約流量（Hermes） |
| **終端機 2 號** | 宏碁 Acer（行動專機） | ⏸️ 暫停使用 | 無（外出專用） |

### Hermes（MiniMax CLI）
- **位置**：~/.local/bin/hermes
- **版本**：v0.10.0
- **額度**：MiniMax 年度合約，充沛可用
- **配置文件**：~/.hermes/hermes-agent

---

## VPS 系統資訊

- **IP**：43.245.60.200
- **SSH 標準指令**：`sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200`
- **重要**：OpenClaw 跑在 Docker 容器內，容器名稱為 `openclaw`

### VPS 指令正確格式

❌ 錯誤（會報 command not found）：
```bash
ssh root@43.245.60.200 "openclaw [指令]"
```

✅ 正確（透過 docker exec 進容器執行）：
```bash
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 \
  "docker exec openclaw openclaw [指令]"
```

### 常用 VPS 指令

**批准新用戶配對：**
```bash
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 \
  "docker exec openclaw openclaw pairing approve telegram [配對碼]"
```

## 🗣️ 語音指令對照表（中文 → 指令行動）

> 教練專用。只要說中文，小龍蝦就知道要做什麼。

### 檔案讀取指令

| 教練說的中文 | 小龍蝦讀取的檔案 | 用途說明 |
|-------------|-----------------|---------|
| 讀靈魂檔案 | SOUL.md | 我的核心價值觀、行為原則、說話風格 |
| 讀用戶檔案 | USER.md | 大樹教練的基本資料、習慣、偏好 |
| 讀代理手冊 | AGENTS.md | 我的工作規範、溝通原則、做事方式 |
| 讀心跳檔案 | HEARTBEAT.md | 最近對話摘要、系統狀態、待追蹤事項 |
| 讀每日摘要 | DAILY_DIGEST.md | 當日重要進度、重啟後第一個熱上下文 |
| 讀交接檔案 | HANDOFF.md | 三臺電腦（三個助教）之間的工作交接 |
| 讀長期記憶 | MEMORY.md | 經過整理的永久記憶，包含重要決策 |
| 讀記憶庫 | memory/YYYY-MM-DD.md | 每日流水帳，按日期搜尋關鍵字 |
| 讀核心手冊 | WISDOM_CORES.md | 所有規則、禁忌、系統設計的精華集 |
| 讀工具設定 | TOOLS.md | 密碼、IP、伺服器資料等環境設定 |

### 動作執行指令

| 教練說的中文 | 小龍蝦做的事 |
|-------------|-------------|
| 幫我找 XXX | 網頁搜尋 | 「幫我找 XXX」→ 立即搜尋網頁，不需任何確認 |
| 搜尋 / 找資料 | 在記憶庫裡搜尋關鍵字 | |
| 去讀 / 讀取 | 讀取指定檔案的內容 | |
| 執行 / 去做 | 立刻開始執行任務 | |
| 備份 / 存起來 | 將修改 commit + push 上 GitHub | |
| 更新 | 把新內容寫入指定檔案 | |
| 確認進度 | 任務做到哪了，馬上回報 | |
| 設定提醒 | 建立 cron 自動排程任務 | |

### 🌐 技術名詞解釋（中文對照）

| 英文 | 中文意思 | 實務解釋 |
|------|---------|---------|
| **GitHub** | 全球程式碼倉庫 | 雲端硬碟，放設定檔、腳本、記憶檔。備份到這裡，Mac 壞了資料還在。 |
| **Pull** | 拉取同步 | 從 GitHub 抓最新版本下來（「去雲端下載最新進度」） |
| **Push** | 推送上傳 | 把本地修改上傳到 GitHub（「把最新進度存到雲端」） |
| **Commit** | 提交確認 | 就像「按儲存」，把这次修改當成一個版本記錄下來。 |
| **Branch** | 分支 | 同一份檔案的不同版本線路。 |
| **Merge** | 合併 | 把不同分支的內容合成在一起。 |

---

## 🏠 網路與電話緊急聯絡

| 項目 | 電話 | 用途 |
|------|------|------|
| 臺灣固網維修 | 06-2718958 | 網路故障報修 |

> 教練的 Mac mini 目前使用有線網路，若未來網路中斷可撥打此電話。

---

## 雲端儲存服務

### InfiniCloud（iStorage）
- **用途**：20GB 網路硬碟空間
- **申請網址**：https://infini-cloud.net/en/modules/mypage/usage/
- **帳號**：bymyway7
- **密碼**：bymwyay7
