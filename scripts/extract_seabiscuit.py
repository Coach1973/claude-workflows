#!/usr/bin/env python3
"""
從 Telegram JSON 提取：
1. seabiscuit_golden_quotes.md — 教練願景/原則語錄
2. seabiscuit_ideas_backlog.md — 教練提出的功能/系統需求
"""

import json
import re
from datetime import datetime
from pathlib import Path

JSON_PATH = Path("/Users/bymyway/Desktop/Telegram_History/telegram_history_20260419_2315.json")
OUT_DIR = Path("/Users/bymyway/.openclaw/workspace")


def get_text(msg):
    text = msg.get("text", "")
    if isinstance(text, list):
        return "".join(t["text"] if isinstance(t, dict) else t for t in text)
    return text or ""


def fmt_date(iso):
    try:
        return datetime.fromisoformat(iso).strftime("%Y-%m-%d %H:%M")
    except Exception:
        return iso


# ── 金句：願景/原則/智慧語錄 ──────────────────────────────────────────────────
# 必須包含這些關鍵詞之一
WISDOM_REQUIRED = [
    "願望", "願景", "使命", "目標是", "理想", "初衷",
    "記住", "守則", "信念", "原則", "哲學",
    "一定要", "必須", "絕對",
    "最重要", "最關鍵", "核心是", "本質是",
    "真正的", "所謂的",
    "成功", "態度", "付出", "全力以赴", "一流",
    "典範", "學習典範", "負責任",
    "不是.{0,20}，?而是",
    "借力使力", "OPE",
    "海餅乾", "守則第",
]
wisdom_re = re.compile("|".join(WISDOM_REQUIRED))

# 排除模式（技術操作）
EXCLUDE_PATTERNS = re.compile(
    r"(終端機|指令|token|API|git|json|.json|模型|切換|額度|路徑|設定|安裝|版本|claude|gemini|gpt|ollama|openclaw|telegram|notebooklm)",
    re.IGNORECASE
)

# 排除問句
QUESTION_RE = re.compile(r"[？?]")


def is_golden_quote(text):
    # 長度：40~600
    if len(text) < 40 or len(text) > 600:
        return False
    # 排除純操作/問句（允許問句但內含大量陳述的長段落除外）
    if QUESTION_RE.search(text) and len(text) < 150:
        return False
    # 排除技術指令開頭
    if text.startswith("/") or text.startswith("http") or text.startswith("```"):
        return False
    # 必須含智慧詞
    if not wisdom_re.search(text):
        return False
    return True


# ── 靈感/需求：教練提出的想法 ────────────────────────────────────────────────
IDEA_REQUIRED = [
    "我想", "我希望", "我要", "我打算", "我計劃",
    "能不能", "可不可以", "有沒有辦法", "試試看",
    "功能", "自動化", "一鍵", "系統", "工具",
    "幫我做", "幫我建", "幫我設計", "幫我整合",
    "之後要", "下一步", "下次", "待辦",
    "訓練小龍蝦", "植入", "同步",
]
idea_re = re.compile("|".join(IDEA_REQUIRED))

IDEA_EXCLUDE = re.compile(r"^(謝謝|好的|好了|哦|嗯|是的|對的|沒問題|了解|明白)")


def is_idea(text):
    if len(text) < 30 or len(text) > 500:
        return False
    if text.startswith("/") or text.startswith("http"):
        return False
    if IDEA_EXCLUDE.match(text):
        return False
    if not idea_re.search(text):
        return False
    return True


def main():
    with open(JSON_PATH, encoding="utf-8") as f:
        data = json.load(f)

    msgs = [m for m in data["messages"] if m.get("type") == "message"]
    print(f"總訊息：{len(msgs)} 條")

    coach_msgs = [m for m in msgs if m.get("from") == "coach"]
    print(f"教練訊息：{len(coach_msgs)} 條")

    # ── 金句（只收教練訊息） ─────────────────────────────────────────────────
    quotes = []
    seen = set()
    for m in coach_msgs:
        text = get_text(m).strip()
        if not text or text in seen:
            continue
        if is_golden_quote(text):
            seen.add(text)
            quotes.append((fmt_date(m["date"]), text))

    print(f"金句：{len(quotes)} 條")

    # ── 靈感（只收教練訊息） ─────────────────────────────────────────────────
    ideas = []
    idea_seen = set()
    for m in coach_msgs:
        text = get_text(m).strip()
        if not text or text in idea_seen:
            continue
        if is_idea(text):
            idea_seen.add(text)
            ideas.append((fmt_date(m["date"]), text))

    print(f"靈感：{len(ideas)} 條")

    # ── 寫出金句 ──────────────────────────────────────────────────────────────
    quotes_path = OUT_DIR / "seabiscuit_golden_quotes.md"
    with open(quotes_path, "w", encoding="utf-8") as f:
        f.write("# 大樹教練語錄庫\n")
        f.write(f"> 來源：Telegram 對話記錄（{JSON_PATH.name}，{len(msgs)} 訊息）\n")
        f.write(f"> 自動提取，共 {len(quotes)} 條 | 產生時間：{datetime.now().strftime('%Y-%m-%d %H:%M')}\n\n")
        f.write("---\n\n")
        for date, text in quotes:
            # 多段落處理：每個換行變成引用塊新行
            lines = text.strip().split("\n")
            quoted = "\n>\n> ".join(l.strip() for l in lines if l.strip())
            f.write(f"**[{date}]**\n\n> {quoted}\n\n---\n\n")

    # ── 寫出靈感 ──────────────────────────────────────────────────────────────
    ideas_path = OUT_DIR / "seabiscuit_ideas_backlog.md"
    with open(ideas_path, "w", encoding="utf-8") as f:
        f.write("# 海餅乾靈感背包（待實現功能需求）\n")
        f.write(f"> 來源：Telegram 對話記錄 | 共 {len(ideas)} 條 | 產生時間：{datetime.now().strftime('%Y-%m-%d %H:%M')}\n\n")
        f.write("---\n\n")
        for date, text in ideas:
            short_text = text.replace("\n", " ").strip()
            f.write(f"**[{date}]**\n\n{short_text}\n\n---\n\n")

    print(f"\n✅ 完成")
    print(f"   {quotes_path}")
    print(f"   {ideas_path}")


if __name__ == "__main__":
    main()
