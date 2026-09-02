const fs = require('fs');
const acorn = require('acorn');

['api.js', 'i18n.js', 'crud-page.js', 'admin-configs.js'].forEach(file => {
    try {
        const content = fs.readFileSync('src/ItsTool.Web/wwwroot/js/' + file, 'utf8');
        acorn.parse(content, { ecmaVersion: 2022, sourceType: 'module' });
        console.log(file, 'OK');
    } catch (e) {
        console.error(file, 'ERROR at line', e.loc ? e.loc.line : '?', e.message);
    }
});
