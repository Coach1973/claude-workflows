# Project Memory Index

## 🎯 最高優先級：偉大任務
- [大樹教練的偉大任務與最終願景](user_grand_mission.md) — **所有工作的最高指導方針**：讓中小企業主只要動嘴，AI 全自動處理
- [頂級特助系統完整藍圖](project_top_assistant_blueprint.md) — 命名由來、三套餐商業模式、海餅乾俱樂部十大守則、護城河哲學（2026-04-11）

## User（教練個人檔案）
- [大樹教練個人檔案](user_profile.md) — 身份/目標/設備分工/語音辨識糾偏/內容偏好

## Feedback（行為守則）
- [與大樹教練合作的核心工作守則](feedback_working_rules.md) — 執行策略、Token 管理、安全守則、互動風格、偉大任務
- [DeepSeek Session Lock 試錯總結](feedback_deepseek_session_lock_lessons.md) — 花 2 小時的失敗記錄，根本解是改 Primary 模型，不要繞路
- [Kimi API 台灣無法申請](feedback_kimi_taiwan_blocked.md) — platform.moonshot.cn 台灣封鎖，需請大陸朋友代申請，Key 不綁帳號可直接使用
- [LINE webhook route loss fix](feedback_line_webhook_route_loss_fix.md) — patch for openclaw LINE webhook only responding to first message
- [遇到 debug 要用 Claude Code](feedback_use_claude_code_not_cowork.md) — 提醒使用者用對工具，不要在 cowork 複製貼上
- [讀取 Telegram 回應不截圖](feedback_session_read_no_screenshot.md) — 直接讀 JSONL session 檔，截圖耗 Token 100 倍

## Project（重要技術記錄與決策）
- [模型切換大戰實戰紀錄 4/11](project_model_failover_lessons_20260411.md) — OpenRouter/SambaNova/Cerebras 接入成功，Session Lock 修復步驟，各模型真實限制與 5 條備援線路
- [全自動 API 鑰匙獲取藍圖](project_auto_api_key_blueprint.md) — 小白老闆零門檻接入 AI 免費額度的完整方案（已驗證 Groq 流程）
- [4/8-4/11 重要決策與成功經驗](project_key_decisions.md) — NotebookLM帳號分工、FB私訊方案、模型策略、雙向同步機制
- [DeepSeek 接入 + Session Lock 永久修復](project_deepseek_session_fix_20260411.md) — API 設定、Live Session Lock 根因與自動修復 LaunchAgent (2026-04-11)
- [4/8-4/11 小龍蝦對話完整分析](project_session_analysis_0408_0411.md) — 9項完成任務、DOM模式突破、待辦事項、未記錄守則（YouTube監測、Obsidian、知識過濾哲學）
- [2/25-2/27 小龍蝦開機第一週](project_session_analysis_0225_0227.md) — Mac新手入門、嘸蝦米、GCP帳單轉移、Chrome擴充安裝、Ollama踩坑、模型選擇決策
- [Gemini 空白回應問題永久修復](feedback_gemini_empty_response_fix.md) — memory 檔超過 50KB 導致 Gemini 輸出 0 token，根治方法：HEARTBEAT 禁止讀大型 memory 檔
