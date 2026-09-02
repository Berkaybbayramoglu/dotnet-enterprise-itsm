const fs = require('node:fs');
const acorn = require('acorn');
const html = fs.readFileSync('/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Web/wwwroot/ticket-detail.html', 'utf8');
const scriptStart = html.indexOf('<script type="module">') + '<script type="module">'.length;
const scriptEnd = html.indexOf('</script>', scriptStart);
const scriptContent = html.substring(scriptStart, scriptEnd);
try {
    acorn.parse(scriptContent, { ecmaVersion: 2022, sourceType: 'module' });
    console.log("Acorn parsing passed!");
} catch (e) {
    console.error("Acorn error at line", e.loc.line, "col", e.loc.column);
    console.error(e.message);
}
