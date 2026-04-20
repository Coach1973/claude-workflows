const puppeteer = require('puppeteer-core');
const fs = require('fs');
const path = require('path');

// ─── 設定區 ───────────────────────────────────────────
const CHROME_PATH   = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome';
const USER_DATA_DIR = '/Users/bymyway/Library/Application Support/Google/Chrome';
const OUTPUT_DIR    = '/Users/bymyway/Desktop/NotebookLM_Backup';
const TARGET_NAME   = '海餅乾文化';
// ──────────────────────────────────────────────────────

async function run() {
  let browser;

  try {
    console.log('🔌 連接到已開啟的 Chrome（遠端除錯模式）...');
    browser = await puppeteer.connect({
      browserURL: 'http://localhost:9222',
    });

    const page = await browser.newPage();
    await page.setViewport({ width: 1440, height: 900 });

    console.log('📂 前往 NotebookLM 首頁...');
    await page.goto('https://notebooklm.google.com', {
      waitUntil: 'networkidle2',
      timeout:   40000,
    });
    await delay(3000);

    console.log(`🔍 搜尋筆記本：「${TARGET_NAME}」`);
    const clicked = await page.evaluate((name) => {
      const candidates = Array.from(
        document.querySelectorAll('h2, h3, [class*="title"], [class*="notebook"]')
      );
      for (const el of candidates) {
        if (el.innerText && el.innerText.trim() === name) {
          const clickable = el.closest('a, button, [role="button"], [tabindex]') || el;
          clickable.click();
          return true;
        }
      }
      return false;
    }, TARGET_NAME);

    if (!clicked) {
      await page.screenshot({ path: path.join(OUTPUT_DIR, 'debug_homepage.png'), fullPage: true });
      throw new Error(
        `找不到筆記本「${TARGET_NAME}」。` +
        `已截圖存至 ${OUTPUT_DIR}/debug_homepage.png，請確認筆記本名稱是否完全一致。`
      );
    }

    console.log('✅ 已點擊筆記本，等待載入...');
    await delay(4000);

    console.log('📖 讀取來源區塊內容...');
    const sources = await page.evaluate(() => {
      const SELECTORS = [
        '[data-source-id]',
        '[class*="SourceItem"]',
        '[class*="source-item"]',
        '[class*="sourceItem"]',
        '[aria-label*="Source"]',
        '[aria-label*="來源"]',
        '[data-testid*="source"]',
      ];

      for (const sel of SELECTORS) {
        const items = document.querySelectorAll(sel);
        if (items.length > 0) {
          return {
            selector: sel,
            texts: Array.from(items).map(el => el.innerText.trim()).filter(Boolean),
          };
        }
      }

      const panel = document.querySelector(
        '[class*="SourcePanel"], [class*="sidebar"], aside, [role="complementary"]'
      );
      if (panel) {
        return {
          selector: 'fallback-panel',
          texts: [panel.innerText.trim()],
        };
      }

      return null;
    });

    if (!sources || sources.texts.length === 0) {
      await page.screenshot({ path: path.join(OUTPUT_DIR, 'debug_notebook.png'), fullPage: true });
      throw new Error(
        '找不到來源區塊。NotebookLM DOM 可能已更新。' +
        `已截圖存至 ${OUTPUT_DIR}/debug_notebook.png。`
      );
    }

    console.log(`✅ 使用選擇器「${sources.selector}」，找到 ${sources.texts.length} 筆來源`);

    fs.mkdirSync(OUTPUT_DIR, { recursive: true });

    const ts       = new Date().toISOString().replace(/[:.]/g, '-').slice(0, 19);
    const filename = `${TARGET_NAME}_sources_${ts}.txt`;
    const filepath = path.join(OUTPUT_DIR, filename);
    const content  = sources.texts.join('\n\n' + '='.repeat(60) + '\n\n');

    fs.writeFileSync(filepath, content, 'utf8');

    console.log('\n🎉 備份完成！');
    console.log(`   檔案：${filepath}`);
    console.log(`   來源數量：${sources.texts.length} 筆`);

  } catch (err) {
    fs.mkdirSync(OUTPUT_DIR, { recursive: true });
    console.error('\n❌ 執行失敗');
    console.error(`   原因：${err.message}`);
    process.exit(1);

  } finally {
    if (browser) await browser.close();
  }
}

const delay = ms => new Promise(r => setTimeout(r, ms));

run();
