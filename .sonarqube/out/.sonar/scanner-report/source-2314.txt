const puppeteer = require('puppeteer');
(async () => {
    const browser = await puppeteer.launch({ args: ['--no-sandbox'] });
    const page = await browser.newPage();
    page.on('console', msg => console.log('PAGE LOG:', msg.text()));
    page.on('pageerror', error => console.log('PAGE ERROR:', error.message));
    page.on('requestfailed', request => console.log('REQUEST FAILED:', request.url(), request.failure().errorText));
    
    // Inject token into local storage before page load so API calls succeed
    await page.goto('http://localhost:5246/login.html');
    await page.evaluate(() => {
        localStorage.setItem('token', 'dummy-token'); // Normally you'd login properly, but let's see if the page even loads!
    });
    
    await page.goto('http://localhost:5246/ticket-detail.html?id=1', { waitUntil: 'networkidle0' });
    await browser.close();
})();
