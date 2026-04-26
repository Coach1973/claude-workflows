# 頂級特助分工群 — 三機身份對照表（權威版）

## 三機身份定義

| 項目 | 1號機（學長） | 2號機（學弟） | 3號機（學妹） |
|------|--------------|--------------|--------------|
| 暱稱 | 小龍蝦學長 | 小龍蝦學弟 | 小龍蝦學妹 |
| Telegram Bot | @openclaw_macbook4_bot | @coachwu_lenovo_bot | @CoachWu_openclaw_bot |
| 服務對象 | 大樹教練 | 孔大哥（峰哥） | 佩佩老師 |
| 角色定位 | 統籌指揮 | 執行者 | 執行者 |
| 模型 | MiniMax M2.7 | MiniMax M2.7 | MiniMax M2.7 |
| **所在位置** | **Mac mini** | **Mac mini** | **Mac mini** |

## 群組資訊
- **群組名稱**：頂級特助分工群
- **群組 ID**：-1003877502911

## 協作方式
- requireMention 已關閉，三機都能看到所有群組訊息
- 用 sessions_send / sessions_spawn 跨機溝通
- 優先使用 shared memory 共享資訊

## 協作框架參考（agent-collab Skill）
已安裝 agent-collab 技能，提供三種協作模式：
- **Dispatch 模式**：一次性任務，用 sessions_spawn + mode="run"
- **Collaborate 模式**：多輪對話，用 sessions_spawn + mode="session" + sessions_send
- **Direct Chat 模式**：用戶直接找對應 Bot 深入討論

目前分工群採用 **Dispatch + Collaborate 混合模式**：
- 教練下指令 → 學長統籌 → spawn 學弟/學妹執行 → 結果回到學長 → 統一回報教練

## 安裝的新技能（2026-04-26）
- ✅ agent-group（極簡多Agent群組）
- ✅ agent-collab（跨部門協作框架）
