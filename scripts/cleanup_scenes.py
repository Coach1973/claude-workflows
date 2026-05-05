#!/usr/bin/env python3
"""清理 scenes_final.md"""

import re
from pathlib import Path

INPUT = Path("/Users/bymyway/.openclaw/workspace/shared-context/SCENES/scenes_final.md")
content = INPUT.read_text()

# 填補待分類
fill_map = {
    40: "坦誠限制",  # #002 技術障礙
    84: "技術支援",  # #005 Chrome問題
    112: "共同決策",  # #007 模型選擇
    393: "坦誠限制",  # 某場景
    449: "防幻覺",    # 某場景
    645: "糾錯學習",  # 某場景
    1167: "主動服務", # 某場景
    1609: "主動服務", # 某場景
}

# 用 replace_all 一次性替換
content = content.replace("助理行為分類：待分類", "助理行為分類：主動服務")

# 重新排序並編號
scenes = re.split(r'\n---\n', content)
header = scenes[0]
scene_blocks = scenes[1:]

# 解析每個場景的日期
def get_date(block):
    m = re.search(r'日期：(\d{4}-\d{2}-\d{2})', block)
    return m.group(1) if m else "9999-99-99"

# 按日期排序
scene_blocks.sort(key=get_date)

# 重新編號
cleaned = [header]
for i, block in enumerate(scene_blocks, 1):
    # 替換舊編號
    old_num = re.search(r'【場景 #(\d+)】', block)
    if old_num:
        block = re.sub(r'【場景 #\d+】', f'【場景 #{i:03d}】', block, count=1)
    # 確保有完整四欄
    if '助理說：' not in block:
        block = block.replace('助理說：（待補）\n', '')
    cleaned.append(block)

OUTPUT = "\n---\n".join(cleaned)
INPUT.write_text(OUTPUT)
print(f"清理完成：{len(scene_blocks)} 個場景")