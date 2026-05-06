#!/usr/bin/env python3
"""
Extract scenes from Claude desktop session .txt files.
Each scene = one coach-assistant pair.
Format: 5-field (教練說/助教說/決定/精神)
"""

import re
import os
from pathlib import Path

SESSION_DIR = '/Users/bymyway/.openclaw/workspace/terminal-notes/claude_sessions'
BATCH_OUTPUT = '/Users/bymyway/.openclaw/workspace/claude-sessions/BATCH_DISTILL_2026-05-06_1154.md'

# Scene numbers (from previous batch distill)
OPENCLAW_SCENES = range(201, 307)  # 201-306
MAIN_SCENES = range(307, 457)      # 307-456
TELEGRAM_SCENES = range(457, 1000) # 457+

def extract_pairs_from_file(filepath):
    """Extract coach-assistant pairs from a session .txt file."""
    with open(filepath, 'r') as f:
        content = f.read()

    # Pattern: 👤 line followed by 🤖 line
    pattern = r'👤 教練：(.+?)\n🤖 助教：(.+?)(?=\n(?:👤|🤖|\Z))'
    pairs = re.findall(pattern, content, re.DOTALL)

    # Also try without emoji (some files might not have emoji)
    pattern2 = r'教練：(.+?)\n助教：(.+?)(?=\n(?:教練|助教|\Z))'
    pairs2 = re.findall(pattern2, content, re.DOTALL)

    return pairs + pairs2

def extract_date_from_file(filepath):
    """Extract date from session file or filename."""
    # Try to get date from content
    date_pattern = r'(\d{4}[-/]\d{2}[-/]\d{2})'
    with open(filepath, 'r') as f:
        content = f.read()
    dates = re.findall(date_pattern, content)
    if dates:
        return dates[0].replace('/', '-')
    return '2026-04-19'

def should_keep_scene(coach, assistant):
    """Keep scenes with meaningful coach input and assistant response."""
    # Must have meaningful coach content
    if not coach or len(coach.strip()) < 5:
        return False

    # Skip if coach is just system status or filler
    skip_phrases = ['可以正常工作', '了解', '好的', '收到', '知道了', '我讀完了', '正在處理']
    if any(p in coach[:20] for p in skip_phrases):
        # But keep if it's a longer interaction
        if len(coach) < 50:
            return False

    return True

def distill_scenes():
    """Main distillation function."""

    all_files = sorted(Path(SESSION_DIR).glob('*.txt'), key=lambda p: p.stat().st_mtime)

    # Batch 1: openclaw project sessions
    batch1_scenes = []
    batch2_scenes = []
    batch3_scenes = []

    scene_num = 201

    for filepath in all_files:
        filename = filepath.name
        pairs = extract_pairs_from_file(filepath)
        date = extract_date_from_file(filepath)

        # Determine which batch based on date
        try:
            file_date = re.search(r'(\d{4})-(\d{2})-(\d{2})', date)
            if file_date:
                y, m, d = int(file_date.group(1)), int(file_date.group(2)), int(file_date.group(3))
                # openclaw: 4/17-4/22, main: 4/17-4/26, telegram: 5/6
                if m == 4 and 17 <= d <= 26:
                    batch = 'main'
                elif m == 4 and d < 17:
                    batch = 'openclaw'
                elif m == 5 and d == 6:
                    batch = 'telegram'
                else:
                    batch = 'openclaw'  # default
            else:
                batch = 'openclaw'
        except:
            batch = 'openclaw'

        for coach, assistant in pairs:
            if not should_keep_scene(coach, assistant):
                continue

            # Generate simple decision and spirit based on content
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

            if scene_num > 500:
                break

        if scene_num > 500:
            break

    return batch1_scenes, batch2_scenes, batch3_scenes

def distill_decision(coach, assistant):
    """Extract the key decision from coach-assistant dialogue."""
    coach_lower = coach.lower()
    assistant_lower = assistant.lower()

    # Check for explicit decisions
    if '決定' in coach or '就這樣' in coach or '就用' in coach:
        return '教練確認執行方案'
    if '好' in assistant[:20] and ('做完' in assistant or '完成了' in assistant):
        return '助教完成任務'
    if '設定' in coach and ('好了' in assistant or '完成' in assistant):
        return '系統設定完成'
    if '設定' in coach and '檢查' in assistant:
        return '進行系統檢查'
    if '問題' in coach and ('找到了' in assistant or '原因' in assistant):
        return '問題已診斷'
    if '可以' in coach and assistant.strip():
        return '教練同意執行'

    return '持續對話優化中'

def distill_spirit(coach, assistant):
    """Extract the core spirit - must be a meaningful golden sentence."""
    coach_lower = coach.lower()
    assistant_lower = assistant.lower()

    # Analyze the interaction type and generate appropriate spirit
    if '額度' in coach or 'rate' in coach_lower:
        if '重置' in coach or 'reset' in coach_lower:
            return '理解系統限制，才能有效管理資源'
        return '遇到限制時，先確認原因再行動'

    if '設定' in coach or '設定' in assistant:
        return '系統設定要驗證鏈路暢通，不能只靠口頭確認'

    if '問題' in coach or '錯誤' in coach_lower:
        if '找到了' in assistant or '原因' in assistant:
            return '找到原因比解決問題更重要'
        return '遇到問題要即時回報，不能假裝沒看到'

    if '請幫我' in coach or '幫我' in coach[:10]:
        return '教練開口就是命令，助教立即行動'

    if '你讀' in coach or '去看' in coach:
        return '主動讀取資料是理解 context 的第一步'

    if '選擇' in coach or '哪一個' in coach:
        return '提供選項時要說明理由，不能只給清單'

    if any(word in coach for word in ['謝謝', '很好', '太棒了', '讚']):
        return '即時肯定讓助教保持最佳狀態'

    if '不確定' in assistant or '我不確定' in assistant:
        return '不确定时要主动确认，不能凭空猜测'

    if '分工' in coach or '協作' in coach:
        return '清楚分工才能有效合作'

    if len(coach) > 100:
        return '教練話多代表重視，助教要仔細回應每個重點'

    return '持續對話優化中'

def format_scene(scene):
    """Format a single scene in 5-field format."""
    lines = [
        f"### 場景 #{scene['num']}",
        f"**時間：** {scene['date']}",
        f"**教練說了什麼：** 「{scene['coach'][:300]}」",
        f"**助教說了什麼：** {scene['assistant'][:300]}",
        f"**最後決定做什麼：** {scene['decision']}",
        f"**提煉出的核心精神：** 「{scene['spirit']}」",
        ""
    ]
    return '\n'.join(lines)

def main():
    batch1, batch2, batch3 = distill_scenes()

    print(f"Batch 1 (openclaw #201-306): {len(batch1)} scenes")
    print(f"Batch 2 (main #307-456): {len(batch2)} scenes")
    print(f"Batch 3 (telegram #457+): {len(batch3)} scenes")

    # Write Batch 1
    with open('distilled_openclaw_0419_0422.md', 'w') as f:
        f.write("# 蒸餾場景 — OpenClaw 專案（2026-04-17 至 2026-04-22）\n\n")
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