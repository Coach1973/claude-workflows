#!/usr/bin/env python3
"""批次掃描記憶檔，只提取教練說的話（省 Token）"""
import re, sys, json
from pathlib import Path

def extract_coach_from_file(filepath):
    """從 markdown 記憶檔中提取教練的實際對話"""
    messages = []
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # 找出所有 JSON block（教練訊息）
        # 格式: {"sender_label": "coach", "body": "..."}
        pattern = r'"sender_label":\s*"coach[^}]*"body":\s*"([^"]*)"'
        matches = re.findall(pattern, content)
        
        for body in matches:
            # 過濾系統訊息
            if body and not body.startswith('【') and 'timestamp' not in body and len(body) > 5:
                messages.append(body)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
    return messages

def main():
    if len(sys.argv) < 2:
        print("Usage: extract_coach.py <output_file> [memory_files...]")
        sys.exit(1)
    
    output_file = sys.argv[1]
    memory_files = sys.argv[2:] if len(sys.argv) > 2 else []
    
    all_messages = []
    for mf in memory_files:
        msgs = extract_coach_from_file(mf)
        all_messages.extend(msgs)
        print(f"Processed {mf}: {len(msgs)} messages", file=sys.stderr)
    
    # 寫入輸出檔
    with open(output_file, 'w', encoding='utf-8') as f:
        for i, msg in enumerate(all_messages, 1):
            f.write(f"[{i}] {msg}\n")
    
    print(f"\nTotal: {len(all_messages)} coach messages written to {output_file}", file=sys.stderr)

if __name__ == '__main__':
    main()
