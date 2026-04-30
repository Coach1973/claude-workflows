#!/usr/bin/env python3
"""
relay_poll.py — 輪詢並處理 RELAY_QUEUE 中的任務
用法: python3 relay_poll.py <bot_number>
範例: python3 relay_poll.py 2   # 學弟(2號機)輪詢
       python3 relay_poll.py 3   # 學妹(3號機)輪詢

功能：
1. 每 10 秒執行一次（由 cron 呼叫）
2. 檢查佇列中是否有 status=pending 且 to=自己 bot 號的任務
3. 若有，先 lock 為 processing，再處理，最後標為 completed
4. 任務超時 60 秒，自動重置為 pending
"""

import json
import sys
import os
import fcntl
from datetime import datetime, timezone, timedelta

QUEUE_FILE = "/Users/bymyway/.openclaw/workspace/shared-context/RELAY_QUEUE.json"
TIMEOUT_SECONDS = 60

# Bot Token 對照
BOT_TOKENS = {
    "1": "8758843664:AAE4W-hGh2mPxNt89b2donZ0Q--YZ9uwdsA",
    "2": "8555923043:AAEOoI2ZWIyKW69Z32IMaM0sYajG6D9HkeQ",
    "3": "8705446823:AAHDA0wvjdxXsaB3yX3PRiEkG_wO2N-BWa8"
}

GROUP_ID = "-1003877502911"

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

def find_and_process_task(bot_num):
    """找到第一個屬於自己的 pending 任務並處理"""
    queue = load_queue()
    now = datetime.now(timezone.utc)
    task_found = None
    task_index = -1
    
    # 找 pending 任務
    for i, task in enumerate(queue["tasks"]):
        if task["status"] == "pending" and task["to"] == bot_num:
            task_found = task
            task_index = i
            break
    
    if task_found is None:
        # 檢查是否有超時的 processing 任務，重置為 pending
        for i, task in enumerate(queue["tasks"]):
            if task["status"] == "processing" and task["to"] == bot_num:
                created = datetime.fromisoformat(task["createdAt"].replace("Z", "+00:00"))
                if (now - created) > timedelta(seconds=TIMEOUT_SECONDS):
                    queue["tasks"][i]["status"] = "pending"
                    print(f"⏰ 任務 {task['id']} 處理超時，已重置為 pending")
        save_queue(queue)
        return False
    
    # Lock 任務為 processing
    queue["tasks"][task_index]["status"] = "processing"
    queue["tasks"][task_index]["processedAt"] = now.isoformat()
    save_queue(queue)
    
    print(f"🎯 收到任務：{task_found['content']}")
    print(f"   ID: {task_found['id']}")
    print(f"   From: {task_found['from']}號機")
    print(f"   Status: processing")
    
    # 在這裡呼叫 subagent 或 exec 處理任務
    # 任務內容在 task_found['content']
    # 處理完成後回報群組
    
    return True

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("用法: python3 relay_poll.py <bot_number>")
        print("範例: python3 relay_poll.py 2")
        sys.exit(1)
    
    bot_num = sys.argv[1]
    if bot_num not in ["1", "2", "3"]:
        print("錯誤：bot_number 必須是 1、2 或 3")
        sys.exit(1)
    
    processed = find_and_process_task(bot_num)
    if processed:
        print(f"✅ {bot_num}號機 已接受任務並開始處理")
    else:
        print(f"📭 {bot_num}號機 佇列中沒有新任務")
