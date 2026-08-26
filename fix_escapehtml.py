with open("src/ItsTool.Web/wwwroot/js/ui.js", "r", encoding="utf-8") as f:
    content = f.read()

if "export function escapeHtml" not in content:
    content = "export const escapeHtml = (unsafe) => (unsafe || '').toString().replaceAll('&', \"&amp;\").replaceAll('<', \"&lt;\").replaceAll('>', \"&gt;\").replaceAll('\"', \"&quot;\").replaceAll(\"'\", \"&#039;\");\n" + content
    
with open("src/ItsTool.Web/wwwroot/js/ui.js", "w", encoding="utf-8") as f:
    f.write(content)
