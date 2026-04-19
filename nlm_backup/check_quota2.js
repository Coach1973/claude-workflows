const puppeteer = require('puppeteer-core');
const delay = ms => new Promise(r => setTimeout(r, ms));

async function run() {
  let browser;
  try {
    browser = await puppeteer.connect({ browserURL: 'http://localhost:9222' });
    const page = await browser.newPage();
    await page.setViewport({ width: 1440, height: 900 });

    // Check My First Project quota (the key that hit 429)
    console.log('🔍 查 My First Project 配額...');
    await page.goto(
      'https://console.cloud.google.com/apis/api/generativelanguage.googleapis.com/quotas?project=project-3f94478e-129d-4768-911',
      { waitUntil: 'networkidle2', timeout: 30000 }
    );
    await delay(5000);

    // Search for "day" related quotas
    const text = await page.evaluate(() => {
      const rows = Array.from(document.querySelectorAll('tr, [role="row"]'));
      return rows
        .map(r => r.innerText?.trim())
        .filter(t => t && (
          t.toLowerCase().includes('day') ||
          t.includes('每天') ||
          t.includes('gemini-3.1-pro') ||
          t.includes('generate') ||
          t.includes('quota') ||
          t.includes('250') ||
          t.includes('pending') ||
          t.includes('申請')
        ))
        .join('\n---\n');
    });

    console.log('My First Project 相關配額行：');
    console.log(text || '（找不到相關行）');

    // Full page text for reference
    const full = await page.evaluate(() => document.body.innerText.substring(0, 5000));
    console.log('\n--- 完整頁面前 5000 字 ---');
    console.log(full);

  } catch (err) {
    console.error('❌', err.message);
  } finally {
    if (browser) await browser.disconnect();
  }
}

run();
