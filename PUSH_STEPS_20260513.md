# PUSH_STEPS_20260513.md — 教練一鍵 push 步驟

**使用方式**：在 Windows PowerShell 裡按順序執行以下區塊。
**分兩個 commit** 讓歷史乾淨：先清歷史債，再提今天新產出。

---

## 前置：切到 repo 目錄並先 pull（新鐵律）

```powershell
cd E:\Claude-Data\mac-openclaw-workflows
git fetch --all
git pull --rebase
```

**如果 pull 有衝突**：停下告訴軍師，不要 `--force` 也不要 `reset`。

---

## Commit 1：清掉 5/9 以來的 staged 歷史債

這些檔早就 staged 但沒 commit 沒 push，是之前 Opus 斷線的殘局。先把這批結清。

```powershell
git status --short
```

確認有那 13 ~ 16 份 `A` 開頭的檔（含 `windows-memory/from_system32/*`、`CLAUDE_CLI_TASK_RELAY_VERIFY.md`、`PROPOSAL_STRATEGIST_INTO_RELAY.md`、`scripts/sync-strategist-memory.*`）。

```powershell
git commit -m "chore(memory): 清歷史債 — 5/8-5/9 指揮所考古 staged 產出"
```

---

## Commit 2：今天（5/13）軍師下線交接三份新檔

```powershell
git add OPUS_HANDOFF_20260513.md CLAUDE_CLI_TASK_OPUS_HANDOFF_20260513.md MAC_MIGRATION_PLAN.md
git status --short
```

確認只有這 3 份新增。然後：

```powershell
git commit -m "docs(handoff): Opus 4.7 軍師 5/14 下線交接 + Mac 遷址計畫"
```

---

## 最後：push

```powershell
git push
```

推成功後執行 `git log --oneline -5` 看最新 5 筆，複製貼回給軍師確認。

---

## 備註：5/13 新寫的 Windows 記憶不在本次 push

這份 push 只上 repo 端的交接文件與歷史債。Windows 記憶目錄下今天新寫的 5 份檔（`feedback_sync_before_upload`、`project_coach_grand_strategy`、`reference_ccswitch_and_api_keys`、`handoff_opus_succession_20260513`、`feedback_mac_as_primary_station`）與重寫的 `MEMORY.md`，**要等下一輪跑同步腳本或手動複製進 `windows-memory/from_system32/` 再 push**，詳見 `MAC_MIGRATION_PLAN.md` 第三節。
