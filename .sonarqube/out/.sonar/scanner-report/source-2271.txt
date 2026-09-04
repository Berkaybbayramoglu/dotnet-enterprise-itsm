const puppeteer = require('puppeteer');
(async () => {
    const browser = await puppeteer.launch({ headless: true, args: ['--no-sandbox'] });
    const page = await browser.newPage();
    page.on('console', msg => console.log('CONSOLE:', msg.text()));
    
    // We need to bypass login, so set a fake token
    await page.evaluateOnNewDocument(() => {
        // mock the JWT token so it doesn't redirect
        localStorage.setItem('jwt_token', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6IjEiLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJTdXBlckFkbWluIn0.xxx');
    });

    try {
        await page.goto('http://localhost:5139/ticket-detail.html?id=1', { waitUntil: 'networkidle2' });
        await new Promise(r => setTimeout(r, 2000));
    } catch (e) {
        console.log("Error", e);
    }
    await browser.close();
})();
