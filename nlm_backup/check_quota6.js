const puppeteer = require('puppeteer-core');
const delay = ms => new Promise(r => setTimeout(r, ms));

async function run() {
  let browser;
  try {
    browser = await puppeteer.connect({ browserURL: 'http://localhost:9222' });
    const page = await browser.newPage();
    await page.setViewport({ width: 1440, height: 900 });

    const projects = [
      { name: 'My First Project', id: 'project-3f94478e-129d-4768-911' },
      { name: 'Default Gemini Project', id: 'gen-lang-client-0583438899' },
    ];

    for (const proj of projects) {
      console.log(`\n=== ${proj.name} — 配額調整申請狀態 ===`);
      // Cloud Console quota adjustments / pending requests
      await page.goto(
        `https://console.cloud.google.com/apis/api/generativelanguage.googleapis.com/quotas?project=${proj.id}`,
        { waitUntil: 'networkidle2', timeout: 30000 }
      );
      await delay(5000);

      const text = await page.evaluate(() => {
        const allText = document.body.innerText;
        const lines = allText.split('\n').map(l => l.trim()).filter(Boolean);
        return lines.filter(l =>
          l.includes('pending') || l.includes('Pending') ||
          l.includes('申請') || l.includes('審核') ||
          l.includes('調整') || l.includes('gemini-3.1') ||
          l.includes('GenerateRequests') || l.includes('per day') ||
          l.includes('250') || l.includes('500') || l.includes('1,000') ||
          l.includes('Approved') || l.includes('Denied') || l.includes('批准') ||
          l.toLowerCase().includes('request')
        );
      });

      console.log(text.length ? text.join('\n') : '（找不到相關配額申請記錄）');
    }

    // Also check Cloud Console quota adjustment history
    console.log('\n=== 配額調整歷史 ===');
    await page.goto(
      'https://console.cloud.google.com/iam-admin/quotas?project=project-3f94478e-129d-4768-911',
      { waitUntil: 'networkidle2', timeout: 30000 }
    );
    await delay(4000);
    const hist = await page.evaluate(() => document.body.innerText.substring(0, 3000));
    console.log(hist);

  } catch (err) {
    console.error('❌', err.message);
  } finally {
    if (browser) await browser.disconnect();
  }
}

run();
