const fs = require('node:fs');
const acorn = require('acorn');

['audit-log.html', 'dashboard.html', 'calendar.html'].forEach(file => {
    try {
        const content = fs.readFileSync('src/ItsTool.Web/wwwroot/' + file, 'utf8');
        const scriptMatches = content.matchAll(/<script[^>]*>([\s\S]*?)<\/script>/g);
        let found = false;
        for (const match of scriptMatches) {
            if (match[1].trim()) {
                found = true;
                acorn.parse(match[1], { ecmaVersion: 2022, sourceType: 'module' });
                console.log(file, 'OK');
            }
        }
        if (!found) console.log(file, 'NO INLINE SCRIPT');
    } catch (e) {
        console.error(file, 'ERROR at line', e.loc ? e.loc.line : '?', e.message);
    }
});
