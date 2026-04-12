---
name: 2/25-2/27 小龍蝦開機第一週完整分析
description: OpenClaw 系統初次啟動的完整對話紀錄，包含 Mac 新手入門、嘸蝦米、GCP 帳單轉移、Chrome 擴充安裝、模型選擇
type: project
---

## 概要

這是大樹教練啟動 OpenClaw 的**第一週**（2/25-2/27）。純安裝配置期，尚未進入日常自動化。
共 402 則訊息，扣除自動定時提醒後有意義對話 343 則。

---

## 設備與基礎環境

| 項目 | 內容 |
|------|------|
| 主機 | Mac mini 4，M4 晶片，16GB RAM，256GB SSD |
| 作業系統 | macOS（教練全新 Mac 新手，第一台 Mac） |
| 輸入法 | OpenVanilla + liu.cin（嘸蝦米），手動安裝成功 |
| 本地 LLM | Ollama 0.17.0（跑過 qwen3:8b, qwen2.5:7b，太慢後放棄） |
| Chrome 擴充 | OpenClaw Browser Relay 0.1.0，ID: galflniiolbjomadddgkfajfomijjgfa |
| 最終主模型 | `google/gemini-2.5-flash` |

---

## 完成的重要任務

### 2/25 — 初次啟動
- Telegram 配對成功（第一次 Pairing code: PL6HHV6R）
- 助教命名「龍蝦小助教」，教練自稱「大樹教練」
- 嘸蝦米輸入法安裝：手動將 .cin 放入 `~/Library/Application Support/OpenVanilla/UserData/OVIMGeneric/`

### 2/26 — 模型混亂期
- Google Gemini API rate limit 大量觸發（下午到深夜持續報錯）
- `gemini-2.0-flash-lite` 已下架（404 NOT_FOUND），系統降級到 Ollama 本地模型
- 確認 16GB RAM 跑 8B 本地模型速度太慢

### 2/27 — Chrome + GCP 帳單大工程
- Homebrew 安裝 Chrome
- OpenClaw Chrome 擴充安裝完成，Gateway Token 設定，瀏覽器出現「ON」狀態
- **GCP 帳單轉移**：
  - 舊帳戶 `011E24-402EDB-B8A7D2` 產生約 $15-16 美元費用
  - 將專案 `gen-lang-client-0583438899` 移轉至新 $300 免費試用帳戶 `018C05-870ED8-4EAF45`（約 NT$9,385）
  - 停止舊帳戶計費
- 系統崩潰後，教練執行 `rm -rf ~/.openclaw` 全部重裝
- 重新配對（第二次 Pairing code: Z6U5B4YX）
- 執行 `openclaw onboard`，重新建立 IDENTITY.md + USER.md

---

## 重要決策

1. **主模型選 `gemini-2.5-flash`**，不用最高階 `gemini-3-pro-preview`（成本考量）
2. **放棄本地 Ollama**，回歸雲端（16GB RAM 跑 8B 太慢）
3. **安裝 Chrome**：Safari 不支援 OpenClaw 擴充
4. **GCP 帳單轉移**：主動停止舊帳戶，改用新免費試用額度
5. **系統問題直接重裝**：`rm -rf ~/.openclaw` + 全部重新配置

---

## 失敗與教訓

| 失敗 | 原因 | 教訓 |
|------|------|------|
| Gemini rate limit 大爆 | 初期用最高階模型，配額一天耗盡 | 預設不應用最高階模型 |
| `gemini-2.0-flash-lite` 404 | 對新帳號已下架 | 切換模型前確認是否仍可用 |
| Ollama 太慢 | 16GB RAM 跑 8B 不夠 | 本地模型至少需 32GB，或用 4B 以下 |
| 嘸蝦米安裝 404 | 多個下載連結失效 | 事先備好 GitHub 直連備案 |
| 系統 `fetch failed` | 原因不明，Ollama kill 後 gateway 無法恢復 | 先嘗試 `openclaw start` 重啟，不輕易 rm -rf |

---

## 未完成事項

1. **Gmail 讀取設定** — 教練提出，腳本開始寫但因模型崩潰中斷
2. **GCP 費用監控警報** — 想設「剩 50% 時提醒」，未完成
3. **重裝後配置確認** — IDENTITY.md 和 USER.md 是否完整重建未確認

---

## 教練個人背景（首次留存）

- 台灣，時區 UTC+8，推測台南附近
- Mac mini 4 是第一台 Mac，完全零基礎
- 技術白手起家，解決問題能力強（嘸蝦米安裝自己搞定）
- 費用意識高：看到 $15 立刻想換便宜模型
- 目的：用 OpenClaw 做業務自動化，未來要教學員

**Why:** 這是小龍蝦系統的起點紀錄，對理解整套系統如何從零建立有重要參考價值
**How to apply:** 遇到初學者學員時，可參照教練第一週的踩坑路徑，提前預防
