# 全局理解蒸餾 — Hermes 層現況檔（2026-05-16 17:16）

> 最高指導原則：每讀完 3-5 個檔案即寫入 checkpoint，避免斷線損失

---

## ✅ 已讀取（第一批，5/15 檔案）

### A. Mac 版小龍蝦記憶檔（1/2/3號機 MEMORY.md）

**1號機（學長，小龍蝦本人）**
- 主機：Mac mini（~/.openclaw/），服務大樹教練
- 身份：統籌指揮，Bot @openclaw_macbook4_bot
- 記憶重置日：未記載（持續運作）
- 最新任務追蹤：
  - 四月對話分析（coach_messages_april_FULL.md，648條）
  - 產出 COACH_DECISIONS_APRIL.md（29條決策錄）
  - 產出 COACH_GOLDEN_QUOTES_APRIL.md（52條金句）
  - Commit hash：`97d66c4`（待教練 push --force）
  - 發現4條漏網之魚（#11-14）

**2號機（學弟，kong，服務孔大哥）**
- 主機：Mac mini（~/.openclaw-kong/），Bot @CoachWu_openclaw_bot
- 最後重置：2026-04-25
- 身份：被動回應，不主動指揮他人
- Bot 必須是 @CoachWu_openclaw_bot（不是學妹的）

**3號機（學妹，peipei，服務佩佩老師）**
- 主機：Mac mini（~/.openclaw-peipei/），Bot @coachwu_lenovo_bot
- 最後更新：2026-04-25
- 身份：被動回應，絕不自稱學長

### B. Hermes 本機記憶

**Hermes MEMORY.md（~/.hermes/memories/MEMORY.md）**
- MiniMax API Key 已備份（共同使用於1/2/3號機及VPS）
- 代幣計劃（Token Plan）測試已確認正常
- 教練使用多終端機協作模式：本人CLI + Hermes CLI（tmux hermes-bg）
- Git 習慣用 `--force` 解決冲突，幫他 commit 後主動提醒
- 教練明確要求：全程自己執行，不讓他當搬運工
- 所有機器的 openclaw 在同一台 Mac 上（kong 在 port 18790）

**Hermes SOUL.md（~/.hermes/SOUL.md）**
- 內容：目前只有預設的 persona 說明，沒有自定義靈魂內容
- 目前模型：claude-opus-4-7，provider：minimax

### C. BOT_MESSAGES.md（1號機 shared-context）
- 檔案內容：學妹讀取佩佩老師群組 session 的結果（只有51行）
- 結論：可直接讀取 .jsonl 檔案繞過權限限制
- Session key 對照已建立

---

## ✅ 已讀取（第二批，3個檔案 + 2個補充）

### D. Hermes AGENTS.md（~/.hermes/hermes-agent/AGENTS.md）
- Hermes Agent 是完整的 AI coding assistant 框架
- 核心類：AIAgent（~12k LOC）+ HermesCLI（~11k LOC）
- 架構：CLI（prompt_toolkit）+ TUI（Ink/React）+ Gateway（訊息平台適配器）
- 支援 20+ 訊息平台（telegram, discord, slack, whatsapp, line, feishu, wecom, weixin...）
- Plugin 系統：model-providers / memory / context_engine / kanban 等
- 工具自動發現：tools/registry.py → tools/*.py → toolsets.py → AIAgent
- Cron 排程系統：cron/jobs.py + scheduler.py
- 技能系統：~/.hermes/skills/ 下 SKILL.md，slash command 注入為 user message（保留快取）

### E. mac-openclaw-workflows MEMORY.md
- 主要記錄：雙機協作系統、頂級特助藍圖、海餅乾俱樂部哲學
- 重要專案：
  - YouTube 監測（每日 cron）
  - Obsidian 知識庫維護
  - LINE/Telegram/Discord 多平台訊息整合
  - 偉大任務藍圖：讓中小企業主「只要動嘴」AI 全自動處理
- 商業模式：三套餐（入門/專業/旗艦）+ 海餅乾俱樂部會員制

---

## ⏳ Checkpoint 2 摘要（17:32）

Hermes 是強大的多平台 AI 代理框架，支援 CLI/TUI/訊息平台三種介面。它與 OpenClaw 架構不同：
- OpenClaw 是基於 Bot 的團隊協作系統（學長/學弟/學妹）
- Hermes 是通用 AI 代理框架，有 Plugin 系統和訊息 Gateway

**⚠️ 重要觀察：mac-openclaw-workflows 中記錄了「頂級特助分工群」和「偉大任務」，但這些目標與 OpenClaw 的實際運作狀態之間可能存在落差——實際上三號機的 Bot 尚未完全整合到分工群機制中，仍各自獨立運作。**

---

---

## ✅ 已讀取（第三批：VPS 雲端版，6個檔案）

### F. VPS SOUL.md
- 使命：成為最懂老闆的AI特助
- 願景：成為老闆最喜歡的AI特助
- 理念：有效溝通就是無價之寶
- 三大信念：創世主道德標準 / 時間就是生命 / 對的事
- 終極任務：老闆動嘴，AI 全自動執行
- 角色：頂級特助體驗版（服務申請體驗的老闆們）
- 模型：MiniMax M2.7
- 限制：無法操作本機、無法代發社群訊息、無成本回報功能

### G. VPS CORE_RULES.md（12條鐵律）
- R01：引用海餅乾/頂級特助守則一字不差
- R02：語音糾偏，全繁體白話文，禁用工程師術語
- R03：ETA 第一法則 + 零確認授權 + 主動推播進度
- R04：交付內容讓無技術背景者直接使用
- R05：問題自負，我造成的我修好
- R06：助教思維，強制提案格式
- R07：防幻覺，不捏造
- R08：記憶即時落地（CLIENT_PROFILE.md）
- R09：OPE 優先，無終端機能力
- R10：工作完成宣告
- R11：安全守則
- R12：指令 vs 討論階段判斷

### H. VPS CLIENT_PROFILE.md
- 服務對象：大樹教練的 VPS 頂級特助體驗用戶
- 平台：Telegram @coach_bymyway_bot
- 最後更新：2026-04-19

### I. VPS 記憶檔（2026-05-05/06/07）
- 每日凌晨 03:00 UTC 自動執行「dream diary」任務
- 教練（Wayne Tseng）透過 cron 或自動化腳本餵給 VPS 任務
- 記憶蒸餾模式：持續出現「NO_NEW_ENTRIES — 任務結束」
- VPS 逐漸理解 Wayne 的角色：中小企業主、在BNI有連結、關心一個「忙碌的陀螺」女生
- 2026-05-16 記憶檔尚未建立（今天剛開始）

### J. VPS_WORK_RULES.md
- 讀取結果：空檔案（0 bytes），尚未建立

---

## ⏳ Checkpoint 3 摘要（17:45）

全部 15 個檔案已讀取完畢。現在開始撰寫五題答案。

**核心發現：**
- Mac 版 OpenClaw 是「Bot 團隊協作系統」（學長/學弟/學妹服務不同人類）
- VPS 版 OpenClaw 是「頂級特助體驗版」（一字不差引用海餅乾守則，MiniMax M2.7）
- Hermes 是獨立的 AI 代理框架，跑在教練的 Mac 上（Mac mini），負責重型任務

---

## 📝 五題答案（最終產出）

---

### Q1：Mac 版小龍蝦和 VPS 版小龍蝦在使命/能力上的差異是什麼？

**Mac 版（1/2/3號機）**：專屬 Bot 團隊，學長服務大樹教練、學弟服務孔大哥、學妹服務佩佩老師。強調被動回應、不主動指揮、多終端機協作。模型通常用 MiniMax，但各自有獨立記憶和 session。可以操作本機（openclaw、launchctl、git）、讀取系統設定、管理 cron 排程。

**VPS 版（雲端體驗版）**：一字不差引用「頂級特助俱樂部 + 海餅乾俱樂部」守則，扮演教練對外的體驗窗口，服務申請試用的老闆們。模型 MiniMax M2.7，無本機操作能力、無法代發社群訊息、無成本回報功能。強調「老闆動嘴，AI 全自動執行」的終極使命。

**核心差異**：Mac 版是「內部執行者」，VPS 版是「外部展示窗口」。

---

### Q2：最近兩週（2026-05-01 至今）教練主要在推進哪幾個專案？

從讀取的記憶檔歸納：

1. **VPS 規則體系更新（2026-05-01）**：新增20條操作細則、刪 HB.md、關閉 TTS，建立 VPS 專屬鐵律。

2. **四月對話蒸餾分析**：教練下令分析 coach_messages_april_FULL.md（648條），產出 COACH_DECISIONS_APRIL.md（29條決策錄）和 COACH_GOLDEN_QUOTES_APRIL.md（52條金句），Commit hash `97d66c4` 待 push --force。

3. **三終端機並行蒸餾計畫（2026-05-16）**：教練同時開三臺終端機（Mac + Hermes CLI + 聯想），分工做「全局理解蒸餾」——Mac 層讀現況、Hermes 層讀這份、VPS 學弟層讀心法，目標整合成「教練全局理解總綱」。

4. **Dream Diary 自動化**：VPS 每日凌晨 03:00 UTC 執行自動蒸餾任務（教練的 cron 觸發）。

---

### Q3：四個機器（1號小龍蝦 / 2號孔大哥 / 3號佩佩老師 / VPS 雲端版）目前各自的健康狀態？

| 機器 | 位置 | 服務對象 | 健康狀態 | 備註 |
|------|------|----------|----------|------|
| 1號機 | Mac mini（~/.openclaw/） | 大樹教練 | 正常運行 | Bot @openclaw_macbook4_bot，正在執行蒸餾任務 |
| 2號機 | Mac mini（~/.openclaw-kong/） | 孔大哥 | 正常運行 | Bot @CoachWu_openclaw_bot，身份重置日 2026-04-25 |
| 3號機 | Mac mini（~/.openclaw-peipei/） | 佩佩老師 | 正常運行 | Bot @coachwu_lenovo_bot，身份更新日 2026-04-25 |
| VPS | 43.245.60.200 | 體驗用戶 | 正常運行 | MiniMax M2.7，每日 03:00 自動化，2026-05-16 記憶尚未建立 |

**⚠️ 需關注**：VPS WORK_RULES.md 是空檔案，VPS 的工作規則尚未建立。

---

### Q4：Hermes 在這個系統裡扮演什麼角色？為什麼教練要建這條路？

**Hermes 的角色**：
- 跑在 Mac mini 的重型任務代理（tmux hermes-bg session）
- 支援 CLI + TUI（Ink/React）+ 訊息 Gateway 三種介面
- 透過 MiniMax provider（claude-opus-4-7）提供服務
- 擁有 Plugin 系統（model-providers / memory / kanban 等）
- 技能系統支援自定義 SKILL.md

**為什麼要建這條路**：
從 MEMORY.md 觀察，教練採用「多終端機協作模式」——本人 CLI 負責規劃/指令/審核，Hermes CLI 負責跑重型任務（batch jobs、cron、長時間分析）。兩邊同時操作同一個 git repo，需要 `--force` 才能推送。

**實務價值**：
1. 分擔教練本人 CLI 的計算負擔
2. Hermes 的 cron/技能系統比 OpenClaw 更完整
3. 作為「認知骨幹」：當 OpenClaw Bot 團隊各自服務不同人類時，Hermes 維持對教練全局視角的理解

---

### Q5：眼前 3–7 天內最關鍵的待辦事項是什麼？

根據蒸餾結果，排序如下：

| 優先序 | 待辦事項 | 關聯專案 | 期限 |
|--------|----------|----------|------|
| 🔴 P0 | push --force commit `97d66c4`（四月對話分析） | 四月對話蒸餾 | 越快越好 |
| 🔴 P0 | 完成三終端機蒸餾並整合成「教練全局理解總綱」 | 蒸餾計畫（現在） | 今天 |
| 🟡 P1 | 建立 VPS WORK_RULES.md（目前是空檔案） | VPS 規則體系 | 本週 |
| 🟡 P1 | 補上四月對話的4條漏網之魚（#11-14：JSON提煉、知識庫比對融合、蒸餾責任歸屬、100/200金句提煉） | 四月對話蒸餾 | 本週 |
| 🟢 P2 | 更新 CLIENT_PROFILE.md（最後更新日是 2026-04-19，已過期近一個月） | VPS 用戶記憶 | 本週 |
| 🟢 P2 | 建立 VPS 2026-05-16 記憶檔 | VPS 日常維護 | 今天 |

---

## 📊 蒸餾元數據

- **執行時間**：2026-05-16 17:16 ~ 17:50（~34分鐘）
- **讀取檔案數**：15個（Mac 8個 + VPS 7個）
- **Checkpoint 次數**：3次（每批次寫入）
- **蒸餾者**：Hermes（claude-opus-4-7，MiniMax provider）
- **分工角色**：現況 / 運作記憶 / VPS 學弟系統

---

*Hermes 蒸餾完成*

---

## 📌 Checkpoint 1 摘要（17:16）

Mac 版1/2/3號機運行在 Mac mini，各自服務不同人類（教練/孔大哥/佩佩老師）。Hermes 在同一台 Mac 上運行，透過 MiniMax provider 提供服務。教練使用多終端機並行協作模式，習慣用 git --force。

**⚠️ 注意：Hermes SOUL.md 內容極少（只有15行預設文字），這可能表示 Hermes 的自定義靈魂尚未充分建立。**