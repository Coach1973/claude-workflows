#!/usr/bin/env python3
"""
對話蒸餾腳本 v2
功能：從 daily_*.md 中萃取出教練的實質對話
原理：教練的訊息在 JSON metadata (chat_id:6124913915) + Sender block 之後，下一個 👤 教練 or 🦞 小龍蝦 之前
"""

import re
import os
from pathlib import Path

DAILY_DIR = Path("/Users/bymyway/.openclaw/workspace")
OUTPUT_FILE = DAILY_DIR / "distilled_latest.md"

# 要處理的日期
days = ["24", "25", "26", "27"]

def extract_coach_messages(content: str) -> list:
    """
    從對話紀錄中萃取教練的訊息
    教練的訊息格式：
    👤 教練："chat_id": "telegram:6124913915",
      ...JSON fields...
    }
    
    Sender (untrusted metadata):
    ```json
    {...}
    ```
    
    [教練的訊息在這裡]
    🦞 小龍蝦：...
    """
    messages = []
    
    # 將 content 按行處理
    lines = content.split('\n')
    i = 0
    n = len(lines)
    
    in_coach_block = False
    message_lines = []
    
    while i < n:
        line = lines[i]
        
        # 偵測教練的 direct chat 訊息開頭
        if '"chat_id": "telegram:6124913915"' in line:
            # 開始新的教練訊息區塊
            if message_lines:
                # 保存之前的訊息
                msg_text = '\n'.join(message_lines).strip()
                if msg_text:
                    messages.append(msg_text)
                message_lines = []
            in_coach_block = True
            i += 1
            continue
        
        # 如果在教練區塊內
        if in_coach_block:
            # 跳過 JSON 欄位行（"key": "value", 格式）
            if re.match(r'^  "[^"]+":', line):
                i += 1
                continue
            
            # 跳過 Sender block 的 ```json ... ``` 區塊
            if line.strip().startswith('```json') or line.strip().startswith('```'):
                # 跳到 ``` 結束
                i += 1
                while i < n and not lines[i].strip().startswith('```'):
                    i += 1
                i += 1
                continue
            
            # 跳過 "Sender (untrusted metadata):" 這行和空白行
            if 'Sender (untrusted metadata)' in line or line.strip() == '':
                i += 1
                continue
            
            # 跳過 JSON 的 } 閉合行（單一行只有 }）
            if line.strip() == '}':
                i += 1
                continue
            
            # 如果遇到下一個 bot 或 user 回覆 → 這段教練訊息結束
            if line.startswith('🦞 小龍蝦：') or line.startswith('👤 教練：'):
                if message_lines:
                    msg_text = '\n'.join(message_lines).strip()
                    if msg_text:
                        messages.append(msg_text)
                    message_lines = []
                in_coach_block = False
                i += 1
                continue
            
            # 否則這行是教練的訊息內容
            # 去除行首的空白
            cleaned = line.strip()
            if cleaned and not cleaned.startswith('```'):
                message_lines.append(cleaned)
        
        i += 1
    
    # 最後一筆訊息
    if message_lines:
        msg_text = '\n'.join(message_lines).strip()
        if msg_text:
            messages.append(msg_text)
    
    return messages

def is_meaningful(text: str) -> bool:
    """
    過濾無意義的內容
    去除：心跳指令、系統預設文字、太短的隨口回應
    """
    # 心跳預設指令（很長一串都是這個）
    if 'Read HEARTBEAT.md if it exists' in text:
        return False
    if 'cron:' in text and 'target心跳' in text:
        return False
    # 太短（< 10字）可能是隨口回應或單字
    if len(text) < 10:
        return False
    # 只包含 URL 或特殊符號
    if re.match(r'^https?://[^\s]+$', text):
        return False
    return True

def distill():
    """主蒸餾流程"""
    all_results = {}
    
    for day in days:
        filename = DAILY_DIR / f"daily_2026-04-{day}.md"
        if not filename.exists():
            all_results[day] = []
            continue
        
        content = filename.read_text()
        messages = extract_coach_messages(content)
        
        # 過濾
        meaningful = [m for m in messages if is_meaningful(m)]
        all_results[day] = meaningful
    
    return all_results

def format_output(results: dict) -> str:
    """格式化輸出"""
    lines = []
    lines.append("# 對話蒸餾結果")
    lines.append(f"蒸餾時間：2026-04-27 01:47")
    lines.append(f"蒸餾日期：2026-04-24 ~ 2026-04-27")
    lines.append("")
    
    total_messages = 0
    
    for day, messages in results.items():
        lines.append(f"## 2026-04-{day} 教練對話（{len(messages)} 則）")
        lines.append("")
        
        for msg in messages:
            lines.append(f"> {msg}")
            lines.append("")
            total_messages += 1
        
        if not messages:
            lines.append("(無實質對話)")
            lines.append("")
        
        lines.append("---")
        lines.append("")
    
    lines.append(f"## 蒸餾統計")
    lines.append(f"- 總天數：{len(results)} 天")
    lines.append(f"- 教練訊息總數：{total_messages} 則")
    lines.append(f"- 蒸餾完成時間：{__import__('datetime').datetime.now().strftime('%Y-%m-%d %H:%M')}")
    
    return '\n'.join(lines)

if __name__ == "__main__":
    print("🚀 開始蒸餾對話...")
    results = distill()
    
    output = format_output(results)
    
    OUTPUT_FILE.write_text(output)
    
    total = sum(len(msgs) for msgs in results.values())
    print(f"✅ 蒸餾完成！")
    print(f"   - 處理 4 天對話")
    print(f"   - 萃取出 {total} 則教練訊息")
    print(f"   - 輸出至：{OUTPUT_FILE}")
