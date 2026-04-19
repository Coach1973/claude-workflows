const puppeteer = require('puppeteer-core');
const delay = ms => new Promise(r => setTimeout(r, ms));

async function run() {
  let browser;
  try {
    browser = await puppeteer.connect({ browserURL: 'http://localhost:9222' });
    const page = await browser.newPage();
    await page.setViewport({ width: 1440, height: 900 });

    // AI Studio Spend page
    console.log('=== AI Studio Spend ===');
    await page.goto('https://aistudio.google.com/apikey', { waitUntil: 'networkidle2', timeout: 30000 });
    await delay(3000);

    // Click Spend in sidebar
    await page.evaluate(() => {
      const els = Array.from(document.querySelectorAll('a, span, div'));
      for (const el of els) {
        if (el.innerText?.trim() === 'Spend') { el.click(); return; }
      }
    });
    await delay(4000);
    console.log('URL:', page.url());

    for (let i = 0; i < 3; i++) {
      await page.evaluate(() => window.scrollTo(0, document.body.scrollHeight));
      await delay(1000);
    }

    await page.screenshot({ path: '/Users/bymyway/Desktop/spend_screenshot.png' });
    const text = await page.evaluate(() => document.body.innerText);
    const lines = text.split('\n').map(l => l.trim()).filter(Boolean);
    const relevant = lines.filter(l =>
      l.includes('$') || l.includes('token') || l.includes('Token') ||
      l.includes('gemini') || l.includes('Gemini') || l.includes('3.1') ||
      l.includes('Input') || l.includes('Output') || l.includes('cost') ||
      l.includes('spend') || l.includes('Spend') || l.includes('fee') ||
      l.includes('Project') || l.includes('per') || l.includes('price')
    );
    relevant.forEach(l => console.log(l));

    // Also check Gemini API pricing page
    console.log('\n=== Gemini API Pricing ===');
    await page.goto('https://ai.google.dev/gemini-api/docs/pricing', { waitUntil: 'networkidle2', timeout: 30000 });
    await delay(4000);
    const text2 = await page.evaluate(() => document.body.innerText);
    const lines2 = text2.split('\n').map(l => l.trim()).filter(Boolean);
    const pricing = lines2.filter(l =>
      l.includes('3.1') || l.includes('$') || l.includes('token') ||
      l.includes('Input') || l.includes('Output') || l.includes('per') ||
      l.includes('price') || l.includes('Price') || l.includes('free') || l.includes('paid')
    );
    pricing.forEach(l => console.log(l));

  } catch (err) {
    console.error('❌', err.message);
  } finally {
    if (browser) await browser.disconnect();
  }
}

run();
