# Relay 自動化基礎架構說明

> 建立日期：2026-05-05
> 目的：讓小龍蝦可以透過 Telegram 觸發終端機任務，教練不用當傳話筒

---

## 一、relay 架構（三段式）

```
教練 → 小龍蝦（Telegram）→ RELAY_QUEUE.json → relay_poll.py → 終端機（Claude Code）
                                        ↓
                              type=claude_exec → claude --print 執行
```

1. **寫入階段**：小龍蝦（或教練）透過 `relay_submit.py` 把任務寫進 `RELAY_QUEUE.json`
2. **輪詢階段**：`relay_poll.py` 由 cron 每 10 秒呼叫，檢查 pending 任務
3. **執行階段**：`relay_poll.py` 分發給對應 handler（目前已實作 `claude_exec`）

---

## 二、小龍蝦怎麼寫入任務

### 指令格式（relay_submit.py）
```bash
python3 scripts/relay_submit.py <from_bot> <to_bot> "<content>" ["<created_by>"]
```

### claude_exec 任務格式（直接寫入 RELAY_QUEUE.json）
```python
# 在 Python 裡執行：
import json
from datetime import datetime, timezone

with open('shared-context/RELAY_QUEUE.json', 'r') as f:
    queue = json.load(f)

task = {
    "id": "自訂ID",
    "from": "1",
    "to": "1",
    "type": "claude_exec",
    "prompt": "你的 prompt 內容",
    "status": "pending",
    "createdAt": datetime.now(timezone.utc).isoformat(),
    "createdBy": "小龍蝦"
}
queue["tasks"].append(task)

with open('shared-context/RELAY_QUEUE.json', 'w') as f:
    json.dump(queue, f, ensure_ascii=False, indent=2)
```

---

## 三、輸出結果在哪裡找

當 `relay_poll.py` 執行完 `claude_exec` 任務，輸出會寫入：

```
terminal-notes/relay_output_YYYYMMDD.md
```

**格式**：
```markdown
## 任務 {task_id} | {timestamp}
**Prompt**: {prompt}

**輸出**:
{claude --print 的輸出}
---
```

---

## 四、已實作的 Task Type

| type | 功能 | 輸出位置 |
|------|------|----------|
| `claude_exec` | 執行 `claude --print "prompt"` | `terminal-notes/relay_output_YYYYMMDD.md` |
| 其他 | 待實作 | （僅回報收到）|

---

## 五、Cron 設定（讓 relay_poll 自動跑）

```bash
# 每 10 秒輪詢一次（學弟/學妹机器用）
* * * * * /usr/bin/python3 /Users/bymyway/.openclaw/workspace/scripts/relay_poll.py 2 >> /tmp/relay_poll_2.log 2>&1
* * * * * /usr/bin/python3 /Users/bymyway/.openclaw/workspace/scripts/relay_poll.py 3 >> /tmp/relay_poll_3.log 2>&1
```

---

## 六、測試

```bash
# 手動執行測試
python3 scripts/relay_poll.py 1

# 查看輸出
cat terminal-notes/relay_output_20260505.md
```
