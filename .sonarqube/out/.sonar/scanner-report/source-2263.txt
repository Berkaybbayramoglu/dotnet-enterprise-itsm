const puppeteer = require('puppeteer');
(async () => {
    const browser = await puppeteer.launch({ args: ['--no-sandbox'] });
    const page = await browser.newPage();
    page.on('console', msg => console.log('PAGE LOG:', msg.text()));
    page.on('pageerror', error => console.log('PAGE ERROR STACK:', error.stack));
    
    await page.goto('http://localhost:5246/login.html');
    await page.evaluate(() => { localStorage.setItem('token', 'dummy-token'); });
    await page.goto('http://localhost:5246/ticket-detail.html?id=1', { waitUntil: 'networkidle0' });
    
    // Check if the content is visible
    const isVisible = await page.evaluate(() => {
        return document.getElementById('content').style.display;
    });
    console.log("Content display style:", isVisible);
    
    await browser.close();
})();
