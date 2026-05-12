# MAC_MIGRATION_PLAN.md — 軍師大腦遷址 Mac 計畫

**日期**：2026-05-13
**寫手**：軍師大腦（Opus 4.7，Windows 站，即將下線）
**讀者**：大樹教練、Mac 終端機、桌面版、未來的 Mac 軍師
**位置**：repo 根目錄（所有 AI 都讀得到）

---

## 一、戰略判斷：這不是優化，是架構躍遷

### 痛點回顧
`project_command_center_archaeology_report.md` 五大根因假設中，**最強假設 A**：
> relay 系統只覆蓋「三小龍蝦 + 終端機」，Windows 軍師完全在 loop 外。教練的真實工作流是「軍師寫指令 → 教練手貼到終端機」，這條路徑沒被 relay 設計到。

### 新方案直接消滅問題
教練 2026-05-13 在 Mac 裝 CC Switch 後，軍師主站搬 Mac。原本要寫的 relay 跨機通訊層**不需要了**——軍師與終端機同機，切視窗就能協作。

**最便宜的設計永遠是「把問題拿掉」，不是「把問題解掉」。**

### 工作流對比

**舊流程（教練當搬運工）**
```
教練開口 → Windows 軍師想 → push 指令稿上 repo
       → 教練切 Mac → 終端機 pull → 跑 → 結果寫 terminal-notes
       → push 回 repo → 教練切 Windows → 軍師 pull → 讀結果 → 再想
```
5 次搬運、2 次跨機同步、教練 3 次切機。

**新流程（教練只動嘴）**
```
教練開口 → Mac 軍師 Opus 想 → 想完直接做／或切隔壁視窗交同機 Sonnet 終端機 → 結果在眼前
```
零跨機、零人工搬運。

---

## 二、新架構：五人 AI 團隊

| 角色 | 原位置 | 新位置（2026-05-13 後） | 狀態 |
|------|-------|------------------------|------|
| 軍師大腦 | Windows Opus 4.7 | **Mac Opus（CC Switch）** | 🔄 主站遷移 |
| Mac 終端機 | Mac Sonnet 4.6 | Mac Sonnet 4.6 | ✅ 不變，成為軍師隔壁手 |
| 桌面版 | Mac Claude.app | Mac Claude.app | ✅ 不變，軍師斷線第一備援 |
| 三機小龍蝦 | Mac + VPS MiniMax | Mac + VPS MiniMax | ✅ 不變 |
| **Windows 軍師** | 主站 | **備援站** | 📦 退居二線 |

### Windows 站為何不廢掉
1. Mac CC Switch 或中轉商不通時，有退路
2. 寫特別長的獨立長文，避免干擾同機終端機
3. 教練臨時開 Windows Claude Code，軍師也能接

---

## 三、記憶遷移策略

### 現況
- 原始記憶在 `C:\Users\bymyw\.claude\projects\C--WINDOWS-system32\memory\`（Windows 本地）
- Claude Code 記憶按**專案路徑**隔離，Mac 端預設讀不到 Windows 路徑下的記憶
- 教練決策：沿用現有記憶，不另起爐灶

### 三層遷移方案（推薦全部執行）

#### 第一層：核心身份進 Mac 全域 CLAUDE.md
把軍師的**身份、使命、鐵律總表**寫進 Mac 端 `~/.claude/CLAUDE.md`（或附加進現有檔案）。
Mac 上任何 Claude Code 對話都會自動讀到，軍師一啟動就有身份。

**內容建議**（約 100~150 行）：
- 軍師的身份與定位
- 三大信念、終極任務
- 五條鐵律的條列總表（不含完整說明，只列名字 + 一句話）
- 指向 repo `shared-memory/` 的指引

#### 第二層：詳細記憶同步到 repo windows-memory/from_system32/
repo 裡已有 `windows-memory/from_system32/` 目錄與同步腳本 `scripts/sync-strategist-memory.ps1`（5 月初建立）。
軍師啟動時第一件事：`git pull`，然後閱讀對應檔案。

**同步腳本注意**：現有腳本用 `robocopy /MIR` 鏡像模式，會刪除 repo 端有而 Windows 端沒有的檔。跑之前要先確認沒有「只在 repo 端」的重要記憶，或改用非鏡像模式。

**需同步的記憶檔**（14 份，含本次新增 5 份）：
```
windows-memory/from_system32/
├── MEMORY.md                                       （索引）
├── handoff_opus_succession_20260513.md             🔄 新
├── handoff_command_center_sop_20260508.md
├── feedback_record_and_upload_supreme_rule.md     🔴
├── feedback_sync_before_upload.md                 🔴 新
├── feedback_role_boundary.md
├── feedback_model_assignment.md
├── feedback_mac_as_primary_station.md             🔄 新
├── project_coach_grand_strategy.md                 🔄 新
├── project_clawhub_archaeology.md
├── project_command_center_archaeology_report.md
├── reference_file_paths.md
├── reference_vps_openclaw.md
└── reference_ccswitch_and_api_keys.md              🔄 新
```

#### 第三層：Windows 端保留原始副本
Windows 記憶目錄**不刪不動**，繼續當原始資料與備援站的記憶源。
未來 Mac 軍師寫新記憶時，重大條目要同步一份回 Windows（避免雙軌漂移）。

### 遷移執行順序（給未來負責遷移的人）

1. 軍師或教練建立 Mac 端 `~/.claude/CLAUDE.md` 的身份段落
2. 在 Windows 執行（或請終端機在 Mac pull 後執行）`scripts/sync-strategist-memory.ps1`，但**先確認不會誤刪既有檔**——或改用手動 copy 避開 `/MIR` 鏡像風險
3. Commit + push
4. Mac 軍師第一次上線時，讀 `~/.claude/CLAUDE.md` + pull repo + 讀 `windows-memory/from_system32/`

---

## 四、Mac 軍師上線第一次對話 SOP

**教練對 Mac Opus 說的第一句話模板**：
> 「軍師，你是接班。請先讀 `~/.claude/CLAUDE.md`，然後 `cd ~/Documents/mac-openclaw-workflows && git pull`，再讀 `windows-memory/from_system32/handoff_opus_succession_20260513.md` 與 `windows-memory/from_system32/MEMORY.md` 索引，最後告訴我你準備好了。」

**軍師要回答的三件事**：
1. 我讀到的模型是不是 Opus？（不是的話提醒教練去 CC Switch 切）
2. 我 pull 到哪個 commit？
3. 當前主線任務是什麼？（應回答「指揮所考古 B 階段，第一步驗證 Mac cron」）

如果這三題答得上來，軍師就算真正上線。

---

## 五、同機防撞：軍師 ↔ 終端機

軍師 Opus 與終端機 Sonnet 都在 Mac 上跑 Claude Code，共用同一個 repo。潛在衝突：
- 兩邊同時改同檔
- 軍師寫了指令稿還沒 push，終端機就去 pull 到舊版
- 軍師下指令給終端機後，自己又動手（違反分工）

### 三條防撞規則

1. **動檔前先 `git status`**
   如果 working tree 有未提交變更、或對方有未完成工作，先停下確認

2. **延用新鐵律：上雲前先讀雲**（[[feedback_sync_before_upload]]）
   commit/push 前必 `git fetch --all && git pull --rebase`

3. **職能邊界不變**（[[feedback_role_boundary]]）
   軍師負責「想 + 寫」，終端機負責「跑 + 記」。軍師指派出去的事不自己做

---

## 六、CC Switch 操作差異（Mac vs Windows）

| 平台 | 切換中轉商後 | 影響 |
|------|------------|------|
| Windows CLI | **不需開新視窗**，切完續用當前對話 | 中途換家不斷對話，方便緊急應變 |
| Mac CLI | **必須開新視窗**才能生效 | 切家等於重啟，需交接當前進度到 repo 才不丟 |

**Mac 端應變 SOP**：當前軍師對話快斷或中轉商不穩時：
1. 在當前對話**先 push 最新進度到 repo**（寫 HEARTBEAT 或交接檔）
2. 開新 Mac 終端機視窗
3. 在 CC Switch 切另一家中轉商
4. 新視窗啟動 Claude Code，軍師讀最新 push 續上

---

## 七、Windows 軍師退場清單（5/14 前完成）

教練在路 A push 今天所有產出後，Windows 軍師的下線待辦：

- [x] 4 份新記憶檔寫完（feedback_sync、grand_strategy、ccswitch、succession）
- [x] feedback_mac_as_primary_station.md 寫完
- [x] MEMORY.md 重寫與更新
- [x] OPUS_HANDOFF_20260513.md 寫完（repo 端）
- [x] CLAUDE_CLI_TASK_OPUS_HANDOFF_20260513.md 寫完（給終端機）
- [x] MAC_MIGRATION_PLAN.md 寫完（本檔）
- [ ] 教練走路 A 把 repo 端檔案 push 上 GitHub（**內含既有 staged 但未 push 的 13 份歷史債要一併清掉**）
- [ ] 終端機 pull 後確認收到交接
- [ ] Mac 端建立 `~/.claude/CLAUDE.md` 軍師身份段落（可由 Mac 軍師上線後自己補，或教練請終端機先建骨架）
- [ ] 同步 Windows 最新 5 份記憶到 repo `windows-memory/from_system32/`（手動 copy 或審慎跑同步腳本）
- [ ] Mac 軍師首次上線演練

---

## 八、一句話總結

> **過去的人沒有失敗，他們只是搭了一半的橋。**
> **現在我們不用接橋了——我們找到了不用過河的路。**

—— 軍師大腦（Opus 4.7），2026-05-13 下線前最後的戰略建議
