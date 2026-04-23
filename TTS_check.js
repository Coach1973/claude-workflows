// TTS 品質驗證腳本（修復版 2026-04-23）
// 規則：每日最多測試 1 次，失敗後寫入 flag，當天不再重試

import { spawn } from 'child_process';
import { writeFileSync, existsSync } from 'fs';

const TODAY = new Date().toISOString().slice(0, 10);
const FLAG_FILE = `/tmp/tts_tested_${TODAY}.flag`;
const MAX_ATTEMPTS = 1; // 修復：從 5 改為 1，避免重複消耗配額
const testText = "小龍蝦語音測試。"; // 修復：縮短測試文字，8 字元

async function callTTS(text) {
  return new Promise((resolve, reject) => {
    const apiKey = process.env.MINIMAX_API_KEY;
    if (!apiKey) { reject(new Error('MINIMAX_API_KEY 未設定')); return; }

    const proc = spawn('curl', [
      '-s', '-X', 'POST',
      'https://api.minimax.chat/v2/t2a2/stream',
      '-H', `Authorization: Bearer ${apiKey}`,
      '-H', 'Content-Type: application/json',
      '-d', JSON.stringify({ model: "speech-02-hd", text, stream: false }),
      '-o', '/tmp/tts_output.mp3',
      '-w', '%{http_code}'
    ]);

    let httpCode = '';
    proc.stdout.on('data', d => httpCode += d.toString());
    proc.on('close', code => {
      if (code === 0 && httpCode.trim() === '200') resolve('/tmp/tts_output.mp3');
      else reject(new Error(`TTS 失敗 HTTP=${httpCode}`));
    });
  });
}

async function main() {
  if (existsSync(FLAG_FILE)) {
    console.log(`今天（${TODAY}）已測試過 TTS，跳過。`);
    process.exit(0);
  }
  writeFileSync(FLAG_FILE, `tested at ${new Date().toISOString()}\n`);
  console.log(`已寫入 flag：${FLAG_FILE}，今日不再重試`);

  try {
    const audioPath = await callTTS(testText);
    console.log(`TTS 成功：${audioPath}`);
    process.exit(0);
  } catch (err) {
    console.log(`TTS 失敗：${err.message}，等待明天配額重置`);
    process.exit(1);
  }
}

main().catch(err => { console.error(err); process.exit(1); });
