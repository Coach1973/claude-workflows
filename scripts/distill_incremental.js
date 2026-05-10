#!/usr/bin/env node
const fs = require('fs');
const path = require('path');
const os = require('os');

const WORKSPACE = path.join(os.homedir(), '.openclaw', 'workspace');
const MEMORY_DIR = path.join(WORKSPACE, 'memory');
const PROFILE_PATH = path.join(WORKSPACE, 'CLIENT_PROFILE.md');

function getLastDistillTime() {
  try {
    const content = fs.readFileSync(PROFILE_PATH, 'utf-8');
    const match = content.match(/<!-- DISTILL_CHECKPOINT: (.+?) -->/);
    if (match) return new Date(match[1]);
  } catch (e) {}
  return new Date(0);
}

function updateCheckpoint(time) {
  const content = fs.readFileSync(PROFILE_PATH, 'utf-8');
  const updated = content.replace(
    /<!-- DISTILL_CHECKPOINT: .+? -->/,
    `<!-- DISTILL_CHECKPOINT: ${time.toISOString()} -->`
  );
  fs.writeFileSync(PROFILE_PATH, updated);
}

function getTodayLogPath() {
  const now = new Date();
  const formatted = new Date(now.toLocaleString('en-US', { timeZone: 'Asia/Taipei' }));
  const y = formatted.getFullYear();
  const m = String(formatted.getMonth() + 1).padStart(2, '0');
  const d = String(formatted.getDate()).padStart(2, '0');
  return path.join(MEMORY_DIR, `${y}-${m}-${d}.md`);
}

function extractNewEntries(logPath, since) {
  if (!fs.existsSync(logPath)) return '';
  const content = fs.readFileSync(logPath, 'utf-8');
  const lines = content.split('\n');
  const result = [];
  let capturing = false;
  const sinceMs = since.getTime();

  for (const line of lines) {
    const timeMatch = line.match(/##.*?(\d{2}):(\d{2})/);
    if (timeMatch) {
      const now = new Date();
      const entryTime = new Date(now.getFullYear(), now.getMonth(), now.getDate(),
        parseInt(timeMatch[1]), parseInt(timeMatch[2]));
      capturing = entryTime.getTime() > sinceMs;
    }
    if (capturing) result.push(line);
  }
  return result.join('\n').trim();
}

const lastDistill = getLastDistillTime();
const logPath = getTodayLogPath();
const newEntries = extractNewEntries(logPath, lastDistill);

if (!newEntries) {
  console.log('NO_NEW_ENTRIES');
  process.exit(0);
}

console.log(`=== 增量蒸餾原始資料（${lastDistill.toISOString()} 之後） ===\n`);
console.log(newEntries);
console.log(`\n=== 資料結束 ===`);

updateCheckpoint(new Date());
console.log(`\nCHECKPOINT_UPDATED`);
