const fs = require('node:fs');
const acorn = require('acorn');
const html = fs.readFileSync('/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Web/wwwroot/ticket-detail.html', 'utf8');
const scriptStart = html.indexOf('<script type="module">') + '<script type="module">'.length;
const scriptEnd = html.indexOf('</script>', scriptStart);
const scriptContent = html.substring(scriptStart, scriptEnd);
const lines = scriptContent.split('\n');
for (let i = 870; i <= 940; i++) {
    console.log((i+1) + ': ' + lines[i]);
}
