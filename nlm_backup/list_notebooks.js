const puppeteer = require('puppeteer-core');
const fs = require('fs');

async function listNotebooks(page, authuser) {
  const url = `https://notebooklm.google.com/?authuser=${authuser}`;
  console.log(`\n📂 載入 authuser=${authuser}: ${url}`);

  await page.goto(url, { waitUntil: 'networkidle2', timeout: 60000 });
  await delay(4000);

  // Scroll to load all notebooks
  for (let i = 0; i < 5; i++) {
    await page.evaluate(() => window.scrollTo(0, document.body.scrollHeight));
    await delay(1500);
  }

  const notebooks = await page.evaluate(() => {
    const results = [];
    // Try various selectors for notebook titles
    const selectors = [
      'h2.notebook-title',
      '[class*="notebook"][class*="title"]',
      'mat-card-title',
      '[class*="NoteBookCard"] h2',
      '[class*="NoteBookCard"] h3',
      '[data-notebook-id]',
    ];

    // Generic approach: find all clickable cards with headings
    const cards = document.querySelectorAll(
      'mat-card, [class*="notebook-card"], [class*="NotebookCard"], [class*="notebook_card"]'
    );

    for (const card of cards) {
      const heading = card.querySelector('h2, h3, h4, [class*="title"]');
      if (heading && heading.innerText.trim()) {
        results.push(heading.innerText.trim());
      }
    }

    if (results.length > 0) return { method: 'cards', list: results };

    // Fallback: all h2/h3 elements
    const headings = document.querySelectorAll('h2, h3');
    const texts = Array.from(headings)
      .map(h => h.innerText.trim())
      .filter(t => t.length > 0 && t.length < 100);
    return { method: 'headings', list: texts };
  });

  console.log(`  -> 方法: ${notebooks.method}, 找到 ${notebooks.list.length} 筆`);
  return notebooks.list;
}

const delay = ms => new Promise(r => setTimeout(r, ms));

async function run() {
  let browser;
  try {
    browser = await puppeteer.connect({ browserURL: 'http://localhost:9222' });
    const page = await browser.newPage();
    await page.setViewport({ width: 1440, height: 900 });

    const list0 = await listNotebooks(page, 0);
    await delay(2000);
    const list1 = await listNotebooks(page, 1);

    const result = { authuser0: list0, authuser1: list1, ts: new Date().toISOString() };
    fs.writeFileSync('/Users/bymyway/Desktop/nlm_notebook_lists.json', JSON.stringify(result, null, 2));

    console.log('\n=== authuser=0 (大樹/BNI) ===');
    list0.forEach((n, i) => console.log(`  ${i+1}. ${n}`));
    console.log('\n=== authuser=1 (海餅乾/個人品牌) ===');
    list1.forEach((n, i) => console.log(`  ${i+1}. ${n}`));
    console.log(`\n✅ 已儲存至 /Users/bymyway/Desktop/nlm_notebook_lists.json`);

  } catch (err) {
    console.error('❌', err.message);
    process.exit(1);
  } finally {
    if (browser) await browser.disconnect();
  }
}

run();
