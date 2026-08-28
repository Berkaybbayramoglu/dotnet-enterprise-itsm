const puppeteer = require('puppeteer');

(async () => {
    const browser = await puppeteer.launch({ headless: true, args: ['--no-sandbox'] });
    const page = await browser.newPage();
    
    page.on('console', msg => {
        console.log('CONSOLE:', msg.type(), msg.text());
    });
    
    page.on('response', response => {
        if (!response.ok()) {
            console.log('FAILED REQUEST:', response.url(), response.status());
        }
    });

    try {
        await page.goto('http://localhost:5139/ticket-detail.html?id=1', { waitUntil: 'networkidle2' });
        
        await page.waitForSelector('#newComment');
        await page.type('#newComment', '@');
        
        await new Promise(r => setTimeout(r, 1000));
    } catch (e) {
        console.log("Error", e);
    }
    await browser.close();
})();
