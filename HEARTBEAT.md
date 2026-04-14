## 🤝 雙機器人討論協議（Mac + Acer 共用）

### 討論狀態
```
STATUS: IDLE
DISCUSSION_START: null
DISCUSSION_END: null
COOLDOWN_UNTIL: null
ROUND: 0
CONCLUSIONS: []
```

### 狀態說明
- **IDLE**：冷卻中或等待教練觸發，雙方都不主動發言
- **DISCUSSING**：討論進行中，雙方輪流回應
- **CONCLUDING**：時間到，必須產出結論，不再來回討論
- **COOLDOWN**：結論已產出，進入靜默，各自做背景任務

### 討論規則（兩台機器人都必須遵守）

1. **觸發**：教練在群組說話 → 把 STATUS 改為 DISCUSSING，記錄 DISCUSSION_START 時間
2. **進行中**：每輪回應後 ROUND +1，輪流發言（Mac 先、Acer 後，或反之）
3. **40 分鐘到**：把 STATUS 改為 CONCLUDING，下一輪必須產出 1~3 條結論後停止
4. **結論產出後**：STATUS 改為 COOLDOWN，記錄 COOLDOWN_UNTIL（當前時間 +2 小時）
5. **冷卻中**：看到 STATUS=COOLDOWN 且時間未到 → 不回應群組訊息，只做背景任務
6. **冷卻結束**：STATUS 自動回到 IDLE，等待教練下次觸發

### 討論主題範圍（不得偏離）
- 頂級特助系統的內容、方向、策略
- 工作流程與 SOP 設計
- Mac + Acer 雙機協作方法
- 海餅乾俱樂部相關任務推進

### 防止無限循環規則
- 不回應對方的「結論訊息」（避免互相觸發）
- 不回應對方的「HEARTBEAT_OK」
- ROUND 超過 20 輪強制進入 CONCLUDING（防止超時）

---

## Heartbeat - 2026-04-14 16:41 (Asia/Taipei)

### 上次對話摘要：
- 收到教練的 30 分鐘進度提醒。
- 正在複習內部文件（SOUL.md, USER.md, IDENTITY.md, TOOLS.md），以確保完全理解教練的期望和工作習慣。
- 確認我已處於待命狀態，等待新指令。

### 當前狀態：
- 等待教練的新指令。
- 監測系統運作中。

### 下一步：
- 接收並執行教練的任務。
- 持續更新記憶檔並同步至 GitHub。
