const puppeteer = require('puppeteer-core');
const delay = ms => new Promise(r => setTimeout(r, ms));

async function run() {
  let browser;
  try {
    browser = await puppeteer.connect({ browserURL: 'http://localhost:9222' });
    const page = await browser.newPage();
    await page.setViewport({ width: 1440, height: 900 });

    // Navigate to Google AI Studio quota page
    console.log('🔍 前往 Google AI Studio API 配額頁面...');
    await page.goto(
      'https://aistudio.google.com/apikey',
      { waitUntil: 'networkidle2', timeout: 30000 }
    );
    await delay(3000);

    const url1 = page.url();
    console.log('目前 URL:', url1);

    const text1 = await page.evaluate(() => document.body.innerText.substring(0, 2000));
    console.log('--- AI Studio 頁面內容 ---');
    console.log(text1);

    // Try Google Cloud Console quota page for Gemini API
    console.log('\n🔍 前往 Google Cloud Console 配額頁面...');
    await page.goto(
      'https://console.cloud.google.com/apis/api/generativelanguage.googleapis.com/quotas',
      { waitUntil: 'networkidle2', timeout: 30000 }
    );
    await delay(5000);

    const url2 = page.url();
    console.log('目前 URL:', url2);

    const text2 = await page.evaluate(() => document.body.innerText.substring(0, 3000));
    console.log('--- Cloud Console 配額頁面內容 ---');
    console.log(text2);

  } catch (err) {
    console.error('❌', err.message);
  } finally {
    if (browser) await browser.disconnect();
  }
}

run();
