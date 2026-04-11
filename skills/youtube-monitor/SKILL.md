# YouTube 頻道監測技能

## 功能說明
監測大樹教練訂閱的 31 個 YouTube 頻道，分兩個階段執行：
- **第一階段**（自動）：每天抓最新影片標題，篩選符合主題的推薦
- **第二階段**（用戶觸發）：用戶選定影片後，深度讀取摘要

## 頻道清單（31 個）

```
@inspiredcanvas_m    → UC17zrOCuDUXmtREyx9G2tCQ
@LuluTechnology1     → UCPwCUeMO9EB-kFno2zKsm9w
@greentrainpodcast   → UCJhUtNsR5pvU_gWWkxxUXUQ
@Teacher_Kong        → UCpnBpREMjMNFvLTLnc2iLPQ
@applefans520        → UCCC_m0Lw7Z4IT6IjoPb0ZLg
@kocpc               → UCcQA-MzQxCvET1S-BekQdAA
@panscischool        → UCATnB3v_NkTTd9iD_4W2A-g
@apple-dad           → UCIpZAGl9xHcuzmHW0AAJs7g
@rickhau99           → UCKMtbQbyhpBgyKaNX5vJUsw
@MeticsMediaChinese  → UC7Qp52WIwke2P3l1Xh6k74Q
@AlanChen            → UCfB2JYduVCYdHcoxlEWGw4w
@PH-WorkFlow         → UCpXOvRzWW0lJhYrUeWBlNmA
@TuTu                → UCuhAUKCdKrjYoMiJQc74ZkQ
@lichangzhanglaile   → UC0v9b0Z00wWED_vGy-Q6ibg
@Macro_Alpha_cn      → UC9oosAco7nIVZwuGhnC0FKg
@AIPractitioners123  → UCfMXQ45Ch5EnT2jokiHuysw
@SFReality           → UCCzf5FvUaAurIuY-YGmWJyQ
@mage291             → UCG_qhxmgI1E0wO4x11TiI5w
@ami.moment          → UCGs_cktFPCgN8ggJJVon84g
@TackyTechy          → UC3YHFDbkHcqVxg4w20YYC7A
@martinz2025         → UC1HhvtQd_yTBJAGYNYffmSQ
@BizofFame           → UCQT2N6N_Jay8nWS_0h7muyw
@Petersunreview      → UCl9BPXjyEmA0q6IrQvsEazA
@techbang3c          → UC9IyDJ6vlG50iYjXGQpwwOQ
@aaron-1215          → UCKHHtxWYOg15Gsrsa9ZDfrA
@talkspg             → UCUa8Meh6_eFq7v1h_CCa9fQ
@AI-Short-Taipei     → UC1Ld3B4Y1NBam9BTk9tMThR
@digitalxu           → UCGQPLvp98hRrzTG14AiTfUQ
@austinchou888       → UC3hsgc8SHJs1RDMEZBCAccA
@HarryLee            → UCEA4ZfPzWDHp72mlq7IvUcw
@sensebar            → UCI2YklLazU9tB_Kh_9nMpKA
```

## 篩選標準（教練親自定義）
1. 頻道訂閱數需大於 1 萬
2. 排除嘗鮮型 / 實驗型教學
3. 只挑「實踐落地型」內容：
   - AI 工具實際應用
   - 創業、企業管理
   - 人際關係、溝通技巧
   - 增加工作效率的方法

## 第一階段執行腳本

```python
# fetch-youtube-rss.py
# 用 RSS 抓最新影片，完全不需要 YouTube API Key，零 Token
import urllib.request
import xml.etree.ElementTree as ET
from datetime import datetime, timezone, timedelta

CHANNEL_IDS = [
    "UC17zrOCuDUXmtREyx9G2tCQ", "UCPwCUeMO9EB-kFno2zKsm9w",
    "UCJhUtNsR5pvU_gWWkxxUXUQ", "UCpnBpREMjMNFvLTLnc2iLPQ",
    "UCCC_m0Lw7Z4IT6IjoPb0ZLg", "UCcQA-MzQxCvET1S-BekQdAA",
    "UCATnB3v_NkTTd9iD_4W2A-g", "UCIpZAGl9xHcuzmHW0AAJs7g",
    "UCKMtbQbyhpBgyKaNX5vJUsw", "UC7Qp52WIwke2P3l1Xh6k74Q",
    "UCfB2JYduVCYdHcoxlEWGw4w", "UCpXOvRzWW0lJhYrUeWBlNmA",
    "UCuhAUKCdKrjYoMiJQc74ZkQ", "UC0v9b0Z00wWED_vGy-Q6ibg",
    "UC9oosAco7nIVZwuGhnC0FKg", "UCfMXQ45Ch5EnT2jokiHuysw",
    "UCCzf5FvUaAurIuY-YGmWJyQ", "UCG_qhxmgI1E0wO4x11TiI5w",
    "UCGs_cktFPCgN8ggJJVon84g", "UC3YHFDbkHcqVxg4w20YYC7A",
    "UC1HhvtQd_yTBJAGYNYffmSQ", "UCQT2N6N_Jay8nWS_0h7muyw",
    "UCl9BPXjyEmA0q6IrQvsEazA", "UC9IyDJ6vlG50iYjXGQpwwOQ",
    "UCKHHtxWYOg15Gsrsa9ZDfrA", "UCUa8Meh6_eFq7v1h_CCa9fQ",
    "UC1Ld3B4Y1NBam9BTk9tMThR", "UCGQPLvp98hRrzTG14AiTfUQ",
    "UC3hsgc8SHJs1RDMEZBCAccA", "UCEA4ZfPzWDHp72mlq7IvUcw",
    "UCI2YklLazU9tB_Kh_9nMpKA"
]

TWO_DAYS_AGO = datetime.now(timezone.utc) - timedelta(days=2)
results = []

for cid in CHANNEL_IDS:
    try:
        url = f"https://www.youtube.com/feeds/videos.xml?channel_id={cid}"
        req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
        with urllib.request.urlopen(req, timeout=10) as resp:
            tree = ET.parse(resp)
        ns = {"atom": "http://www.w3.org/2005/Atom",
              "yt": "http://www.youtube.com/xml/schemas/2015",
              "media": "http://search.yahoo.com/mrss/"}
        root = tree.getroot()
        channel_name = root.find("atom:title", ns).text
        for entry in root.findall("atom:entry", ns)[:3]:
            title = entry.find("atom:title", ns).text
            link = entry.find("atom:link", ns).attrib.get("href", "")
            pub = entry.find("atom:published", ns).text
            pub_dt = datetime.fromisoformat(pub.replace("Z", "+00:00"))
            if pub_dt >= TWO_DAYS_AGO:
                results.append({
                    "channel": channel_name,
                    "title": title,
                    "url": link,
                    "published": pub_dt.strftime("%m/%d %H:%M")
                })
    except Exception as e:
        pass

# 輸出給 AI 篩選（只有標題，不讀影片內容）
for i, r in enumerate(results, 1):
    print(f"{i}. [{r['channel']}] {r['title']}")
    print(f"   {r['url']} ({r['published']})")
```

## 第一階段 Cron 提示詞

```
【YouTube 每日掃描 - 第一階段】

請執行 /Users/bymyway/.openclaw/workspace/skills/youtube-monitor/fetch-youtube-rss.py
這個腳本會列出過去 48 小時內，31 個頻道的最新影片標題。

你的任務：
1. 執行腳本，取得影片標題列表
2. 根據篩選標準評估每個標題（只看標題，不讀影片內容）：
   - 實踐落地型 AI 工具應用 → 高分
   - 創業/管理/效率方法 → 高分
   - 嘗鮮型/開箱/測試 → 排除
   - 娛樂/閒聊 → 排除
3. 整理成清單，最多 8 個，格式如下：

📺 今日 YouTube 精選（2026-04-12）

⭐⭐⭐ 強烈推薦
1. [頻道名] 影片標題
   👉 連結 | 推薦原因（一句話）

⭐⭐ 值得一看
2. [頻道名] 影片標題
   👉 連結 | 推薦原因（一句話）

---
💬 回覆「深入 #1 #3」可獲得這幾部的完整摘要
（深入分析會使用較多 Token，請按需選擇）

就這樣！不要讀影片內容，只評估標題。
```

## 第二階段觸發方式

用戶在 Telegram 回覆：「深入 #1 #3」或「深入 #2」

小龍蝦收到後：
1. 使用 `summarize` 技能讀取影片 URL
2. 生成完整摘要、重點整理、可行動建議
3. 傳回 Telegram

## Token 成本估算

| 階段 | 動作 | 估計 Token | 每次費用（Gemini Flash） |
|------|------|-----------|------------------------|
| 第一階段 | 31個標題篩選 | ~1,500 | 約 NT$0.003（幾乎免費） |
| 第二階段 | 每部影片深度摘要 | ~15,000 | 約 NT$0.3 |

NT$6,000 額度可支撐：
- 第一階段：無限次（幾乎免費）
- 第二階段：20,000 次深度摘要（遠超需求）
