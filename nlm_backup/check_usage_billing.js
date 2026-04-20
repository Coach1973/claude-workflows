const puppeteer = require('puppeteer-core');
const delay = ms => new Promise(r => setTimeout(r, ms));

async function run() {
  let browser;
  try {
    browser = await puppeteer.connect({ browserURL: 'http://localhost:9222' });
    const page = await browser.newPage();
    await page.setViewport({ width: 1440, height: 900 });

    // 1. AI Studio Rate Limit — Default Gemini Project
    console.log('=== 1. 目前用量（AI Studio Rate Limit）===');
    await page.goto('https://aistudio.google.com/rate-limit?timeRange=last-28-days', { waitUntil: 'networkidle2', timeout: 30000 });
    await delay(4000);
    // Switch to Default Gemini Project if needed
    const text1 = await page.evaluate(() => document.body.innerText);
    const lines1 = text1.split('\n').map(l => l.trim()).filter(Boolean);
    const relevant1 = lines1.filter(l =>
      l.includes('3.1') || l.includes('RPM') || l.includes('TPM') || l.includes('RPD') ||
      l.includes('/') || l.includes('Project') || l.includes('Tier')
    );
    relevant1.forEach(l => console.log(l));

    // 2. Google Cloud Billing — today's spend for Default Gemini Project
    console.log('\n=== 2. 今日費用（Cloud Billing）===');
    await page.goto(
      'https://console.cloud.google.com/billing/reports?project=gen-lang-client-0583438899',
      { waitUntil: 'networkidle2', timeout: 30000 }
    );
    await delay(5000);
    const text2 = await page.evaluate(() => document.body.innerText.substring(0, 4000));
    console.log(text2);

    // Screenshot billing page
    await page.screenshot({ path: '/Users/bymyway/Desktop/billing_screenshot.png' });
    console.log('\n截圖存至 ~/Desktop/billing_screenshot.png');

  } catch (err) {
    console.error('❌', err.message);
  } finally {
    if (browser) await browser.disconnect();
  }
}

run();
