const puppeteer = require('puppeteer');
(async () => {
    const browser = await puppeteer.launch({ args: ['--no-sandbox'] });
    const page = await browser.newPage();
    
    // Instead of navigating, let's load the file via file:// protocol
    page.on('pageerror', error => console.log('PAGE ERROR STACK:', error.stack));
    await page.goto('file:///home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Web/wwwroot/ticket-detail.html', { waitUntil: 'networkidle0' });
    
    await browser.close();
})();
