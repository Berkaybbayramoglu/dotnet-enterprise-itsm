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
        await new Promise(r => setTimeout(r, 2000));
        await page.goto('http://localhost:5246/admin-crud.html?page=roles', {waitUntil: 'networkidle0'});
    }
    
    // Click on SuperAdmin Edit button
    await page.waitForSelector('tr[data-id="1"] .btn-ghost', {timeout: 5000}).catch(()=>console.log("No edit button for id 1"));
    await page.click('tr[data-id="1"] .btn-ghost');
    
    await new Promise(r => setTimeout(r, 1000));
    
    await browser.close();
})();
