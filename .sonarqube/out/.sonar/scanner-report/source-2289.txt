const fs = require('node:fs');
const content = fs.readFileSync('src/ItsTool.Web/wwwroot/js/ui.js', 'utf8');
const lines = content.split('\n');
const line = lines[571]; // 0-indexed for line 572
console.log(line);
console.log(line.substring(210, 240));
