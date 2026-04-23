# HEARTBEAT 熱上下文（每次心跳必讀）

> 最後更新：2026-04-23（Claude Code 終端機對話）

## ⚡ 系統狀態
- Primary 模型：google/gemini-3.1-pro-preview
- 名稱對等：Telegram = 小龍蝦 = 電報

## 🔴 新視窗啟動後第一件事
直接告訴教練：「🦞 已同步最新記憶，PROMISES 尚有1條待兌現」

## 📋 PROMISES 待兌現
✅ **全部結清。帳本清零。**（截至 2026-04-23）
- 血淚教訓38條掃描完成：補齊7條缺口，commit `fddef64`，結清 commit `9e8f228`

## ✅ 今日完成里程碑（2026-04-23）

### 身份修復
- 三台 SOUL.md 全部加入身份鐵律區塊（學長/學妹/學弟 + 正確 bot 帳號）
- 1號機幻覺帳號 @OpenClaw MacBook 問題修正

### ClawHub 接入（重大）
- 查明正確名稱：ClawHub（非 Cloudhub），13,000+ 技能，`openclaw skills search/install`
- 第37條寫入三台 SOUL.md：遇到不會的事先查 ClawHub → OPE → 才自己做
- 補上教練兩個月來一直強調的「先上網搜」，終於落地為具體工具和指令

### 多智能體協作架構（照搬 openclaw-multi-agent-kit 10-bot 生產驗證架構）
- 建立 `workspace/shared-context/`：SUPERGROUP-MAP.md / THESIS.md / SIGNALS.md / FEEDBACK-LOG.md
- SUPERGROUP-MAP.md：三機成員名冊 + Turn-Taking Protocol（防無限互ping）
- bot-relay-inbound 補入2、3號機（之前只有發、沒有收，所以不知道彼此在說什麼）
- 三台 AGENTS.md 加入團隊表格 + 啟動必讀 SUPERGROUP-MAP.md
- 2、3號機推送到 remote（previously 無 remote）

### Cron 修正
- 停用浮動「每4小時進度關懷」（與固定版重疊，47分鐘內發兩次「四小時到了」）

### 執行鐵律（永久寫入）
- SOUL.md + CLAUDE.md：邏輯唯一解直接做，不問
- PROMISES.md：承諾帳本，commit hash 才算憑證

## ⚠️ 所有對話守則
- 全部繁體中文，不夾任何英文
- 能自己做直接做，不問確認
- 預估超過 5 萬 Token 先回報教練確認
- 執行完通報 Telegram（Chat ID: 6124913915）

## 🔑 關鍵架構速查
- shared-context 路徑：`/Users/bymyway/.openclaw/workspace/shared-context/`
- 三機 bot：1號 @openclaw_macbook4_bot / 2號 @CoachWu_openclaw_bot / 3號 @coachwu_lenovo_bot
- 群組 ID：-1003877502911（頂級特助分工群）
- ClawHub：`openclaw skills search "功能"` → `openclaw skills install <slug>`
