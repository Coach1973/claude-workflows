# 多 Agent 群組通訊系統 - 進展報告

**日期**：2026-04-24
**作者**：克勞德助教（Claude Code）
**目標**：讓三台小龍蝦（Telegram Bot）在同一個群組內實現自主協作對話

---

## 一、系統架構

| # | 名稱 | Bot 帳號 | 服務對象 | 運行位置 |
|---|------|---------|---------|---------|
| 1 | 小龍蝦學長 | @openclaw_macbook4_bot | 大樹教練 | MacBook (~/.openclaw/) |
| 2 | 小龍蝦學妹 | @coachwu_lenovo_bot | 佩佩老師 | Mac mini (~/.openclaw-peipei/) |
| 3 | 小龍蝦學弟 | @CoachWu_openclaw_bot | 孔大哥 | Mac mini (~/.openclaw-kong/) |

**共享群組**：`頂級特助分工群`（Telegram Supergroup, ID: -1003877502911）

---

## 二、所嘗試過的方法

### 方法一：Telegram Bot API 直接呼叫（call_bot.sh）
**說明**：透過 Telegram Bot API 的 `sendMessage` 直接發訊息到群組，期望讓其他 bot 收到 @mention 後自動回覆。

**結果**：訊息可以發到群組，但其他 bot 收到後不會自動回覆。

**根本原因**：Telegram Bot API 的限制——bot 發出的訊息不會被其他 bot 接收。無法透過 @mention 觸發其他 bot 的回覆機制。

---

### 方法二：sessions_send + multi-agent-chat plugin（ClawHub 官方方案）
**說明**：參考 ClawHub 的 `multi-agent-chat` 插件（https://clawhub.ai/harven-droid/multi-agent-group-chat），透過 OpenClaw 內部的 `sessions_send` 工具，在不同 bot 之間傳遞任務，並由 plugin 自動將回覆轉發到群組。

**結果**：Plugin 已正確安裝在所有三台 bot，但學妹/學弟收到 sessions_send 任務後，回覆是否能被 plugin 自動轉發到群組——尚未完全確認。

**相關檔案**：
- Plugin 位置：`~/.openclaw/workspace/skills/multi-agent-group-chat/index.ts`
- 安裝至 peipei：`~/.openclaw-peipei/extensions/multi-agent-chat/`
- 安裝至 kong：`~/.openclaw-kong/extensions/multi-agent-chat/`

---

### 方法三：Relay 輪詢機制（共享檔案 + Cron Job）
**說明**：學長將任務寫入共享的 `BOT_RELAY.json`，學妹和學弟各自的 cron job 每分鐘輪詢一次，發現新任務就回覆到群組。

**結果**：Relay cron 已正常運作。學妹每分鐘檢查一次，無任務時輸出 `HEARTBEAT_OK`（不發言）。✅ 自言自語問題已解決。

**Relay 檔案位置**：`/Users/bymyway/.openclaw/workspace/shared-context/BOT_RELAY.json`

**格式**：
```json
{
  "ts": "2026-04-24T06:20:00.000Z",
  "messages": [
    {"id": "502", "bot": "2", "from": "1號機學長", "content": "任務內容"}
  ],
  "last_processed": {"1": "330", "2": "501", "3": "328"}
}
```

---

## 三、發現的問題

### 問題一：Bot 用戶名大小寫錯誤（根本原因）
**發現**：1號機 SOUL.md 的團隊表格中，Bot 用戶名從一開始就寫反了：
- 學妹應為 `@coachwu_lenovo_bot`，誤寫為 `@CoachWu_openclaw_bot`
- 學弟應為 `@CoachWu_openclaw_bot`，誤寫為 `@coachwu_lenovo_bot`

**影響**：學弟會以為自己是學妹，學妹也會被錯誤引導。

**狀態**：✅ 已修正（commit `9493579`）

---

### 問題二：agents.entries 不支援（嚴重錯誤）
**發現**：在 peipei 和 kong 的 `openclaw.json` 中錯誤地加入了 `agents.entries`（命名代理人），但 OpenClaw 版本不支援這個設定，導致兩台 bot 的 gateway 不斷崩潰重啟。

**錯誤訊息**：
```
Config invalid
File: ~/.openclaw-peipei/openclaw.json
Problem: agents: Unrecognized key: "entries"
```

**狀態**：✅ 已移除，三台 bot 現在正常運行

---

### 問題三：學妹和學弟不回覆群組 @提及
**現象**：教練在群組中說話，學長有回覆，但學妹和學弟完全沒有回應。

**分析**：
- 學妹設定了 `requireMention: true`，需要被 @ 才能回覆
- 學弟（kong）的 `dmPolicy: "allowlist"` 導致 `pairing required` 錯誤，Telegram 連線異常
- 學妹的 `dmPolicy: "allowlist"` 也有同樣的潛在風險

---

### 問題四：SOUL.md 的 SUPERGROUP-MAP 路徑不存在
**發現**：學妹和學弟的 SOUL.md 要求「啟動時讀取 `workspace/shared-context/SUPERGROUP-MAP.md`」，但這個路徑一開始根本不存在。

**狀態**：✅ 已建立並同步到 peipei 和 kong 的 workspace

---

## 四、目前已得到的成果

### ✅ 已修復且正常運作的項目
1. **Relay 自言自語問題已解決**：學妹和學弟的 cron job 在無新任務時輸出 `HEARTBEAT_OK`，不發言到群組
2. **Bot 用戶名已全部修正**：SUPERGROUP-MAP.md 中的三個 bot 用戶名已確認正確
3. **三台 bot 正常運行**：peipei（port 18793）、kong（port 18790）、學長（port 18791）均正常啟動
4. **multi-agent-chat plugin 已安裝**：所有三台 bot 均已啟用並載入
5. **學長的 team roster 已修正**：SOUL.md 中的團隊表格 Bot 用戶名已修正
6. **kong 的 multi-agent-chat plugin 已啟用**

### ⚠️ 尚待驗證的項目
1. **sessions_send + multi-agent-chat 的完整流程**：學長用 sessions_send 呼叫學妹/學弟後，回覆是否真的能自動轉發到群組
2. **學妹和學弟在 relay 任務觸發後的回覆機制**：是否能正確在群組發言

---

## 五、目前的通訊架構

### Relay 輪詢機制（目前主要依賴）
```
教練 → 1號機（在群組回覆）
教練/1號機 → BOT_RELAY.json（寫入任務）
                         ↓ 每分鐘
         學妹/學弟 cron job 讀取 → 回覆到群組
```

### sessions_send 機制（理論上可行，尚未完全確認）
```
教練 → 1號機（學長）
           ↓ sessions_send
     agent:main:telegram:group:-1003877502911
           ↓ multi-agent-chat plugin
     學妹/學弟 回覆 → 自動發到群組
```

---

## 六、相關設定檔位置

| 項目 | 路徑 |
|------|------|
| 學長 SOUL.md | `~/.openclaw/workspace/SOUL.md` |
| 學妹 SOUL.md | `~/.openclaw-peipei/workspace/SOUL.md` |
| 學弟 SOUL.md | `~/.openclaw-kong/workspace/SOUL.md` |
| 共享 SUPERGROUP-MAP | `~/.openclaw/workspace/shared-context/SUPERGROUP-MAP.md` |
| Relay 任務隊列 | `~/.openclaw/workspace/shared-context/BOT_RELAY.json` |
| 學妹 cron jobs | `~/.openclaw-peipei/cron/jobs.json` |
| 學弟 cron jobs | `~/.openclaw-kong/cron/jobs.json` |
| multi-agent-chat plugin | `~/.openclaw/workspace/skills/multi-agent-group-chat/` |

---

*報告完成（2026-04-24）*
*Cloud sync: GitHub commit `9493579` + 本地檔案同步*