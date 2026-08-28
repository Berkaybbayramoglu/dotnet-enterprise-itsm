const puppeteer = require('puppeteer');
(async () => {
    const browser = await puppeteer.launch({ args: ['--no-sandbox'] });
    const page = await browser.newPage();
    page.on('pageerror', error => console.log('PAGE ERROR STACK:', error.stack));
    await page.goto('http://localhost:5246/ticket-detail.html?id=1', { waitUntil: 'networkidle0' });
    await browser.close();
})();
