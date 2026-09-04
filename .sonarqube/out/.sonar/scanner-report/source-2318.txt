const fs = require('node:fs');
const content = fs.readFileSync('src/ItsTool.Web/wwwroot/js/ui.js', 'utf8');
const lines = content.split('\n');
const line = lines[571]; // 0-indexed for line 572
for(let i=210; i<250; i++) {
   if (i < line.length) {
       console.log(i, line[i], line.codePointAt(i));
   }
}
