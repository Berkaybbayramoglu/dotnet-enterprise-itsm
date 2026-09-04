const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.launch({ args: ['--no-sandbox', '--disable-setuid-sandbox'] });
  const page = await browser.newPage();
  
  page.on('console', msg => console.log('PAGE LOG:', msg.text()));
  page.on('pageerror', error => {
      console.log('PAGE ERROR:', error.message);
      console.log('STACK:', error.stack);
  });
  
  const express = require('express');
  const app = express();
  app.disable('x-powered-by');
  app.use(express.static('src/ItsTool.Web/wwwroot'));
  const server = app.listen(0, async () => {
    const port = server.address().port;
    await page.goto(`http://localhost:${port}/dashboard.html`);
    await new Promise(r => setTimeout(r, 2000));
    await browser.close();
    server.close();
  });
})();
