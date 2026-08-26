import os
import glob
import re

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    orig_content = content
    
    # 1. getAttribute('data-...') -> dataset...
    # e.g., getAttribute('data-id') -> dataset.id
    # getAttribute("data-status-name") -> dataset.statusName (camelCase)
    def dataset_replacer(match):
        attr = match.group(2)
        # convert kebab-case to camelCase
        parts = attr.split('-')
        camel = parts[0] + ''.join(word.capitalize() for word in parts[1:])
        return f"{match.group(1)}.dataset.{camel}"

    content = re.sub(r'([a-zA-Z0-9_\.\$]+)\.getAttribute\([\'"]data-([a-zA-Z0-9_\-]+)[\'"]\)', dataset_replacer, content)

    # 2. Empty Catch
    # catch (e) { } or catch(err){}
    # We will replace {} with { console.error(e); }
    # First, find catch statements with empty braces or just comments
    def catch_replacer(match):
        var_name = match.group(1) or "e"
        inner = match.group(2).strip()
        if not inner or inner.startswith('//'):
            return f"catch ({var_name}) {{ console.error({var_name}); }}"
        return match.group(0)

    content = re.sub(r'catch\s*\(\s*([a-zA-Z0-9_]+)\s*\)\s*\{([^}]*)\}', catch_replacer, content)

    # 3. Top-Level Await / Async Initiation without await
    # Typically in v11.5, we wrap initialization in a top-level await or IIFE, but since ES modules support top-level await:
    # If the file has `<script>` it needs to be `<script type="module">` if it has top-level await.
    # The user says "await'siz async giriş yok". This means if we call `init()` which is async, we should `await init()`.
    # And if we do `await init()`, the script tag must be `<script type="module">`.
    # Look for calls to async functions that are not awaited. e.g. `loadDashboard();` -> `await loadDashboard();`
    # We will specifically look for specific known functions mentioned by the user:
    # admin-fields L399: `loadFields();`
    # audit-log L260: `loadAuditLogs();`
    # dashboard L402: `loadDashboard();`
    
    if "admin-fields.html" in filepath:
        content = content.replace("loadFields();\n    </script>", "await loadFields();\n    </script>")
        content = content.replace("<script>", '<script type="module">')
        
    if "audit-log.html" in filepath:
        content = content.replace("loadAuditLogs();\n    </script>", "await loadAuditLogs();\n    </script>")
        content = content.replace("<script>", '<script type="module">')
        
    if "dashboard.html" in filepath:
        content = content.replace("loadDashboard();\n    </script>", "await loadDashboard();\n    </script>")
        content = content.replace("<script>", '<script type="module">')

    # Additional generic empty catch fixing for simple ones
    content = re.sub(r'catch\s*\(\s*[a-zA-Z0-9_]+\s*\)\s*\{\s*\}', r'catch(e) { console.error(e); }', content)

    if orig_content != content:
        with open(filepath, 'w') as f:
            f.write(content)
        print(f"Refactored {filepath}")

for f in glob.glob('src/ItsTool.Web/wwwroot/**/*.html', recursive=True):
    process_file(f)
for f in glob.glob('src/ItsTool.Web/wwwroot/**/*.js', recursive=True):
    process_file(f)
