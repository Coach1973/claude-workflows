const puppeteer = require('puppeteer-core');
const delay = ms => new Promise(r => setTimeout(r, ms));

async function run() {
  let browser;
  try {
    browser = await puppeteer.connect({ browserURL: 'http://localhost:9222' });
    const page = await browser.newPage();
    await page.setViewport({ width: 1440, height: 900 });

    // Check both projects
    const projects = [
      { name: 'My First Project', id: 'project-3f94478e-129d-4768-911' },
      { name: 'Default Gemini Project', id: 'gen-lang-client-0583438899' },
    ];

    for (const proj of projects) {
      console.log(`\n=== ${proj.name} ===`);
      await page.goto(
        `https://console.cloud.google.com/apis/api/generativelanguage.googleapis.com/quotas?project=${proj.id}`,
        { waitUntil: 'networkidle2', timeout: 30000 }
      );
      await delay(4000);

      // Try to use the filter input to search for gemini-3.1-pro
      const filterInput = await page.$('input[placeholder*="篩選"], input[placeholder*="Filter"], input[aria-label*="Filter"], input[aria-label*="篩選"]');
      if (filterInput) {
        await filterInput.click();
        await filterInput.type('gemini-3.1-pro');
        await delay(3000);
        console.log('已輸入篩選條件');
      } else {
        console.log('找不到篩選輸入框，擷取全頁...');
      }

      // Get all text containing gemini-3.1-pro or day
      const rows = await page.evaluate(() => {
        const allText = document.body.innerText;
        const lines = allText.split('\n').map(l => l.trim()).filter(Boolean);
        return lines.filter(l =>
          l.includes('gemini-3.1-pro') ||
          (l.includes('day') && !l.includes('batch')) ||
          l.includes('250') ||
          l.includes('pending') ||
          l.includes('審核') ||
          l.includes('申請中') ||
          l.includes('GenerateRequests')
        );
      });

      console.log('相關配額行：');
      rows.forEach(r => console.log(' ', r));
    }

  } catch (err) {
    console.error('❌', err.message);
  } finally {
    if (browser) await browser.disconnect();
  }
}

run();
