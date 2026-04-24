# 2026-04-24 下午場：NVIDIA/OpenCode/三機互通 整合日誌

> 記錄人：克勞德助教
> 時間：2026-04-24（下午至 17:16）
> 對話量：極大（建議接手者直接讀本檔，不要看原始對話）

---

## 🎯 今日目標（三條主線）

1. 把 NVIDIA API Key 接入 OpenCode UI
2. 把 EasyClaude API Key 接入 OpenCode UI
3. 解決 3號機（kong）在 Telegram 群組無回應問題

---

## ✅ 已完成

### OpenCode UI 模型整合

- **EasyClaude**：成功接入，僅保留 `claude-sonnet-4-6`
- **NVIDIA**：成功接入，保留 8 個測試通過模型
- **設定檔位置**：`/Users/bymyway/.config/opencode/opencode.jsonc`
- **所有 115 個內建 provider 已全數 disable**，只顯示自訂的兩組

#### 最終有效模型清單（全部 API 200 測試通過）

| # | 模型 ID | 強項 |
|---|---------|------|
| ① | `claude-sonnet-4-6`（EasyClaude） | 日常主力 |
| ② | `meta/llama-3.3-70b-instruct` | 免費通用 |
| ③ | `meta/llama-3.1-405b-instruct` | 開源最大 |
| ④ | `deepseek-ai/deepseek-v3.2` | 程式推理（較慢） |
| ⑤ | `qwen/qwen3-coder-480b-a35b-instruct` | 最強寫程式 |
| ⑥ | `qwen/qwen3-next-80b-a3b-thinking` | 深度推理 |
| ⑦ | `moonshotai/kimi-k2-instruct` | 中文+128K |
| ⑧ | `nvidia/llama-3.3-nemotron-super-49b-v1` | 128K 長上下文 |
| ⑨ | `qwen/qwen3.5-397b-a17b` | 知識廣度最全 |

---

## ❌ 確認無效（踩坑紀錄）

### OpenCode 接入坑

| 坑 | 原因 | 正確做法 |
|----|------|---------|
| `api_key` 欄位無效 | SDK ProviderConfig 沒有此欄位 | 必須用 `options.apiKey` |
| `@ai-sdk/anthropic` + EasyClaude | 此 npm 不支援自訂 baseURL | 改用 `@ai-sdk/openai-compatible` |
| 沒加 `whitelist` | OpenCode 會動態抓 `/v1/models`，把所有模型都列出 | 加 `whitelist` 陣列鎖死顯示清單 |
| 沒加 `blacklist` | whitelist 擋不住的漏網之魚 | whitelist + blacklist 雙重封鎖 |

### NVIDIA 模型（此 Key 下 404 無效）

- `nvidia/llama-3.1-nemotron-ultra-253b-v1`（404）
- `mistralai/mistral-small-3.2-24b-instruct`（404）
- `qwen/qwen2.5-72b-instruct`（404）
- `microsoft/phi-4-multimodal-instruct`（404）
- `meta/llama-4-maverick-17b-128e-instruct`（404）
- `qwen/qwen2.5-coder-32b-instruct`（404）

### OpenCode 中 Claude 的問題
- 選單出現「BED」（可能是某個 provider 殘留）
- EasyClaude 在 OpenCode 中仍有「Invalid」報錯
- **結論：NVIDIA 模型可在 OpenCode 正常使用，Claude 仍有問題，暫記錄待後續排查**

---

## 🔴 未解決（最重要）

### 3號機（kong）Telegram 群組無回應

**根本原因確認**：
- kong 的 system prompt + tools ≈ **108,000 tokens**
- 大多數模型上下文窗口不夠（DeepSeek 64K、Qwen 32K 等）
- 需要支援 **≥128K context** 的模型

**今日嘗試過的模型（全部失敗）**：

| 嘗試 | 結果 | 失敗原因 |
|------|------|---------|
| `openrouter/deepseek/deepseek-chat` | ❌ | 64K 上下文不足 |
| `litellm/claude-sonnet-easyclaude` | ❌ | OpenClaw 拒絕，不在內部 registry |
| `nvidia-api/nvidia/llama-3.3-nemotron-super-49b-v1` | ❌ | 自訂 provider 格式不被 OpenClaw 接受 |
| `openrouter/nvidia/llama-3.3-nemotron-super-49b-v1` | ⏳ | 剛換上，尚未確認結果 |

**現在的設定（截至 17:16）**：
- Primary：`openrouter/nvidia/llama-3.3-nemotron-super-49b-v1`
- Fallback 1：`openrouter/qwen/qwen3-next-80b-a3b-thinking`
- Fallback 2：`openrouter/qwen/qwen3-coder-480b-a35b-instruct`
- Fallback 3：`openrouter/google/gemini-2.5-flash`（原本可用的保底）

**下一步**：確認 OpenRouter 上這些 NVIDIA 模型 ID 是否正確，如果不行，回退到 Gemini 2.5 Flash 繼續用。

---

## 🔴 三機互讀方案（設計中，未實作）

**問題**：Telegram Bot API 限制——Bot 無法接收其他 Bot 的訊息

**現有機制**：
- `BOT_RELAY.json`：`/Users/bymyway/.openclaw/shared/BOT_RELAY.json`
- 三機各有 `bot-relay`（寫出）和 `bot-relay-inbound`（輪詢讀入）hook

**待實作方案**（已準備好任務書，交由 Qwen3 Thinking 80B 推導，再交 Coder 480B 實作）：
- BOT_RELAY.json 需加入 `round_counter`、`sender`、`timestamp`
- 每次人類發言後，三機各回應一次，總計不超過 3 輪（9 條訊息上限）
- `bot-relay-inbound` hook 需判斷「這一輪我要不要回應」

---

## 💡 關鍵發現總結

1. **NVIDIA API Key 只能用於 OpenCode UI，不能直接接入 OpenClaw bot**
2. **OpenClaw 有 model registry 驗證機制**，自訂 provider 格式必須嚴格符合，否則報 Unknown model
3. **OpenCode 的 provider 設定**：`npm: "@ai-sdk/openai-compatible"` + `options.apiKey` + `options.baseURL` + `whitelist` 是正確組合
4. **DeepSeek V4 今日發布**，NVIDIA 尚未上架（全 404），可改走官方 `api.deepseek.com`（需申請 key）
5. **Qwen3 Thinking 80B 適合設計，Coder 480B 適合實作**——兩段式流程效率最高

---

## 📋 PROMISES 新增項目

| # | 內容 | 狀態 |
|---|------|------|
| 17 | 確認 OpenRouter 上的 NVIDIA 模型 ID 是否正確，3號機測試結果 | ⬜ 待確認 |
| 18 | 三機互讀 BOT_RELAY 方案：Qwen3 Thinking 推導 → Coder 實作 → 部署 | ⬜ 待執行 |
| 19 | EasyClaude 在 OpenCode 的 Invalid 問題排查 | ⬜ 低優先 |
| 20 | DeepSeek 官方 API Key 申請後接入 OpenCode | ⬜ 待教練申請 |

---

## ⏱️ 時間浪費與重複項目（血淚教訓）

| 浪費點 | 耗費回合 | 改進方式 |
|--------|---------|---------|
| `api_key` 欄位用錯，重試多次 | ~3輪 | 接新 provider 前先讀 SDK TypeScript 型別定義 |
| EasyClaude 先用 `@ai-sdk/anthropic` 失敗，再換 `openai-compatible` | ~2輪 | 先測試端點格式（OpenAI vs Anthropic）再決定 npm |
| NVIDIA 自訂 provider 在 OpenClaw 失敗 | ~3輪 | 先確認 OpenClaw 支援的 model 格式再動手 |
| whitelist 沒加，模型清單一直亂跑 | ~2輪 | 接入 OpenCode 的同時就要加 whitelist |
| 模型精簡邏輯反覆修改（14→8→7→9個） | ~4輪 | 先測試再加入，不要假設可用 |

**總結**：今天約 40% 的對話是在修復之前步驟造成的問題。核心教訓：**先查型別定義和 API 格式，再動手改設定**。
