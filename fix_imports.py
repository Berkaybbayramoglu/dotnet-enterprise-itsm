import glob
import re

files = ["src/ItsTool.Web/wwwroot/projects.html", "src/ItsTool.Web/wwwroot/categories.html", 
         "src/ItsTool.Web/wwwroot/departments.html", "src/ItsTool.Web/wwwroot/groups.html", 
         "src/ItsTool.Web/wwwroot/users.html", "src/ItsTool.Web/wwwroot/roles.html"]

for file in files:
    with open(file, 'r', encoding='utf-8') as f:
        content = f.read()

    # The current import might look like: import { bindShellActions, showToast, escapeHtml, showUndoToast } from './js/ui.js?v=2';
    # Or without ?v=2. We just want to ensure openModal and closeModal are in there.
    
    # We will use regex to find the ui.js import and replace it completely with a full set of imports
    content = re.sub(
        r"import \{[^\}]+\} from '\./js/ui\.js(\?v=\d+)?';",
        "import { bindShellActions, showToast, escapeHtml, showUndoToast, openModal, closeModal } from './js/ui.js?v=3';",
        content
    )
    
    with open(file, 'w', encoding='utf-8') as f:
        f.write(content)
