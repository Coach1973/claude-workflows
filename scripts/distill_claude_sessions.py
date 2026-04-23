#!/usr/bin/env python3
"""
每2小時自動蒸餾：克勞德助教對話 JSONL → workspace/distilled_claude_[日期].md
只處理過去 N 小時內有更新的 session 檔案。
"""

import json
import os
import sys
import subprocess
from datetime import datetime, timedelta
from pathlib import Path

SESSIONS_DIR = Path("/Users/bymyway/.claude/projects/-Users-bymyway--openclaw/")
WORKSPACE = Path("/Users/bymyway/.openclaw/workspace")
HOURS_BACK = int(os.environ.get("HOURS_BACK", "2"))


def get_recent_sessions(hours=2):
    cutoff = datetime.now() - timedelta(hours=hours)
    sessions = []
    for f in SESSIONS_DIR.glob("*.jsonl"):
        if datetime.fromtimestamp(f.stat().st_mtime) > cutoff:
            sessions.append(f)
    return sorted(sessions, key=lambda f: f.stat().st_mtime)


def extract_messages(jsonl_path):
    messages = []
    with open(jsonl_path, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            try:
                obj = json.loads(line)
            except Exception:
                continue
            msg = obj.get("message", {})
            role = msg.get("role", "")
            content = msg.get("content", "")
            if isinstance(content, list):
                text = " ".join(
                    c.get("text", "") for c in content if isinstance(c, dict) and c.get("type") == "text"
                )
            else:
                text = str(content)
            text = text.strip()
            if text and role in ("user", "assistant"):
                messages.append((role, text[:1000]))
    return messages


def call_claude_api(prompt):
    """用 claude CLI 呼叫 API 做蒸餾"""
    try:
        result = subprocess.run(
            ["claude", "-p", prompt, "--output-format", "text"],
            capture_output=True, text=True, timeout=120
        )
        if result.returncode == 0:
            return result.stdout.strip()
    except Exception:
        pass
    return None


def distill_with_simple_heuristic(messages):
    """無 API 備援：用關鍵詞提取教練發言重點"""
    coach_msgs = [text for role, text in messages if role == "user"]
    keywords = ["任務", "完成", "要做", "記住", "寫入", "承諾", "計劃", "目標", "問題", "修正"]
    highlights = []
    for msg in coach_msgs:
        if any(k in msg for k in keywords) and len(msg) > 30:
            highlights.append(f"- {msg[:200]}")
    return "\n".join(highlights[:20]) if highlights else "（本輪無明顯重點訊息）"


def main():
    now = datetime.now()
    date_str = now.strftime("%Y-%m-%d")
    time_str = now.strftime("%H:%M")

    sessions = get_recent_sessions(HOURS_BACK)
    print(f"[{time_str}] 找到 {len(sessions)} 個近 {HOURS_BACK} 小時內更新的 session")

    if not sessions:
        print("無新對話，跳過。")
        return

    # 收集所有訊息
    all_messages = []
    for s in sessions:
        msgs = extract_messages(s)
        all_messages.extend(msgs)
        print(f"  {s.name}: {len(msgs)} 條訊息")

    coach_count = sum(1 for r, _ in all_messages if r == "user")
    print(f"教練發言共 {coach_count} 條")

    # 嘗試用 Claude API 蒸餾
    coach_text = "\n---\n".join(
        f"[教練] {t}" for r, t in all_messages if r == "user"
    )[:8000]

    prompt = f"""以下是教練（大樹教練）在過去 {HOURS_BACK} 小時內與克勞德助教的對話摘錄。

請蒸餾出：
1. 教練下達的重要指令或決策（3-8條）
2. 新的承諾或待辦事項
3. 教練的金句或智慧語錄（若有）

格式：
## 重要決策
- ...

## 新待辦
- ...

## 金句（若有）
- ...

---
對話摘錄：
{coach_text}
"""

    summary = call_claude_api(prompt)
    if not summary:
        print("Claude API 無回應，改用啟發式提取")
        summary = distill_with_simple_heuristic(all_messages)

    # 寫入輸出檔
    out_path = WORKSPACE / f"distilled_claude_{date_str}.md"
    with open(out_path, "a", encoding="utf-8") as f:
        f.write(f"\n## 蒸餾記錄 {date_str} {time_str}（過去 {HOURS_BACK} 小時）\n\n")
        f.write(f"> Sessions: {len(sessions)} 個 | 教練發言: {coach_count} 條\n\n")
        f.write(summary)
        f.write("\n\n---\n")

    print(f"✅ 寫入：{out_path}")

    # Git commit + push
    try:
        subprocess.run(["git", "add", str(out_path)], cwd=WORKSPACE, check=True)
        subprocess.run(
            ["git", "commit", "-m", f"auto: 蒸餾克勞德助教對話 {date_str} {time_str}"],
            cwd=WORKSPACE, check=True
        )
        subprocess.run(["git", "push", "origin", "main"], cwd=WORKSPACE, check=True)
        print("✅ Git push 完成")
    except Exception as e:
        print(f"⚠️ Git 操作失敗：{e}")


if __name__ == "__main__":
    main()
