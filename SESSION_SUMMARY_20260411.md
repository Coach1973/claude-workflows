# 2026-04-11 工作總結

## 完成的任務

### 1. DeepSeek API 接入
- 教練自行登入 DeepSeek 開放平台（Google 帳號），取得 API Key
- 完成三個設定檔修改：`auth-profiles.json`、`models.json`、`openclaw.json`
- OpenClaw 自動校正 models.json（改為正確的 `openai-completions` 格式）
- 確認 `openclaw models` 顯示 deepseek 已載入

### 2. Live Session Model Lock 永久修復
**根本原因分析：**
- 每次 Session 啟動，OpenClaw 把 Primary（Gemini）鎖入 `model_change` 事件
- Gemini 限流後，Fallback 嘗試接管時被要求「切回 Gemini」，而 Gemini 不可用 → error=unknown
- 源碼在 `live-model-switch.ts`，無法透過設定關閉

**永久修復：**
- 建立 `/Users/bymyway/.openclaw/scripts/auto-fix-session-lock.sh`
- 安裝 LaunchAgent `ai.openclaw.session-fix`（每 2 分鐘自動執行）
- 邏輯：session=failed + Gemini cooldown → 重導向 DeepSeek；Gemini 恢復 → 清除 session 讓它重啟

### 3. Token 效率優化
- 確認讀取 Telegram 回應的最佳方式：**直接讀 JSONL session 檔案**
- 比截圖省 100 倍 Token（純文字讀取 vs 圖像解析）
- 日後由 Claude Code 主動讀取，不需教練轉貼

---

## 待完成（Gemini 8 點恢復後執行）

**根本解：把 Primary 改成 DeepSeek**
```json
"primary": "deepseek/deepseek-chat",
"fallbacks": ["google/gemini-3.1-pro-preview", "groq/llama-3.3-70b-versatile", "anthropic/claude-sonnet-4-6"]
```
原因：DeepSeek 無每日次數限制，不會觸發 session lock 問題。Gemini 的每日 250 次配額留給高品質任務。

---

## 重要學習：讀取 Telegram 回應不截圖

```python
# 查 session 狀態
import json
with open('/Users/bymyway/.openclaw/agents/main/sessions/sessions.json') as f:
    d = json.load(f)
entry = d.get('agent:main:telegram:direct:6124913915', {})
print(entry.get('status'), entry.get('sessionFile'))
```

---

## 目前模型 Fallback 順序
1. Gemini 3.1 Pro（每日 250 次免費）
2. Groq llama-3.3-70b（免費額度，128k context）
3. **DeepSeek Chat** ← 新增，免費額度，65k context
4. Claude Sonnet（付費，餘額不足暫停）
