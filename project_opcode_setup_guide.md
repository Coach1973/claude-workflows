# 🎯 Opcode (開源 Claude 桌面版) 環境變數設定指南

> **建立日期**：2026-04-16
> **核心貢獻者**：大樹教練

## 📖 背景說明
教練在跨平臺（Mac/Windows 聯想電腦）安裝開源軟體 Opcode 後，必須配置對應的 API 才能順利運行。為了讓未來的部署（每臺電腦）都能快速複製貼上、無腦設定，特此記錄這份標準設定流程。此配置使用了代理伺服器 (easyclaude.com) 來無縫接入 Anthropic 服務。

## ⚙️ 環境變數設定步驟 (Environment Variables)

請在軟體介面中執行以下操作：

1. 點擊上方的 **Environment** 分頁。
2. 點擊 **Add Variable**，依序加入以下兩個變數：

### 第一個變數（API 金鑰）
- **Name**：`ANTHROPIC_API_KEY`
- **Value**：`sk-XdJhSUk1W49askZnrr4sDxqzfDNyBGBYlKq0VIsWbERQbprV`

### 第二個變數（代理網址）
- **Name**：`ANTHROPIC_BASE_URL`
- **Value**：`https://api.easyclaude.com`

## ✅ 完成驗證
填完後點擊 **Save Settings**，然後重新開一個對話試試看，確認是否能正常運作並給出回覆。