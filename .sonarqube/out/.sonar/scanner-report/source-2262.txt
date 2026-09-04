const puppeteer = require('puppeteer');
const express = require('express');

(async () => {
  const app = express();
  app.disable('x-powered-by');
  app.use(express.static('src/ItsTool.Web/wwwroot'));
  
  // mock api
  app.get('/api/Roles', (req, res) => res.json([{id:1, name:'Admin', description:'Admin role', permissions:['CreateUser', 'DeleteUser']}]));
  app.get('/api/Permissions', (req, res) => res.json([{key:'CreateUser', name:'Create User', description:'Can create users'}, {key:'DeleteUser', name:'Delete User', description:'Can delete users'}]));
  app.get('/api/Roles/:id/Permissions', (req, res) => res.json({permissions:['CreateUser', 'DeleteUser'], overrides:['DeleteUser']}));
  
  const server = app.listen(0, async () => {
    const port = server.address().port;
    const browser = await puppeteer.launch({ args: ['--no-sandbox', '--disable-setuid-sandbox'] });
    const page = await browser.newPage();
    
    // Mock the token
    await page.evaluateOnNewDocument(() => {
      window.api = { token: 'mock-token', request: async () => [] };
      localStorage.setItem('token', 'mock');
    });
    
    page.on('console', msg => console.log('PAGE LOG:', msg.text()));
    page.on('pageerror', error => console.log('PAGE ERROR:', error.message));
    
    await page.goto(`http://localhost:${port}/admin-configs.html`);
    await new Promise(r => setTimeout(r, 1000));
    
    // Click edit on the first role
    // Wait! Admin configs doesn't use standard crud page, it has custom tabs!
    // Let's just evaluate if there are any syntax errors.
    const errs = await page.evaluate(() => {
       return window.errors || [];
    });
    console.log("ERRORS:", errs);
    
    await browser.close();
    server.close();
  });
})();
