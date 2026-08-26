import glob

button_html = """
                    <button class="mobile-menu-btn" id="mobileMenuBtn">
                        <svg viewBox="0 0 24 24" width="24" height="24"><path d="M3 18h18v-2H3v2zm0-5h18v-2H3v2zm0-7v2h18V6H3z"/></svg>
                    </button>
"""

overlay_html = '<div class="sidebar-overlay" id="sidebarOverlay"></div>\n        <aside class="sidebar">'

for file in glob.glob("src/ItsTool.Web/wwwroot/*.html"):
    if file.endswith("login.html") or file.endswith("survey.html") or file.endswith("index.html"):
        continue
    with open(file, "r", encoding="utf-8") as f:
        content = f.read()
    
    modified = False
    
    if '<div class="topbar-left">' in content and 'id="mobileMenuBtn"' not in content:
        content = content.replace('<div class="topbar-left">', '<div class="topbar-left">' + button_html)
        modified = True
        
    if '<aside class="sidebar">' in content and 'sidebarOverlay' not in content:
        content = content.replace('<aside class="sidebar">', overlay_html)
        modified = True
        
    if modified:
        with open(file, "w", encoding="utf-8") as f:
            f.write(content)
        print(f"Updated {file}")
