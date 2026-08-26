with open("src/ItsTool.Web/wwwroot/js/ui.js", "r", encoding="utf-8") as f:
    content = f.read()

# Make sure window.openModal is set
if "window.openModal = openModal;" not in content:
    content += "\nwindow.openModal = openModal;\n"
if "window.closeModal = closeModal;" not in content:
    content += "window.closeModal = closeModal;\n"
if "window.showToast = showToast;" not in content:
    content += "window.showToast = showToast;\n"
if "window.showUndoToast = showUndoToast;" not in content:
    content += "window.showUndoToast = showUndoToast;\n"

with open("src/ItsTool.Web/wwwroot/js/ui.js", "w", encoding="utf-8") as f:
    f.write(content)
