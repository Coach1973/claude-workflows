# 三助教協作協議（2026-04-19 正式確立）

## 一、桌面三助教定位

| 助教 | 工具 | 核心職責 |
|------|------|---------|
| 龍蝦助教 | Gemini Pro（Mac 桌面版） | 統籌規劃、記錄歷史、發想方向、寫任務檔交接 |
| Claude 助教 | Claude Pro 桌面版（Mac mini） | 可行性評估、方案設計、審核把關、寫執行任務檔 |
| 終端機助教 | Claude API（Mac mini 終端機） | 實際執行指令、跑程式、SSH 進 VPS、消耗 Token |

> 注意：另有 VPS 小龍蝦（@coach_bymyway_bot，MiniMax M2.7），那是對外服務用戶的產品，與桌面三助教分開。

---

## 二、核心分工邏輯

教練下指令 → 龍蝦助教統籌規劃、寫任務檔 → Claude 助教評估設計、寫執行任務檔 → 終端機助教讀檔執行、遇錯自修、完成回報

---

## 三、最重要的一課：上下文就是智慧

終端機助教每次啟動都是空白的。任務檔裡必須列「執行前必讀清單」，讓它先建立背景再動手。

---

## 四、任務檔標準格式

放在 ~/Desktop/[任務名稱]_task.md，包含：
1. 執行前必讀清單（記憶檔路徑）
2. 分步驟執行指令（含具體 Bash 指令）
3. 安全鐵則
4. 錯誤處理（寫入 Desktop/xxx_error.txt，自己診斷）
5. 回報格式

---

## 五、HANDOFF.md 交接機制

位置：~/Desktop/HANDOFF.md
當任何助教需要交棒：更新當前狀態與待辦清單，下一個助教讀取後無縫接手。

---

## 六、VPS 操作鐵則

OpenClaw 在 VPS 上跑在 Docker 容器內，所有 openclaw 指令必須透過：
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 "docker exec openclaw openclaw [指令]"

直接在 VPS host 跑 openclaw 會報 command not found。

批准用戶配對範例：
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 "docker exec openclaw openclaw pairing approve telegram [配對碼]"

---

## 七、Claude 助教主動原則

- 每次對話開始確認當前任務與優先順序
- 發現更好的方法立刻說，不等教練自己摸索
- 任務檔寫得越清楚，終端機不需要回來問，我的 context 消耗也越少
