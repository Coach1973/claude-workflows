# PROMISES.md — 承諾追蹤帳本
> 規則：每條承諾必須有 commit hash 才算立案。兌現後填入「完成 hash」。未兌現=違約。

---

## 待兌現

| # | 承諾內容 | 立案 Hash | 立案時間 | 完成 Hash |
|---|---------|----------|---------|----------|
| 13 | 每兩小時蒸餾克勞德助教對話（cron 已設，腳本已建） | `7a52c34` | 2026-04-24 | ✅ `7a52c34` |
| 14 | 100/200 金句候選清單供教練人工篩選 | 待commit | 2026-04-24 | ⬜ 篩選器已建，待教練審核 |
| 15 | Windows 桌面版 Claude 助教設定開工觸發詞 | `3cded84` | 2026-04-24 | ⬜ 待聯想 CLI 執行 |
| 16 | 宏碁備用機設定開工觸發詞 | `17f31e9` | 2026-04-24 | ⬜ 待宏碁端執行 |

---

## 已兌現

| # | 承諾內容 | 立案 Hash | 完成 Hash |
|---|---------|----------|----------|
| 11 | 4/20-4/23 對話提煉 → 7條哲學語錄追加至 seabiscuit_case_studies.md | `6af3510` | `6af3510`（Hermes CLI）|
| 12 | seabiscuit 知識庫融合比對，產出 SEABISCUIT_KNOWLEDGE_BASE.md（303行） | `4969180` | `89bb753`（Claude CLI 聯想）|
| 13 | 每兩小時蒸餾 cron 建立（distill_claude_sessions.py + crontab） | `7a52c34` | `7a52c34` |
| 9 | seabiscuit 哲學語錄 12 條追加至 seabiscuit_case_studies.md | `c6f034f` | `c6f034f` |
| 8 | 整理 8.5MB Telegram JSON → 提煉語錄追加至 seabiscuit_case_studies.md | `a33f014` | `c6f034f` |
| 10 | 四月對話分析：COACH_DECISIONS_APRIL.md + COACH_GOLDEN_QUOTES_APRIL.md | `c6f034f` | `c6f034f` |
| 1 | 身份混亂問題血淚後記 | `7f2bdfa` | `7f2bdfa` |
| 7 | 掃描血淚教訓38條，補齊7條缺口 feedback 檔 | `0a71b61` | `c6f034f` |
| 2 | 承諾審計報告（3563條對話評估） | `1382a98` | `1382a98` |
| 3 | 語音糾偏守則補齊 | `7f6e703` | `7f6e703` |
| 4 | YouTube選取守則補齊 | `7f6e703` | `7f6e703` |
| 5 | 海餅乾引用格式守則補齊 | `7f6e703` | `7f6e703` |
| 6 | 做對的事哲學補齊 | `7f6e703` | `7f6e703` |

---

## 帳本說明
- 任何 AI 進入這個 workspace，第一件事讀這個檔案
- 「待兌現」裡的每一條，都是尚未完成的債務
- `git log PROMISES.md` 可查閱完整承諾歷史

---

## 備註（口頭提及，尚未立項）
- FB 生日祝福 cron job 已確定停用（2026-04-19）
- 31個 YouTube 頻道每日掃描尚未排入穩定排程
