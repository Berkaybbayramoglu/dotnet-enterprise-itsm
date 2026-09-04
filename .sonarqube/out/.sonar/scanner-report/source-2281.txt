import re

def fix_load_ticket():
    path = "src/ItsTool.Web/wwwroot/ticket-detail.html"
    with open(path, "r") as f:
        content = f.read()

    start_str = "// Setup Manage Assignees Modal\n                window.openAssignModal = async () => {"
    end_str = """                        console.error(e);
                        showToast('Assignment failed', 'error');
                    }
                };"""
    
    if start_str in content and end_str in content:
        start_idx = content.find(start_str)
        end_idx = content.find(end_str) + len(end_str)
        
        block1 = content[start_idx:end_idx]
        content = content[:start_idx] + content[end_idx:]
        
        start2_str = "// Setup Assignment Tree Modal\n                window.openAssignmentTree = async () => {"
        end2_str = """                        container.innerHTML = `<div style="color:var(--danger)">Failed to load assignment tree.</div>`;
                    }
                };"""
        
        if start2_str in content and end2_str in content:
            start2_idx = content.find(start2_str)
            end2_idx = content.find(end2_str) + len(end2_str)
            block2 = content[start2_idx:end2_idx]
            content = content[:start2_idx] + content[end2_idx:]
            
            insert_pos = content.find("        window.openUserDetails = async function(userId) {")
            if insert_pos != -1:
                combined_blocks = "\n" + block1.replace('                window.', '        window.').replace('                document.', '        document.') + "\n\n" + block2.replace('                window.', '        window.') + "\n\n"
                
                content = content[:insert_pos] + combined_blocks + content[insert_pos:]
                
                with open(path, "w") as f:
                    f.write(content)
                print("Refactored loadTicket successfully")
            else:
                print("Failed to find insertion point")
        else:
            print("Failed to find block2")
    else:
        print("Failed to find block1")

fix_load_ticket()
