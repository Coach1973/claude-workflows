#!/usr/bin/env python3
import re

with open('/Users/bymyway/.openclaw/workspace/100場景蒸餾-第二階段.md', 'r') as f:
    content = f.read()

# Split into scenes
scenes = re.split(r'^### 場景 #(\d+)', content, flags=re.MULTILINE)[1:]

# First element is empty/intro
output = []
output.append("# 100場景勾選版（教練專用）\n")
output.append("> 勾選規則：\n")
output.append("> - ✅ = 留下，作為《頂級助教守則》的素材\n")
output.append("> - ⬜ = 跳過，當歷史記錄保存\n")
output.append("> - ⚠️ = 過去式技術問題，可快速跳過\n\n")
output.append("---\n\n")

i = 0
while i < len(scenes):
    scene_num = scenes[i]
    scene_body = scenes[i+1] if i+1 < len(scenes) else ""
    
    # Extract the core spirit
    spirit_match = re.search(r'\*\*提煉出的核心精神：\*\* (.+)', scene_body)
    spirit = spirit_match.group(1) if spirit_match else "(無核心精神)"
    
    # Extract time
    time_match = re.search(r'\*\*時間：\*\* (.+)', scene_body)
    time_val = time_match.group(1) if time_match else ""
    
    # Check if it's a past-tech issue (memory/context overflow already fixed)
    is_tech_fixed = bool(re.search(r'(Context Overflow|記憶體|Gemini.*當機|空白回應|設定衝突)', spirit))
    
    checkbox = "⬜"
    if is_tech_fixed:
        checkbox = "⚠️"
    
    line = f"### {checkbox} 場景 #{scene_num} {time_val}\n"
    line += f"**{spirit}**\n\n"
    
    output.append(line)
    i += 2

with open('/Users/bymyway/.openclaw/workspace/100場景勾選版.md', 'w') as f:
    f.writelines(output)

print(f"Done. Created {len(output)//2} scenes.")
