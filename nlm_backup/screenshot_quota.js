const puppeteer = require('puppeteer-core');
const delay = ms => new Promise(r => setTimeout(r, ms));

async function run() {
  let browser;
  try {
    browser = await puppeteer.connect({ browserURL: 'http://localhost:9222' });
    const pages = await browser.pages();

    // Find the quota-related page
    let targetPage = null;
    for (const p of pages) {
      const url = p.url();
      if (url.includes('console.cloud.google') || url.includes('aistudio')) {
        targetPage = p;
        console.log('找到頁面:', url);
      }
    }

    if (!targetPage) {
      targetPage = pages[pages.length - 1];
      console.log('使用最後一個頁面:', targetPage.url());
    }

    await targetPage.screenshot({
      path: '/Users/bymyway/Desktop/quota_screenshot.png',
      fullPage: false
    });
    console.log('截圖已存至 ~/Desktop/quota_screenshot.png');

    const text = await targetPage.evaluate(() => document.body.innerText.substring(0, 3000));
    console.log('頁面內容：\n', text);

  } catch (err) {
    console.error('❌', err.message);
  } finally {
    if (browser) await browser.disconnect();
  }
}

run();
