---
name: 模型切換大戰實戰紀錄（2026-04-11）
description: 一整天的模型失敗與修復過程，成功接入 OpenRouter/SambaNova/Cerebras，建立 5 條備援線路
type: project
---

## 最終成功配置

```
Primary:    openrouter/nvidia/nemotron-3-super-120b-a12b:free（免費，262k context）
Fallback 1: openrouter/google/gemma-4-31b-it:free（免費，262k context）
Fallback 2: sambanova/Meta-Llama-3.3-70B-Instruct（免費，131k context）
Fallback 3: cerebras/qwen-3-235b-a22b-instruct-2507（免費，128k context）
Fallback 4: google/gemini-3.1-pro-preview（每日 250 次免費）
```

---

## 每個模型的真實狀況

### ❌ Groq — 永久不能當 Primary
- **根本問題**：openclaw 系統提示約 57k tokens，Groq 的 llama-3.3-70b 每分鐘上限 12k TPM
- **結論**：結構問題，改不了。Groq 只能跑小任務，不能當小龍蝦主力
- **錯誤訊息**：`413 Request too large: Limit 12000, Requested 58024`

### ❌ DeepSeek — billing 帳號問題
- **根本問題**：舊 key `sk-d1cc076253d3403e889f8ab65dd97197` 累積 915 次 billing 錯誤
- **新 key 也失敗**：`sk-240d251b3dc145e7b5943c74c691ef57` → `Insufficient Balance`
- **結論**：DeepSeek 免費額度已限縮，新帳號需儲值才能用

### ❌ xAI Grok — 不是免費
- **根本問題**：API key 只有 web search 權限，跑模型需付費 credits
- **錯誤**：`Your newly created team doesn't have any credits or licenses yet`
- **結論**：xAI 非免費，不適合納入

### ⚠️ Gemini — 每日 250 次，今日已耗盡
- **重置時間**：午夜 UTC = 台灣時間 **早上 8 點**
- **陷阱**：auth-profiles.json 的 usageStats 顯示「可用」，但實際 API 仍回 429
  - 代表 openclaw 內部 cooldown 和 Gemini 實際配額是兩件事
- **結論**：保留為最後 fallback，不能當 Primary

### ✅ Cerebras — 可用但流量不穩
- **接入方式**：apiKey 必須直接寫進 models.json provider 設定，auth-profiles 方式無效
- **可用模型**：`qwen-3-235b-a22b-instruct-2507`（其他模型 context 太小或無法存取）
- **限制**：免費額度降低公告，GLM-4.7 和 GPT-OSS 暫時降低；qwen 高峰期 429/timeout
- **接入 endpoint**：`https://api.cerebras.ai/v1`

### ✅ SambaNova — 可用但有 rate limit
- **接入 endpoint**：`https://fast-api.snova.ai/v1`（不是 api.sambanova.ai，那個 DNS 不通）
- **速度極快**：330+ tokens/秒
- **限制**：免費帳號有 rate limit，同樣用 apiKey 直接寫進 models.json

### ✅ OpenRouter — 最穩定，當 Primary
- **接入 endpoint**：`https://openrouter.ai/api/v1`
- **免費模型**：27 個，其中好用的：
  - `nvidia/nemotron-3-super-120b-a12b:free`（262k ctx，目前 Primary）
  - `google/gemma-4-31b-it:free`（262k ctx）
  - `nvidia/nemotron-3-nano-30b-a3b:free`（256k ctx）
- **接入方式**：apiKey 寫進 models.json + auth-profiles 都要設

---

## Live Session Model Lock — 最核心的技術問題

**症狀**：`All models failed: Live session model switch requested: xxx (unknown)`

**根本原因**（不變）：
1. Session 啟動時，openclaw 把 Primary 模型寫入 JSONL 的 `model_change` 事件
2. Primary 失敗後，fallback 嘗試接管
3. openclaw 偵測到「session 應該用 Primary」→ 拒絕 fallback → 全部失敗

**正確的修復步驟**（每次遇到都這樣做）：
```bash
python3 << 'EOF'
import json, os

# 1. 找並刪掉鎖死的 JSONL
sess_path = '/Users/bymyway/.openclaw/agents/main/sessions/sessions.json'
d = json.load(open(sess_path))
for k in list(d.keys()):
    sf = d[k].get('sessionFile')
    if sf and os.path.exists(sf): os.remove(sf)
    del d[k]
json.dump(d, open(sess_path, 'w'), indent=2)

# 2. 清所有 cooldown
auth_path = '/Users/bymyway/.openclaw/agents/main/agent/auth-profiles.json'
d2 = json.load(open(auth_path))
for k in d2.get('usageStats', {}): d2['usageStats'][k] = {}
json.dump(d2, open(auth_path, 'w'), indent=2)
EOF

# 3. 重啟
launchctl kickstart -k gui/$(id -u)/ai.openclaw.gateway
```

**重要**：JSONL 檔案一定要刪，只清 sessions.json 條目不夠，gateway 會找到舊 JSONL 繼續鎖

---

## 接入新 Provider 的正確方法

必須同時做三件事（缺一不可）：

1. **models.json** — 加 provider 設定（含 baseUrl、api格式、apiKey、模型清單）
2. **auth-profiles.json** — 加 `xxx:default` profile（部分 provider 此步可省，但建議都加）
3. **openclaw.json** — 把模型加進 primary 或 fallbacks，加 alias

**context window 設定**：models.json 裡的 `contextWindow` 必須 ≥ 16000，否則 openclaw 直接拒絕該模型

---

## 新增的監控機制

- **心跳監測**：LaunchAgent `ai.openclaw.heartbeat`，每 90 分鐘檢查並 Telegram 通報
- **Session 自動修復**：LaunchAgent `ai.openclaw.session-fix`，每 2 分鐘執行
- **腳本位置**：`/Users/bymyway/.openclaw/scripts/`

---

## 下次遇到「小龍蝦沒反應」的排查順序

1. `launchctl list | grep openclaw` — gateway 有沒有跑
2. 讀 sessions.json — session status 是不是 failed
3. 讀最新 JSONL tail — 看具體錯誤（rate_limit? billing? session lock?）
4. 執行上面的修復步驟
5. 換 Primary 到目前可用的模型
6. `openclaw agent -m "測試" --channel telegram --deliver --to 6124913915` 驗證
