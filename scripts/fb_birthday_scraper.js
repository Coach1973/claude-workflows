const puppeteer = require('puppeteer');
const fs = require('fs');

(async () => {
  const browser = await puppeteer.launch({
    headless: "new",
    userDataDir: "/Users/bymyway/.openclaw/workspace/scripts/fb_session_data"
  });
  
  const page = await browser.newPage();
  await page.setUserAgent('Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36');

  try {
    // 前往新的 FB 壽星專屬頁面
    await page.goto('https://www.facebook.com/friends/birthdays/', { waitUntil: 'networkidle2' });
    await new Promise(r => setTimeout(r, 4000)); 

    const birthdays = await page.evaluate(() => {
      // 找出所有 h2 標題 (通常代表分類或人名)
      const h2s = Array.from(document.querySelectorAll('h2')).map(h => h.innerText.trim());
      
      let todayList = [];
      let isTodaySection = false;

      for (let text of h2s) {
        if (text === '今日壽星') {
          isTodaySection = true;
          continue;
        }
        // 如果遇到下一個分類，就停止收集
        if (text === '剛過生日的壽星' || text === '即將過生日的壽星' || text === '近期過生日的壽星' || text === '朋友') {
          break;
        }
        
        // 收集壽星名字
        if (isTodaySection && text.length > 0) {
          todayList.push(text);
        }
      }
      return todayList;
    });

    if (birthdays.length === 0) {
      console.log("✅ 今天沒有壽星。");
    } else {
      console.log(`\n🎉 今天共有 ${birthdays.length} 位壽星！請複製以下名單：\n`);
      birthdays.forEach((b, i) => console.log(`${i+1}. ${b}`));
    }

  } catch (error) {
    console.error("❌ 腳本執行發生錯誤：", error);
  } finally {
    await browser.close();
  }
})();
