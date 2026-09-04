const puppeteer = require('puppeteer');

(async () => {
    const browser = await puppeteer.launch({ headless: true, args: ['--no-sandbox'] });
    const page = await browser.newPage();
    
    page.on('console', msg => {
        console.log('CONSOLE:', msg.text());
    });
    
    await page.evaluateOnNewDocument(() => {
        window.mentionsInited = false;
    });

    try {
        await page.goto('http://localhost:5139/ticket-detail.html?id=1', { waitUntil: 'networkidle2' });
        
        await page.waitForSelector('#newComment');
        
        const initialized = await page.evaluate(() => {
            const ta = document.getElementById('newComment');
            return ta ? ta.dataset.mentionsInitialized : null;
        });
        
        console.log("Mentions initialized attr:", initialized);
        
        await page.type('#newComment', '@');
        await new Promise(r => setTimeout(r, 1000));
        
        const dropdownHtml = await page.evaluate(() => {
            const ta = document.getElementById('newComment');
            const dropdown = ta.parentNode.querySelector('.dropdown-menu');
            return dropdown ? dropdown.outerHTML : null;
        });
        
        console.log("Dropdown HTML:", dropdownHtml);
        
    } catch (e) {
        console.log("Error", e);
    }
    await browser.close();
})();
