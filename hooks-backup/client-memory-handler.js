"use strict";

const fs = require('fs');
const path = require('path');

const OPENCLAW_DIR = path.resolve(__dirname, '../../');
const PROFILE_PATH = path.join(OPENCLAW_DIR, 'workspace', 'CLIENT_PROFILE.md');
const HEARTBEAT_PATH = path.join(OPENCLAW_DIR, 'workspace', 'HEARTBEAT.md');
const COUNTER_PATH = path.join(OPENCLAW_DIR, 'workspace', 'state', 'session_counter.json');

function getSessionCounter() {
  try {
    const dir = path.dirname(COUNTER_PATH);
    if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
    if (!fs.existsSync(COUNTER_PATH)) return { round: 0, bootstrapTime: new Date().toISOString() };
    return JSON.parse(fs.readFileSync(COUNTER_PATH, 'utf-8'));
  } catch (e) {
    return { round: 0, bootstrapTime: new Date().toISOString() };
  }
}

function resetSessionCounter() {
  try {
    const dir = path.dirname(COUNTER_PATH);
    if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
    fs.writeFileSync(COUNTER_PATH, JSON.stringify({
      round: 0,
      bootstrapTime: new Date().toISOString()
    }));
  } catch (e) {}
}

const handler = async (event) => {
  if (!event || typeof event !== 'object') return;
  if (event.type !== 'agent' || event.action !== 'bootstrap') return;
  if (!event.context || typeof event.context !== 'object') return;

  if (!event.context.inject) event.context.inject = [];
  if (!Array.isArray(event.context.inject)) return;

  // 重置本次 session 的輪次計數器
  resetSessionCounter();

  try {
    // 注入 CLIENT_PROFILE.md
    if (fs.existsSync(PROFILE_PATH)) {
      const profileContent = fs.readFileSync(PROFILE_PATH, 'utf-8');
      if (profileContent.trim()) {
        const block = [
          '---',
          '# 📋 用戶記憶檔案（CLIENT_PROFILE）',
          '> 以下是這位用戶的背景資料，請在整個對話中牢記。',
          '',
          profileContent,
          '---',
        ].join('\n');
        event.context.inject.unshift({ role: 'system', content: block });
      }
    }
  } catch (err) {}

  try {
    // 注入 HEARTBEAT.md（當前任務狀態 — 最高優先）
    if (fs.existsSync(HEARTBEAT_PATH)) {
      const hbContent = fs.readFileSync(HEARTBEAT_PATH, 'utf-8');
      if (hbContent.trim()) {
        const now = new Date().toLocaleString('zh-TW', { timeZone: 'Asia/Taipei' });
        const block = [
          '---',
          '# 🚨 系統啟動上下文（HEARTBEAT — 自動注入）',
          `> 本次 Session 啟動時間：${now}`,
          '> ⚠️ 這是新的 Session。以下是你上次的工作狀態，請立即同步並告知教練你已重啟。',
          '',
          hbContent,
          '---',
        ].join('\n');
        // 放在最前面，確保是第一條讀到的 system 訊息
        event.context.inject.unshift({ role: 'system', content: block });
      }
    }
  } catch (err) {}
};

module.exports = handler;
module.exports.default = handler;
