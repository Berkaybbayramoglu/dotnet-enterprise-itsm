const puppeteer = require('puppeteer');
(async () => {
    const browser = await puppeteer.launch({ headless: 'new' });
    const page = await browser.newPage();
    
    page.on('console', msg => console.log('PAGE LOG:', msg.text()));
    
    await page.goto('http://localhost:5246/admin-crud.html?page=roles');
    
    // Login
    await page.waitForSelector('#loginForm input[type="text"]', {timeout: 5000}).catch(() => {});
    if (await page.$('#loginForm input[type="text"]')) {
        await page.type('#loginForm input[type="text"]', 'admin');
        await page.type('#loginForm input[type="password"]', 'Admin123!');
        await page.click('#loginForm button[type="submit"]');
        await page.waitForNavigation({waitUntil: 'networkidle0'});
        await page.goto('http://localhost:5246/admin-crud.html?page=roles', {waitUntil: 'networkidle0'});
    }
    
    const roles = await page.evaluate(async () => {
        return await window.api.request('/Roles');
    });
    console.log("ROLES FETCHED:", JSON.stringify(roles, null, 2));
    
    await browser.close();
})();
