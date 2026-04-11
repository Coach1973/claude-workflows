# 偉大任務：讓任何老闆只要動嘴，AI 全自動工作

> 作者：大樹教練（吳大樹）
> 記錄者：Claude 助教 + 小龍蝦助教
> 開始日期：2026-02

---

## 🎯 最終目標

**一句話版本**：
讓沒有任何工程師背景的中小企業老闆，只要用語音說話，就能享受跟頂尖工程師一樣的 AI 自動化工作流程。

**具體樣貌**：
- 早上說「幫我看一下今天的重要郵件」→ 小龍蝦自動篩選、摘要、推送 Telegram
- 說「整理一下 BNI 的筆記本」→ 自動分類、搬移、報告結果
- 說「今天有哪些 YouTube 值得看」→ 自動掃描 31 個頻道、篩選、推送精華

---

## 📖 血淚史：從零到系統的踩坑全記錄

### 第一章：開機第一週（2026-02）

**踩的坑**：
- Mac mini 對新手完全陌生，連基本操作都要學
- 嘸蝦米輸入法安裝困難
- Ollama 本地模型跑不動（硬體不夠）
- GCP 帳單轉移耗時費力

**花的代價**：至少一週時間，全是基礎設定

**學到的**：本地模型不實際，雲端 API 才是正解

---

### 第二章：小龍蝦上線初期（2026-02 ~ 03）

**踩的坑**：
- Chrome 擴充安裝方式不直覺
- 模型選擇沒有依據，憑感覺亂試
- 不知道系統提示會吃掉大量 Token

**花的代價**：多次重複設定，反覆試錯

**學到的**：要先確認模型的 TPM（每分鐘 Token 上限）再選

---

### 第三章：Groq 限流災難（2026-04-08 前後）

**踩的坑**：
- 把 Groq 設為 Primary 模型
- 小龍蝦系統提示約 57,000 tokens
- Groq 上限 12,000 TPM → 永遠 413 錯誤
- 花了大量時間以為是其他問題

**花的代價**：半天時間、無數次重試

**學到的**：
- 接入新模型前，先確認 TPM 上限
- Groq 只能跑小任務，不能當 Primary

---

### 第四章：Session Lock 迷宮（2026-04-11 上午）

**踩的坑**：
- 錯誤訊息：`All models failed: Live session model switch requested: xxx (unknown)`
- 以為是模型問題，換了又換
- 其實是 JSONL 鎖死，只清 sessions.json 不夠
- JSONL 還在，gateway 就會從裡面恢復鎖定狀態

**花的代價**：2+ 小時，試了 DeepSeek、Groq、xAI 都沒用

**正確解法（花 5 分鐘）**：
```bash
# 1. 刪 JSONL + 清 sessions.json
# 2. 清 auth cooldown
# 3. 重啟 gateway
```

**學到的**：永遠要刪 JSONL，不只是清 sessions.json

---

### 第五章：記憶失憶問題（2026-04-11 下午）

**踩的坑**：
- AGENTS.md 規定啟動時讀 `memory/YYYY-MM-DD.md`
- 但 `memory/` 目錄從未被建立
- 小龍蝦每次都說「今日記憶不存在」是真的
- 結果每次重啟都是完全失憶狀態

**花的代價**：多次重複交代同樣的事、小龍蝦搞錯帳號

**正確解法（一行指令）**：
```bash
mkdir -p /Users/bymyway/.openclaw/workspace/memory/
```

**學到的**：AGENTS.md 說的東西要逐項驗證，不能假設都已設定好

---

### 第六章：Context Overflow 與記憶銜接（2026-04-11 下午）

**教練發現的關鍵問題**：
> 「如果半小時還沒到，對話框就滿了，中間那段不就遺失了？」

這個問題觸發了整個書籤機制的設計。

**最終解法**：
- 書籤記錄「哪個檔案存到哪一行」
- 溢出時從書籤接著存到最後一行
- 換新 session 時書籤自動歸零
- 結果：任何情況下都零遺漏

---

## 🏗️ 最終建立的系統架構

```
教練（語音/文字）
    ↓
Telegram → 小龍蝦助教（執行層）
    ↓ 出問題
Claude Code → Claude 助教（診斷層）
    ↓ 修復完
memory/ + HEARTBEAT + GitHub（記憶層）
    ↓ 下次啟動
小龍蝦讀記憶 → 無縫繼續
```

### 五條備援模型線路
```
Primary:    Gemini 3.1 Pro（繁體中文穩定）
Fallback 1: OpenRouter Nemotron 120B（免費）
Fallback 2: OpenRouter Gemma 31B（免費）
Fallback 3: SambaNova Llama 70B（免費，超快）
Fallback 4: Cerebras Qwen 235B（免費）
Fallback 5: Claude Sonnet（保底）
```

### 自動化守護機制
| 機制 | 頻率 | 功能 |
|------|------|------|
| session-fix | 每 2 分鐘 | 偵測 Session Lock + Context Overflow |
| memory-sync | 每 30 分鐘 | 把 Telegram 對話存入記憶 |
| heartbeat | 每 90 分鐘 | 系統健康檢查 + 刷新記憶 |
| HEARTBEAT.md | 每次心跳 | 即時上下文，告訴小龍蝦現在做什麼 |

---

## 📦 給下一個人的複製清單

想要複製這套系統，需要做的事（按順序）：

**第一步：基礎設定**
- [ ] 安裝 OpenClaw
- [ ] 申請 OpenRouter API key（免費，27個免費模型）
- [ ] 申請 SambaNova API key（免費）
- [ ] 申請 Cerebras API key（免費）
- [ ] 設定 Telegram Bot

**第二步：建立記憶體系**
- [ ] `mkdir -p ~/.openclaw/workspace/memory/`
- [ ] 建立今日 `memory/YYYY-MM-DD.md`
- [ ] 更新 HEARTBEAT.md

**第三步：安裝自動化守護**
- [ ] 安裝 session-fix LaunchAgent（每 2 分鐘）
- [ ] 安裝 memory-sync LaunchAgent（每 30 分鐘）
- [ ] 安裝 heartbeat LaunchAgent（每 90 分鐘）

**第四步：驗證**
- [ ] 發 Telegram 訊息，確認小龍蝦回中文
- [ ] 確認 `memory/` 有今日日誌
- [ ] 確認 GitHub 有備份

**不需要做的事（踩過坑了）**：
- ❌ 不要用 Groq 當 Primary
- ❌ 不要假設 memory/ 目錄已存在
- ❌ 遇到 Session Lock 只清 sessions.json 是不夠的
- ❌ Cerebras 的 apiKey 不能只放 auth-profiles，要進 models.json

---

## 💡 給未來自己的話

「你花的每一分鐘困惑，都是下一個人省下的一小時。
這不是血淚史，是使用手冊的第一稿。」
