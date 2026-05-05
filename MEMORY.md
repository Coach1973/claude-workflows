# Memory Index

- [工作團隊正確架構](project_team_structure.md) — 1/2/3號機都在Mac mini，VPS是獨立學弟系統，終端機1/2號是不同的
- [身份混亂血淚後記](feedback_openclaw_identity_postmortem.md) — 修身份問題唯一有效位置是SOUL.md，必先讀AGENTS.md確認啟動順序
- [ClawHub OPE 鐵律](feedback_clawhub_ope_rule.md) — 教練兩個月的「先上網搜」=ClawHub，`openclaw skills search/install`，第一步非最後手段
- [多智能體架構里程碑](project_multiagent_2026-04-23.md) — shared-context建立、SUPERGROUP-MAP、bot-relay-inbound修復、Turn-Taking Protocol
- [不問顯而易見答案的問題](feedback_obvious_question_rule.md) — 對話脈絡已限縮答案唯一時，直接推導，不問教練
- [該做就做，不要問](feedback_just_do_it.md) — 待辦事項清楚時直接執行，不問教練「要先做哪一個」
- [MiniMax auth-profiles 格式鐵律](feedback_minimax_auth_format.md) — VPS minimax/minimax-portal 必須用 vars 格式，改成 key 格式會導致完全無回應
- [OpenWhisper 是要關閉的語音辨識軟體](feedback_openwhisper_app.md) — 要關的是 OpenWhisper，Typeless 是正常常駐軟體不能動
- [LINE 群組身份混淆修復方法](feedback_line_group_identity_fix.md) — group-identity hook 加 LINE session 注入，bot 改用 userId 層級認人
- [VPS 規則體系更新 2026-05-01](project_vps_rules_update.md) — 新增20條操作細則、刪HB.md、關TTS
- [禁止未授權修改openclaw.json模型](feedback_openclaw_json_forbidden.md) — 教練明令：agents.list model欄位未經允許絕對不碰
- [各工具設定檔隔離鐵律](feedback_config_isolation.md) — OpenCode/Opcode/終端機/OpenClaw四份設定完全獨立，操作只動對應那一個
- [Google API proxy baseUrl 需含 /v1beta](project_google_baseurl_fix.md) — baseUrl少/v1beta會導致embedded agent全面404，已修復
- [settings.json禁止加ANTHROPIC_/VERTEX vars](feedback_settings_json_vertex_forbidden.md) — settings.json env覆蓋claude-easyclaude，CLAUDE_CODE_USE_VERTEX會觸發Google ADC錯誤
- [禁止用截圖讀取系統資訊](feedback_no_screenshot_for_data.md) — 查進程/記憶體/系統狀態一律用終端指令，截圖消耗流量且不必要
