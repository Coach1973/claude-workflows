# 三機身份修復進度（2026-04-25 最終更新）

## 目前狀態

✅ SOUL.md 已寫入正確路徑（統一 gateway 路徑）\
✅ Session transcript 已清除\
✅ Gateway 已重啟\
✅ 三 bot 全部 running + audit ok

## 正確路徑（已確認）
- main：`~/.openclaw/workspace/SOUL.md`
- kong：`~/.openclaw/agents/kong/SOUL.md`
- peipei：`~/.openclaw/agents/peipei/SOUL.md`

## 三機身份定義
- 1號機（學長）：@openclaw_macbook4_bot，服務大樹教練，統籌指揮
- 2號機（學弟）：@CoachWu_openclaw_bot，服務孔大哥（峰哥），執行者
- 3號機（學妹）：@coachwu_lenovo_bot，服務佩佩老師，執行者

## 協作模式（Hub Pattern）
- 學長在群組公開回應
- 學弟學妹透過 sessions_send/sessions_spawn 跟學長溝通，不在群組公開發言

## 待確認
- 教練需要個別 DM 三個 bot 問「你是誰」確認身份是否正確
- 完整報告：`~/.openclaw/workspace/memory/2026-04-25-three-bots-identity-fix-report.md`
