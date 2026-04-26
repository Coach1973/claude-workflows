#!/usr/bin/env python3
"""只抽出教練說的話，用於蒸餾場景"""
import json, sys, os

def extract_coach_messages(filepath):
    messages = []
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            data = json.load(f)
        # 遍歷所有訊息
        for item in data:
            if isinstance(item, dict):
                sender = item.get('sender_label', '')
                body = item.get('body', '')
                if 'coach' in sender.lower() and body and not body.startswith('【') and 'timestamp' not in body:
                    messages.append(body)
    except Exception as e:
        print(f"Error reading {filepath}: {e}", file=sys.stderr)
    return messages

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: scan_coach_dialogue.py <memory_file.md>")
        sys.exit(1)
    
    filepath = sys.argv[1]
    messages = extract_coach_messages(filepath)
    print(f"\n=== {os.path.basename(filepath)} ({len(messages)} messages) ===\n")
    for i, msg in enumerate(messages[:50], 1):  # 最多50條
        print(f"[{i}] {msg[:300]}")
