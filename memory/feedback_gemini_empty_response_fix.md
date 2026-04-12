# Gemini 空白回應問題 — 根本原因與永久修復

## 問題描述
小龍蝦完全沒有回應，但 session 顯示 `done`（不是 `failed`）

## 根本原因

**memory 檔案膨脹 → 觸發讀取 → Gemini 輸出 0 token**

流程：
1. Context Overflow 自動重啟 → HEARTBEAT.md 被覆寫為「讀 memory/today.md」
2. memory/today.md 已超過 50KB（sync-telegram-memory.sh 每半小時同步一次全部歷史）
3. 教練傳訊息 → 小龍蝦啟動 → 讀了 27,949 字的 memory 檔
4. Gemini context 爆滿 → `output: 0 tokens`, `stopReason: stop` → 回覆空字串
5. 教練看不到任何回應，以為小龍蝦壞了

## 永久修復（2026-04-12 完成）

### 1. HEARTBEAT.md 輕量化
- 正常心跳：只回 `HEARTBEAT_OK`
- Overflow 重啟後：只說「已重啟請繼續」，**不讀 memory 大檔**
- 明確警告：`memory/today.md > 50KB 不可讀`

### 2. auto-fix-session-lock.sh 更新
- Overflow 觸發的 HEARTBEAT 模板改為輕量版
- 不再要求小龍蝦讀 memory 檔案

## 診斷快速步驟
```bash
# 1. 看 session 狀態
cat sessions.json | python3 -c "import json,sys; d=json.load(sys.stdin); [print(k[:50],'→',v.get('status')) for k,v in d.items()]"

# 2. 看最新 session 的 output tokens
# output=0 + stopReason=stop → Gemini context 爆滿

# 3. 看 memory 檔大小
ls -la workspace/memory/

# 4. 確認 HEARTBEAT 是否叫讀大型 memory 檔
cat workspace/HEARTBEAT.md | grep -i memory
```

## 重要規則
- `memory/today.md` 超過 **30KB** 就不要讓小龍蝦讀
- HEARTBEAT.md 絕對不可以包含「讀 memory/today.md」這類指令
- Gemini 3.1 Pro Preview 的有效 context 約 15-20K token，超過就返回空
