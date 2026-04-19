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
      console.log(`\n=== ${proj.name} ===`);
      await page.goto(
        `https://console.cloud.google.com/apis/api/generativelanguage.googleapis.com/quotas?project=${proj.id}`,
        { waitUntil: 'networkidle2', timeout: 30000 }
      );
      await delay(5000);

      // Try to find and use the filter input
      const filterInputFound = await page.evaluate(() => {
        // Try different ways to find the filter
        const inputs = Array.from(document.querySelectorAll('input'));
        for (const inp of inputs) {
          if (inp.placeholder && (inp.placeholder.includes('篩選') || inp.placeholder.includes('Filter') || inp.placeholder.includes('屬性'))) {
            inp.click();
            inp.focus();
            return inp.placeholder;
          }
        }
        // Also try by aria-label
        const labeled = document.querySelector('[aria-label*="篩選"], [aria-label*="Filter"]');
        if (labeled) { labeled.click(); labeled.focus(); return labeled.getAttribute('aria-label'); }
        return null;
      });

      console.log('篩選框:', filterInputFound);

      if (filterInputFound) {
        await page.keyboard.type('GenerateRequests');
        await delay(3000);
        const text = await page.evaluate(() => document.body.innerText.substring(0, 3000));
        console.log('篩選結果：\n', text);
        await page.screenshot({ path: `/Users/bymyway/Desktop/quota_filter_${proj.id.substring(0,8)}.png` });
      } else {
        // Try clicking the filter area visible on screen
        const clicked = await page.evaluate(() => {
          const spans = Array.from(document.querySelectorAll('span, div, label'));
          for (const s of spans) {
            if (s.innerText?.includes('篩選條件')) {
              const inp = s.parentElement?.querySelector('input') || s.nextElementSibling;
              if (inp && inp.tagName === 'INPUT') { inp.click(); inp.focus(); return true; }
            }
          }
          return false;
        });
        console.log('備用點擊:', clicked);
        if (clicked) {
          await page.keyboard.type('GenerateRequests');
          await delay(3000);
          const text = await page.evaluate(() => document.body.innerText.substring(0, 3000));
          console.log('篩選結果：\n', text);
        }
      }
    }

  } catch (err) {
    console.error('❌', err.message);
  } finally {
    if (browser) await browser.disconnect();
  }
}

run();
