# 頂級特助安裝 SOP（v0.1草稿）

> 把這套系統變成可複製的安裝流程
> 目標：讓零基礎老闆也能跟著步驟完成安裝
> 版本：v0.1 | 日期：2026-04-26 | 狀態：草稿建置中

---

## 目标读者

完全不懂程式的中小企業老闆，只需要會：
- 安裝 App（拖曳到應用程式資料夾）
- 複製貼上指令
- 按下 Enter 執行

---

## 安裝前准備

### 需要准備的帳戶
- [ ] Telegram 帳戶（拿來綁定 Bot）
- [ ] MiniMax API Key（或其他 AI API Key）
- [ ] GitHub 帳戶（拿來備份設定檔）

### 需要准備的設備
- [ ] Mac Mini（M晶片最佳）或 Mac（M晶片）
- [ ] iPhone（拿來操作 Telegram）

---

## 第一階段：OpenClaw 本體安裝

### 步驟 1.1：下載 OpenClaw

1. 打開瀏覽器，前往 OpenClaw 官方網站
2. 點擊「下載 Mac 版本」
3. 下載完成後，在下載項目找到 `.dmg` 檔案，點擊兩下開啟

### 步驟 1.2：安裝 OpenClaw

1. 在開啟的視窗中，看到左邊的 OpenClaw 應用程式圖示
2. **按住滑鼠拖曳**這個圖示到右邊的「應用程式 (Applications)」資料夾
3. 放開滑鼠，完成安裝

### 步驟 1.3：第一次開啟（安全警告）

如果是第一次開啟，可能會看到以下警告：
> 「無法打開，因為無法識別開發者」

**解決方式：**
1. 按住鍵盤的 `Control (⌃)` 鍵不放
2. 同時點擊 OpenClaw 圖示
3. 選擇「打開」
4. 再點一次「打開」確認

---

## 第二階段：設定 Bot

### 步驟 2.1：找 BotFather 拿 API Token

1. 在 Telegram 搜尋「BotFather」
2. 點擊 `/start`
3. 輸入 `/newbot`
4. 幫你的 Bot 取一個名字（例如「張老闆特助」）
5. 幫你的 Bot 取一個使用者名稱（例如「zhanglaoban_bot」）
6. BotFather 會給你一串 **API Token**，長這樣：
   ```
   123456789:ABCdefGhIJKlmNoPQRstuVWxyz
   ```
7. **把這串 Token 記下來**，等一下會用到

### 步驟 2.2：連接 OpenClaw 與 Telegram

1. 打開 OpenClaw 應用程式
2. 找到「設定」或「Settings」
3. 找到「Telegram Bot」或「Bot Token」的欄位
4. 貼上剛才拿到的 API Token
5. 儲存設定

---

## 第三階段：設定身份（最重要！）

### 步驟 3.1：建立 SOUL.md

這個檔案決定了「這台機器是誰的助理」。

在 OpenClaw 的設定資料夾中，建立 `SOUL.md`，內容如下：

```
我是「[暱稱]」，專屬於 [老闆名字] 的頂級數位特助。

我的工作：
- 幫 [老闆名字] 處理大小事
- 主動發現問題並提出解決方案
- 永遠不說「我不知道」，而是「我會幫你找到答案」

我的原則：
- 百分之百負責
- 自動自發
- 說到做到
```

### 步驟 3.2：建立 USER.md

這個檔案記錄老闆的基本資料。

```
# 關於 [老闆名字]

## 基本資料
- 姓名：[老闆名字]
- 稱呼：[老闆希望被怎麼稱呼]
- 時區：Asia/Taipei（GMT+8）
- Telegram Chat ID：[教練告訴你]

## 背景
- [老闆從事的行業]
- [老闆的目標或願景]

## 溝通偏好
- 語言：繁體中文
- 輸入方式：語音為主
```

### 步驟 3.3：建立 IDENTITY.md

```
# IDENTITY.md - 誰是我？

- **名字：[暱稱]**
- **服務對象：[老闆名字]**
- **上線日期：[日期]**
```

---

## 第四階段：備份設定

### 步驟 4.1：初始化 Git

1. 打開終端機（Terminal）
2. 輸入以下指令（把路徑換成你自己的）：
   ```bash
   cd /Users/[你的使用者名稱]/.openclaw/workspace
   git init
   ```

### 步驟 4.2：推上 GitHub

1. 在 GitHub 建立一個新的 Repository（例如叫 `my-assistant-config`）
2. 複製 SSH 位址
3. 在終端機輸入：
   ```bash
   git remote add origin [SSH位址]
   git add -A
   git commit -m "first commit"
   git push origin main
   ```

---

## 第五階段：連接其他機器（可選）

如果老闆想要多台機器共同服務：

1. 在第二台機器上安裝 OpenClaw
2. 複製第一台機器的 `SOUL.md` 和 `USER.md` 到新機器
3. 用同一個 GitHub Repository 同步設定

---

## 疑難排解

### Q：安裝後打不開？
A：看上面「步驟 1.3」的 Control + 點擊方式。

### Q：Bot 沒有回應？
A：檢查 API Token 是否正確，檢查網路是否正常。

### Q：忘記 API Token？
A：回 BotFather 輸入 `/mybots`，選擇你的 Bot，點「API Token」。

---

## 📋 快速指令卡（新手標配）

> 這張卡是你每天都會用到的指令。把它印出來或截圖儲存！

### 基本操作

| 做什麼 | 按什麼鍵或輸入什麼 |
|--------|-------------------|
| 開啟程式搜尋 | `Cmd (⌘) + 空白鍵` |
| 開啟終端機 | `Cmd (⌘) + 空白鍵`，然後打「Terminal」按 Enter |
| 複製文字 | `Cmd (⌘) + C` |
| 貼上文字 | `Cmd (⌘) + V` |
| 強制關閉程式 | `Cmd (⌘) + Q`（當機時用） |

### 終端機常用指令

| 做什麼 | 輸入什麼 | 備註 |
|--------|----------|------|
| 查看現在時間 | `date` | 按 Enter 執行 |
| 進入資料夾 | `cd 資料夾名稱` | 例如 `cd Desktop` |
| 列出檔案 | `ls` | 看這個資料夾裡有什麼 |
| 刪除檔案 | `rm 檔案名稱` | ⚠️ 刪了救不回來！先確認再按 Enter |
| 顯示路徑 | `pwd` | 看你在哪個資料夾 |
| 向上移動一層 | `cd ..` | 兩個點代表上層目錄 |

### OpenClaw 指令（在終端機裡輸入）

| 做什麼 | 輸入什麼 |
|--------|----------|
| 查看版本 | `openclaw --version` |
| 查看狀態 | `openclaw gateway status` |
| 開啟幫助 | `openclaw help` |
| 重啟服務 | `openclaw gateway restart` |

### ⚠️ 新手常見錯誤

1. **打完指令沒按 Enter** → 指令不會執行！記得按 `↩`
2. **指令前面有 `$` 或 `>` 符號** → 那是提示符號，不用輸入！只複製後面的文字
3. **密碼輸入看不見任何反應** → 正常的，放心盲打後直接按 Enter

---

## 安裝後常見問題排解

### Q1：Telegram Bot 沒有回應

**檢查順序：**
1. 在 Telegram 確認 Bot 已經 `/start`（傳送 /start 給 Bot）
2. 回到 OpenClaw 設定，確認 Bot API Token 有正確貼上
3. 檢查網路是否正常（可以打開瀏覽器測試）
4. 嘗試重啟 OpenClaw：在終端機輸入 `openclaw gateway restart`

### Q2：OpenClaw 說「找不到指令」

**原因：** 終端機還沒重新開啟，安裝的路徑還沒生效
**解決：** 按 `Cmd (⌘) + Q` 關閉終端機，然後重新打開終端機再試

### Q3：第一次開啟看到「無法識別開發者」警告

**這是 Mac 的安全機制，不是錯誤！**
解決方式：
1. 按住 `Control (⌃)` 鍵不放
2. 同時點擊 OpenClaw 圖示
3. 選擇「打開」
4. 再點一次「打開」確認

### Q4：Bot 有回應但 AI 不回答問題

**檢查順序：**
1. 確認已經設定 AI API Key（MiniMax / OpenAI / Claude 等）
2. 在 OpenClaw 設定確認 API Key 有正確輸入
3. 檢查 API Key 是否還有額度（可以去 provider 網站查）
4. 看看錯誤訊息說什麼，貼給助教幫你判斷

### Q5：設定檔不見了或亂掉了

**預防：** 建議把設定檔上傳到 GitHub 備份（參考第四階段）
**救回：** 如果有備份，在終端機執行 `cd ~/.openclaw/workspace && git pull origin main`

### Q6：畫面一直轉圈圈或當機

1. 等 30 秒看看是否還活著（有時候只是在載入）
2. 如果真的沒反應，按 `Cmd (⌘) + Option (⌥) + Esc` 強制結束 OpenClaw
3. 重新開啟 OpenClaw
4. 如果常常當機，嘗試重開 Mac

---

## 安裝完成檢查清單

拿這張清單逐項確認，全部打勾代表安裝成功！

### 基本功能檢查

- [ ] **OpenClaw 已安裝**：在應用程式資料夾看到 OpenClaw 圖示
- [ ] **第一次開啟成功**：用 Control + 點擊方式打開，沒有當機
- [ ] **看到歡迎畫面**：第一次開啟會有設定引導

### Bot 連接檢查

- [ ] **在 Telegram 找到自己的 Bot**：搜尋 Bot 名稱有結果
- [ ] **和 Bot 說話有回應**：傳「/start」，Bot 有回覆
- [ ] **知道自己的 Chat ID**：傳訊息給 Bot，拿到了自己的數字 ID

### 身份設定檢查

- [ ] **SOUL.md 已建立**：在 `~/.openclaw/workspace/` 裡有 SOUL.md
- [ ] **USER.md 已建立**：在同一目錄下有 USER.md，內容是老闆的資料
- [ ] **IDENTITY.md 已建立**：內容清楚說明「我是誰、服務誰」

### GitHub 備份檢查

- [ ] **終端機可以開啟**：按 `Cmd (⌘) + 空白鍵`，打「Terminal」按 Enter
- [ ] **git 有回應**：在終端機輸入 `git --version` 有版本號
- [ ] **設定檔已上傳**：在 GitHub 上可以看到 SOUL.md、USER.md 等檔案

### 網路與權限檢查

- [ ] **網路正常**：可以打開 YouTube、Google 等網站
- [ ] **OpenClaw 可以對外連線**：嘗試問它「今天天氣怎麼樣」有回答

---

## 待完成項目

- [ ] 補充截圖說明（嚴禁消耗大量 Token，採用文字說明）
- [ ] 測試這份 SOP 是否真的可以讓零基礎老闆完成安裝
- [x] 建立「安裝完成檢查清單」✅
- [ ] 為學弟/學妹建立專用 HB.md 範本（已創建 HB_Member_Template.md）

---

## 附錄：學弟/學妹專用 HB.md 範本

> 已單獨建立於 `skills/onboarding_script/HB_Member_Template.md`，供複製到學弟/學妹的 VPS workspace

### 學弟妹 HB.md 核心精神
- 第一優先：建立並維護 USER.md（服務物件資料）
- 第二優先：每日主動簡報（早上主動出擊）
- 第三優先：定期蒸餾記憶（每週整理一次）
- 心跳頻率：每 15 分鐘讀 HB.md → 做一件小事 → 寫入 HEARTBEAT.md

---

*最後更新：2026-04-26 20:09*
