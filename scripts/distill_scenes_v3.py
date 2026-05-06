#!/usr/bin/env python3
"""
Extract scenes from Claude desktop session .txt files with proper 5-field format.
Each scene = one coach-assistant pair (user message + assistant response).
"""

import re
from pathlib import Path
from datetime import datetime

SESSION_DIR = Path('/Users/bymyway/.openclaw/workspace/terminal-notes/claude_sessions')

def extract_content_from_msg(msg):
    """Extract text content from a message object."""
    content = msg.get('message', {}).get('content', [])
    if isinstance(content, list):
        texts = []
        for c in content:
            if c.get('type') == 'text':
                texts.append(c.get('text', ''))
            elif c.get('type') == 'tool_result':
                # Include tool results as they might have useful info
                tool_text = c.get('content', [])
                if isinstance(tool_text, list):
                    for t in tool_text:
                        if t.get('type') == 'text':
                            texts.append(t.get('text', ''))
                else:
                    texts.append(str(tool_text))
        return '\n'.join(texts)
    return str(content)

def extract_pairs_from_file(filepath):
    """Extract coach-assistant pairs from a session .txt file."""
    with open(filepath, 'r') as f:
        content = f.read()

    # Pattern: 👤 line followed by 🤖 line
    pattern = r'👤 教練：(.+?)\n🤖 助教：(.+?)(?=\n(?:👤|🤖|\Z))'
    pairs = re.findall(pattern, content, re.DOTALL)

    return pairs

def extract_date_from_file(filepath):
    """Extract date from file content."""
    with open(filepath, 'r') as f:
        content = f.read()
    date_pattern = r'(\d{4}-\d{2}-\d{2})'
    dates = re.findall(date_pattern, content)
    return dates[0] if dates else '2026-04-19'

def should_keep_scene(coach, assistant):
    """Keep scenes with meaningful coach input and assistant response."""
    if not coach or len(coach.strip()) < 5:
        return False

    # Skip pure status/filler exchanges
    skip_phrases = ['可以正常工作', '了解，', '收到，', '知道了', '我讀完了', '正在處理']
    for p in skip_phrases:
        if coach.strip() == p or coach.strip().startswith(p):
            return False

    return True

def distill_decision(coach, assistant):
    """Extract the key decision from coach-assistant dialogue."""
    coach_lower = coach.lower()

    if '決定' in coach or '就這樣' in coach or '就用' in coach:
        return '教練確認執行方案'
    if any(x in assistant[:50] for x in ['做完', '完成', '好了']):
        return '助教完成任務'
    if '設定' in coach and any(x in assistant for x in ['設定', '設定完成', '設定好了']):
        return '系統設定完成'
    if '檢查' in coach or '檢查' in assistant[:30]:
        return '進行系統檢查'
    if '問題' in coach and any(x in assistant for x in ['找到了', '原因', '問題在']):
        return '問題已診斷'
    if '額度' in coach or 'rate limit' in coach_lower:
        if '重置' in coach:
            return '確認額度重置時間'
        return '處理額度限制'
    if '讀' in coach[:10] or '看' in coach[:10]:
        return '助教主動讀取資料'
    if '請幫我' in coach[:15] or '幫我' in coach[:10]:
        return '教練提出需求，助教執行'
    if len(coach) > 100:
        return '教練提出詳細需求'

    return '持續對話優化'

def distill_spirit(coach, assistant):
    """Extract the core spirit - must be a meaningful golden sentence."""
    coach_lower = coach.lower()
    assistant_lower = assistant.lower()

    if '額度' in coach or 'rate limit' in coach_lower:
        if '重置' in coach:
            return '理解系統限制機制，才能有效管理資源'
        return '遇到限制時，先確認原因再行動'

    if '設定' in coach and ('設定' in assistant or '好了' in assistant):
        return '系統設定完成後要驗證鏈路暢通'

    if '問題' in coach or '錯誤' in coach_lower:
        if '找到了' in assistant or '原因' in assistant:
            return '找到真正原因才能根本解決問題'
        return '遇到問題要即時回報，不能假裝沒看到'

    if '請幫我' in coach or '幫我' in coach[:10]:
        return '教練開口就是命令，助教立即行動'

    if '你讀' in coach or '去看' in coach:
        return '主動讀取資料是理解context的第一步'

    if '選擇' in coach or '哪一個' in coach:
        return '提供選項時要說明理由，不能只給清單'

    if any(word in coach for word in ['謝謝', '很好', '太棒了', '讚']):
        return '即時肯定讓助教保持最佳狀態'

    if '不確定' in assistant_lower:
        return '不确定时要主动确认，不能凭空猜测'

    if '分工' in coach or '協作' in coach:
        return '清楚分工才能有效合作'

    if len(coach) > 200:
        return '教練話多代表重視，助教要仔細回應每個重點'

    if 'API' in coach or 'api' in coach_lower:
        return '技術問題要追根究底，不能只給表面答案'

    return '持續對話優化中'

def format_scene(scene):
    """Format a single scene in 5-field format."""
    lines = [
        f"### 場景 #{scene['num']}",
        f"**時間：** {scene['date']}",
        f"**教練說了什麼：** 「{scene['coach'][:250]}」",
        f"**助教說了什麼：** {scene['assistant'][:250]}",
        f"**最後決定做什麼：** {scene['decision']}",
        f"**提煉出的核心精神：** 「{scene['spirit']}」",
        ""
    ]
    return '\n'.join(lines)

def distill_sessions():
    """Main distillation function."""

    all_files = sorted(Path(SESSION_DIR).glob('*.txt'), key=lambda p: p.stat().st_mtime)

    batch1_scenes = []  # openclaw: 4/19-4/22
    batch2_scenes = []  # main: 4/17-4/26
    batch3_scenes = []  # telegram: 5/6

    scene_num = 201

    for filepath in all_files:
        pairs = extract_pairs_from_file(filepath)
        if not pairs:
            continue

        date = extract_date_from_file(filepath)
        emoji_count = len(re.findall(r'👤|🤖', filepath.read_text()))

        # Determine batch based on date
        try:
            file_date = datetime.strptime(date, '%Y-%m-%d')
            m, d = file_date.month, file_date.day

            if m == 5 and d == 6:
                batch = 'telegram'
            elif m == 4 and 17 <= d <= 26:
                batch = 'main'
            elif m == 4 and d >= 19:
                batch = 'openclaw'
            else:
                batch = 'openclaw'  # default older files to openclaw
        except:
            batch = 'openclaw'

        for coach, assistant in pairs:
            if not should_keep_scene(coach, assistant):
                continue

            decision = distill_decision(coach, assistant)
            spirit = distill_spirit(coach, assistant)

            scene = {
                'num': scene_num,
                'date': date,
                'coach': coach.strip(),
                'assistant': assistant.strip(),
                'decision': decision,
                'spirit': spirit
            }

            if batch == 'openclaw':
                batch1_scenes.append(scene)
            elif batch == 'main':
                batch2_scenes.append(scene)
            else:
                batch3_scenes.append(scene)

            scene_num += 1

    return batch1_scenes, batch2_scenes, batch3_scenes

def main():
    batch1, batch2, batch3 = distill_sessions()

    print(f"Batch 1 (openclaw #201-~): {len(batch1)} scenes")
    print(f"Batch 2 (main #~307-~): {len(batch2)} scenes")
    print(f"Batch 3 (telegram #~457+): {len(batch3)} scenes")

    # Write Batch 1
    with open('distilled_openclaw_0419_0422.md', 'w') as f:
        f.write("# 蒸餾場景 — OpenClaw 專案（2026-04-19 至 2026-04-22）\n\n")
        f.write(f"> 共 {len(batch1)} 個高品質場景\n\n")
        f.write("---\n\n")
        for s in batch1:
            f.write(format_scene(s) + '\n')

    # Write Batch 2
    with open('distilled_main_0417_0426.md', 'w') as f:
        f.write("# 蒸餾場景 — Main 專案（2026-04-17 至 2026-04-26）\n\n")
        f.write(f"> 共 {len(batch2)} 個高品質場景\n\n")
        f.write("---\n\n")
        for s in batch2:
            f.write(format_scene(s) + '\n')

    # Write Batch 3
    with open('distilled_telegram_0506.md', 'w') as f:
        f.write("# 蒸餾場景 — Telegram 對話（2026-05-06）\n\n")
        f.write(f"> 共 {len(batch3)} 個高品質場景\n\n")
        f.write("---\n\n")
        for s in batch3:
            f.write(format_scene(s) + '\n')

    print("\n✅ 三個批次檔案已寫入")
    print("  - distilled_openclaw_0419_0422.md")
    print("  - distilled_main_0417_0426.md")
    print("  - distilled_telegram_0506.md")

if __name__ == '__main__':
    main()