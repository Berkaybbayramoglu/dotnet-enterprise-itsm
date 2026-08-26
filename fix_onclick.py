import re
import glob

files = ["src/ItsTool.Web/wwwroot/projects.html", "src/ItsTool.Web/wwwroot/categories.html", 
         "src/ItsTool.Web/wwwroot/departments.html", "src/ItsTool.Web/wwwroot/groups.html", 
         "src/ItsTool.Web/wwwroot/users.html", "src/ItsTool.Web/wwwroot/roles.html"]

def replace_onclick(match):
    full_call = match.group(1)
    # case 1: closeModal('id')
    m1 = re.match(r"closeModal\('([^']+)'\)", full_call)
    if m1:
        return f'data-action="closeModal" data-target="{m1.group(1)}"'
    
    # case 2: window.something()
    m2 = re.match(r"window\.([a-zA-Z0-9_]+)\(\)", full_call)
    if m2:
        return f'data-action="{m2.group(1)}"'
    
    # case 3: window.something(${id})
    m3 = re.match(r"window\.([a-zA-Z0-9_]+)\(\$\{([^\}]+)\}\)", full_call)
    if m3:
        return f'data-action="{m3.group(1)}" data-id="${{{m3.group(2)}}}"'
    
    # case 4: window.setOverride(${p.id}, true/false)
    m4 = re.match(r"window\.([a-zA-Z0-9_]+)\(\$\{([^\}]+)\},\s*(true|false)\)", full_call)
    if m4:
        return f'data-action="{m4.group(1)}" data-id="${{{m4.group(2)}}}" data-flag="{m4.group(3)}"'
    
    return match.group(0) # fallback

delegation_script = """
        document.addEventListener('click', (e) => {
            const btn = e.target.closest('[data-action]');
            if (!btn) return;
            const action = btn.getAttribute('data-action');
            const target = btn.getAttribute('data-target');
            const idAttr = btn.getAttribute('data-id');
            const flagAttr = btn.getAttribute('data-flag');
            const id = idAttr && idAttr !== 'undefined' ? parseInt(idAttr) : undefined;
            const flag = flagAttr ? (flagAttr === 'true') : undefined;
            
            if (action === 'closeModal' && target) {
                if (typeof closeModal === 'function') closeModal(target);
            } else if (typeof window[action] === 'function') {
                if (flag !== undefined) window[action](id, flag);
                else window[action](id);
            }
        });
"""

for file in files:
    with open(file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    content = re.sub(r'onclick="([^"]+)"', replace_onclick, content)
    
    # Add delegation to <script type="module">
    if "data-action" in content and "document.addEventListener('click', (e) => {" not in content:
        # insert right after bindShellActions();
        if "bindShellActions();" in content:
            content = content.replace("bindShellActions();", f"bindShellActions();\n{delegation_script}")
    
    with open(file, 'w', encoding='utf-8') as f:
        f.write(content)
