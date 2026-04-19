#!/bin/bash
echo "正在啟動 FB 綁定程式，請稍候..."
cd /Users/bymyway/.openclaw/workspace/scripts/
npm install puppeteer --no-save
node login_fb.js
