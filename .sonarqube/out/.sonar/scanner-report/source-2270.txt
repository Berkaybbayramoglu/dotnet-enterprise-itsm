import re

# 1) test_admin.js
with open('test_admin.js', 'r') as f:
    text = f.read()
text = text.replace("const app = express();\n  app.use(express.static('src/ItsTool.Web/wwwroot'));", 
                    "const app = express();\n  app.disable('x-powered-by');\n  app.use(express.static('src/ItsTool.Web/wwwroot'));")
with open('test_admin.js', 'w') as f:
    f.write(text)

# 2) test_bug.js
with open('test_bug.js', 'r') as f:
    text = f.read()
text = text.replace("const app = express();\n  app.use(express.static('src/ItsTool.Web/wwwroot'));", 
                    "const app = express();\n  app.disable('x-powered-by');\n  app.use(express.static('src/ItsTool.Web/wwwroot'));")
with open('test_bug.js', 'w') as f:
    f.write(text)

# 3) test_bug2.js
with open('test_bug2.js', 'r') as f:
    text = f.read()
text = text.replace("const app = express();\n  app.use(express.static('src/ItsTool.Web/wwwroot'));", 
                    "const app = express();\n  app.disable('x-powered-by');\n  app.use(express.static('src/ItsTool.Web/wwwroot'));")
with open('test_bug2.js', 'w') as f:
    f.write(text)

# 4) test_users.js
with open('test_users.js', 'r') as f:
    text = f.read()
text = text.replace("const app = express();\n  app.use(express.static('src/ItsTool.Web/wwwroot'));", 
                    "const app = express();\n  app.disable('x-powered-by');\n  app.use(express.static('src/ItsTool.Web/wwwroot'));")
with open('test_users.js', 'w') as f:
    f.write(text)

# 5) find_char.js
with open('find_char.js', 'r') as f:
    text = f.read()
text = text.replace("require('fs')", "require('node:fs')")
with open('find_char.js', 'w') as f:
    f.write(text)

# 6) find_char2.js
with open('find_char2.js', 'r') as f:
    text = f.read()
text = text.replace("require('fs')", "require('node:fs')")
text = text.replace("charCodeAt(i)", "codePointAt(i)")
with open('find_char2.js', 'w') as f:
    f.write(text)

# 7) find_char3.js
with open('find_char3.js', 'r') as f:
    text = f.read()
text = text.replace("require('fs')", "require('node:fs')")
text = text.replace("'\\\\u'", "String.raw`\\u`")
# if there's any replaceAll or other things the user mentioned, let's fix them too if they exist
with open('find_char3.js', 'w') as f:
    f.write(text)

# 8) fix_ui.js
with open('fix_ui.js', 'r') as f:
    text = f.read()
text = text.replace("require('fs')", "require('node:fs')")
# Replace .replace( with .replaceAll(
text = text.replace(".replace(", ".replaceAll(")

# Fix String.raw issues on lines 3 and 4
text = text.replace('"replaceAll(\\"\\'\\", \\"\\\\\\\\\\'\\")"', "String.raw`replaceAll(\"'\", \"\\'\")`")
text = text.replace('"replaceAll(\\"\\'\\", \\"\\\\\\'\\")"', "String.raw`replaceAll(\"'\", \"\\'\")`")
# Wait, let's just rewrite fix_ui.js completely to match exactly what it should be
fix_ui_content = """const fs = require('node:fs');
let content = fs.readFileSync('src/ItsTool.Web/wwwroot/js/ui.js', 'utf8');
content = content.replaceAll(String.raw`replaceAll("'", "\\'")`, String.raw`replaceAll("'", "\\'")`); // wait, let's use regex
content = content.replaceAll(/replaceAll\(\\"'\\", \\"\\\\'\\"\)/g, String.raw`replaceAll("'", "\\'")`);
fs.writeFileSync('src/ItsTool.Web/wwwroot/js/ui.js', content);
"""
with open('fix_ui.js', 'w') as f:
    f.write(fix_ui_content)

# 9) parse_all.js
with open('parse_all.js', 'r') as f:
    text = f.read()
text = text.replace("require('fs')", "require('node:fs')")
with open('parse_all.js', 'w') as f:
    f.write(text)

# 10) parse_html_all.js
with open('parse_html_all.js', 'r') as f:
    text = f.read()
text = text.replace("require('fs')", "require('node:fs')")
text = text.replace("require('path')", "require('node:path')")
text = text.replace("if (stat && stat.isDirectory())", "if (stat?.isDirectory())")
text = text.replace("} else { \n            if (file.endsWith('.html')) results.push(file);\n        }", 
                    "} else if (file.endsWith('.html')) {\n            results.push(file);\n        }")
text = text.replace("} catch (e) {}", "} catch (e) {\n        console.error('[script] Hata:', e);\n        process.exitCode = 1;\n    }")

with open('parse_html_all.js', 'w') as f:
    f.write(text)

