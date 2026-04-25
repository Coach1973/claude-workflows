# DeepSeek 任務書 — 2026-04-25

> 執行者：DeepSeek V3.2（透過 OpenCode）
> 授權人：大樹教練
> 優先級：高
> 原則：能自己做直接做，不問確認，完成後回報結果

---

## 🕐 上一手進度交接（Opcode 2026-04-24 晚間跑到一半停止）

上一個 AI（Claude，透過 Opcode）昨晚處理到以下進度，**因 API 額度耗盡而中斷**：

### 已確認的問題根源
- 三機個別私訊都正常，但在各自老師的 Telegram 群組裡沒有回應
- 原因：各機的 `openclaw.json` 裡 `channels.telegram.groups` 缺少對應的群組 ID

### 已完成的修復（上一手做的）
- 2號機：已加入佩佩老師群組 `-5115910257`（`requireMention: false`）
- 3號機：已加入孔大哥群組 `-5083547625`（`requireMention: true`）
- 3號機模型已換為 `openrouter/nvidia/llama-3.3-nemotron-super-49b-v1`（尚未確認是否有效）

### 尚未完成（停在這裡）
- 修完設定後**沒有重啟**任何一台（額度用完就停了）
- 未確認 OpenRouter 上是否真的有 Nemotron Super 49B 這個模型 ID
- 未在群組實測三機是否真的能回應

### 你現在接手的起點
設定理論上已正確，但三機**沒有重啟過**，所以新設定還沒生效。你的第一步就是重啟 + 驗證。

---

## 📋 背景說明（必讀）

系統有三隻 OpenClaw AI Bot，跑在同一台 Mac mini：

| 名稱 | 服務 | 目錄 | Telegram Bot |
|------|------|------|-------------|
| 1號機（學長） | ai.openclaw.gateway | `/Users/bymyway/.openclaw/` | @openclaw_macbook4_bot |
| 2號機（佩佩） | ai.openclaw.peipei | `/Users/bymyway/.openclaw-peipei/` | @coachwu_lenovo_bot |
| 3號機（孔大哥/kong） | ai.openclaw.kong | `/Users/bymyway/.openclaw-kong/` | @CoachWu_openclaw_bot |

**重要群組 ID：**
- 頂級特助分工群：`-1003877502911`
- 佩佩老師群組：`-5115910257`
- 孔大哥群組：`-5083547625`

---

## 🔴 任務一：確認三機目前狀態

執行以下指令，回報結果：

```bash
launchctl list | grep claw
```

確認三個服務都有 PID（代表正在運行）。若任何一個沒有 PID，執行：

```bash
launchctl kickstart -k gui/$(id -u)/ai.openclaw.gateway
launchctl kickstart -k gui/$(id -u)/ai.openclaw.peipei
launchctl kickstart -k gui/$(id -u)/ai.openclaw.kong
```

---

## 🔴 任務二：確認三機群組設定正確

檢查每台的 `openclaw.json`，確認 `channels.telegram.groups` 包含以下內容：

**1號機** `/Users/bymyway/.openclaw/openclaw.json`：
應包含 `-1003877502911`（頂級特助分工群）

**2號機** `/Users/bymyway/.openclaw-peipei/openclaw.json`：
應同時包含：
- `-1003877502911`（頂級特助分工群）
- `-5115910257`（佩佩老師群組，requireMention: false）

**3號機** `/Users/bymyway/.openclaw-kong/openclaw.json`：
應同時包含：
- `-1003877502911`（頂級特助分工群，requireMention: true）
- `-5083547625`（孔大哥群組，requireMention: true）

執行指令確認：
```bash
python3 -c "
import json
for name, path in [('1號機','/Users/bymyway/.openclaw/openclaw.json'),('2號機','/Users/bymyway/.openclaw-peipei/openclaw.json'),('3號機','/Users/bymyway/.openclaw-kong/openclaw.json')]:
    d = json.load(open(path))
    groups = d.get('channels',{}).get('telegram',{}).get('groups',{})
    print(name, '群組:', list(groups.keys()))
"
```

若有缺少，照以下格式補入對應 `openclaw.json` 的 `channels.telegram.groups` 區塊。

---

## 🔴 任務三：重啟並等待穩定

設定確認無誤後，依序重啟三機：

```bash
launchctl kickstart -k gui/$(id -u)/ai.openclaw.gateway && sleep 3
launchctl kickstart -k gui/$(id -u)/ai.openclaw.peipei && sleep 3
launchctl kickstart -k gui/$(id -u)/ai.openclaw.kong && sleep 3
launchctl list | grep claw
```

---

## 🟡 任務四：確認 3號機模型是否有效

3號機目前設定的 primary 模型是 `openrouter/nvidia/llama-3.3-nemotron-super-49b-v1`。

檢查 OpenRouter 是否有這個模型 ID：

```bash
curl -s "https://openrouter.ai/api/v1/models" \
  -H "Authorization: Bearer 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" \
  | python3 -c "
import json, sys
data = json.load(sys.stdin)
models = data.get('data', [])
target = 'nvidia/llama-3.3-nemotron-super-49b-v1'
found = [m for m in models if target in m.get('id','')]
print('找到:', [m['id'] for m in found])
print('總模型數:', len(models))
"
```

**若找不到該模型 ID：**
將 3號機的 primary 改為 `openrouter/google/gemini-2.5-flash`（穩定可用）：

```bash
python3 -c "
import json
path = '/Users/bymyway/.openclaw-kong/openclaw.json'
with open(path) as f:
    d = json.load(f)
d['agents']['defaults']['model']['primary'] = 'openrouter/google/gemini-2.5-flash'
with open(path, 'w') as f:
    json.dump(d, f, indent=2, ensure_ascii=False)
print('已更新 3號機模型為 Gemini 2.5 Flash')
"
```

然後重啟 3號機：
```bash
launchctl kickstart -k gui/$(id -u)/ai.openclaw.kong
```

---

## 完成後回報

請回報：
1. 三機服務狀態（PID）
2. 三機群組設定是否正確
3. 3號機模型最終使用哪一個
4. 是否有任何錯誤

---
*任務書由克勞德助教撰寫，授權 DeepSeek 執行*
