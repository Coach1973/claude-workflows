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
5. claude_exec 類型任務：執行 claude --print "prompt" 並將輸出寫入檔案
"""

import json
import sys
import os
import fcntl
import subprocess
from datetime import datetime, timezone, timedelta

QUEUE_FILE = "/Users/bymyway/.openclaw/workspace/shared-context/RELAY_QUEUE.json"
WORKSPACE = "/Users/bymyway/.openclaw/workspace"
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

    task_type = task_found.get("type", "default")
    content = task_found.get("content", task_found.get("prompt", ""))

    print(f"🎯 收到任務：{content}")
    print(f"   ID: {task_found['id']}")
    print(f"   From: {task_found['from']}號機")
    print(f"   Status: processing")

    # 分發給對應 handler 處理
    success = False
    result_msg = ""

    if task_type == "claude_exec":
        success, result_msg = handle_claude_exec(task_found)
    else:
        # default: 僅回報收到任務（尚未實作其他類型）
        print(f"   [INFO] 任務類型 '{task_type}' 尚未實作特定 handler")
        success = True
        result_msg = "任務已收到（待實作處理）"

    # 更新任務狀態
    queue = load_queue()
    for i, task in enumerate(queue["tasks"]):
        if task["id"] == task_found["id"]:
            queue["tasks"][i]["status"] = "done" if success else "failed"
            queue["tasks"][i]["completedAt"] = datetime.now(timezone.utc).isoformat()
            queue["tasks"][i]["result"] = result_msg
            break
    save_queue(queue)

    print(f"✅ 任務處理完成：{result_msg}")
    return True


def handle_claude_exec(task):
    """處理 claude_exec 類型任務：執行 claude --print 并输出到文件"""
    prompt = task.get("prompt", "")
    if not prompt:
        return False, "prompt 為空"

    # 生成輸出檔名
    date_str = datetime.now().strftime("%Y%m%d")
    output_file = os.path.join(WORKSPACE, f"terminal-notes/relay_output_{date_str}.md")

    # 執行 claude --print
    try:
        result = subprocess.run(
            ["claude", "--print", prompt],
            capture_output=True,
            text=True,
            timeout=120,
            cwd=WORKSPACE
        )
        output = result.stdout if result.returncode == 0 else f"錯誤：{result.stderr}"
    except subprocess.TimeoutExpired:
        return False, "執行超時（120秒）"
    except FileNotFoundError:
        return False, "找不到 claude 命令"
    except Exception as e:
        return False, f"執行異常：{str(e)}"

    # 寫入輸出檔
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    with open(output_file, "a", encoding="utf-8") as f:
        f.write(f"\n## 任務 {task['id']} | {timestamp}\n")
        f.write(f"**Prompt**: {prompt}\n\n")
        f.write("**輸出**:\n")
        f.write(output)
        f.write("\n---\n")

    return True, output_file


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
