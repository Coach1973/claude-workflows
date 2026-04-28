# 血淚後記：Grok vs 克勞德 交叉驗證過程（2026-04-28）

> **核心教訓：不要用「推理」代替「看檔案」。**

---

## 事件經過

教練把 Grok 提供的「記憶修復方案」拿來請克勞德評估。
克勞德第一輪直接否定所有內容，說全部是幻覺。
Grok 反駁，提出具體文件連結和 YouTube 影片。
最終實際執行驗證，發現**克勞德部分判斷錯誤，Grok 部分說對了**。

---

## 最終驗證結果

### Grok 說對的（克勞德錯誤否認）

| Grok 的主張 | 實際結果 |
|-------------|---------|
| `openclaw memory index --force` 存在 | ✅ 真實存在，執行成功 |
| `openclaw memory status` 存在 | ✅ 真實存在 |
| `/dreaming` 是真實功能（memory-core 提供）| ✅ 存在，預設關閉 |
| `openclaw plugins install` 存在 | ✅ 真實存在 |
| Memory Wiki 插件存在 | ✅ 存在，預設 disabled |
| `DREAMS.md` 架構存在 | ✅ 系統內有 dream corpus 路徑 |
| `docs.openclaw.ai` 是真實網址 | ✅ CLI help 頁面本身引用此網址 |

### Grok 說錯的

| Grok 的主張 | 實際結果 |
|-------------|---------|
| `--link` 用於安裝 GitHub URL | ❌ `--link` 是連結本地路徑，不是 GitHub URL |
| `win4r/lossless-claw-enhanced` 是可靠插件 | ⚠️ 來源不明，無法驗證，有安全風險 |
| 「召回率從 56% 直接拉到 100%」| ❌ 誇大，無法量化成這種形式 |
| `/dreaming on` 是正確指令格式 | ❌ 正確格式需透過 config 或 runtime 啟用 |

---

## 克勞德犯的錯誤

**根本原因：用「推理這個功能應該不存在」代替「實際查看系統檔案」。**

克勞德看到 `/dreaming on` 這樣的指令，推斷「Claude Code 沒有 dreaming 機制」就否定了。
但克勞德沒有先跑 `openclaw --help` 或 `openclaw memory status` 確認。

正確的驗證流程應該是：
1. 先跑指令確認存不存在，再下結論
2. 「聽起來像幻覺」不等於「確定是幻覺」
3. 對方有具體指令名稱時，30秒內就能實際測試

---

## 正確的交叉驗證 SOP

當收到任何 AI 提供的「系統操作方案」時：

```
1. 先不表態（不說「正確」也不說「幻覺」）
2. 把指令在實際系統上跑一遍
3. 對照結果再說話
4. 若部分對部分錯，分開說，不要整包否定或整包接受
```

**一句話原則：對自己不確定的系統，先查再說，不要靠推理下判斷。**

---

## 為什麼 Grok 說對了部分內容？

Grok 使用即時搜尋工具，可以查到 OpenClaw 的官方文件和 GitHub。
克勞德沒有即時搜尋，但有直接讀取你電腦檔案的能力。

這兩個能力是互補的，不是競爭的：
- Grok 擅長：查網路上的最新文件、功能介紹
- 克勞德擅長：讀你電腦上的實際設定、修改真實檔案、測試執行結果

**最佳策略：用 Grok 找方向，用克勞德實際執行與驗證。**

---

## 今天實際完成的修復（驗證後才動手）

1. ✅ Bootstrap 自動注入 HEARTBEAT.md
2. ✅ Context overflow 分級預警 hook（message:preprocessed）
3. ✅ Dreaming 每日蒸餾（light + deep + rem 三階段）
4. ✅ Active Memory plugin 啟用
5. ✅ Startup 自動載入7天記憶
6. ✅ Gemini 向量搜尋，召回率 10/10 = 100%

---

*記錄人：克勞德助教 | 日期：2026-04-28*
