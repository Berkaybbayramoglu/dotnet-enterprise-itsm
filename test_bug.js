const fs = require('fs');
// Let's just check if there's any obvious syntax error in ticket-detail.html script tag
const html = fs.readFileSync('src/ItsTool.Web/wwwroot/ticket-detail.html', 'utf8');
const scriptMatch = html.match(/<script>([\s\S]*?)<\/script>/);
if (scriptMatch) {
    try {
        require('vm').Script(scriptMatch[1]);
        console.log("No syntax errors.");
    } catch (e) {
        console.log("Syntax error in HTML JS:", e.message);
    }
}
