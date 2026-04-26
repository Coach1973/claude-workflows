# 台大 AI Agent 授課逐字稿

> 日期：2026-02（精確日期待確認）
> 場合：台灣大學課堂
> 主題：用 OpenClaw（ 小龍蝦）為例，說明 AI Agent 是如何運作的
> 素材：Tyoeless 語音辨識產出（部分簡體字為軟體特性）

---

## 授課核心內容

### 1. 小龍蝦是什麼？
- OpenClaw 的 Logo 是一隻龍蝦（Claw = 爪子/鉗子）
- 「養龍蝦」= 在電腦上安裝 OpenClaw，24小時運行
- 對比：小金老師（另一個AI）自己經營 YouTube 頻道、製作教學影片

### 2. AI Agent vs 一般語言模型
- 一般語言模型：只動口不動手（像指導教授，只給建議）
- AI Agent：真的會做事（開瀏覽器、創建頻道、上傳影片、語音合成）

### 3. OpenClaw 的系統架構
```
人 → OpenClaw（龍蝦）→ 語言模型（Gemini/Claude/GPT）
                     ↑
              System Prompt（身份設定）
```

### 4. System Prompt 的四個核心檔案
- `SOUL.md` — 靈魂/身份（我叫什麼名字、人生目標）
- `USER.md` — 主人是誰、有什麼偏好
- `AGENTS.md` — 行為準則
- `MEMORY.md` / `memory/` — 長期記憶與短期日記

### 5. Context Window 限制
- 每個語言模型都有輸入長度上限（context window）
- 超過上限怎麼辦？需要「壓縮」（compression / compaction）
- 比喻：失意女友電影，每天記憶歸零，要靠日記重新開始

### 6. 工具（Tools）
- `Read` — 讀取檔案
- `Write` — 寫入檔案
- `Execute` — 執行任何 Shell 命令（最危險！）
- 工具使用說明寫在 System Prompt 裡

### 7. Subagent（spawn）機制
- 大龍蝦可以召喚小龍蝦
- 小龍蝦去做瑣碎工作（搜論文、做摘要）
- 大龍蝦只看到摘要，看不到中間過程
- 節省 Context Window

### 8. Skills（技能 SOP）
- Skills = 工作流程的文字檔
- 放在指定資料夾，OpenClaw 會自動搜尋
- 可以與其他人交換 Skills（就像駭客任務裡記憶傳輸）
- ClawHub = 交換 Skills 的平台

### 9. 心跳機制（Heartbeat）
- 每30分鐘自動戳語言模型一次
- 讓龍蝦即使沒收到指令也能主動做事
- 用途：檢查郵件、朝目標前進（15分鐘報告一次）

### 10. Cron Job（排程系統）
- 讓 AI Agent 學會「等待」
- 範例：中午12點做一支影片
- 設定延遲，等 NotebookLM 生成完再下載

### 11. Context Compression（上下文壓縮）
- 當對話太長，會觸發壓縮機制
- 把歷史對話丟給語言模型做摘要
- 缺點：可能被遺漏重要的「一開始的指令」

### 12. 安全警示
- 不要給 AI 你的主要帳號密碼
- 讓 AI 用獨立帳號（獨立 Gmail、獨立 GitHub）
- 不要把 OpenClaw 安裝在平時使用的電腦上
- Compression 機制可能讓「一開始的指令」消失

---

## 重要比喻

### AI Agent 如同「實習生」
- 會犯錯
- 需要明確的安全邊界
- 犯錯了才知道學習
- 重點是給他安全的環境去嘗試

### 失意女友電影比喻
- AI 就像女主角，每天（或每次對話）都忘記一切
- 要靠「日記」（memory）重新記得
- 沒有寫進 memory 的事情 = 沒有發生過

---

## 小金（另一個AI）的實際案例
- 小金老師的 YouTube 頻道：瞎縮 AI
- 參加「教學怪物」比賽（AI 教學影片競賽）
- 32道題目全部通過
- 犯過的錯誤：把 API Key 推到公開 Repo、音檔沒有聲音
