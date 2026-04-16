const puppeteer = require('puppeteer');

(async () => {
  console.log("開啟瀏覽器讓教練手動登入 FB...");
  const browser = await puppeteer.launch({
    headless: false, // 顯示畫面
    userDataDir: "/Users/bymyway/.openclaw/workspace/scripts/fb_session_data", // 指定同一個資料夾
    defaultViewport: null,
    args: ['--start-maximized']
  });
  
  const page = await browser.newPage();
  await page.goto('https://www.facebook.com/events/birthdays/');
  
  console.log("請在彈出的瀏覽器中登入 FB。登入完成並看到生日名單後，您可以直接關閉該瀏覽器。");
  
  // 讓瀏覽器保持開啟，直到使用者自己關閉
  browser.on('disconnected', () => {
    console.log("瀏覽器已關閉，登入狀態已儲存！");
    process.exit(0);
  });
})();
