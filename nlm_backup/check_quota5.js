const puppeteer = require('puppeteer-core');
const delay = ms => new Promise(r => setTimeout(r, ms));

async function run() {
  let browser;
  try {
    browser = await puppeteer.connect({ browserURL: 'http://localhost:9222' });
    const page = await browser.newPage();
    await page.setViewport({ width: 1440, height: 900 });

    await page.goto('https://aistudio.google.com/apikey', { waitUntil: 'networkidle2', timeout: 30000 });
    await delay(3000);

    // Click "Rate Limit" in left sidebar
    const clicked = await page.evaluate(() => {
      const links = Array.from(document.querySelectorAll('a, [role="menuitem"], [role="listitem"], button, span'));
      for (const el of links) {
        const t = el.innerText?.trim();
        if (t === 'Rate Limit' || t === 'Rate Limits') {
          el.click();
          return t;
        }
      }
      return null;
    });

    console.log('點擊結果:', clicked);
    await delay(4000);
    console.log('URL:', page.url());

    for (let i = 0; i < 5; i++) {
      await page.evaluate(() => window.scrollTo(0, document.body.scrollHeight));
      await delay(1000);
    }

    const text = await page.evaluate(() => document.body.innerText);
    console.log('=== Rate Limit 頁面內容 ===');
    console.log(text.substring(0, 5000));

  } catch (err) {
    console.error('❌', err.message);
  } finally {
    if (browser) await browser.disconnect();
  }
}

run();
