---
name: GPU Undervolting 待執行任務
description: 聯想 Gaming 3-16IAH7 RTX 3050 Ti Laptop GPU Undervolt，流量回來後執行
type: project
---

## 待執行：GPU Undervolting

**目標機器：** 聯想 Gaming 3-16IAH7（主力 Windows）
**GPU：** RTX 3050 Ti Laptop GPU
**執行時間：** 2026-04-11 下午 1:00 後（流量重新計算後）

**Why:** 用戶流量用完，現在是額外計費模式，等流量重置後再執行以節省費用。

**How to apply:** 2026-04-11 13:00 後用戶回來時，主動提醒繼續執行 GPU Undervolting。

## 執行計畫（已準備好）

1. 確認有無安裝 MSI Afterburner
2. 開啟 Voltage/Frequency Curve Editor（Ctrl+F）
3. 找到 Boost Clock（約 1485 MHz）
4. 從 -50mV 開始降壓
5. 跑 FurMark 壓力測試 15 分鐘驗證穩定性
6. 穩定則繼續降，目標 -75mV 或 -100mV

## 參考數值

| 降壓幅度 | 預期溫度效果 |
|----------|-------------|
| -50mV | -3~5°C |
| -75mV | -5~8°C |
| -100mV | -8~12°C |
