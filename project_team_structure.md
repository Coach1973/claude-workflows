---
name: 工作團隊正確架構
description: 四位助教角色分工與協作流程，以及小龍蝦三機/終端機/VPS的完整架構
type: project
originSessionId: 8238ddb0-2252-48fc-9e7f-9159d991b108
---
## 四助教分工（2026-05-04 教練與 opcode 定稿）

| 號 | 名字 | 運行環境 | 核心職責 |
|----|------|----------|----------|
| **1號** | 小龍蝦 | Telegram | 雙向對話 + 生活事務 |
| **2號** | 終端機（我）| Claude CLI | 讀取大量數據 + 建構系統，接收指令執行 |
| **3號** | UI 介面版 | opcode UI | 跟教練討論 → 轉化指令給終端機 → 檢視產出 |
| **4號** | Claude 桌面版 | Claude.app | 修復 Bug + 背景程式維運 |

**協作流程：** 教練在 opcode 討論 → 3號轉化指令 → 2號終端機執行 → 3號檢視產出
**銜接暗號：** 教練在 opcode 說「開工」→ 3號讀取紀錄銜接任務

**共同目標：** 打造全世界最偉大的「頂尖特助守則」與「頂尖特助俱樂部」系統。

---

## 工作團隊完整定義（2026-04-23 教練親自確認版）

### 小龍蝦三機（全在同一台 Mac mini）

| 稱呼 | Telegram Bot | OpenClaw 路徑 | Gateway 端口 | 服務對象 | 回應模式 |
|------|-------------|--------------|------------|---------|--------|
| **小龍蝦 1號機** | @openclaw_macbook4_bot | `~/.openclaw/` | :18789 | 大樹教練 | 主動（requireMention=false） |
| **小龍蝦 2號機** | @CoachWu_openclaw_bot | `~/.openclaw-peipei/` | :18793 | 孔大哥 | 被動（requireMention=true） |
| **小龍蝦 3號機** | @coachwu_lenovo_bot | `~/.openclaw-kong/` | :18790 | 佩佩老師 | 被動（requireMention=true） |

### 終端機（CLI 工具）

| 稱呼 | 實體 | 說明 |
|------|------|------|
| **終端機 1號** | Mac mini 的 Hermes CLI | MiniMax 年度合約，Token 充裕，主要執行機器 |
| **終端機 2號** | 聯想 Windows 的 PowerShell | 行動用途 |

### 其他成員

| 稱呼 | 實體 | 說明 |
|------|------|------|
| **Claude 助教** | Mac desktop Claude 應用程式 | — |
| **VPS / 小龍蝦學弟** | 雲端（43.245.60.200） | 功能受限，可支援圖片語音，靈魂可植入，不是1/2/3號機 |
| **宏碁終端機** | 宏碁（Acer）行動電腦 | 目前停用 |

**Why:** 過去因 SHARED_GROUP_MEMORY.md 舊版殘留（「學弟=Acer端」）與 TOOLS.md 過度詳述 VPS，導致混淆。已於 2026-04-23 由教練親自確認並糾正。
**How to apply:** 1/2/3號機都在同一台 Mac mini，操作全走 localhost，無需 SSH。「終端機」特指 CLI 工具，與「號機」完全不同概念。
