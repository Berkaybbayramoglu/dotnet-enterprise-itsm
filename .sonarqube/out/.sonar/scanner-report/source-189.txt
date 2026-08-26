import re

files = ["src/ItsTool.Web/wwwroot/projects.html", "src/ItsTool.Web/wwwroot/categories.html", 
         "src/ItsTool.Web/wwwroot/departments.html", "src/ItsTool.Web/wwwroot/groups.html", 
         "src/ItsTool.Web/wwwroot/users.html", "src/ItsTool.Web/wwwroot/roles.html"]

for file in files:
    with open(file, 'r', encoding='utf-8') as f:
        content = f.read()

    # Fix closeModal
    content = content.replace(
        "if (typeof closeModal === 'function') closeModal(target);",
        "if (typeof closeModal === 'function') closeModal(target); else if (typeof window.closeModal === 'function') window.closeModal(target);"
    )
    
    with open(file, 'w', encoding='utf-8') as f:
        f.write(content)
