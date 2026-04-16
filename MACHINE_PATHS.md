---
name: MACHINE_PATHS
description: 三台電腦的本地路徑對照表
type: reference
---

# MACHINE_PATHS.md — 三台電腦路徑對照表

## Mac（主力機）
- **使用者**：bymyway
- **Repo 路徑**：`~/Documents/mac-openclaw-workflows`
- **工作區路徑**：`/Users/bymyway/.openclaw/workspace`
- **Claude 指令**：`claude`（終端機）
- **圖形介面**：Opcode（/Applications/opcode.app）、Open WebUI（http://localhost:3000）

## 聯想 Lenovo（Windows）
- **使用者**：bymyw
- **Repo 路徑**：`E:\Claude-Data\mac-openclaw-workflows`
- **工作區路徑**：`E:\Claude-Data\mac-openclaw-workflows`
- **Claude 指令**：`claude`（PowerShell）
- **圖形介面**：Opcode（Windows 版）

## 宏碁 Acer（Windows）
- **使用者**：Administrator
- **Repo 路徑**：`C:\Users\Administrator\Documents\mac-openclaw-workflows`
- **工作區路徑**：`C:\Users\Administrator\.openclaw\workspace`
- **Claude 指令**：`openclaw gateway start`（小龍蝦系統）
- **圖形介面**：無

## Open WebUI（三台共用）
- **主機**：Mac（192.168.0.61）
- **網址**：`http://192.168.0.61:3000`
- **本機網址**：`http://localhost:3000`
- **條件**：三台需在同一 WiFi 下
