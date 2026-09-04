const fs = require('node:fs');
const acorn = require('acorn');

const files = process.argv.slice(2);
files.forEach(file => {
    if (!file.endsWith('.js') || file.includes('chart.js') || file.includes('lib/')) return;
    try {
        const content = fs.readFileSync(file, 'utf8');
        acorn.parse(content, { ecmaVersion: 2022, sourceType: 'module' });
    } catch (e) {
        console.error(file, 'ERROR at line', e.loc ? e.loc.line : '?', e.message);
    }
});
