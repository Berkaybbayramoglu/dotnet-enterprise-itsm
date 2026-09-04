import re
with open("src/ItsTool.Web/wwwroot/js/ui.js", "r", encoding="utf-8") as f:
    content = f.read()
# Replace literally
content = content.replace(r'replaceAll(\"\'\", \"\\\\\'\")', r"""replaceAll("'", "\\'")""")
with open("src/ItsTool.Web/wwwroot/js/ui.js", "w", encoding="utf-8") as f:
    f.write(content)
