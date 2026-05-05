#!/bin/bash
# dispatch.sh — 把 TASK_QUEUE.txt 的任務丟進 tmux 背景執行
# 用法：bash scripts/dispatch.sh
# 小龍蝦呼叫：bash /Users/bymyway/.openclaw/workspace/scripts/dispatch.sh

SESSION="task-runner"
WORKSPACE="/Users/bymyway/.openclaw/workspace"
BOT_TOKEN="8758843664:AAE4W-hGh2mPxNt89b2donZ0Q--YZ9uwdsA"
GROUP_ID="-1003877502911"

notify() {
  curl -s "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
    -d "chat_id=${GROUP_ID}" \
    -d "text=$1" \
    -d "parse_mode=HTML" > /dev/null 2>&1
}

# 如果上次的任務還在跑，先砍掉
tmux kill-session -t "$SESSION" 2>/dev/null

# 開新 tmux session，背景執行 queue_runner.sh
tmux new-session -d -s "$SESSION" \
  "bash $WORKSPACE/scripts/queue_runner.sh 2>&1 | tee -a $WORKSPACE/logs/dispatch.log"

notify "🚀 <b>任務已送出</b>
終端機正在背景執行，完成後逐一通知"

echo "✅ 任務已在 tmux session '$SESSION' 中啟動"
echo "   查看進度：tmux attach -t $SESSION"
