#!/bin/bash
# relay_task_bot2.sh
# 由 peipei（2號機）cron 每分鐘執行一次
# 檢查 BOT_RELAY.json，發現留給自己的任務就透過 openclaw agent 處理

RELAY_FILE="/Users/bymyway/.openclaw/workspace/shared-context/BOT_RELAY.json"
BOT_ID="2"
AGENT_PORT="18793"
GATEWAY_TOKEN="0283df55e8cb4c34a1c095f5f5ccb5455e7b388e30152ada"

python3 -c "
import json, os

RELAY_FILE = '$RELAY_FILE'
BOT_ID = '$BOT_ID'
GATEWAY_TOKEN = '$GATEWAY_TOKEN'
AGENT_PORT = '$AGENT_PORT'

with open(RELAY_FILE) as f:
    relay = json.load(f)

last = relay.get('last_processed', {}).get(BOT_ID, '0')
messages = relay.get('messages', [])
pending = []

for msg in messages:
    msg_id = str(msg.get('id', '0'))
    target_bot = str(msg.get('bot', ''))
    if msg_id > last and target_bot == BOT_ID:
        pending.append(msg)

if not pending:
    print('[relay] no pending tasks for bot 2')
    exit(0)

print(f'[relay] found {len(pending)} task(s) for bot 2')
for task in pending:
    task_id = str(task['id'])
    content = task.get('content', '')
    from_bot = task.get('from', 'unknown')
    print(f'[relay] processing task {task_id} from {from_bot}')
    # Update last_processed immediately
    relay['last_processed'][BOT_ID] = task_id
    with open(RELAY_FILE, 'w') as f:
        json.dump(relay, f, ensure_ascii=False)
    # Use openclaw agent to process the task
    os.system(f'openclaw --profile peipei agent --message \"{content[:200]}\" --deliver 2>/dev/null')
    print(f'[relay] task {task_id} done')
" 2>/dev/null