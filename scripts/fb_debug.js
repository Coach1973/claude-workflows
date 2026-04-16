const puppeteer = require('puppeteer');
const fs = require('fs');

(async () => {
  const browser = await puppeteer.launch({
    headless: "new",
    userDataDir: "/Users/bymyway/.openclaw/workspace/scripts/fb_session_data"
  });
  const page = await browser.newPage();
  await page.setUserAgent('Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36');
  
  await page.goto('https://www.facebook.com/events/birthdays/', { waitUntil: 'networkidle2' });
  await new Promise(r => setTimeout(r, 5000));
  
  // 抓取整個頁面的文字結構，幫助尋找壽星
  const data = await page.evaluate(() => {
    // 找今天生日的區塊
    const allText = document.body.innerText;
    const links = Array.from(document.querySelectorAll('a')).map(a => a.innerText.trim()).filter(t => t.length > 0);
    return { allText: allText.substring(0, 2000), links };
  });
  
  fs.writeFileSync('fb_dump.json', JSON.stringify(data, null, 2));
  await browser.close();
})();
