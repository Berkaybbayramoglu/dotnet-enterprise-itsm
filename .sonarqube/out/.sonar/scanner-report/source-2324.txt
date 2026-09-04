const fs = require('node:fs');
const content = fs.readFileSync('src/ItsTool.Web/wwwroot/js/ui.js', 'utf8');
const lines = content.split('\n');
const line = lines[571]; // 0-indexed for line 572
console.log(line.includes(String.raw`\u`));
console.log(line.substring(220, 240));
