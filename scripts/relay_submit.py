#!/usr/bin/env python3
"""
relay_submit.py — 寫入任務到 RELAY_QUEUE.json
用法: python3 relay_submit.py <from_bot> <to_bot> "<content>" ["<created_by>"]
範例: python3 relay_submit.py 1 2 "學弟，請檢查今日進度" "教練"
       python3 relay_submit.py 1 3 "學妹，請確認目標" "教練"
"""

import json
import sys
import uuid
from datetime import datetime, timezone

QUEUE_FILE = "/Users/bymyway/.openclaw/workspace/shared-context/RELAY_QUEUE.json"

def load_queue():
    try:
        with open(QUEUE_FILE, "r", encoding="utf-8") as f:
            return json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
        return {
            "tasks": [],
            "status": {
                "1": {"lastTaskId": None, "lastAt": None},
                "2": {"lastTaskId": None, "lastAt": None},
                "3": {"lastTaskId": None, "lastAt": None}
            }
        }

def save_queue(queue):
    with open(QUEUE_FILE, "w", encoding="utf-8") as f:
        json.dump(queue, f, ensure_ascii=False, indent=2)

def submit_task(from_bot, to_bot, content, created_by="教練"):
    queue = load_queue()
    task_id = str(uuid.uuid4())
    now = datetime.now(timezone.utc).isoformat()
    
    task = {
        "id": task_id,
        "from": from_bot,
        "to": to_bot,
        "content": content,
        "status": "pending",
        "createdAt": now,
        "createdBy": created_by
    }
    
    queue["tasks"].append(task)
    save_queue(queue)
    
    print(f"✅ 任務已寫入佇列")
    print(f"   ID: {task_id}")
    print(f"   From: {from_bot}號機")
    print(f"   To: {to_bot}號機")
    print(f"   內容: {content}")
    print(f"   狀態: pending")
    return task_id

if __name__ == "__main__":
    if len(sys.argv) < 4:
        print("用法: python3 relay_submit.py <from_bot> <to_bot> \"<content>\" [\"created_by\"]")
        print("範例: python3 relay_submit.py 1 2 \"學弟，請檢查今日進度\" \"教練\"")
        sys.exit(1)
    
    from_bot = sys.argv[1]
    to_bot = sys.argv[2]
    content = sys.argv[3]
    created_by = sys.argv[4] if len(sys.argv) > 4 else "教練"
    
    submit_task(from_bot, to_bot, content, created_by)
