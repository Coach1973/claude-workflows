---
name: 4/8-4/11 重要決策與成功經驗
description: 這段時間確立的重要技術決策、帳號分工、成功方案
type: project
---

## NotebookLM 帳號分工（確定，不可更改）
- `bymyway7` = **BNI 專屬**（留原地，大型筆記本不動，有共用連結不可搬）
- `seabiscuit` = **個人品牌**（搬移）
- 安全習慣：先備份上傳 Drive，再重建

**Why:** 搬錯過一次（原本反了），教練糾正後確立。共用連結的筆記本動了學員/夥伴連結就斷掉
**How to apply:** 提到 NotebookLM 操作時，先確認帳號再動手

---

## FB 生日私訊發送（成功方案）
- **棄用**：Claude Code 截圖模式（消耗百萬 Token，成本差 10 倍以上）
- **採用**：OpenClaw Browser Control **文字骨架/DOM 模式**（93K Token 完成全部）
- 操作：逐一找聯絡人 → 點訊息按鈕 → 輸入祝賀文字 → 發送

**Why:** 截圖模式每次都要重新渲染畫面，DOM 模式只讀文字結構，省錢且更穩定

---

## AI 模型 Fallback 策略（企業級流量漏斗）
優先順序：
1. **Gemini 3.1 Pro**（每日 250 次免費，高品質）
2. **Groq llama-3.3-70b**（免費額度，128k context）
3. **DeepSeek Chat**（免費額度，無每日次數限制）
4. **Claude Sonnet**（付費，餘額不足暫停中）

待執行根本解：把 Primary 改成 DeepSeek，Gemini 降為 Fallback（避免 Session Lock）

**Why:** Gemini 每日 250 次用完後，Session Lock 機制導致 Groq/DeepSeek 全部被擋

---

## Claude Code vs OpenClaw 分工（確立）
- **Claude Code（克勞德助教）**：系統除錯、設定檔修改、log 分析、深度技術工作（被動呼叫）
- **OpenClaw（小龍蝦助教）**：全天候 Telegram/LINE 常駐、自動化行政、定時提醒（主動運作）
- 銜接方式：Claude Code 修改設定 → 小龍蝦重啟生效 → 繼續對話

---

## 雙向同步機制（2026-04-11 確立）
Claude Code 與 OpenClaw 兩邊都要持有完整經驗庫：
- 中樞：**GitHub `Coach1973/mac-openclaw-workflows`**
- 任何一邊學到新東西 → 立刻寫入記憶 → 推送 GitHub → 另一邊同步讀取
- 這樣不管教練從哪邊進入，都不用重新教
