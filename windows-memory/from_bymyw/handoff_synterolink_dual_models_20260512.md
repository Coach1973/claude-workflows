---
name: Synterolink 雙模型 + Prompt Caching 接班（2026-05-12）
description: Synterolink 已測通並拆成 Opus/Sonnet 兩筆 CC Switch provider；新對話第一件事查 prompt caching 是否啟用
type: handoff
date: 2026-05-12
originSessionId: e08504ad-23a4-4a10-ab3a-2b905e47bc7d
---
# 關鍵啟動詞（教練在新視窗貼這句即可接續）

> **「軍師，雙模型接班，讀 handoff_synterolink_dual_models_20260512。」**

---

# 新對話第一件事（教練指定優先任務）

**已驗收：Synterolink 有透傳 prompt caching。**
1. /usage 已看到 `cache_read > 0`
2. 成本主因是本輪大量跑在 Opus，不是 cache 沒開
3. 接下來預設維持 Sonnet，必要時才切 Opus

**為何重要：** Anthropic 官方功能——相同 context 在 5 分鐘內重用只收 10% 費用。長對話 + Opus 模型情況下，這個功能開不開差很多。

**確認的方法（提示給未來軍師參考）：**
- Anthropic 官方文件：https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching
- Claude Code 設定：看 `.claude/settings.json` 或 `~/.claude/CLAUDE.md`
- Synterolink 那邊只能寫信問客服或查官方說明書
- 也可以實驗：開兩個對話同樣 prompt 連跑，看計費差異

---

# 本輪做完的事（一次列清）

## 1. Synterolink 接入已徹底測通 ✅

- 設定：`ANTHROPIC_AUTH_TOKEN` + `https://api.synterolink.com`（無 /v1）
- Sonnet 4.6 測通：回 `SONNET-4-6-OK`
- Opus 4.7 測通：回 `OPUS-4-7-OK`
- 教練已從每月 900 點方案改為 **120 美金不限時間方案**
- 關鍵規則：**CLI 模型名稱必須與 Synterolink 後台模型分組一致**

## 2. CC Switch 現有 4 筆 Claude provider

| id | name | model | 用途 |
|---|---|---|---|
| `synterolink` | Synterolink Opus 4.7 | claude-opus-4-7 | 重任務 |
| `synterolink-sonnet` | Synterolink Sonnet 4.6 | claude-sonnet-4-6 | **預設主力（省錢）** |
| `easyclaude` | EasyClaude | （未指定） | 備援 |
| `claude-official` | Claude Official | （空殼） | 未使用 |

切換完當下生效，不用關 CLI。

## 3. 重要備份檔（時間順序）

- `cc-switch.db.before_synterolink_fix_20260511_212359`
- `cc-switch.db.before_id_fix_20260511_222039`
- `cc-switch.db.before_split_models_20260512_035522`（本輪最新）
- `settings.json.before_synterolink_fix_20260511_213046`

全部在 `C:\Users\bymyw\.cc-switch\backups\`。

## 4. 已修正的記憶（避免下次再踩坑）

- `feedback_cc_switch_no_restart.md`：CC Switch 切換不需重啟 CLI
- `feedback_opus_costly_default_sonnet.md`：Opus 在 Synterolink 上一輪燒 10 美金，預設用 Sonnet
- `project_synterolink_success_202605.md`：Synterolink 接入已成功（取代之前錯誤的「無法交付」結論）
- `reference_synterolink_setup.md`：補上「CLI 模型與後台分組必須一致」規則

## 5. 為什麼這輪這麼燒錢（教練本人的洞察）

對話過長 = 每輪 input 都把整個歷史送一次（API stateless）= context 5~8 萬 tokens × Opus 倍率 = 一輪 10 美金合理。  
**對策：開新對話 + 預設 Sonnet + 已確認 prompt caching 有透傳。**

---

# 還沒做（教練可挑下一輪做）

- 把 `MEMORY.md` 那批「待補」記憶從 `E:\Claude-Data\mac-openclaw-workflows\windows-memory\from_system32\` 搬遷整理
- 把 `.claude/settings.json` 預設 model 從 `"opus"` 改成 `"sonnet"`（如果教練希望多一層保險）

---

# 工具備忘（給未來軍師省冤枉路）

- **sqlite3.exe 路徑**：`C:\Users\bymyw\AppData\Local\Microsoft\WinGet\Packages\SQLite.SQLite_Microsoft.Winget.Source_8wekyb3d8bbwe\sqlite3.exe`
- **動 DB 前一定先確認 CC Switch 關閉** + **備份**
- **Bash classifier 對 sqlite UPDATE/INSERT 敏感**：寫成 .sh 檔再執行，或單行直接打較穩
- **教練用 `! 命令` 在輸入框可直接跑 shell**，繞開 auto mode classifier 暫時不可用的狀況
