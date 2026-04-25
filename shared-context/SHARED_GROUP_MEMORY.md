# SHARED_GROUP_MEMORY.md — 三機共享記憶體

> 最後更新：2026-04-26

## 三機身份

| 機號 | 暱稱 | Bot | 服務對象 | Agent ID |
|------|------|-----|---------|---------|
| 1號機 | 小龍蝦學長 | @openclaw_macbook4_bot | 大樹教練 | main |
| 2號機 | 小龍蝦學弟 | @CoachWu_openclaw_bot | 孔大哥（峰哥） | kong |
| 3號機 | 小龍蝦學妹 | @coachwu_lenovo_bot | 佩佩老師 | peipei |

## 協作規則（Hub Pattern）

- 學長在群組公開回應教練
- 學弟、學妹不在群組公開發言
- 學弟、學妹透過 sessions_send / sessions_spawn 跟學長溝通
- 完成任務後把結果寫進 shared memory，學長統整後回覆教練
