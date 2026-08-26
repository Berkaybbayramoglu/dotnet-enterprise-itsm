import glob

files = ["src/ItsTool.Web/wwwroot/projects.html", "src/ItsTool.Web/wwwroot/categories.html", 
         "src/ItsTool.Web/wwwroot/departments.html", "src/ItsTool.Web/wwwroot/groups.html", 
         "src/ItsTool.Web/wwwroot/users.html", "src/ItsTool.Web/wwwroot/roles.html",
         "src/ItsTool.Web/wwwroot/kanban.html", "src/ItsTool.Web/wwwroot/dashboard.html",
         "src/ItsTool.Web/wwwroot/tickets.html", "src/ItsTool.Web/wwwroot/ticket-detail.html",
         "src/ItsTool.Web/wwwroot/kb.html", "src/ItsTool.Web/wwwroot/kb-article.html",
         "src/ItsTool.Web/wwwroot/audit-log.html"]

for file in files:
    try:
        with open(file, 'r', encoding='utf-8') as f:
            content = f.read()

        content = content.replace("'./js/ui.js'", "'./js/ui.js?v=2'")
        content = content.replace("'./js/api.js'", "'./js/api.js?v=2'")
        
        with open(file, 'w', encoding='utf-8') as f:
            f.write(content)
    except FileNotFoundError:
        pass
