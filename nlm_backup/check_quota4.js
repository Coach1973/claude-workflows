const puppeteer = require('puppeteer-core');
const delay = ms => new Promise(r => setTimeout(r, ms));

async function run() {
  let browser;
  try {
    browser = await puppeteer.connect({ browserURL: 'http://localhost:9222' });
    const page = await browser.newPage();
    await page.setViewport({ width: 1440, height: 900 });

    // AI Studio Rate Limits page
    console.log('🔍 AI Studio Rate Limits...');
    await page.goto('https://aistudio.google.com/rate-limits', { waitUntil: 'networkidle2', timeout: 30000 });
    await delay(4000);

    // Scroll down to load more
    for (let i = 0; i < 5; i++) {
      await page.evaluate(() => window.scrollTo(0, document.body.scrollHeight));
      await delay(1000);
    }

    const text = await page.evaluate(() => document.body.innerText);
    // Filter for gemini-3.1 or day related content
    const lines = text.split('\n').map(l => l.trim()).filter(Boolean);
    const relevant = lines.filter(l =>
      l.includes('3.1') || l.includes('day') || l.includes('Day') ||
      l.includes('250') || l.includes('pending') || l.includes('RPD') ||
      l.includes('Requests per day') || l.includes('每天') || l.includes('每日')
    );

    console.log('=== Rate Limits 相關行 ===');
    relevant.forEach(l => console.log(' ', l));

    console.log('\n=== 全頁前 4000 字 ===');
    console.log(text.substring(0, 4000));

  } catch (err) {
    console.error('❌', err.message);
  } finally {
    if (browser) await browser.disconnect();
  }
}

run();
