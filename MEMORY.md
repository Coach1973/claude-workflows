# Project Memory Index

## 🤝 雙機協作與三助教系統
- [分工群組共享記憶體](SHARED_GROUP_MEMORY.md) — **群組 Session 必讀**：學長/學弟身份定義、協作 SOP、衝突防護規則（2026-04-15）
- [三助教協作正式 SOP (HANDOFF 機制)](memory/project_three_assistants_sop_20260419.md) — **核心必讀**：2026-04-19 確立的 Gemini/Claude/終端機 三助教完美交接協議與全自動執行標準。

## 🎯 最高優先級：偉大任務
- [大樹教練的偉大任務與最終願景](user_grand_mission.md) — **所有工作的最高指導方針**：讓中小企業主只要動嘴，AI 全自動處理
- [頂級特助系統完整藍圖](project_top_assistant_blueprint.md) — 命名由來、三套餐商業模式、海餅乾俱樂部十大守則、護城河哲學（2026-04-11）

## User（教練個人檔案）
- [大樹教練個人檔案](user_profile.md) — 身份/目標/設備分工/語音辨識糾偏/內容偏好

## Feedback（行為守則）
- [大任務配速與配額保護機制](project_quota_protection_sop.md) — **防當機必讀**：Gemini Token 超載防護、大任務分批處理與背景排程 SOP（2026-04-17）
- [系統架構預警原則：硬體常駐意識與主動避坑](project_deployment_warning_principle.md) — **架構必讀**：伺服器與終端機的物理界線，AI 必須主動預警無效部署（2026-04-16）
- [拒絕讓老闆當傳話筒的顧問式引導](feedback_proactive_advisory.md) — **UX體驗必讀**：AI 明知有更優解時，必須主動打斷教練提出，絕對禁止讓教練在不同視窗間複製貼上當廉價勞工 (2026-04-19 痛點反省)。
- [AI 資訊壁壘突破守則：拒絕被單一模型的「不可能」綁架](project_ai_cross_validation_principle.md) — **防坑必讀**：破解 AI 先入為主與保守防禦的交叉驗證法則（2026-04-16）
- [🚨 Live Session Model Switch 致命缺陷](feedback_live_session_model_switch_bug.md) — **壓力測試發現（2026-04-12）**：fallback 鏈在 live session 中完全無效，治本方案：配額耗盡時必須改 primary + 清 session + 重啟
- [與大樹教練合作的核心工作守則](feedback_working_rules.md) — 執行策略、Token 管理、安全守則、互動風格、偉大任務
- [DeepSeek Session Lock 試錯總結](feedback_deepseek_session_lock_lessons.md) — 花 2 小時的失敗記錄，根本解是改 Primary 模型，不要繞路
- [Kimi API 台灣無法申請](feedback_kimi_taiwan_blocked.md) — platform.moonshot.cn 台灣封鎖，需請大陸朋友代申請，Key 不綁帳號可直接使用
- [LINE webhook route loss fix](feedback_line_webhook_route_loss_fix.md) — patch for openclaw LINE webhook only responding to first message
- [遇到 debug 要用 Claude Code](feedback_use_claude_code_not_cowork.md) — 提醒使用者用對工具，不要在 cowork 複製貼上
- [讀取 Telegram 回應不截圖](feedback_session_read_no_screenshot.md) — 直接讀 JSONL session 檔，截圖耗 Token 100 倍
- [優先用指令，不要用截圖](feedback_use_cli_not_screenshot.md)
- [頂級特助 UX 黃金標準](feedback_top_assistant_ux_standard.md) — **客戶不能踩坑**：所有技術設定部署前完成，群組功能必做清單，「只要動嘴」不是口號是底線 — 能 CLI 做的事絕對不截圖；computer use 只用在真正需要視覺操作的場合

## HaiBingGan（海餅乾知識庫）
- [海餅乾俱樂部核心哲學與守則全知識庫](project_haibinggan_philosophy.md) — 三大信念、十大守則深度解析、五大關鍵要素、金句集（2026-04-13 整理自逐字稿）

## Project（重要技術記錄與決策）
- [VPS 隔離架構與頂級特助 UX 體驗](project_vps_isolation_and_ux_20260418.md) — **架構與UX必讀**：186MB 歷史垃圾導致的精神錯亂事件、英文日誌自動翻譯的防呆邏輯、多租戶防失憶架構與團隊稱呼定義（2026-04-18）
- [Opcode (開源 Claude 桌面版) 環境變數設定指南](project_opcode_setup_guide.md) — **部署必讀**：跨平臺安裝後的 API 金鑰與代理網址標準設定流程（2026-04-16）
- [模型切換大戰實戰紀錄 4/11](project_model_failover_lessons_20260411.md) — OpenRouter/SambaNova/Cerebras 接入成功，Session Lock 修復步驟，各模型真實限制與 5 條備援線路
- [全自動 API 鑰匙獲取藍圖](project_auto_api_key_blueprint.md) — 小白老闆零門檻接入 AI 免費額度的完整方案（已驗證 Groq 流程）
- [4/8-4/11 重要決策與成功經驗](project_key_decisions.md) — NotebookLM帳號分工、FB私訊方案、模型策略、雙向同步機制
- [DeepSeek 接入 + Session Lock 永久修復](project_deepseek_session_fix_20260411.md) — API 設定、Live Session Lock 根因與自動修復 LaunchAgent (2026-04-11)
- [4/8-4/11 小龍蝦對話完整分析](project_session_analysis_0408_0411.md) — 9項完成任務、DOM模式突破、待辦事項、未記錄守則（YouTube監測、Obsidian、知識過濾哲學）
- [2/25-2/27 小龍蝦開機第一週](project_session_analysis_0225_0227.md) — Mac新手入門、嘸蝦米、GCP帳單轉移、Chrome擴充安裝、Ollama踩坑、模型選擇決策
- [Gemini 空白回應問題永久修復](feedback_gemini_empty_response_fix.md) — memory 檔超過 50KB 導致 Gemini 輸出 0 token，根治方法：HEARTBEAT 禁止讀大型 memory 檔
- [頂級特助防失憶完整架構](project_anti_amnesia_architecture.md) — **部署必讀**：四層防失憶機制、HEARTBEAT模板、新機器清單、常見失誤診斷（2026-04-12）

## Feedback（行為守則）- 2026-04-17 新增
- [坦誠底層限制與不迴避原則](feedback_ai_transparency_rule.md) — **溝通必讀**：遇到技術限制必須第一時間坦白並給替代方案，絕不讓老闆花時間逼問真相。
- [教練碎碎念精華：頂級特助的底層思維](feedback_coach_golden_rules.md) — 紀錄教練嚴厲指正的核心商業邏輯與 UX 體驗要求。

- [數字與數量級的絕對精準](feedback_numerical_precision_rule.md) — **商業底線必讀**：差一個零就是 10 倍災難，頂級特助對數字的精準度要求（2026-04-19 痛點反省）。
- [模型切換後的自動接續守則](feedback_model_switch_auto_resume.md) — **防乾等必讀**：切換線路後必須立刻檢查 HEARTBEAT 並接續中斷任務，絕對不准等教練提醒 (2026-04-19)
