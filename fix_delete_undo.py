import re
import glob

files = ["src/ItsTool.Web/wwwroot/projects.html", "src/ItsTool.Web/wwwroot/categories.html", 
         "src/ItsTool.Web/wwwroot/departments.html", "src/ItsTool.Web/wwwroot/groups.html", 
         "src/ItsTool.Web/wwwroot/users.html", "src/ItsTool.Web/wwwroot/roles.html"]

for file in files:
    with open(file, 'r', encoding='utf-8') as f:
        content = f.read()

    # Find what entity it is (e.g. getCategories, getRoles)
    entity_api = re.search(r'await window\.api\.delete([A-Za-z]+)\(', content)
    if not entity_api: continue
    
    entity = entity_api.group(1) # e.g. Role, Category

    # Ensure showUndoToast is imported
    if 'showUndoToast' not in content:
        content = re.sub(r'(import \{ [^\}]+)( \} from \'./js/ui.js\';)', r'\1, showUndoToast\2', content)
    
    # Replace promptDelete function
    new_prompt_delete = f"""
        window.promptDelete = async function(id) {{
            const proceed = await showUndoToast('Öğe silinecek. Geri almak için tıklayın.', null, 4000);
            if (proceed) {{
                try {{
                    await window.api.delete{entity}(id);
                    showToast('Silme işlemi tamamlandı');
                    loadData();
                }} catch (e) {{
                    showToast('Silme işlemi başarısız', 'error');
                }}
            }}
        }};
"""
    
    content = re.sub(r'window\.promptDelete\s*=\s*function\(id\)\s*\{[^}]+\};', new_prompt_delete.strip(), content, flags=re.DOTALL)
    
    # Remove confirm delete listener
    content = re.sub(r'document\.getElementById\(\'btnConfirmDelete\'\)\.addEventListener\(\'click\',.*?\}\);', '', content, flags=re.DOTALL)
    
    # Optionally remove deleteModal HTML
    content = re.sub(r'<!-- Delete Modal -->.*?</div>\s*</div>\s*</div>', '', content, flags=re.DOTALL)
    
    with open(file, 'w', encoding='utf-8') as f:
        f.write(content)
