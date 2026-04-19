const puppeteer = require('puppeteer-core');
const delay = ms => new Promise(r => setTimeout(r, ms));

async function run() {
  let browser;
  try {
    browser = await puppeteer.connect({ browserURL: 'http://localhost:9222' });
    const page = await browser.newPage();
    await page.setViewport({ width: 1440, height: 900 });

    // Check billing report filtered by Default Gemini Project only
    console.log('=== 費用明細（Default Gemini Project 專屬）===');
    await page.goto(
      'https://console.cloud.google.com/billing/reports?project=gen-lang-client-0583438899&groupby=SKU',
      { waitUntil: 'networkidle2', timeout: 30000 }
    );
    await delay(6000);
    await page.screenshot({ path: '/Users/bymyway/Desktop/billing_detail.png' });

    const text = await page.evaluate(() => document.body.innerText);
    const lines = text.split('\n').map(l => l.trim()).filter(Boolean);
    const relevant = lines.filter(l =>
      l.includes('$') || l.includes('USD') || l.includes('費用') ||
      l.includes('gemini') || l.includes('Gemini') || l.includes('token') ||
      l.includes('SKU') || l.includes('輸入') || l.includes('輸出') ||
      l.includes('Input') || l.includes('Output') || l.includes('小計') ||
      l.includes('總計') || l.includes('優惠') || l.includes('抵免')
    );
    relevant.forEach(l => console.log(l));

    // Also check the SKU-level spend page
    console.log('\n=== 費用表（SKU 層級）===');
    await page.goto(
      'https://console.cloud.google.com/billing/01E96D-4B3E54-24F8E0/reports;timeRange=CURRENT_MONTH;groupby=SKU',
      { waitUntil: 'networkidle2', timeout: 30000 }
    );
    await delay(5000);
    const text2 = await page.evaluate(() => document.body.innerText.substring(0, 4000));
    console.log(text2);

  } catch (err) {
    console.error('❌', err.message);
  } finally {
    if (browser) await browser.disconnect();
  }
}

run();
