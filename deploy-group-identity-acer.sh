#!/bin/bash
# deploy-group-identity-acer.sh
# 在 Acer 端執行此腳本，部署 group-identity hook（學弟身份）
# 使用方式：bash deploy-group-identity-acer.sh

set -e

REPO_DIR="$HOME/Documents/mac-openclaw-workflows"
HOOK_DIR="$HOME/.openclaw/hooks/group-identity"
OPENCLAW_JSON="$HOME/.openclaw/openclaw.json"

echo "🦐 Acer 學弟端部署開始..."

# 1. 確保 repo 是最新的
echo "📥 同步最新記憶..."
cd "$REPO_DIR" && git pull origin main

# 2. 建立 hook 目錄
echo "📁 建立 hook 目錄..."
mkdir -p "$HOOK_DIR"

# 3. 複製 hook 檔案（從 repo 下載，若有的話；否則就地生成）
if [ -f "$REPO_DIR/hooks/group-identity/handler.js" ]; then
  cp "$REPO_DIR/hooks/group-identity/handler.js" "$HOOK_DIR/handler.js"
  cp "$REPO_DIR/hooks/group-identity/handler.ts" "$HOOK_DIR/handler.ts"
  cp "$REPO_DIR/hooks/group-identity/HOOK.md" "$HOOK_DIR/HOOK.md"
  echo "✅ Hook 檔案從 repo 複製完成"
else
  echo "⚠️  Repo 中無 hook 檔案，使用內嵌版本生成..."

  cat > "$HOOK_DIR/HOOK.md" << 'HOOKMD'
---
name: group-identity
description: "偵測群組 Session，強制注入 SHARED_GROUP_MEMORY 與機器身份（學長/學弟）"
metadata: {"openclaw":{"emoji":"🦐","events":["agent:bootstrap"]}}
---
# Group Identity Hook
偵測當前 Session 是否為 Telegram 分工群組，若是則注入共享記憶與學弟身份。
HOOKMD

  cat > "$HOOK_DIR/handler.js" << 'HANDLERJS'
"use strict";
const fs = require('fs');
const os = require('os');
const path = require('path');

const hostname = os.hostname().toLowerCase();
const IS_MAC_SENIOR = hostname.includes('mac-mini') || hostname.includes('mac');

const IDENTITY_BLOCK = IS_MAC_SENIOR
  ? `## 🦞 你的身份：學長（Mac 端）\n- **角色**：發號施令、策略決策\n- **職責**：統籌任務、分派工作給學弟、審核輸出、與教練直接溝通\n- **回報格式**：決策時以「📋 學長決策：」開頭\n- **鐵律**：你是指揮官，不要讓教練覺得有兩個平等的機器人，你代表整個系統發言`
  : `## 🦐 你的身份：學弟（Acer 端）\n- **角色**：執行者、查資料、爬蟲、做髒活\n- **職責**：執行學長指令、蒐集資料、回傳原始結果，不做最終決策\n- **回報格式**：完成後以「✅ 學弟回報：」開頭\n- **鐵律**：等待學長發令再行動，有疑問先問學長，不要直接告知教練結論`;

const WORKSPACE_DIR = path.join(os.homedir(), 'Documents', 'mac-openclaw-workflows');
const SHARED_MEMORY_PATH = path.join(WORKSPACE_DIR, 'SHARED_GROUP_MEMORY.md');

function isGroupSession(event) {
  const ctx = (event && event.context) ? event.context : {};
  const chatType = (ctx.source && ctx.source.chat && ctx.source.chat.type) || (ctx.session && ctx.session.chatType) || (ctx.channel && ctx.channel.type) || ctx.chatType || '';
  if (['group', 'supergroup', 'channel'].includes(chatType)) return true;
  const chatId = (ctx.source && ctx.source.chat && ctx.source.chat.id) || (ctx.session && ctx.session.chatId) || ctx.chatId || 0;
  if (typeof chatId === 'number' && chatId < 0) return true;
  return false;
}

const handler = async (event) => {
  if (!event || typeof event !== 'object') return;
  if (event.type !== 'agent' || event.action !== 'bootstrap') return;
  if (!event.context || typeof event.context !== 'object') return;
  if (!isGroupSession(event)) return;

  const injections = [];
  try {
    if (fs.existsSync(SHARED_MEMORY_PATH)) {
      const sharedMemory = fs.readFileSync(SHARED_MEMORY_PATH, 'utf-8');
      injections.push(`## 📋 分工群組共享記憶體（SHARED_GROUP_MEMORY）\n\n${sharedMemory}`);
    } else {
      injections.push(`## ⚠️ SHARED_GROUP_MEMORY.md 不存在\n請執行：cd ${WORKSPACE_DIR} && git pull`);
    }
  } catch (err) {
    injections.push(`## ⚠️ 無法讀取 SHARED_GROUP_MEMORY.md：${err.message}`);
  }

  injections.push(IDENTITY_BLOCK);

  const block = ['---', `# 🚨 群組身份強制注入（Group Identity Hook）`, `> 主機：${os.hostname()} | 身份：${IS_MAC_SENIOR ? '🦞 學長' : '🦐 學弟'}`, '', ...injections, '---'].join('\n');

  if (!event.context.inject) event.context.inject = [];
  if (Array.isArray(event.context.inject)) event.context.inject.unshift({ role: 'system', content: block });
};

module.exports = handler;
module.exports.default = handler;
HANDLERJS

  echo "✅ Hook 檔案內嵌生成完成"
fi

# 4. 在 openclaw.json 啟用 hook（用 node 安全插入，避免手動 JSON 錯誤）
echo "⚙️  更新 openclaw.json..."
node -e "
const fs = require('fs');
const p = '$OPENCLAW_JSON';
const json = JSON.parse(fs.readFileSync(p, 'utf-8'));
if (!json.hooks) json.hooks = {};
if (!json.hooks.internal) json.hooks.internal = { enabled: true, entries: {} };
if (!json.hooks.internal.entries) json.hooks.internal.entries = {};
json.hooks.internal.entries['group-identity'] = { enabled: true };
fs.writeFileSync(p, JSON.stringify(json, null, 2));
console.log('openclaw.json 更新完成');
"

echo ""
echo "🎉 Acer 學弟端部署完成！"
echo "   Hook 位置：$HOOK_DIR"
echo "   身份：🦐 學弟（Acer 端）"
echo "   偵測主機：$(hostname)"
echo ""
echo "請重啟 OpenClaw 讓 hook 生效：openclaw restart"
