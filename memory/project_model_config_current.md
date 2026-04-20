---
date: 2026-04-19
type: project
title: 當前模型配置（最新版，覆蓋舊版 failover 紀錄）
---

# 當前模型配置（2026-04-19 確認）

## Mac 版 OpenClaw（小龍蝦主機）

- **Primary**：litellm/gemini-3.1-pro-preview（第一個 Gemini 帳號，已開通帳單）
- **Fallback**：google/gemini-3.1-pro-preview（第二個 Gemini 帳號）
- **每日總容量**：約 500 次呼叫
- **重置時間**：台灣時間每天早上 8 點（UTC 午夜）

## 已廢棄的模型（不再使用）

所有免費模型已全部刪除，原因：智慧等級不足，無法維持服務品質。
包含：OpenRouter、SambaNova、Cerebras、Groq、DeepSeek 等。

## 遇到限流時的處理方式

- 短暫限流（Rate-limited ~30s）：等待即可，自動恢復
- 一條帳號用完：自動切換到 fallback 第二條帳號
- 兩條都用完：等隔天早上 8 點重置，無法繞過

## VPS 版 OpenClaw（雲端測試版）

- **Primary**：MiniMax M2.7（訂閱制，1500 次/5小時）
- **備援**：尚未設定
