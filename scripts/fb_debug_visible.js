const puppeteer = require('puppeteer');
const fs = require('fs');

(async () => {
  const browser = await puppeteer.launch({
    headless: false, // 改用有頭模式，避免 FB 阻擋
    userDataDir: "/Users/bymyway/.openclaw/workspace/scripts/fb_session_data",
    args: ['--window-position=-32000,-32000'] // 藏到螢幕外
  });
  const page = await browser.newPage();
  
  await page.goto('https://www.facebook.com/friends/birthdays/', { waitUntil: 'networkidle2' });
  await new Promise(r => setTimeout(r, 6000));
  
  const data = await page.evaluate(() => {
    return document.body.innerText.substring(0, 3000);
  });
  
  fs.writeFileSync('fb_dump_visible.txt', data);
  await browser.close();
})();
