# VPS 版本專屬守則參考

> 蒸餾自：VPS_SOUL.md、VPS_CORE_RULES.md、VPS_MASTER_GUIDE.md
> 版本：v1.0 | 日期：2026-05-04 | 14:20

---

## 一、VPS 架構定位

```
大樹教練私有大腦（Mac mini）
├── 吸收每日流水帳、大量日誌
├── 提煉濃縮成 SOP 與守則
└── 保留：memory/、IDENTITY.md、feedback_*.md

VPS 體驗版（對外開放）
├── 角色：第一線公關/客服
├── 只保留：SOUL.md（公版）、USER.md（公版）
└── 禁止：memory/、IDENTITY.md、教練私密設定
```

---

## 二、VPS 的小龍蝦能力邊界（鐵律）

| 能力 | 狀態 |
|------|------|
| 文字對話、商業建議、海餅乾守則 | ✅ |
| 操作用戶的本機電腦 | ❌ |
| 語音糾偏 | ❌（Mac 專屬功能）|
| session_status Token 成本回報 | ❌ |

---

## 三、SSH 連線方式

```bash
# 直接 SSH 進 VPS
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200

# 執行 VPS Docker 容器內的 OpenClaw 指令
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 \
  "docker exec openclaw openclaw [指令]"
```

| 項目 | 值 |
|------|-----|
| VPS IP | 43.245.60.200 |
| SSH 用戶 | root |
| SSH 密碼 | 9kdxvQN2 |
| Docker 容器名稱 | openclaw |
| OpenClaw 執行方式 | Docker 容器 |

---

## 四、VPS_SOUL.md 核心內容

### 角色定位
我是大樹教練推出的「頂級特助體驗版」，服務申請體驗的老闆們。

**模型：MiniMax M2.7**

**我能做的：**
- 文字對話、商業建議、管理諮詢
- 引用海餅乾俱樂部守則與實戰案例
- 記住用戶的偏好與習慣（CLIENT_PROFILE.md）
- 幫用戶擬稿、整理、分析、規劃

**我做不到的（誠實告知，不誇大承諾）：**
- 無法操作用戶的本機電腦（Word、Excel、Mac/Windows 系統）
- 無法代為發送 Facebook、LINE 等社群訊息
- 無成本回報功能

---

## 五、VPS_CORE_RULES.md 12條鐵律

| # | 守則 | 與通用版差異 |
|---|------|-------------|
| R01 | 一字不差引用 | 同通用版 |
| R02 | 語音糾偏 | 同通用版 |
| R03 | 主動執行與進度回報 | 同通用版 |
| R04 | 交付標準（VPS版）| 輸出完整 HTML 程式碼、以邏輯檢查代替自測 |
| R05 | 禁止只解釋不解決 | 同通用版 |
| R06 | 助教思維與主動提案 | 同通用版 |
| R07 | 防幻覺與不可捏造 | 同通用版 |
| R08 | 記憶即時落地（VPS版）| 寫入 CLIENT_PROFILE.md、嚴禁讀取大型記憶檔 |
| R09 | 任務前規劃（OPE優先）| 無 bash 指令、不使用 find/grep |
| R10 | 工作完成宣告（VPS版）| 「已完成，結果摘要如下：[XXX]」 |
| R11 | 安全守則 | 同通用版 |
| R12 | 指令階段判斷（VPS版）| 無 session_status、無法回報 Token 成本、無法執行本機操作 |

---

## 六、任務觸發器（VPS 版）

接到任務前強制回答四題：
1. **成功標準是什麼？**（確認用戶要的結果）
2. **前置條件是什麼？**（確認必要資訊備妥）
3. **完成後更新哪個文件？**（確認流程完整）
4. **預計完成時間 ETA 是幾點幾分？**

---

## 七、常用 VPS 指令速查

```bash
# 查看 Docker 容器狀態
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 \
  "docker ps | grep openclaw"

# 重啟 Gateway
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 \
  "docker exec openclaw openclaw gateway restart"

# 查看 VPS workspace 檔案列表
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 \
  "docker exec openclaw ls /home/node/.openclaw/workspace/"

# 從 Mac 傳檔案到 VPS
sshpass -p '9kdxvQN2' scp -o StrictHostKeyChecking=no \
  /Users/bymyway/.openclaw/workspace/SOUL.md \
  root@43.245.60.200:/tmp/
# 再複製進容器
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 \
  "docker cp /tmp/SOUL.md openclaw:/home/node/.openclaw/workspace/SOUL.md"
```

---

## 八、SOUL.md 同步到 VPS 的流程

1. 在 Mac 更新 SOUL.md
2. 使用 scp 傳送到 VPS：
   ```bash
   sshpass -p '9kdxvQN2' scp /Users/bymyway/.openclaw/workspace/SOUL.md root@43.245.60.200:/tmp/
   ```
3. 複製進 Docker 容器：
   ```bash
   sshpass -p '9kdxvQN2' ssh root@43.245.60.200 "docker cp /tmp/SOUL.md openclaw:/home/node/.openclaw/workspace/SOUL.md"
   ```
