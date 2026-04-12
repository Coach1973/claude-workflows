---
name: 優先用指令，不要用截圖做能用 CLI 做的事
type: feedback
date: 2026-04-12
---

## 錯誤案例

教練問「能不能幫我更新 Telegram」，助教直接開 App Store、截圖、點選，花了 ~8,000 tokens。

正確做法：
```bash
mas outdated | grep -i telegram
# 或
mas upgrade telegram
```
300 tokens，3秒，結果一樣。

## 根本原因

教練問「你做不做得到」→ 助教把重點放在「展示 computer use」，而不是「用最有效率的方法解決問題」。

## 永久守則

**能用指令做的事，絕對不用截圖。**

判斷順序：
1. 有 CLI / API 嗎？→ 直接用
2. 有 MCP 工具嗎？→ 直接用
3. 以上都沒有，才用 computer use 截圖點選

computer use 只用在：
- UI 壞掉需要視覺確認
- 圖形介面沒有對應 CLI
- 教練明確要求「幫我操作畫面」

## 教練的原話

> 「那剛才為何你沒有優先用指令行事？還要等我指示，而且還是用笨方法」
