"use strict";

const fs = require('fs');
const path = require('path');

const COUNTER_PATH = path.join(process.env.HOME, '.openclaw', 'workspace', 'state', 'session_counter.json');

// 閾值設定
const WARN_YELLOW = 20;  // 🟡 警戒
const WARN_ORANGE = 30;  // 🟠 警告，準備交接
const WARN_RED    = 38;  // 🔴 危急，立即搶救

function readCounter() {
  try {
    if (!fs.existsSync(COUNTER_PATH)) return { round: 0, bootstrapTime: new Date().toISOString() };
    return JSON.parse(fs.readFileSync(COUNTER_PATH, 'utf-8'));
  } catch (e) {
    return { round: 0, bootstrapTime: new Date().toISOString() };
  }
}

function writeCounter(data) {
  try {
    const dir = path.dirname(COUNTER_PATH);
    if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
    fs.writeFileSync(COUNTER_PATH, JSON.stringify(data));
  } catch (e) {}
}

const handler = async (event) => {
  if (!event || typeof event !== 'object') return;
  if (event.type !== 'message' || event.action !== 'preprocessed') return;
  if (!event.context || typeof event.context !== 'object') return;

  // 計數 +1
  const counter = readCounter();
  counter.round = (counter.round || 0) + 1;
  writeCounter(counter);

  const round = counter.round;
  const remaining_to_red = WARN_RED - round;

  let warning = null;

  if (round >= WARN_RED) {
    warning = {
      level: '🔴',
      text: [
        '# 🔴 危急：Context 即將溢出',
        `> 本次 Session 已進行第 **${round}** 輪對話，距離強制刷新只剩 ${Math.max(0, 45 - round)} 輪以內。`,
        '',
        '**你現在必須立即執行：**',
        '1. 更新 HEARTBEAT.md（寫入當前任務進度、未完成事項）',
        '2. git commit && git push（確保記憶不遺失）',
        '3. 發送 Telegram 通知教練：「🔴 記憶體即將滿，請準備開新視窗」',
        '4. 等待教練確認後再繼續',
        '',
        '⚠️ 絕對不可在未通知教練的情況下繼續對話直到溢出。',
      ].join('\n'),
    };
  } else if (round >= WARN_ORANGE) {
    warning = {
      level: '🟠',
      text: [
        '# 🟠 警告：準備 Context 交接',
        `> 本次 Session 已進行第 **${round}** 輪，距離危急線還有 ${WARN_RED - round} 輪。`,
        '',
        '**請在本輪回覆結尾完成：**',
        '1. 更新 HEARTBEAT.md（記錄當前進度）',
        '2. git commit 確保狀態已存',
        '3. 回覆結尾附上：「⚠️ 記憶體即將滿（第 ' + round + ' 輪），請教練準備開新視窗」',
      ].join('\n'),
    };
  } else if (round >= WARN_YELLOW) {
    warning = {
      level: '🟡',
      text: [
        `# 🟡 警戒：Session 已進行第 ${round} 輪`,
        `> 距離警告線（${WARN_ORANGE}輪）還有 ${WARN_ORANGE - round} 輪，距離危急線還有 ${WARN_RED - round} 輪。`,
        '',
        '請在回覆結尾附上健康度尾巴：',
        `\`━━━ 健康度 🟡 輪 #${round} | 距離刷新線：${WARN_RED - round}輪\``,
      ].join('\n'),
    };
  }

  if (warning) {
    if (!event.context.inject) event.context.inject = [];
    if (Array.isArray(event.context.inject)) {
      event.context.inject.push({ role: 'system', content: warning.text });
    }
  }
};

module.exports = handler;
module.exports.default = handler;
