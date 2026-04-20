const puppeteer = require('puppeteer-core');
const delay = ms => new Promise(r => setTimeout(r, ms));

async function run() {
  let browser;
  try {
    browser = await puppeteer.connect({ browserURL: 'http://localhost:9222' });
    const page = await browser.newPage();
    await page.setViewport({ width: 1440, height: 900 });

    // Go to Gemini API quota page for My First Project, filter by gemini-3.1-pro
    const url = 'https://console.cloud.google.com/apis/api/generativelanguage.googleapis.com/quotas?project=project-3f94478e-129d-4768-911&filter=gemini-3.1-pro';
    console.log('🔍 前往配額頁面...');
    await page.goto(url, { waitUntil: 'networkidle2', timeout: 30000 });
    await delay(6000);

    await page.screenshot({ path: '/Users/bymyway/Desktop/quota_gemini31_before.png' });
    console.log('截圖已存: quota_gemini31_before.png');

    const text = await page.evaluate(() => document.body.innerText.substring(0, 5000));
    console.log('頁面內容：\n', text);

  } catch (err) {
    console.error('❌', err.message);
  } finally {
    if (browser) await browser.disconnect();
  }
}

run();
