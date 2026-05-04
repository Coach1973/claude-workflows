#!/usr/bin/env python3
"""
蒸餾 Claude 桌面版 Sessions - 萃取場景到 stage2_scenes.md
"""

import json
import os
import re
from pathlib import Path
from datetime import datetime

OPENCLAW_SESSIONS = Path.home() / ".claude/projects/-Users-bymyway--openclaw"
MAIN_SESSIONS = Path.home() / ".claude/projects/-Users-bymyway"
OUTPUT_FILE = Path("/Users/bymyway/.openclaw/workspace/shared-context/SCENES/stage2_scenes.md")

def get_last_scene_num():
    if not OUTPUT_FILE.exists():
        return 73
    content = OUTPUT_FILE.read_text()
    matches = re.findall(r'【場景 #(\d+)】', content)
    if matches:
        return max(int(m) for m in matches)
    return 73

def process_session_file(filepath):
    messages = []
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            for line in f:
                try:
                    entry = json.loads(line.strip())
                    msg = entry.get('message', entry)
                    role = msg.get('role', '')
                    content = msg.get('content', '')

                    if role == 'user' and isinstance(content, str) and len(content) > 15:
                        if '[cron:' in content or content.startswith('Read HEARTBEAT'):
                            continue
                        if re.match(r'^[A-Za-z\s]+$', content) and not re.search(r'[一-鿿]', content):
                            continue

                        timestamp = entry.get('timestamp', '')
                        messages.append({
                            'timestamp': timestamp,
                            'content': content,
                            'file': filepath.name
                        })
                except json.JSONDecodeError:
                    continue
    except Exception as e:
        pass
    return messages

def evaluate_scene(content):
    """評估訊息是否為有價值的場景"""
    tags = []

    fail_patterns = ['不是', '錯了', '我要的是', '你要做的是', '不是這樣', '方向錯了', '你誤會了', '應該是', '我要你']
    for p in fail_patterns:
        if p in content:
            tags.append('行為糾正')
            break

    if '這就是我要的' in content or '就是這樣' in content or '完美' in content:
        tags.append('成功範本')

    proactive = ['幫我', '你去', '直接', '自動', '下次', '記得', '主動', '幫我檢查', '幫我看']
    for p in proactive:
        if p in content:
            tags.append('主動服務')
            break

    if any(k in content for k in ['幫我做', '你去處理', '執行', '完成', '幫我']):
        tags.append('老闆動嘴')

    return tags

def main():
    scene_num = get_last_scene_num() + 1
    all_scenes = []

    for sessions_dir, label in [(OPENCLAW_SESSIONS, 'openclaw'), (MAIN_SESSIONS, 'main')]:
        print(f"\n處理 {label} sessions ({len(list(sessions_dir.glob('*.jsonl')))} 個檔案)...")

        for fp in sorted(sessions_dir.glob("*.jsonl")):
            msgs = process_session_file(fp)
            for msg in msgs:
                tags = evaluate_scene(msg['content'])
                if tags or len(msg['content']) > 80:
                    date = msg['timestamp'][:10] if msg['timestamp'] else 'unknown'
                    all_scenes.append({
                        'num': scene_num,
                        'date': date,
                        'source': msg['file'],
                        'content': msg['content'][:400],
                        'tags': tags if tags else ['一般對話']
                    })
                    scene_num += 1

            print(f"\n萃取 {len(all_scenes)} 個場景")

    if all_scenes:
        with open(OUTPUT_FILE, 'a', encoding='utf-8') as f:
            for scene in all_scenes:
                tags_str = '/'.join(scene['tags'])
                f.write(f"\n### 【場景 #{scene['num']}】\n")
                f.write(f"日期：{scene['date']}\n")
                f.write(f"來源：{scene['source']}\n")
                f.write(f"教練說：{scene['content']}\n")
                f.write(f"標籤：{tags_str}\n")

if __name__ == '__main__':
    main()