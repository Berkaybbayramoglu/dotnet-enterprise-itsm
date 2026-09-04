const puppeteer = require('puppeteer');
(async () => {
    const browser = await puppeteer.launch({ headless: 'new' });
    const page = await browser.newPage();
    page.on('response', async res => {
        if (res.url().includes('/api/Roles') && res.request().method() === 'GET') {
            console.log(await res.text());
        }
    });
    await page.goto('http://localhost:5246/admin-crud.html?page=roles');
    
    // Login
    await page.waitForSelector('#loginForm input[type="text"]', {timeout: 5000}).catch(() => {});
    if (await page.$('#loginForm input[type="text"]')) {
        await page.type('#loginForm input[type="text"]', 'admin');
        await page.type('#loginForm input[type="password"]', 'Admin123!');
        await page.click('#loginForm button[type="submit"]');
    }
    
    await new Promise(r => setTimeout(r, 3000));
    await browser.close();
})();
