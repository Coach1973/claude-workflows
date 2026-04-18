#!/bin/bash
# 【執行命令】VPS 學弟專用：強制簽收總部記憶體的 GitOps 腳本
# 用途：放在 VPS 的 crontab 中自動執行，確保學弟的大腦與總部 Hash 憑證一致
cd "$(dirname "$0")/.." || exit
git fetch origin main >/dev/null 2>&1
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/main)

if [ "$LOCAL" != "$REMOTE" ]; then
    echo "[!] 發現總部新指令 (Hash: $REMOTE)"
    git pull origin main --rebase >/dev/null 2>&1
    echo "✅ 最新記憶體已強制簽收。當前大腦版本：$(git rev-parse HEAD)"
else
    echo "✅ 目前已是最新版本 (Hash: $LOCAL)"
fi
