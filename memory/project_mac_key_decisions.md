---
name: Mac 端重要決策與成功經驗（4/8-4/11）
description: 從 GitHub mac-openclaw-workflows 同步的重要技術決策、帳號分工、模型策略
type: project
---

## 雙向同步機制（2026-04-11 確立）

- 中樞：GitHub `Coach1973/mac-openclaw-workflows`（私有 Repo）
- 任何一邊學到新東西 → 立刻寫入記憶 → 推送 GitHub → 另一邊同步讀取
- 讓教練不管從哪邊進入，都不用重新教

## NotebookLM 帳號分工（確定，不可更改）

- `bymyway7` = **BNI 專屬**（留原地，大型筆記本不動，有共用連結不可搬）
- `seabiscuit` = **個人品牌**（搬移）
- 安全習慣：先備份上傳 Drive，再重建

**Why:** 搬錯過一次（原本反了），教練糾正後確立。共用連結的筆記本動了學員/夥伴連結就斷掉。
**How to apply:** 提到 NotebookLM 操作時，先確認帳號再動手。

## Claude Code vs OpenClaw 分工（確立）

| 維度 | Claude Code（克勞德助教）| OpenClaw（小龍蝦助教）|
|------|------------------------|----------------------|
| 使用方式 | 坐在電腦前，終端機 | 手機 Telegram，隨時隨地 |
| 運作模式 | 被動呼叫 | 全天候常駐 |
| 適合任務 | 深度程式開發、設定修改、log 分析 | 自動化行政、定時提醒、瀏覽器操作 |

銜接方式：Claude Code 修改設定 → 小龍蝦重啟生效 → 繼續對話

## Browser Control DOM 模式（技術突破）

- **舊方式（截圖模式）**：每次渲染整個畫面 → 百萬 Token，成本極高
- **新方式（DOM/文字骨架模式）**：只讀 HTML 結構 → 93K Token 完成全部
- **成本差距：10 倍以上**
- 結論：凡瀏覽器任務，一律 DOM 模式，嚴禁截圖模式

## AI 模型 Fallback 策略（Mac 端）

優先順序：
1. Gemini 2.5 Flash（每日 250 次免費，高品質）
2. Groq llama-3.3-70b（免費額度，128k context）
3. DeepSeek Chat（免費額度，無每日次數限制）
4. Claude Sonnet（付費，餘額不足暫停中）

注意：Gemini 每日 250 次用完後，Session Lock 機制導致 Groq/DeepSeek 全部被擋。
根本解：把 Primary 改成 DeepSeek，Gemini 降為 Fallback。

## 最省力方案優先（4/10 NotebookLM 案例學到）

遇到工程浩大的任務，先提出「最省力方案」再執行。
案例：107 個筆記本不用搬，直接對調帳號定位——逆向思考遠勝線性執行。

## 已完成的重要任務（4/8-4/11，Mac 端）

1. 每週四 11:55 執董週會提醒 — 已設定運作
2. Gmail 批次已讀（銀行帳單、Zoom 登入、電子報）
3. Facebook 生日私訊 — DOM 模式成功發送 5 人
4. NotebookLM 107 個筆記本分類完成
5. GitHub Repo `mac-openclaw-workflows` 建立並首次 push
6. Groq + DeepSeek API 接入完成
7. FB 生日祝福排程化（subagent 每日執行）

## Mac 端待辦事項（未完成）

1. YouTube 頻道監測 Mac 版排程（Mac 每天 08:00 推播尚未建立）
2. YouTube 首頁自動招募機制（白嫖演算法，方案有但未實裝）
3. Obsidian 第二大腦懶人包（教練詢問是否執行，尚未執行）
4. NotebookLM 搬家確認（腳本啟動但未確認全部完成）
5. Kimi API（台灣無法申請，需大陸朋友代申請）
6. DeepSeek Session Lock 根本解（把 Primary 改成 DeepSeek）
