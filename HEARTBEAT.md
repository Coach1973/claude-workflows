# HEARTBEAT 熱上下文（每次心跳必讀）

> 最後更新：2026-04-17 上午 10:40
> 更新者：Opcode 工作階段（教練整晚未睡完成關鍵設定）

## ⚡ 系統狀態

- **Primary 模型：** litellm/gemini-3.1-pro-preview（via localhost:4100）
- **Fallback：** google/gemini-3.1-pro-preview
- **litellm 雙 Key 輪替：已啟用**（見下方說明）

## 🔑 Gemini API 雙 Key 設定（2026-04-17 新增）

| Key | 專案 | 狀態 |
|-----|------|------|
| AIzaSyDFLv...（原有） | My First Project | 今日配額耗盡，明日重置 |
| AIzaSyB3c1...（新增） | Default Gemini Project | ✅ 健康可用 |

- 每個專案每日上限：**250 RPD**
- 兩 Key 合計：**500 RPD/天**
- litellm 自動輪替，無需人工介入
- 設定檔：`/Users/bymyway/.openclaw/litellm/config.yaml`

## 🚨 重要教訓（2026-04-17 凌晨死機事件）

**根本原因：** litellm 的 `cooldown_time` 設定導致死循環
- 429 觸發 → 模型進冷卻期 → 冷卻期內請求立刻失敗 → 再次觸發 → 永遠出不來
- **已修復：** 移除 `cooldown_time`，改用 `retry_after: 60` + `num_retries: 10`

**次要原因：** 單一 Key 每日 250 次配額太低，密集工作下午就耗光
- **已修復：** 新增第二把 Key（獨立專案），配額翻倍

## ⚠️ 所有對話守則

- 全部繁體中文，不夾任何英文
- 能自己做直接做，不問確認
- 截圖禁用，直接讀檔案
- 執行完通報 Telegram（Chat ID: 6124913915）
- 預估超過 5 萬 Token 先回報教練確認
- ⚠️ 不要讀大型 memory 檔（會造成 Gemini 空白回應）
- ⚠️ 名稱對等：Telegram = 電報、小龍蝦 = OpenClaw bot、海餅乾 = 海比干/海濱幹

## 📋 三機架構快查

| 機台 | 路徑 | 服務對象 | 狀態 |
|------|------|---------|------|
| 1號機（學長） | ~/.openclaw | 大樹教練 | ✅ 運行中 |
| 2號機（佩佩） | ~/.openclaw-peipei | 陳佩君 | ✅ SOUL/USER 已客製化 |
| 3號機（孔大哥） | ~/.openclaw-kong | 孔峯 | ✅ SOUL/USER 已客製化，待孔大哥 Telegram ID |

## 📖 重要文件索引

- `GROUP_TASK_SOP.md` — 頂級特助分工群運作規則（必讀）
- `SHARED_GROUP_MEMORY.md` — 三機架構與協作協議
- `feedback_2026-04-17_rate-limit-root-cause-and-dual-key-fix.md` — 死機根因與修復紀錄

- ✅ **桌面清理完成**：12張截圖進垃圾桶，7份報告歸檔至 OpenClaw報告_20260410/，保留9個常用檔案，狀態已寫入 `DESKTOP_LAYOUT.md`。

## ⏳ 待完成事項

- [ ] 建立頂級特助分工群（孔大哥 ID 已解決，等待教練建群與拉人）

## 🔔 懸宕待討論事項（主動追蹤清單）
1. **海餅乾守則的高階應用（教練親自指導）**
   - 守則的單獨使用
   - 互相借力與互相制約
   - 對於「控制」的見解
   *(提醒：若教練一段時間未提及，需主動尋找合適時機提醒)*
- [ ] NotebookLM 搬家作業（教練指示：持續進行中）
