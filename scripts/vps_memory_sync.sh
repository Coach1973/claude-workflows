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
    
    # 執行成功後，主動發送通知給教練 (透過 VPS 本機的 OpenClaw CLI)
    SHORT_HASH=$(echo $REMOTE | cut -c 1-8)
    openclaw message send --target 6124913915 --message "✅ 【VPS 學弟自動回報】報告教練與學長：我已成功簽收並載入總部最新指令 (憑證碼：$SHORT_HASH)！即刻起全面依據新規則執行任務。" >/dev/null 2>&1
    
    echo "✅ 最新記憶體已強制簽收並回報。當前大腦版本：$(git rev-parse HEAD)"
else
    echo "✅ 目前已是最新版本 (Hash: $LOCAL)"
fi
