---
name: 記憶系統 Index
description: 軍師大腦（Windows / bymyw 帳號）記憶索引
originSessionId: 9b71599f-3527-49bb-b841-541e2917342e
---
# Memory Index

## Feedback（行為指引）
- [自動化執行不要每件事都問](feedback_autonomous_execution.md) — 教練要軍師主動補回失落記憶、自動推進，不重複請示
- [教練給結論後不要再測證](feedback_trust_coach_conclusion.md) — 後台/官方證據是權威，軍師測試結果衝突時預設「我們接入錯了」
- [CC Switch 切換不需重啟 CLI](feedback_cc_switch_no_restart.md) — Windows 切換後當前 CLI 對話框立即生效
- [CC Switch Mac vs Windows 切換行為差異](feedback_cc_switch_mac_vs_windows.md) — Mac 切換後須開新終端機視窗；Windows 熱切換即生效
- [Opus 4.7 在 Synterolink 上極燒錢](feedback_opus_costly_default_sonnet.md) — 一輪燒 10 美金；預設用 Sonnet 4.6，非必要不切 Opus
- [先把解法準備好，把實測降級為驗收](feedback_solve_dont_test.md) — 不要把「要不要動手」的決策推給實測；朝「沒 OK」的角度直接解
- [終端機也能執行修復指令](feedback_terminal_can_repair.md) — 指令夠明確時，Mac 終端機可直接修復，不需要繞道桌面版

## Reference（外部系統 / 工具）
- [CC Switch 設定檔位置（Windows 站）](reference_cc_switch_paths.md) — DB/設定/日誌路徑，以及它改寫 .claude\settings.json 的運作方式
- [Synterolink Claude CLI 接入規格](reference_synterolink_setup.md) — 必須用 ANTHROPIC_AUTH_TOKEN，BASE_URL 不可加 /v1
- [EchoTokens 閘道參考](reference_echotokens.md) — gw.echotokens.me，SDK 相容閘道，附 Sage Analytics token 後台，已由桌面版建置完成

## Handoff（接班檔）
- [Synterolink 接入修復 2026-05-11](handoff_synterolink_fix_20260511.md) — 三邊已對齊，教練可在 CC Switch 熱切換驗證；含啟動詞與除錯路徑
- [雙模型 + Prompt Caching 接班 2026-05-12](handoff_synterolink_dual_models_20260512.md) — Synterolink 已測通並拆成 Opus/Sonnet 兩筆；下一輪第一件事查 prompt caching

## Project（進行中事件）
- [Synterolink 接入已成功（2026-05）](project_synterolink_success_202605.md) — 關鍵是 CLI 模型與後台分組一致；已升級 120 美金不限時間方案並測通

## 待補（從 system32 帳號搬遷中，目前 staging 在 E:\Claude-Data\mac-openclaw-workflows\windows-memory\from_system32\）
- feedback_role_boundary.md — 軍師角色邊界（含「軍師也要 commit、也要記憶」這條更正）
- feedback_conversation_segmentation_sop.md — 分段對話 SOP（省 token）
- feedback_model_assignment.md — 模型分派
- feedback_remote_safety.md — 遠端安全
- feedback_three_beliefs_first_one.md — 三大信念第一條
- handoff_command_center_sop_20260508.md — 5/8 指揮所交接
- project_clawhub_archaeology.md — ClawHub 考古
- project_command_center_archaeology_report.md — 指揮所考古報告
- reference_file_paths.md — 重要檔案路徑
- reference_vps_openclaw.md — VPS / OpenClaw 服務參考
- user_coach_profile.md — 教練側寫
- user_top_assistant_constitution.md — 頂尖特助守則
