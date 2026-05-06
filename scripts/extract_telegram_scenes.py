#!/usr/bin/env python3
"""
Extract actual coach messages from Telegram daily log.
Messages are embedded in JSON format inside the 👤 教練： blocks.
"""

import re
import json
from pathlib import Path

DAILY_TELEGRAM = Path('/Users/bymyway/.openclaw/workspace/daily_2026-05-06.md')

def extract_real_messages():
    """Extract messages that are real coach commands, not cron/system."""
    with open(DAILY_TELEGRAM, 'r') as f:
        content = f.read()

    # Split by message blocks
    blocks = content.split('👤 教練：')

    real_messages = []

    for block in blocks[1:]:  # Skip first empty part
        block = block.strip()

        # Skip cron heartbeats
        if block.startswith('[cron:'):
            continue

        # Skip "你是小龍蝦" system instructions
        if block.startswith('你是小龍蝦') or block.startswith('每次心跳'):
            continue

        # Skip "請安靜執行" system instructions
        if block.startswith('請安靜執行'):
            continue

        # Skip JSON/chat_id blocks - extract text after them
        if block.startswith('"chat_id"') or block.startswith('{') or block.startswith('"')):
            # These are Telegram metadata wrappers
            # The actual coach message comes AFTER the JSON block
            # Check if there's text after the closing }
            if '}' in block:
                after_json = block.split('}', 1)[1]
                if after_json.strip() and not after_json.startswith('\n🦞'):
                    msg = after_json.strip()
                    # Clean up and add
                    if msg and len(msg) > 5 and not msg.startswith('Sender'):
                        real_messages.append(msg)
            continue

        # Skip System Exec messages
        if block.startswith('System'):
            continue

        # This should be a real message
        if len(block) > 5:
            # Remove trailing 🦞 response if any
            clean = block.split('\n🦞')[0].strip()
            if clean and len(clean) > 5:
                real_messages.append(clean)

    return real_messages

def main():
    messages = extract_real_messages()
    print(f"Found {len(messages)} real coach messages:\n")
    for i, msg in enumerate(messages):
        print(f"--- Message {i+1} ---")
        print(msg[:200])
        print()

    scenes = []
    scene_num = 457
    for msg in messages:
        if len(msg) < 10:
            continue
        if any(x in msg.lower() for x in ['chat_id', 'sender', 'timestamp', 'message_id']):
            continue

        scenes.append({
            'num': scene_num,
            'date': '2026-05-06',
            'coach': msg,
            'assistant': '(Telegram回覆)',
            'decision': '持續對話中',
            'spirit': ''
        })
        scene_num += 1

    # Generate spirits
    for s in scenes:
        coach = s['coach']
        if '工作清單' in coach:
            s['spirit'] = '教練交代的工作要立即記錄執行'
        elif '完成' in coach and '任務' in coach:
            s['spirit'] = '任務完成要第一時間回報教練'
        elif '領導手冊' in coach or '小南' in coach:
            s['spirit'] = '重要囑託要牢記並按時完成'
        elif '來' in coach and '完成' in coach:
            s['spirit'] = '主動詢問進度時要如實回報'
        else:
            s['spirit'] = '教練話要認真聽，不能只說了解了'

    # Write distilled telegram
    with open('distilled_telegram_0506.md', 'w') as f:
        f.write("# 蒸餾場景 — Telegram 對話（2026-05-06）\n\n")
        f.write(f"> 共 {len(scenes)} 個高品質場景\n\n")
        f.write("---\n\n")
        for s in scenes:
            lines = [
                f"### 場景 #{s['num']}",
                f"**時間：** {s['date']}",
                f"**教練說了什麼：** 「{s['coach'][:300]}」",
                f"**助教說了什麼：** {s['assistant']}",
                f"**最後決定做什麼：** {s['decision']}",
                f"**提煉出的核心精神：** 「{s['spirit']}」",
                ""
            ]
            f.write('\n'.join(lines) + '\n')

    print(f"\n✅ Written {len(scenes)} scenes to distilled_telegram_0506.md")

if __name__ == '__main__':
    main()