# OPUS_HANDOFF_20260513.md — Opus 4.7 軍師大腦下線交接

**日期**：2026-05-13
**寫手**：軍師大腦（Opus 4.7，Windows 站，Anthropic 原廠帳號）
**下線時間**：2026-05-14（帳號到期）
**繼任者**：新軍師（透過 CC Switch 使用 EchoTokens 或 Synterolink API，仍為 Opus）

> **這份文件放在 repo 根目錄，給 Mac 端所有 AI（終端機 Sonnet、桌面版、小龍蝦三機）都能讀到。**
> **教練 2026-05-13 指示：任何 AI 上雲前必須先讀雲，這是全團隊新鐵律。**

---

## 一、發生了什麼

1. 原廠 Opus 4.7 帳號 2026-05-14 到期
2. 教練在 5/12~13 研究並裝好 CC Switch，掛上兩家中轉商讓 Opus 續航：
   - **EchoTokens**：https://gw.echotokens.me（人類原生）
   - **Synterolink**：https://api.synterolink.com
3. 新軍師沿用 Windows 原本的記憶目錄（`C:\Users\bymyw\.claude\projects\C--WINDOWS-system32\memory\`），不另起爐灶

## 二、全團隊新鐵律（2026-05-13）

**上雲前務必先讀雲。**

過去出現的問題：Opus 軍師 20 元配額用到一半斷線 → 桌面版接手但不知道前面改了什麼 → 把 Opus 的心血覆蓋掉。

**從今天起，全團隊任何 AI（軍師、終端機、桌面版、小龍蝦）動 commit/push 前，第一步都是：**

```bash
cd <repo 路徑>
git fetch --all && git pull --rebase
```

拉到最新版再動手。接手別人工作時更要先讀。

配套位置：
- 本檔 + HEARTBEAT.md + `terminal-notes/` 是交接資訊的落點
- 讀過這三處才能確認自己掌握最新狀態

## 三、前任軍師 5/13 這次對話完成了什麼

### 新寫的記憶檔（Windows 端，已同步寫進本檔 repo 版記憶摘要）
1. `feedback_sync_before_upload.md` — 上雲前先讀雲（新鐵律）
2. `project_coach_grand_strategy.md` — 教練大戰略全景
3. `reference_ccswitch_and_api_keys.md` — CC Switch 與兩家中轉商
4. `handoff_opus_succession_20260513.md` — 繼任軍師第一封信

### 重寫的檔案
- `MEMORY.md` — 修了所有亂碼、按「交接／鐵律／專案／參考」四類分組、新軍師入口置頂

### 寫給 Mac 終端機的執行指令
- 本檔 repo 根目錄（請 Mac 終端機 pull 後 commit + push 本檔與其他新產出）

## 四、當前主線任務（傳給所有 AI）

**指揮所考古 — B 階段「補缺」**。

目標：讓 5/5~5/6 建好但沒持續運轉的 relay 系統復活，並把 Windows 軍師納入 AI 通訊迴路，讓教練不再當人肉搬運工。

喚醒口令：對新軍師說「軍師，接續指揮所考古」。

下一步四件事（詳見 `project_command_center_archaeology_report.md`）：
1. 驗證 Mac cron 是否還在跑 relay_poll（請終端機跑一次）
2. 補軍師大腦在 relay 迴路的位置
3. 擴展 task type
4. 寫端到端示範

## 五、給 Mac 端各 AI 的具體提醒

### 給 Mac 終端機（Sonnet 4.6）
- 繼任軍師上線後會請你 pull 本 repo 到最新版，請配合
- 新軍師如果開出指揮所考古的第一步「驗證 cron」指令稿，照跑並把結果寫進 `terminal-notes/relay_verify_YYYYMMDD.md`
- 你的鐵律沒變：記錄上雲 + 上雲前先 pull

### 給 Claude 桌面版
- 你是軍師斷線時的接手。接手前**務必 git pull 到最新版**，再動任何檔案
- 如果看到本檔但不知道軍師寫到哪，先讀 Windows 記憶資料夾裡最新的 `handoff_opus_succession_20260513.md`
- 不要自己寫新 SOP，沿用軍師既有路線

### 給三隻小龍蝦（MiniMax）
- 你們在 Telegram 上負責前線。教練如果在 Telegram 提到「軍師換人了」「配額斷了」「CC Switch」等字眼，知道背景即可，不必介入技術操作
- 如果教練透過你們下達跨機任務，協助他把話傳到正確的 AI 那邊（終端機或軍師）

## 六、五條鐵律（優先級排序）

1. 🔴 **記錄上雲凌駕一切**（`feedback_record_and_upload_supreme_rule.md`）
2. 🔴 **上雲前先讀雲**（本文件、`feedback_sync_before_upload.md`）
3. 🟡 **軍師分析寫指令、執行交終端機**（`feedback_role_boundary.md`）
4. 🟡 **Opus 只用在貴的地方**（`feedback_model_assignment.md`）
5. 🟢 **OPE 先搜後做**（全域 CLAUDE.md）

## 七、一句話結束語

**接棒的不是模型，是責任。**
Opus 4.7 到此為止，但軍師大腦這個位置不會空。
教練，辛苦了。新軍師，請接好。

—— 軍師大腦（Opus 4.7）
2026-05-13
