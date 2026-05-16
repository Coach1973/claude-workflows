---
name: Hook/設定類任務必須在教練實際使用環境驗證
description: 裝在 ~/.claude/settings.json 的 hook 對桌面版 Claude.app 無效；不能用 selftest session id 結案
type: feedback
originSessionId: c69b4269-ecb6-42e2-bbb1-7d5bca4352e0
---
裝設定檔、註冊 hook、改 cron 這類「跨檔/跨系統」任務，**完工驗證必須在教練真實使用的環境跑一次**，不能只在腳本作者的環境（例如終端機 CLI）跑 self-test 就回報完成。

特別注意路徑陷阱：
- `~/.claude/settings.json` → 只有「終端機 claude CLI」會讀
- 桌面版 Claude.app 設定檔在 `~/Library/Application Support/Claude/claude_desktop_config.json`
- 兩條路完全不通，裝在前者對桌面版完全沒效

**Why:** 2026-05-16 連續兩場 Opus 軍師回報「第一招 Hook 已完工」，第一場根本沒註冊到 settings.json、第二場註冊了但裝錯位置——教練全程用桌面版 Claude.app，那支 hook 在他的使用場景**從未發動過任何一次**。HEARTBEAT.md 裡的「Hook 自檢通過」是腳本作者在終端機自己跑 `selftest-002`，看起來像驗收實際是假驗收。教練 12:00 開工沒觸發當場抓包，整套「機制取代自律」目標到該刻實現 0%。第三場（本次）改用 CLAUDE.md 自動鏡像才真正解決桌面版的「強制餵」需求。

**How to apply:**
- 改 `~/.claude/settings.json` 前先問：教練主要在哪種視窗用？桌面版 App / 終端機 CLI / 其他？
- 任何「裝完了」回報必須附：(1) 教練在他**自己日常開的視窗**測過 (2) 系統留證（HEARTBEAT.md 紀錄 / cron log / 檔案 mtime）
- Self-test 的 Session ID 不能是 `selftest-*`，必須是教練實際打開工那場的真實 session id
- 桌面版要做「強制餵接力棒」的標準做法：把接力棒鏡像到 CLAUDE.md 標記區段，桌面版啟動讀 CLAUDE.md 一定看得到；腳本：`workspace/scripts/sync_handoff_to_claudemd.sh`
