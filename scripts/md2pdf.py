#!/usr/bin/env python3
import markdown
import sys
import os

def md_to_pdf(input_path, output_path):
    with open(input_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    html = markdown.markdown(content, extensions=['tables', 'fenced_code'])
    
    # Wrap with basic CSS for better formatting
    full_html = f'''<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<style>
body {{ font-family: -apple-system, BlinkMacSystemFont, "PingFang TC", "Microsoft JhengHei", sans-serif; padding: 40px; line-height: 1.6; }}
h1 {{ color: #1a1a1a; border-bottom: 2px solid #333; padding-bottom: 10px; }}
h2 {{ color: #333; margin-top: 30px; }}
table {{ border-collapse: collapse; width: 100%; margin: 15px 0; }}
th, td {{ border: 1px solid #ddd; padding: 8px 12px; text-align: left; }}
th {{ background: #f5f5f5; }}
blockquote {{ border-left: 4px solid #ccc; margin: 15px 0; padding-left: 15px; color: #555; }}
code {{ background: #f0f0f0; padding: 2px 6px; border-radius: 3px; }}
pre {{ background: #f0f0f0; padding: 15px; overflow-x: auto; border-radius: 5px; }}
</style>
</head>
<body>
{html}
</body>
</html>'''
    
    html_path = output_path.replace('.pdf', '.html')
    with open(html_path, 'w', encoding='utf-8') as f:
        f.write(full_html)
    
    os.system(f'textutil -convert pdf "{html_path}" -output "{output_path}"')
    os.remove(html_path)
    print(f"✓ {os.path.basename(output_path)}")

files = [
    ('/Users/bymyway/.openclaw/workspace/seabiscuit_golden_quotes.md', '海餅乾金句庫.pdf'),
    ('/Users/bymyway/.openclaw/workspace/seabiscuit_ideas_backlog.md', '創意待辦清單.pdf'),
    ('/Users/bymyway/.openclaw/workspace/seabiscuit_case_studies.md', '案例研究薈萃.pdf'),
]

for src, dst in files:
    md_to_pdf(src, f'/Users/bymyway/Desktop/{dst}')
