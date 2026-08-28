const puppeteer = require('puppeteer');
(async () => {
    const browser = await puppeteer.launch({ headless: 'new', args: ['--no-sandbox'] });
    const page = await browser.newPage();
    
    page.on('console', msg => console.log('PAGE LOG:', msg.text()));
    
    // Create an HTML file that uses window.api mock logic or we can just fetch via API 
    // Wait, let's login first
    await page.goto('http://localhost:5246/index.html');
    await page.type('#loginEmail', 'admin');
    await page.type('#loginPassword', 'admin');
    await page.click('button[type="submit"]');
    await page.waitForNavigation();
    
    await page.goto('http://localhost:5246/admin-crud.html?page=roles');
    
    await page.waitForTimeout(2000);
    
    const roles = await page.evaluate(() => window.currentData);
    console.log("ROLES DATA:");
    console.log(JSON.stringify(roles, null, 2));
    
    await browser.close();
})();
