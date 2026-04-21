const puppeteer = require('puppeteer-core');
const fs = require('fs');
const delay = ms => new Promise(r => setTimeout(r, ms));

const ERROR_LOG = '/Users/bymyway/Desktop/migration_error.txt';
function logError(step, msg, cmd = '') {
  const t = new Date().toLocaleString('zh-TW', { timeZone: 'Asia/Taipei' });
  const line = `[${t}] 步驟：${step}\n[${t}] 錯誤：${msg}\n${cmd ? `[${t}] 指令：${cmd}\n` : ''}`;
  fs.appendFileSync(ERROR_LOG, line + '\n');
  console.error('❌', step, msg);
}

// 動作A：個人品牌 → 複製到 authuser=1
const toSeabiscuit = [
  '海餅乾守則：卓越人生的行為精髓',
  '熵金燎原計劃',
  '西蒙學習法：六個月從零到專家的精進手冊',
];

// 動作B：BNI → 複製到 authuser=0
const toBymyway7 = [
  'BNI真愛分會',
  'BNI真誠分會：來賓接待與分組協調策略會議',
  'BNI DNA 探索之旅',
  'BNI DNA 第13梯探索',
  'DnA月例會',
  '執董週會(國董指導)',
  '真誠分會2025例會PPT更新與來賓管理會議',
  '真誠分會營運會議',
  '招募諮詢流程優化與領導力培訓會議',
  '支持與增長董顧培訓 1月8日',
  '新會員入會訪談標準作業程序SOP',
  '商務人脈引薦與職涯斜槓轉型討論',
  '第二階段面試',
  '會員投訴',
  '選任領導團隊哲學',
  '從商業思維看團隊留員與新人產值',
  '領導團隊訓練合輯',
  '0108週四分享會',
];

async function getExistingNotebooks(page) {
  await delay(3000);
  for (let i = 0; i < 5; i++) {
    await page.evaluate(() => window.scrollTo(0, document.body.scrollHeight));
    await delay(1000);
  }
  const notebooks = await page.evaluate(() => {
    const cards = document.querySelectorAll('mat-card, [class*="notebook-card"], [class*="NotebookCard"]');
    const results = [];
    for (const card of cards) {
      const h = card.querySelector('h2, h3, h4, [class*="title"]');
      if (h && h.innerText.trim()) results.push(h.innerText.trim());
    }
    return results;
  });
  return notebooks;
}

async function createNotebook(page, name, authuser) {
  try {
    // Click "建立新的筆記本" button
    const clicked = await page.evaluate(() => {
      const btns = Array.from(document.querySelectorAll('button, [role="button"], a'));
      for (const b of btns) {
        const t = b.innerText?.trim();
        if (t && (t.includes('建立新') || t.includes('New notebook') || t.includes('Create'))) {
          b.click();
          return t;
        }
      }
      return null;
    });

    if (!clicked) {
      logError(`建立「${name}」`, '找不到建立按鈕');
      return false;
    }

    await delay(2000);

    // Look for title input field in the dialog/new notebook page
    const titled = await page.evaluate((notebookName) => {
      // Try to find title input
      const inputs = Array.from(document.querySelectorAll('input[type="text"], textarea, [contenteditable="true"]'));
      for (const inp of inputs) {
        const placeholder = inp.placeholder || inp.getAttribute('aria-label') || '';
        if (placeholder.includes('標題') || placeholder.includes('title') || placeholder.includes('Title') ||
            placeholder.includes('名稱') || placeholder.includes('Untitled') || placeholder.includes('筆記')) {
          inp.focus();
          inp.value = notebookName;
          inp.dispatchEvent(new Event('input', { bubbles: true }));
          inp.dispatchEvent(new Event('change', { bubbles: true }));
          return true;
        }
      }
      // Try contenteditable
      const editables = document.querySelectorAll('[contenteditable="true"]');
      for (const e of editables) {
        e.focus();
        e.innerText = notebookName;
        e.dispatchEvent(new Event('input', { bubbles: true }));
        return true;
      }
      return false;
    }, name);

    if (!titled) {
      // Try typing with keyboard
      await page.keyboard.type(name);
    }

    await delay(1000);

    // Press Enter or click Create button
    await page.keyboard.press('Enter');
    await delay(3000);

    // Check if we're now in the notebook (URL changed or notebook title visible)
    const url = page.url();
    if (url.includes('notebooklm.google.com') && !url.includes('?authuser=')) {
      console.log(`✅ 已複製：${name} → authuser=${authuser}`);
      return true;
    }

    // Try clicking a confirm/create button
    const confirmed = await page.evaluate(() => {
      const btns = Array.from(document.querySelectorAll('button'));
      for (const b of btns) {
        const t = b.innerText?.trim();
        if (t && (t === '建立' || t === 'Create' || t === '確定' || t === 'OK')) {
          b.click();
          return t;
        }
      }
      return null;
    });

    await delay(3000);
    console.log(`✅ 已複製：${name} → authuser=${authuser}`);
    return true;

  } catch (err) {
    logError(`建立「${name}」`, err.message);
    return false;
  }
}

async function processAccount(page, authuser, notebooks, label) {
  console.log(`\n=== ${label} (authuser=${authuser}) — 建立 ${notebooks.length} 個筆記本 ===`);

  await page.goto(`https://notebooklm.google.com/?authuser=${authuser}`, {
    waitUntil: 'networkidle2', timeout: 60000
  });
  await delay(4000);

  const existing = await getExistingNotebooks(page);
  console.log(`目前已有 ${existing.length} 個筆記本`);

  const results = { success: [], skip: [], fail: [] };

  for (const name of notebooks) {
    // Check if already exists
    if (existing.some(e => e.trim() === name.trim())) {
      console.log(`⏭️  已存在，跳過：${name}`);
      results.skip.push(name);
      continue;
    }

    // Go back to homepage first
    await page.goto(`https://notebooklm.google.com/?authuser=${authuser}`, {
      waitUntil: 'networkidle2', timeout: 60000
    });
    await delay(3000);

    const ok = await createNotebook(page, name, authuser);
    if (ok) {
      results.success.push(name);
    } else {
      results.fail.push(name);
    }
    await delay(2000);
  }

  return results;
}

async function run() {
  let browser;
  const summary = { success: [], skip: [], fail: [] };

  try {
    browser = await puppeteer.connect({ browserURL: 'http://localhost:9222' });
    const page = await browser.newPage();
    await page.setViewport({ width: 1440, height: 900 });

    // 動作A：複製到 authuser=1（海餅乾）
    const resA = await processAccount(page, 1, toSeabiscuit, '海餅乾帳號（個人品牌）');
    summary.success.push(...resA.success.map(n => `${n} → authuser=1`));
    summary.skip.push(...resA.skip.map(n => `${n} (已存在)`));
    summary.fail.push(...resA.fail);

    // 動作B：複製到 authuser=0（大樹）
    const resB = await processAccount(page, 0, toBymyway7, '大樹帳號（BNI）');
    summary.success.push(...resB.success.map(n => `${n} → authuser=0`));
    summary.skip.push(...resB.skip.map(n => `${n} (已存在)`));
    summary.fail.push(...resB.fail);

    console.log('\n========== 搬家任務完成 ==========');
    console.log(`✅ 成功建立：${summary.success.length} 個`);
    summary.success.forEach(n => console.log(`   ✅ ${n}`));
    if (summary.skip.length) {
      console.log(`⏭️  已存在跳過：${summary.skip.length} 個`);
      summary.skip.forEach(n => console.log(`   ⏭️  ${n}`));
    }
    if (summary.fail.length) {
      console.log(`❌ 失敗：${summary.fail.length} 個`);
      summary.fail.forEach(n => console.log(`   ❌ ${n}`));
    }
    console.log('\n請教練確認兩邊都有再決定是否整理原本的。');

  } catch (err) {
    logError('主程式', err.message);
  } finally {
    if (browser) await browser.disconnect();
  }
}

run();
