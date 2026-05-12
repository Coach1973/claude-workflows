---
name: CC Switch 切換行為：Mac vs Windows 差異
description: Windows 熱切換即生效；Mac 切換後須開新終端機視窗才能銜接新模型
type: feedback
date: 2026-05-12
originSessionId: 711517c5-d5c6-44c9-afa9-23e7358edc02
---
**Windows：** CC Switch 切換 provider 後，當前 CLI 視窗直接生效，不需要關閉或重開。

**Mac：** 一個終端機視窗對應一個帳號/provider。切換到新模型後，必須開新的終端機視窗，舊視窗不會自動銜接。

**Why:** 教練 2026-05-12 親自回報 Mac 端的實際行為。

**How to apply:** 在 Mac 端規劃 CC Switch 工作流時，切換模型 = 開新終端機視窗。不要假設 Mac 跟 Windows 行為一致。給終端機的切換指令後面要提醒「請開新視窗執行」。
