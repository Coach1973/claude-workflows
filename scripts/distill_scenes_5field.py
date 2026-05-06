#!/usr/bin/env python3
"""Extract and format scenes from BATCH_DISTILL into proper 5-field format."""

import re

INPUT_FILE = 'claude-sessions/BATCH_DISTILL_2026-05-06_1154.md'

def extract_scenes(content):
    """Extract all scenes from the batch distill file."""
    scenes = []
    # Pattern to match each scene block
    pattern = r'### 【場景 #(\d+)】— (\d{4}-\d{2}-\d{2})  \[([^\]]+)\]\n\*\*類別：\*\* ([^\n]+)\n(?:\*\*教練說：\*\* (.*?)(?=\n(?:### 【場景|\*\*助教說|\n\n|\z)))?'

    blocks = re.split(r'\n(?=### 【場景)', content)

    for block in blocks:
        if not block.strip():
            continue

        # Extract scene header
        header_match = re.match(r'### 【場景 #(\d+)】— (\d{4}-\d{2}-\d{2})  \[([^\]]+)\]', block)
        if not header_match:
            continue

        scene_num = int(header_match.group(1))
        date = header_match.group(2)
        source = header_match.group(3)

        # Extract category
        cat_match = re.search(r'\*\*類別：\*\* ([^\n]+)', block)
        category = cat_match.group(1) if cat_match else ''

        # Extract coach says
        coach_match = re.search(r'\*\*教練說：\*\* (.*?)(?=\n(?:### 【場景|\*\*助教說|\*\*提煉精神|\n\n))', block, re.DOTALL)
        coach_says = coach_match.group(1).strip() if coach_match else ''

        # Extract assistant says
        assistant_match = re.search(r'\*\*助教說：\*\* (.*?)(?=\n(?:### 【場景|\*\*提煉精神|\*\*教練|\n\n))', block, re.DOTALL)
        assistant_says = assistant_match.group(1).strip() if assistant_match else ''

        # Extract refined spirit
        spirit_match = re.search(r'\*\*提煉精神：\*\* (.*?)(?=\n(?:### 【場景|\n\n)|$)', block, re.DOTALL)
        spirit = spirit_match.group(1).strip() if spirit_match else ''

        # Extract final decision
        decision_match = re.search(r'\*\*最後決定：\*\* (.*?)(?=\n(?:### 【場景|\*\*提煉精神|\n\n)|$)', block, re.DOTALL)
        decision = decision_match.group(1).strip() if decision_match else ''

        scenes.append({
            'num': scene_num,
            'date': date,
            'source': source,
            'category': category,
            'coach': coach_says,
            'assistant': assistant_says,
            'decision': decision,
            'spirit': spirit
        })

    return scenes

def should_keep(scene):
    """Keep scenes with coach corrections, rule establishment, questions, or important decisions."""
    # Check if coach says something meaningful (not just "---")
    if not scene['coach'] or scene['coach'] == '---' or len(scene['coach']) < 5:
        return False

    # Keep if has meaningful assistant response
    if scene['assistant'] and len(scene['assistant']) > 10:
        return True

    # Keep if has decision
    if scene['decision'] and len(scene['decision']) > 5:
        return True

    # Keep if has refined spirit (not placeholder)
    if scene['spirit'] and '(待教練確認)' not in scene['spirit'] and len(scene['spirit']) > 5:
        return True

    # Keep categories that indicate important moments
    important_cats = ['教練糾錯', '建立守則', '提問追問', '重要決策', '任務指派', '問題診斷']
    for cat in important_cats:
        if cat in scene['category']:
            return True

    return False

def format_scene_5field(scene):
    """Format scene in 5-field format."""
    # Determine source label
    source = scene['source']
    if 'openclaw' in source.lower():
        label = 'Claude桌面版-openclaw專案'
    elif 'main' in source.lower():
        label = 'Claude桌面版-main專案'
    elif 'telegram' in source.lower():
        label = 'Telegram對話'
    else:
        label = source

    # Build output
    lines = [
        f"### 場景 #{scene['num']}",
        f"**時間：** {scene['date']}",
        f"**教練說了什麼：** 「{scene['coach'][:200]}」" if scene['coach'] else f"**教練說了什麼：** （無記錄）",
        f"**助教說了什麼：** {scene['assistant'][:200]}" if scene['assistant'] else f"**助教說了什麼：** （無記錄）",
        f"**最後決定做什麼：** {scene['decision'][:150]}" if scene['decision'] else f"**最後決定做什麼：** （待確認）",
        f"**提煉出的核心精神：** 「{scene['spirit'][:100]}」" if scene['spirit'] and '(待教練確認)' not in scene['spirit'] else f"**提煉出的核心精神：** （待教練確認）",
        ""
    ]
    return '\n'.join(lines)

def main():
    with open(INPUT_FILE, 'r') as f:
        content = f.read()

    scenes = extract_scenes(content)
    print(f"Extracted {len(scenes)} scenes total")

    # Categorize into batches
    batch1 = [s for s in scenes if s['num'] <= 306]   # openclaw project
    batch2 = [s for s in scenes if 307 <= s['num'] <= 456]  # main project
    batch3 = [s for s in scenes if s['num'] >= 457]   # telegram

    print(f"Batch 1 (openclaw #201-306): {len(batch1)} scenes")
    print(f"Batch 2 (main #307-456): {len(batch2)} scenes")
    print(f"Batch 3 (telegram #457+): {len(batch3)} scenes")

    # Filter and format each batch
    batch1_filtered = [s for s in batch1 if should_keep(s)]
    batch2_filtered = [s for s in batch2 if should_keep(s)]
    batch3_filtered = [s for s in batch3 if should_keep(s)]

    print(f"\nFiltered (with meaningful content):")
    print(f"Batch 1: {len(batch1_filtered)} scenes")
    print(f"Batch 2: {len(batch2_filtered)} scenes")
    print(f"Batch 3: {len(batch3_filtered)} scenes")

    # Write batch 1
    with open('distilled_openclaw_0419_0422.md', 'w') as f:
        f.write("# 蒸餾場景 — OpenClaw 專案（2026-04-19 至 2026-04-22）\n\n")
        f.write(f"> 共 {len(batch1_filtered)} 個高品質場景（從 588 個原始場景蒸餾而來）\n\n")
        f.write("---\n\n")
        for s in batch1_filtered:
            f.write(format_scene_5field(s))

    # Write batch 2
    with open('distilled_main_0417_0426.md', 'w') as f:
        f.write("# 蒸餾場景 — Main 專案（2026-04-17 至 2026-04-26）\n\n")
        f.write(f"> 共 {len(batch2_filtered)} 個高品質場景\n\n")
        f.write("---\n\n")
        for s in batch2_filtered:
            f.write(format_scene_5field(s))

    # Write batch 3
    with open('distilled_telegram_0506.md', 'w') as f:
        f.write("# 蒸餾場景 — Telegram 對話（2026-05-06）\n\n")
        f.write(f"> 共 {len(batch3_filtered)} 個高品質場景\n\n")
        f.write("---\n\n")
        for s in batch3_filtered:
            f.write(format_scene_5field(s))

    print("\n✅ 三個批次檔案已寫入:")
    print("  - distilled_openclaw_0419_0422.md")
    print("  - distilled_main_0417_0426.md")
    print("  - distilled_telegram_0506.md")

if __name__ == '__main__':
    main()