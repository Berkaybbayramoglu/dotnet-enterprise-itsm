const puppeteer = require('puppeteer');
(async () => {
    const browser = await puppeteer.launch({ headless: true, args: ['--no-sandbox'] });
    const page = await browser.newPage();
    page.on('pageerror', error => {
        console.log('PAGE ERROR:', error.message);
        console.log('STACK:', error.stack);
    });
    try {
        await page.goto('http://localhost:5139/ticket-detail.html?id=1', { waitUntil: 'networkidle2' });
    } catch (e) {}
    await browser.close();
})();
