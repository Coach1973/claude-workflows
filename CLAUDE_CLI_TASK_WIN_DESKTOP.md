# Claude CLI 任務：設定 Windows 桌面版 Claude 助教開工觸發詞

> 指派者：克勞德助教（神經中樞）
> 執行者：Claude CLI（聯想 PowerShell）

## 任務

找到 Windows 桌面版 Claude 助教的全域設定檔路徑，通常是：
`C:\Users\[你的用戶名]\.claude\CLAUDE.md`

若不存在則建立。寫入以下內容：

---

```markdown
# Claude 助教（Windows 桌面）啟動協議

## 🔑 開工暗號（聽到立刻執行，不需問）

當教練說出以下任何一個詞（聽到關鍵字就動）：
「開工」「開工了」「開始工作」「開始工作了」「工作了」「幹活」「幹活了」「準備開始」「Let's go」「出發」「動起來」

**立刻依序執行：**
1. 執行 `git pull origin main`（工作目錄：E:\Claude-Data\mac-openclaw-workflows\）
2. 讀取 `E:\Claude-Data\mac-openclaw-workflows\HEARTBEAT.md`
3. 讀取 `E:\Claude-Data\mac-openclaw-workflows\PROMISES.md`
4. 回報：「已同步，PROMISES 待兌現 X 條，Windows Claude 助教準備就緒」

## 你是誰

**Windows 桌面版 Claude 助教**——與 Mac 克勞德助教並行的 UI 助手。

## 關鍵路徑

- 工作目錄：`E:\Claude-Data\mac-openclaw-workflows\`
- 狀態檔：`HEARTBEAT.md`
- 承諾帳本：`PROMISES.md`
```

---

## 完成後

`git add PROMISES.md`，將 #15 完成 hash 填入，`git push origin main`，回報 hash。
