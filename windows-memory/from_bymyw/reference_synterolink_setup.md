---
name: Synterolink Claude CLI 接入規格
description: synterolink 中繼站的 Claude CLI 設定要求（變數名稱與 URL 格式陷阱）
type: reference
originSessionId: e659b674-dd0a-459c-97cf-55a6e4fb0698
---
Synterolink（`api.synterolink.com`）的 Claude CLI 接入規格，與其他中繼站不同：

| 項目 | 必填值 |
|---|---|
| `ANTHROPIC_AUTH_TOKEN` | 你的 API key（**注意是 AUTH_TOKEN，不是 API_KEY**） |
| `ANTHROPIC_BASE_URL` | `https://api.synterolink.com`（**根網址，不要加 `/v1`**） |
| `ANTHROPIC_API_KEY` | 必須 unset（如果同時存在會搞死 synterolink） |

**兩個常見陷阱：**
1. easyclaude 等其他中繼站吃 `ANTHROPIC_API_KEY`，但 synterolink 只吃 `ANTHROPIC_AUTH_TOKEN`。CC Switch 預設模板可能填錯。
2. 很多人習慣寫 `https://xxx.com/v1`，但 Claude CLI 會自動補 `/v1/messages`，base URL 必須停在根層。

驗證指令：`claude --model claude-sonnet-4-6 -p "Reply exactly: CLI-OK"`

**模型與分組必須一致（2026-05-12 教練實測釐清）：**
- Synterolink 後台的「模型分組」要先選對，Claude CLI 的 `--model` 也要對應該分組。
- 如果後台分組與 CLI 模型不一致，可能出現 403 或 503，不能直接判斷為服務壞掉。
- 教練已從舊的每日 30 / 每月 900 點方案改為 120 美金不限時間方案，並在客服引導後測通。

**Prompt caching 驗收（2026-05-12）：**
- `/usage` 顯示 Opus 4.7 有 `7.0m cache read`、`2.1m cache write`，Haiku 也有 cache write。
- 這證明 Synterolink 會透傳 Anthropic prompt caching，不是每輪都全價 input。
- 5/12 單 session $25.05 的主因是大量使用 Opus 4.7（1.1m input、112.3k output），不是 cache 完全沒開。

可用模型：`claude-sonnet-4-6`（推薦）、`claude-opus-4-7`（複雜任務）、`claude-haiku-4-5`（輕量）。

來源：synterolink 官方說明書（macOS 版），但變數規格在 Windows 同樣適用。
