#!/bin/bash
# 這是給第二隻小龍蝦（宏碁特助）的專屬啟動腳本
export OPENCLAW_HOME="$HOME/.openclaw-2"

# 設定不同的通訊埠(Port)避免跟第一隻打架 (預設是3000，這裡改3001)
export OPENCLAW_PORT=3001

echo "正在啟動第二隻小龍蝦..."
openclaw gateway start
echo "✅ 宏碁特助啟動成功！"
