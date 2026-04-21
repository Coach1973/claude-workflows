#!/usr/bin/env python3
"""
fetch-youtube-rss.py — 抓 31 個 YouTube 頻道最新影片
使用 yt-dlp @handle，不需要 API Key，零 AI Token
每天執行，自動抓各頻道最新 2 支影片
"""
import subprocess, sys
from datetime import datetime, timezone, timedelta

CHANNELS = [
    ("孔老師AI研習社",   "@inspiredcanvas"),
    ("LuluTechnology",   "@LuluTechnology"),
    ("KOCPC",            "@KOCPC"),
    ("PanSci科學新聞",   "@panscischool"),
    ("apple-dad",        "@apple-dad"),
    ("rickhau99",        "@rickhau99"),
    ("MeticsMedia中文",  "@MeticsMedia"),
    ("AlanChen",         "@AlanChen"),
    ("PH-WorkFlow",      "@PH-WorkFlow"),
    ("TuTu",             "@TuTu"),
    ("Macro_Alpha_cn",   "@Macro_Alpha_cn"),
    ("AIPractitioners",  "@AIPractitioners"),
    ("SFReality",        "@SFReality"),
    ("mage291",          "@mage291"),
    ("ami.moment",       "@ami.moment"),
    ("TackyTechy",       "@TackyTechy"),
    ("martinz2025",      "@martinz2025"),
    ("BizofFame",        "@BizofFame"),
    ("Petersunreview",   "@Petersunreview"),
    ("techbang3c",       "@techbang3c"),
    ("talkspg",          "@talkspg"),
    ("AI-Short-Taipei",  "@AI-Short-Taipei"),
    ("digitalxu",        "@digitalxu"),
    ("austinchou888",    "@austinchou888"),
    ("HarryLee",         "@HarryLee"),
    ("sensebar",         "@sensebar"),
    ("applefans520",     "@applefans520"),
    ("lichangzhanglaile","@lichangzhanglaile"),
    ("aaron-1215",       "@aaron-1215"),
    ("綠色火車",          "@greentrainTW"),
    ("BizofFame",        "@BizofFame"),
]

# 移除重複
seen = set()
CHANNELS = [(n,h) for n,h in CHANNELS if not (h in seen or seen.add(h))]

items = int(sys.argv[1]) if len(sys.argv) > 1 else 2
YTDLP = "/opt/homebrew/bin/yt-dlp"
TZ8 = timezone(timedelta(hours=8))
today = datetime.now(TZ8).strftime("%Y/%m/%d")

results, errors = [], []

for name, handle in CHANNELS:
    url = f"https://www.youtube.com/{handle}/videos"
    try:
        cmd = [
            YTDLP,
            "--flat-playlist",
            "--playlist-items", f"1-{items}",
            "--print", "%(title)s\t%(url)s",
            "--no-warnings",
            "--quiet",
            url
        ]
        out = subprocess.run(cmd, capture_output=True, text=True, timeout=20)
        if out.returncode != 0 or not out.stdout.strip():
            err = out.stderr.strip()[:80] if out.stderr.strip() else "no output"
            errors.append(f"❌ {name}: {err}")
            continue
        for line in out.stdout.strip().splitlines():
            parts = line.split("\t")
            if len(parts) >= 2:
                results.append({"ch": handle, "title": parts[0], "url": parts[1]})
    except subprocess.TimeoutExpired:
        errors.append(f"❌ {name}: timeout")
    except Exception as e:
        errors.append(f"❌ {name}: {e}")

print(f"YouTube {today}\n")
print("AI/")
for r in results:
    print(f"• [{r['ch']}] {r['title']}")
    print(f"  {r['url']}")
print()

if errors:
    print(f"=== 無法讀取（{len(errors)} 個）===")
    for e in errors: print(f"  {e}")
