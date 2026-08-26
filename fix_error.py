import glob

files = ["src/ItsTool.Web/wwwroot/projects.html", "src/ItsTool.Web/wwwroot/categories.html", 
         "src/ItsTool.Web/wwwroot/departments.html", "src/ItsTool.Web/wwwroot/groups.html", 
         "src/ItsTool.Web/wwwroot/users.html", "src/ItsTool.Web/wwwroot/roles.html"]

script = """
    <script>
        window.addEventListener('error', function(e) {
            document.body.innerHTML = '<div style="color:red;font-size:20px;padding:20px;background:white;">ERROR: ' + e.message + '</div>';
        });
        window.addEventListener('unhandledrejection', function(e) {
            document.body.innerHTML = '<div style="color:red;font-size:20px;padding:20px;background:white;">PROMISE ERROR: ' + e.reason + '</div>';
        });
    </script>
"""

for file in files:
    with open(file, 'r', encoding='utf-8') as f:
        content = f.read()

    if "<script>" not in content:
        content = content.replace("<body>", f"<body>\n{script}")
        
    with open(file, 'w', encoding='utf-8') as f:
        f.write(content)
