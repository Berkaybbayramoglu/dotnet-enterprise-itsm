with open("src/ItsTool.Web/wwwroot/js/ui.js", "r", encoding="utf-8") as f:
    content = f.read()

import re
# Find the line
for i, line in enumerate(content.split('\n')):
    if 'showInfoModal' in line and 'replaceAll' in line:
        print(repr(line.strip()))
