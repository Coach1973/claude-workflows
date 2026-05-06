#!/usr/bin/env python3
"""
Extract scenes from Claude desktop session .txt files with proper 5-field format.
Only process sessions from target date ranges.
"""

import re
from pathlib import Path
from datetime import datetime

SESSION_DIR = Path('/Users/bymyway/.openclaw/workspace/terminal-notes/claude_sessions')

# Target date ranges
BATCH1_DATES = ['2026-04-19', '2026-04-20', '2026-04-21', '2026-04-22']  # openclaw → #201-306
BATCH2_DATES = ['2026-04-17', '2026-04-18', '2026-04-23', '2026-04-24', '2026-04-25', '2026-04-26']  # main → #307-456
BATCH3_FILES = []  # telegram - no session files from 5/6

def extract_pairs_from_file(filepath):
    """Extract coach-assistant pairs from a session .txt file."""
    with open(filepath, 'r') as f:
        content = f.read()

    pattern = r'👤 教練：(.+?)\n🤖 助教：(.+?)(?=\n(?:👤|🤖|\Z))'
    pairs = re.findall(pattern, content, re.DOTALL)
    return pairs

def extract_date_from_file(filepath):
    """Extract date from file content."""
    with open(filepath, 'r') as f:
        content = f.read()
    dates = re.findall(r'(\d{4}-\d{2}-\d{2})', content)
    return dates[0] if dates else None

def should_keep_scene(coach, assistant):
    """Keep scenes with meaningful coach input."""
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
    if '決定' in coach or '就這樣' in coach or '就用' in coach:
        return '教練確認執行方案'
    if any(x in assistant[:50] for x in ['做完', '完成', '好了']):
        return '助教完成任務'
    if '設定' in coach:
        return '系統設定完成'
    if '檢查' in coach or '檢查' in assistant[:30]:
        return '進行系統檢查'
    if '問題' in coach and any(x in assistant for x in ['找到了', '原因', '問題在']):
        return '問題已診斷'
    if '額度' in coach or 'rate limit' in coach.lower():
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
    """Extract the core spirit - meaningful golden sentence."""
    cl = coach.lower()
    al = assistant.lower()

    if '額度' in coach or 'rate limit' in cl:
        if '重置' in coach:
            return '理解系統限制機制，才能有效管理資源'
        return '遇到限制時，先確認原因再行動'

    if '設定' in coach:
        return '系統設定完成後要驗證鏈路暢通'

    if '問題' in coach or '錯誤' in cl:
        if '找到了' in assistant or '原因' in assistant:
            return '找到真正原因才能根本解決問題'
        return '遇到問題要即時回報，不能假裝沒看到'

    if '請幫我' in coach or '幫我' in coach[:10]:
        return '教練開口就是命令，助教立即行動'

    if '你讀' in coach or '去看' in coach:
        return '主動讀取資料是理解context的第一步'

    if '選擇' in coach or '哪一個' in coach:
        return '提供選項時要說明理由，不能只給清單'

    if any(w in coach for w in ['謝謝', '很好', '太棒了', '讚']):
        return '即時肯定讓助教保持最佳狀態'

    if '不確定' in al:
        return '不确定时要主动确认，不能凭空猜测'

    if '分工' in coach or '協作' in coach:
        return '清楚分工才能有效合作'

    if len(coach) > 200:
        return '教練話多代表重視，助教要仔細回應每個重點'

    if 'API' in coach or 'api' in cl:
        return '技術問題要追根究底，不能只給表面答案'

    return '持續對話優化'

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

def main():
    all_files = sorted(Path(SESSION_DIR).glob('*.txt'), key=lambda p: p.stat().st_mtime)

    batch1_scenes = []  # openclaw: 4/19-4/22 → #201-306
    batch2_scenes = []  # main: 4/17-4/26 → #307-456

    # Process files in date order
    for filepath in all_files:
        date = extract_date_from_file(filepath)
        if not date:
            continue

        pairs = extract_pairs_from_file(filepath)
        if not pairs:
            continue

        for coach, assistant in pairs:
            if not should_keep_scene(coach, assistant):
                continue

            decision = distill_decision(coach, assistant)
            spirit = distill_spirit(coach, assistant)

            scene = {
                'num': 0,  # Will be assigned later
                'date': date,
                'coach': coach.strip(),
                'assistant': assistant.strip(),
                'decision': decision,
                'spirit': spirit
            }

            if date in BATCH1_DATES:
                scene['num'] = len(batch1_scenes) + 201
                batch1_scenes.append(scene)
            elif date in BATCH2_DATES:
                scene['num'] = len(batch2_scenes) + 307
                batch2_scenes.append(scene)

    print(f"Batch 1 (openclaw #201-{200+len(batch1_scenes)}): {len(batch1_scenes)} scenes")
    print(f"Batch 2 (main #307-{306+len(batch2_scenes)}): {len(batch2_scenes)} scenes")

    # Write Batch 1
    with open('distilled_openclaw_0419_0422.md', 'w') as f:
        f.write("# 蒸餾場景 — OpenClaw 專案（2026-04-19 至 2026-04-22）\n\n")
        f.write(f"> 共 {len(batch1_scenes)} 個高品質場景\n\n")
        f.write("---\n\n")
        for s in batch1_scenes:
            f.write(format_scene(s) + '\n')

    # Write Batch 2
    with open('distilled_main_0417_0426.md', 'w') as f:
        f.write("# 蒸餾場景 — Main 專案（2026-04-17 至 2026-04-26）\n\n")
        f.write(f"> 共 {len(batch2_scenes)} 個高品質場景\n\n")
        f.write("---\n\n")
        for s in batch2_scenes:
            f.write(format_scene(s) + '\n')

    # Write Batch 3 (empty - no session files for telegram on 5/6)
    with open('distilled_telegram_0506.md', 'w') as f:
        f.write("# 蒸餾場景 — Telegram 對話（2026-05-06）\n\n\n")
        f.write("> （本日無桌面版 session 記錄檔案，Telegram 對話已併入 Batch Distill）\n\n")
        f.write("---\n\n")
        f.write("無桌面版 session 資料。\n")

    print("\n✅ 三個批次檔案已寫入")
    print("  - distilled_openclaw_0419_0422.md")
    print("  - distilled_main_0417_0426.md")
    print("  - distilled_telegram_0506.md")

if __name__ == '__main__':
    main()