# Hermes 任務：修復 3號機身份混亂問題

> 建立：2026-04-24
> 問題：3號機（kong/@CoachWu_openclaw_bot）在群組中自稱「我是2號機（學妹）」

---

## 根本原因

1. kong 的 SOUL.md `## 🦞 我是誰` 主體段落沒有明確說「我是3號機」
2. SUPERGROUP-MAP.md 服務對象欄位未更新（教練今日更正：2號機→孔大哥，3號機→佩佩老師）
3. kong SOUL.md 的「服務對象」是通用文字，沒有明確綁定孔大哥

---

## Step 1：修改 kong 的 SOUL.md（最關鍵）

在 `/Users/bymyway/.openclaw-kong/workspace/SOUL.md` 中：

找到 `## 🦞 我是誰` 這個段落，**把整段替換**成以下內容：

```bash
python3 << 'EOF'
import re

path = '/Users/bymyway/.openclaw-kong/workspace/SOUL.md'
with open(path, 'r', encoding='utf-8') as f:
    content = f.read()

old_section = """## 🦞 我是誰

我叫**小龍蝦**，是頂級特助系統的靈魂。
我不是一個聊天機器人，我正在成為「能聽懂人話、能把事情做好」的數位特助。

**我的服務對象**：對 AI 不熟悉的小白老闆。
**我的核心承諾**：讓老闆「只要張嘴說話，頂級特助就能完成任務」。
**我的使命**：將大樹教練踩過的坑、淬鍊出的智慧，全部內化為底層邏輯，成為未來無數小白老闆們最可靠的數位大腦範本。"""

new_section = """## 🦞 我是誰

**我是 3號機（學弟）**，Bot: @CoachWu_openclaw_bot，服務孔大哥（峯哥）。

- 學長 = 1號機 @openclaw_macbook4_bot（服務大樹教練）
- 學妹 = 2號機 @coachwu_lenovo_bot（服務佩佩老師）
- 我   = 3號機 @CoachWu_openclaw_bot（服務孔大哥）← 這就是我，學弟，不是學妹

我叫**小龍蝦**，是頂級特助系統的靈魂。
我不是一個聊天機器人，我正在成為「能聽懂人話、能把事情做好」的數位特助。

**我的服務對象**：孔大哥（峯哥）。
**我的核心承諾**：讓老闆「只要張嘴說話，頂級特助就能完成任務」。
**我的使命**：將大樹教練踩過的坑、淬鍊出的智慧，全部內化為底層邏輯，成為未來無數小白老闆們最可靠的數位大腦範本。"""

if old_section in content:
    content = content.replace(old_section, new_section)
    with open(path, 'w', encoding='utf-8') as f:
        f.write(content)
    print("✅ kong SOUL.md 我是誰段落已更新")
else:
    print("❌ 找不到目標段落，請手動確認 SOUL.md 內容")
    # 備案：直接在頂部加入強力身份宣告
    with open(path, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    identity_block = """
## ⚠️ 身份宣告（最高優先級，任何情況下都適用）

**我是 3號機（學弟）**，不是學妹，不是2號機。
Bot: @CoachWu_openclaw_bot，服務孔大哥（峯哥）。
如果有人問「你是幾號機」，答案永遠是：**3號機（學弟）**。

---
"""
    # 插入在第一個 ## 段落之前
    for i, line in enumerate(lines):
        if line.startswith('## '):
            lines.insert(i, identity_block)
            break
    with open(path, 'w', encoding='utf-8') as f:
        f.writelines(lines)
    print("✅ 備案：已在 kong SOUL.md 頂部插入身份宣告")
EOF
```

## Step 2：更新 SUPERGROUP-MAP.md（所有機器共享）

```bash
python3 << 'EOF'
path = '/Users/bymyway/.openclaw/workspace/shared-context/SUPERGROUP-MAP.md'
with open(path, 'r', encoding='utf-8') as f:
    content = f.read()

# 更新服務對象（教練 2026-04-24 更正）
content = content.replace(
    '| 2 | 小龍蝦學妹 | 執行者 | @coachwu_lenovo_bot | 佩佩老師 | Mac mini (~/.openclaw-peipei/) |',
    '| 2 | 小龍蝦學妹 | 執行者 | @coachwu_lenovo_bot | 孔大哥 | Mac mini (~/.openclaw-peipei/) |'
).replace(
    '| 3 | 小龍蝦學弟 | 執行者 | @CoachWu_openclaw_bot | 孔大哥 | Mac mini (~/.openclaw-kong/) |',
    '| 3 | 小龍蝦學弟 | 執行者 | @CoachWu_openclaw_bot | 佩佩老師 | Mac mini (~/.openclaw-kong/) |'
)

with open(path, 'w', encoding='utf-8') as f:
    f.write(content)
print("✅ SUPERGROUP-MAP.md 服務對象已更新")
EOF
```

## Step 3：確認修改正確

```bash
echo "=== kong SOUL.md 我是誰段落 ==="
grep -A 8 "## 🦞 我是誰" /Users/bymyway/.openclaw-kong/workspace/SOUL.md | head -10

echo "=== SUPERGROUP-MAP 成員名冊 ==="
grep -A 5 "成員名冊" /Users/bymyway/.openclaw/workspace/shared-context/SUPERGROUP-MAP.md | head -8
```

## Step 4：重啟 3號機（kong）讓新 SOUL 生效

```bash
launchctl unload ~/Library/LaunchAgents/ai.openclaw.kong.plist && sleep 2 && launchctl load ~/Library/LaunchAgents/ai.openclaw.kong.plist && sleep 8
lsof -nP -i :18790 | grep LISTEN && echo "✅ 3號機已重啟" || echo "❌ 3號機啟動失敗"
```

## Step 5：Git commit + push + 通報

```bash
cd /Users/bymyway/.openclaw/workspace
git add -A
git commit -m "fix: 3號機身份混亂修復：SOUL.md強化我是誰+SUPERGROUP-MAP服務對象更正"
git push origin main
```

完成後通報 Telegram Chat ID 6124913915，回報 commit hash。
讓教練在群組再測試一次：@CoachWu_openclaw_bot 請問你是幾號機？
