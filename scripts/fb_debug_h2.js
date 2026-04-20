const puppeteer = require('puppeteer');
const fs = require('fs');

(async () => {
  const browser = await puppeteer.launch({
    headless: false,
    userDataDir: "/Users/bymyway/.openclaw/workspace/scripts/fb_session_data",
    args: ['--window-position=-32000,-32000']
  });
  const page = await browser.newPage();
  
  await page.goto('https://www.facebook.com/friends/birthdays/', { waitUntil: 'networkidle2' });
  await new Promise(r => setTimeout(r, 4000));
  
  const birthdays = await page.evaluate(() => {
    // 找出包含 "今日壽星" 的區塊
    const headers = Array.from(document.querySelectorAll('span, h2, div')).filter(el => el.innerText === '今日壽星');
    if(headers.length === 0) return ["找不到今日壽星標籤"];
    
    // 從那個標籤之後，找所有的連結 (通常是名字)
    // 但為求精準，我們可以直接抓出 h2 標籤或包含文字的粗體
    // 在 FB 中，好友名字通常放在 <h2> 裡面或特定 role="link"
    const container = headers[0].closest('div[role="main"]') || document.body;
    
    // 這裡我們抓這頁所有的 h2 
    const h2s = Array.from(container.querySelectorAll('h2')).map(h => h.innerText.trim()).filter(t => t.length > 0 && t !== '今日壽星');
    
    return h2s;
  });
  
  console.log(birthdays);
  await browser.close();
})();
