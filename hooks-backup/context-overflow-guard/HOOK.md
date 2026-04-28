---
name: context-overflow-guard
description: "每次收到人類訊息時累計輪次，接近 context 上限時注入分級預警"
metadata: {"openclaw":{"emoji":"🛡️","events":["message:preprocessed"]}}
---

# Context Overflow Guard Hook

每次收到人類訊息時，累計本次 Session 的輪次計數，並在接近 context 上限時自動注入警告。

## 觸發事件
`message:preprocessed` — 每次人類發言時觸發

## 警戒閾值

| 輪次 | 等級 | 行為 |
|------|------|------|
| 20+  | 🟡 警戒 | 注入警告，要求在回覆結尾附健康度尾巴 |
| 30+  | 🟠 警告 | 注入警告，要求更新 HEARTBEAT.md 並通知教練 |
| 38+  | 🔴 危急 | 注入緊急指令，強制搶救記憶並發 Telegram 通知 |

## 計數器位置
`~/.openclaw/workspace/state/session_counter.json`
（每次 bootstrap 由 client-memory hook 重置為 0）
