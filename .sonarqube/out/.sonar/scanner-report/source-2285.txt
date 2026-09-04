const fs = require('node:fs');
const acorn = require('acorn');
const path = require('node:path');

function walk(dir) {
    let results = [];
    const list = fs.readdirSync(dir);
    list.forEach(function(file) {
        file = dir + '/' + file;
        const stat = fs.statSync(file);
        if (stat?.isDirectory()) {
            results = results.concat(walk(file));
        } else if (file.endsWith('.html')) { 
            results.push(file);
        }
    });
    return results;
}

const files = walk('src/ItsTool.Web/wwwroot');

files.forEach(file => {
    try {
        const content = fs.readFileSync(file, 'utf8');
        const scriptMatches = content.matchAll(/<script[^>]*>([\s\S]*?)<\/script>/g);
        for (const match of scriptMatches) {
            if (match[1].trim()) {
                try {
                    acorn.parse(match[1], { ecmaVersion: 2022, sourceType: 'module' });
                } catch (e) {
                    console.error(file, 'ERROR at line', e.loc ? e.loc.line : '?', e.message);
                }
            }
        }
    } catch (e) {
        console.error('[script] Error parsing file:', file, e);
        process.exitCode = 1;
    }
});
