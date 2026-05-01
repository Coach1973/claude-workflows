# LINE_MASTER_GUIDE.md — 終端機一讀就能上手的 LINE 完全指南

> 整合來源：feedback_line_webhook_route_loss_fix / TEAM_IDENTITY / CLIENT_PROFILE / daily_2026-04-28
> 最後更新：2026-05-01

---

## 一、架構定位（重要：LINE ≠ 獨立實例）

LINE 頻道與 Telegram 共用同一個 1號機 OpenClaw 實例：

```
~/.openclaw/openclaw.json       ← 同一份設定檔
  channels.telegram             ← Telegram 頻道
  channels.line                 ← LINE 頻道（同一 agent 處理）
  
~/.openclaw/workspace/          ← 共用 workspace
  SOUL.md                       ← LINE 和 Telegram 共用同一份
  LINE_SOUL.md                  ← LINE 版專屬靈魂（供未來獨立部署用）
  LINE_CORE_RULES.md            ← LINE 版專屬守則
  TEAM_IDENTITY.md              ← 三機共用守則（含 LINE 媒體鐵律）
```

**部署策略**：LINE 目前與 Telegram 共用主 SOUL.md。LINE_SOUL.md 用途：
1. 未來若 LINE 獨立為另一 agent，直接使用
2. 終端機可將 LINE 專屬規則合併進主 SOUL.md 的條件分支

---

## 二、LINE 頻道設定

| 項目 | 值 |
|------|-----|
| 設定檔 | `~/.openclaw/openclaw.json` |
| Channel Access Token | `nmB7+t+MXR38yNkf95GdwZrZs2mlh5S9qz9GvsbBiI4N4/GeIx7v9aQZ31B+1pXCCT47LGgsd1uoiFVmnwwtmXdSQl9j/ZlnjlRPGkREPAptuYzxc2tDUHsTmCWP1iw6JHcPqmnFvaxwVRYdboP8KAdB04t89/1O/w1cDnyilFU=` |
| Channel Secret | `61cd4f1212b0135f69b84044e9cfa46d` |
| Webhook 路徑 | `/line/webhook` |
| DM 政策 | `pairing`（需配對碼） |
| 群組政策 | `open` |
| 教練 LINE ID | `U895a0ad8e49d75f8303dc3d067282dc0` |

---

## 三、LINE 版獨有能力

| 能力 | 狀態 | 備註 |
|------|------|------|
| 文字對話 | ✅ 正常 | 一對一 + 群組 |
| 圖片生成 | ✅ 已開通 | 必須輸出 HTTPS URL |
| 音樂生成 | ✅ 已開通 | 有時不穩定，繼續觀察 |
| 群組記事 | ✅ 正常 | 行程/會議/待辦皆可 |
| 主動推播 | ❌ 不支援 | 只能被動響應 |
| 操作本機電腦 | ❌ 不支援 | LINE 無 exec 能力 |
| Token 成本回報 | ❌ 不支援 | 無 session_status |

---

## 四、媒體傳送鐵律（違反會導致圖片無法顯示）

LINE API 無法存取本機路徑，**所有媒體必須使用公開 HTTPS URL**：

```
本機路徑 → 公開 URL 轉換規則：

/Users/bymyway/.openclaw/media/  →  https://media.bymyway.com/
~/.openclaw/media/               →  https://media.bymyway.com/

範例：
❌ /Users/bymyway/.openclaw/media/tool-image-generation/image-1.png
✅ https://media.bymyway.com/tool-image-generation/image-1.png
```

呼叫 message 工具的 `media` 參數時，**只能填入以 `https://` 開頭的公開 URL**。

---

## 五、Webhook 路由遺失修復記錄（2026-03-16）

**症狀**：LINE 只回應第一則訊息，之後無回應。

**根本原因**：`loadOpenClawPlugins` 非同步觸發 LINE provider 的 abort signal → `stopHandler()` → `unregisterHttp()` 將 `/line/webhook` 從路由表移除。第二則訊息到達時路由表已空。

**已修復位置**：
```
/opt/homebrew/lib/node_modules/openclaw/dist/registry-DtTKJfN8.js
```
在 `setActivePluginRegistry` 中寫入 `globalThis[Symbol.for("openclaw.persistentHttpRoutes")]`。

**⚠️ 重要**：OpenClaw 更新後此 patch 會被覆蓋，需重新手動套用。

---

## 六、已完成的 LINE 相關工作（歷史記錄）

| 時間 | 工作內容 | 結果 |
|------|----------|------|
| 2026-03-16 | Webhook 路由遺失 bug 修復 | ✅ 正常回應多則訊息 |
| 2026-04-12 | LINE 自動化開發策略確立（OPE + 半自動原則）| ✅ 策略定案 |
| 2026-04-28 | 圖片生成功能開通測試 | ✅ 可生成（需 HTTPS URL）|
| 2026-04-28 | 音樂生成功能測試 | ⚠️ 部分成功，持續觀察 |
| 2026-04-28 | 群組記事功能啟動（新書發表/行程記錄）| ✅ 正常運作 |
| 2026-05-01 | LINE_SOUL.md + LINE_CORE_RULES.md 建立 | ✅ 完成 |

---

## 七、關鍵散錄檔案路徑

| 檔案 | 說明 |
|------|------|
| `workspace/LINE_SOUL.md` | LINE 版靈魂核心（本次新建）|
| `workspace/LINE_CORE_RULES.md` | LINE 版 12 條守則（本次新建）|
| `workspace/TEAM_IDENTITY.md` | 三機共用守則，含 LINE 媒體鐵律 |
| `workspace/CLIENT_PROFILE.md` | 用戶記憶檔（含 LINE 群組記事）|
| `workspace/feedback_line_webhook_route_loss_fix.md` | Webhook bug 技術修復記錄 |
| `memory/feedback_line_automation_ope_strategy.md` | LINE 自動化開發策略 |
| `~/.openclaw/openclaw.json` | LINE channel 設定（channelAccessToken / Secret）|

---

## 八、待辦事項

- [ ] 確認音樂生成穩定性（2026-04-28 測試時有失敗案例）
- [ ] OpenClaw 更新後重新套用 Webhook patch
- [ ] 評估是否將 LINE_SOUL.md 設定為 LINE channel 獨立啟動文件
