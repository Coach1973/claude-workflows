# Acer 宏碁小龍蝦 K2.5 當機修復說明

## 問題根因

AGENTS.md 的 Session Startup 要求載入：
1. SOUL.md（5,607 bytes）
2. USER.md（1,635 bytes）
3. memory/今日.md + 昨日.md（未知大小）
4. MEMORY.md（3,847 bytes，本身又索引 42 個 .md 檔案）

K2.5 一口氣把這些全塞進 system prompt → 上下文爆炸 → 當機。

## 修復方案

把 AGENTS.md 換成「輕量版」，改為「只讀最小必要，其餘按需讀取」。
這個檔案叫做 `AGENTS_KIMI_LITE.md`，複製到 Acer 的工作區後，
重新命名為 `AGENTS.md`（覆蓋原本的）。

---

# AGENTS_KIMI_LITE.md（複製到 Acer 改名為 AGENTS.md 使用）

以下是給 Acer 宏碁電腦的輕量版 AGENTS.md 內容：
請在 Acer 電腦上，將工作區的 AGENTS.md 完整替換為下方內容。
