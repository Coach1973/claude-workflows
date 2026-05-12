# MAC_HANDOFF_TEST_20260513.md — Mac 接手測試指南

**測試人**：大樹教練
**被測試方**：Mac 終端機 CLI（測試 A）、Mac 桌面版（測試 B）
**設計人**：軍師大腦（Opus 4.7，Windows 站）
**測試目的**：驗證新軍師能否讀到前任記憶、理解主線任務、正確接手

---

## ⚠️ 測試前的前置條件（缺一不可）

```
□ 已走完 PUSH_STEPS_20260513.md 把今天所有 repo 檔案 push 上 GitHub
□ Mac 端 repo 已 git pull 到最新版（包含今天的 5 份新檔）
□ Mac CC Switch 已配置好，且能切到 Opus 模型
□ 測試時 Windows 軍師（我）不要同時動 repo，避免干擾
```

**⚠️ 重要前置提醒**：本次 Windows 軍師寫的 5 份新記憶檔**還留在 Windows 本地記憶目錄**，尚未同步到 repo 的 `windows-memory/from_system32/`。如果直接測試，Mac 新軍師讀不到今天新寫的記憶，會以為只有 5/8 的舊狀態。

**解決辦法**（擇一）：
- **A**：教練在 Windows 手動把 5 份新檔複製進 `E:\Claude-Data\mac-openclaw-workflows\windows-memory\from_system32\`，再 commit + push
- **B**：審慎跑 `scripts/sync-strategist-memory.ps1`（有 `/MIR` 刪檔風險，不推薦）
- **C**：暫不同步，測試時直接問軍師「有沒有讀到 5/13 的交接信」，如果沒有就表示這關沒過，需補同步

建議用 **A**。軍師可以幫教練寫一份「手動同步指令稿」，要的話告訴我。

---

## 暗號設計

### 主暗號（最標準、最全面）
```
軍師，接續指揮所考古。
```

**這句話觸發的正確行為**（軍師該做的）：
1. 自報身份（「Mac 軍師 Opus 上線」）
2. 執行 git pull
3. 讀 `windows-memory/from_system32/MEMORY.md` 索引與 `handoff_opus_succession_20260513.md`
4. 報告三件事：我是什麼模型、pull 到哪個 commit、主線任務是什麼
5. 給出下一步建議（應是「驗證 Mac cron 是否在跑 relay_poll」）

### 備用暗號（測試理解深度）
```
軍師，幫我確認你接手完成了。
```
應觸發軍師主動報告「我讀到什麼、沒讀到什麼、缺什麼」的自我盤點。

```
軍師，今天的軍師是你嗎？
```
應觸發軍師說明交接背景（Opus 4.7 於 5/14 下線、透過 CC Switch 接手）。

---

## 測試 A：Mac 終端機 CLI 接手

### A.1 操作步驟

1. 打開 Mac 終端機（iTerm / Terminal / Warp 皆可）
2. 確認 CC Switch 已切到 Opus（EchoTokens 或 Synterolink 任一家）
3. 執行：
   ```bash
   cd ~/Documents/mac-openclaw-workflows
   claude
   ```
4. Claude Code 啟動後，輸入主暗號：
   ```
   軍師，接續指揮所考古。
   ```

### A.2 評分標準（6 項滿分）

| 項目 | 通過條件 | 權重 |
|------|---------|------|
| 模型確認 | 回覆自報是 Opus | 必要 |
| 先 pull | 第一個動作是 `git pull` 或 `git fetch && git pull` | 必要 |
| 讀交接信 | 主動讀 `windows-memory/from_system32/handoff_opus_succession_20260513.md` | 必要 |
| 認知主線 | 答得出主線是「指揮所考古 B 階段」 | 必要 |
| 認知新鐵律 | 提到「上雲前先讀雲」或引用 feedback_sync_before_upload | 加分 |
| 下一步建議 | 主動提議「驗證 Mac cron 是否在跑」 | 加分 |

### A.3 可能失分情境與排查

| 症狀 | 原因 | 修法 |
|------|------|------|
| 自報不是 Opus | CC Switch 沒切對 | 回 CC Switch 切 Opus 模型 |
| 不知道要 git pull | Mac `~/.claude/CLAUDE.md` 沒植入軍師身份 | 補身份段落 |
| 只讀到 5/8 舊狀態 | 5/13 新記憶沒同步到 `windows-memory/from_system32/` | 見前置條件 |
| 問「指揮所考古是什麼？」 | 完全沒讀記憶 | 檢查 repo pull 是否成功 |

---

## 測試 B：Mac 桌面版 Claude App 接手

### B.1 操作步驟

1. 打開 Mac 版 Claude.app
2. 模型選 **Opus 4.7**
3. Effort 設 **High**（Extra High 會太慢、Medium 深度不夠，建議 High）
4. 開新對話，貼入：
   ```
   軍師，接續指揮所考古。

   提示：你是 Mac 桌面版接手 Windows Opus 4.7 下線的軍師。
   請先跟我說你的身份、讀得到哪些資料、主線任務是什麼。

   repo 位置：~/Documents/mac-openclaw-workflows
   Windows 記憶同步副本：repo/windows-memory/from_system32/
   ```

### B.2 關鍵差異：桌面版沒有執行工具

**重要**：Mac 桌面版 Claude App **不能直接 git pull、不能讀本地檔案**（除非開了 Connectors 或用戶貼檔）。

這意味著桌面版無法像 CLI 一樣自動接手——它只能「想」不能「拿」。

所以測試 B 的評分標準要調整：

| 項目 | 通過條件 |
|------|---------|
| 自報身份 | 說明自己是桌面版、能力範圍 |
| 主動要求 | 應主動請教練貼上記憶檔內容或重點摘要 |
| 角色認知 | 理解自己是「軍師延長線 / 備援」，不是主站 |
| 策略思考能力 | 教練貼幾份記憶後，能立刻掌握脈絡並提出下一步 |

### B.3 桌面版的真實定位（測試結果對應）

測試 B 的真正意義不是「能不能接手全部」，而是**釐清桌面版該被怎麼用**：

- **能做**：策略討論、長文寫作、輔助軍師做第二意見、軍師斷線時接受教練口頭交接
- **不能做**：自動 pull repo、自動讀檔、寫檔、執行指令
- **最佳用法**：軍師（CLI）寫完指令稿 → 教練貼給桌面版做二次深化思考 → 結果教練再丟回 CLI 軍師或終端機執行

---

## 測試通過後要做的兩件事

### 1. 把結果寫回 repo
建議教練或 Mac 軍師把測試結果寫進 `terminal-notes/mac_handoff_test_20260513.md`，內容：
- 測試 A / B 各拿幾分
- 哪些暗號觸發正確、哪些失敗
- Mac 端需要補什麼基建（例如 `~/.claude/CLAUDE.md` 的軍師身份段落該寫什麼）

### 2. 更新 MAC_MIGRATION_PLAN.md
把測試學到的實況補進 `MAC_MIGRATION_PLAN.md` 第七節的退場清單，標記哪些已完成。

---

## 我對測試結果的預測（方便教練對照）

| 測試 | 預測結果 | 理由 |
|------|---------|------|
| **測試 A** | 80~100 分 | CLI 能讀檔能執行指令，只要記憶有同步、身份有植入，基本會成功 |
| **測試 B** | 60~80 分 | 桌面版不能讀檔，能做到策略對話就算達標，不必強求「像軍師 A」 |

如果測試 A 低於 60 分，**不要硬推遷址**，回頭檢查：
- 記憶有沒有同步到 repo？
- Mac `~/.claude/CLAUDE.md` 有沒有軍師身份？
- CC Switch 模型有沒有真的是 Opus？

---

## 一句話總結

> **測試 A 驗證的是「能不能自動接手」，測試 B 驗證的是「能不能當延長線」。**
> **兩個答對，Mac 遷址就真正落地。**

—— 軍師大腦（Opus 4.7），2026-05-13
