const fs = require('node:fs');
const acorn = require('acorn');

['audit-log.html', 'dashboard.html', 'calendar.html', 'users.html', 'rules.html'].forEach(file => {
    try {
        const content = fs.readFileSync('src/ItsTool.Web/wwwroot/' + file, 'utf8');
        const scriptMatch = content.match(/<script[^>]*>([\s\S]*?)<\/script>/);
        if (scriptMatch?.[1]) {
            acorn.parse(scriptMatch[1], { ecmaVersion: 2022, sourceType: 'module' });
            console.log(file, 'OK');
        } else {
            console.log(file, 'NO SCRIPT');
        }
    } catch (e) {
        console.error(file, 'ERROR at line', e.loc ? e.loc.line : '?', e.message);
    }
});
