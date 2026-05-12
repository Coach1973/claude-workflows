# CLAUDE_CLI_TASK_OPUS_HANDOFF_20260513.md

**任務對象**：Mac 終端機（Claude Code CLI, Sonnet 4.6）
**指派人**：軍師大腦（Opus 4.7，即將於 5/14 下線）
**指派時間**：2026-05-13
**優先級**：🔴 高（關乎軍師交接的記錄上雲鐵律）

---

## 一、背景（30 秒讀完）

Opus 4.7 軍師帳號 5/14 到期，今晚完成了大交接。所有產出在 Windows 端已寫好，但教練鐵律：**記錄必須上雲 GitHub**。軍師本人不直接 commit/push（分工原則），這份任務請你完成。

另外全團隊今日新增一條鐵律：**上雲前先讀雲**。所以你的第一步是 pull，最後一步才是 push。

## 二、一鍵執行流程（請照順序跑）

### 步驟 0：先 pull（新鐵律第一步）

```bash
cd ~/Documents/mac-openclaw-workflows
git fetch --all
git pull --rebase
```

如果有衝突，**不要自己硬解、不要 --force**，回報教練。

### 步驟 1：把 Windows 軍師寫的交接文件同步進 repo

教練的 Lenovo 電腦上 repo 路徑是 `E:\Claude-Data\mac-openclaw-workflows`，軍師已在那邊寫了 `OPUS_HANDOFF_20260513.md`。那份應該已經被教練手動 push 上來，或者會由 Windows 端另行同步。

你這邊的工作：**確認本檔與 `OPUS_HANDOFF_20260513.md` 兩份都已在本地 repo**：

```bash
ls -la OPUS_HANDOFF_20260513.md
ls -la CLAUDE_CLI_TASK_OPUS_HANDOFF_20260513.md
```

如果其中一份沒有，代表 Windows 端還沒 push 上來。請回報教練。

### 步驟 2：驗證 Windows 記憶檔是否也需同步

軍師 5/13 新寫了 4 份記憶檔在 Windows 本地：
- `feedback_sync_before_upload.md`
- `project_coach_grand_strategy.md`
- `reference_ccswitch_and_api_keys.md`
- `handoff_opus_succession_20260513.md`
- 加上修改的 `MEMORY.md`

這些**位在 Windows 本機記憶目錄**（不在 repo 裡）：
`C:\Users\bymyw\.claude\projects\C--WINDOWS-system32\memory\`

**目前設計**：這些是 Windows 軍師本地記憶，新軍師（也在 Windows）會直接讀到，不需要同步到 Mac。

**但如果教練希望跨機共享**（讓桌面版、終端機也讀得到），請軍師下輪用 `shared-memory/` 或 `terminal-notes/` 目錄做一份副本。這件事等教練決策，不在本次任務範圍。

### 步驟 3：檢視 staging 狀態

```bash
git status
git diff OPUS_HANDOFF_20260513.md | head -30
```

### 步驟 4：commit + push

```bash
git add OPUS_HANDOFF_20260513.md CLAUDE_CLI_TASK_OPUS_HANDOFF_20260513.md
git commit -m "chore(handoff): Opus 4.7 軍師 5/14 下線交接

- 新增 OPUS_HANDOFF_20260513.md：全團隊交接文件、新鐵律公告
- 新增本指令稿：給 Mac 終端機的 pull/commit/push 任務
- 全團隊新鐵律：上雲前先 git pull 讀雲（避免 Opus 斷線後版本錯亂）
- 繼任軍師透過 CC Switch 接手（EchoTokens / Synterolink）
- 主線任務維持：指揮所考古 B 階段補缺"

git push
```

### 步驟 5：回報

在 `terminal-notes/` 目錄新增一份 `opus_handoff_20260513_done.md`，寫：
- pull 到哪個 commit
- push 出去的 commit hash
- git log 最新 3 筆
- 有沒有衝突或異常

然後把檔名告訴教練（不用 push 這份，教練看本地就行）。

## 三、如果出錯

1. pull 衝突 → 回報教練，不自己 reset
2. push 被拒 → 先 pull --rebase 再 push
3. 兩份檔案其中一份在本地找不到 → 代表 Windows 端還沒 push 上來，回報教練
4. 其他任何異常 → 回報，不要硬來

## 四、任務完成定義

- [x] 本地 repo 已 pull 到最新
- [x] OPUS_HANDOFF_20260513.md 與本指令稿都已 commit + push
- [x] 在 terminal-notes/ 留下執行記錄

---

**軍師備註**：
這份是我（Opus 4.7）下線前最後交付的任務之一。鐵律要守到最後：記錄上雲、上雲前讀雲。辛苦你了。

—— 軍師大腦（Opus 4.7），2026-05-13
