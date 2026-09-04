const puppeteer = require('puppeteer');
const express = require('express');

(async () => {
  const app = express();
  app.disable('x-powered-by');
  app.use(express.static('src/ItsTool.Web/wwwroot'));
  const server = app.listen(0, async () => {
    const port = server.address().port;
    const browser = await puppeteer.launch({ args: ['--no-sandbox', '--disable-setuid-sandbox'] });
    const page = await browser.newPage();
    
    // We will evaluate the innerHTML of the body to see if the ERROR text is there
    await page.goto(`http://localhost:${port}/users.html`);
    await new Promise(r => setTimeout(r, 1000));
    const html = await page.evaluate(() => document.body.innerHTML);
    console.log("BODY START\n" + html.substring(0, 200) + "\nBODY END");
    
    await browser.close();
    server.close();
  });
})();
