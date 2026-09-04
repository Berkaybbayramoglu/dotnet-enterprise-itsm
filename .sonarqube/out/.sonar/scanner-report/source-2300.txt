import re

with open("old-ticket-detail.html", "r", encoding="utf-8") as f:
    content = f.read()

# R16: Remove groupName dead assignment
content = content.replace("let groupName = '-';\n", "")
content = content.replace("if (grp) groupName = grp.name;\n", "")
# Note: we need to handle the whole block:
#                 let groupName = '-';
#                 if (t.assignedGroupId) {
#                     try {
#                         const groups = await window.api.getGroups();
#                         const grp = groups.find(x => x.id === t.assignedGroupId);
#                         if (grp) groupName = grp.name;
#                     } catch(e) { console.warn(e); }
#                 }
old_group_block = """                let groupName = '-';
                if (t.assignedGroupId) {
                    try {
                        const groups = await window.api.getGroups();
                        const grp = groups.find(x => x.id === t.assignedGroupId);
                        if (grp) groupName = grp.name;
                    } catch(e) { console.warn(e); }
                }"""
content = content.replace(old_group_block, "")

# R18: typeof globalLookup !== 'undefined'
content = content.replace(
    "typeof globalLookup !== 'undefined' && globalLookup.departments ? globalLookup.departments : []",
    "globalLookup !== undefined && globalLookup.departments ? globalLookup.departments : []"
)

# R17: nested ternary
old_ternary = "const key = a.userId ? `u_${a.userId}` : (a.groupId ? `g_${a.groupId}` : null);"
new_ternary = """let key = null;
                        if (a.userId) {
                            key = `u_${a.userId}`;
                        } else if (a.groupId) {
                            key = `g_${a.groupId}`;
                        }"""
content = content.replace(old_ternary, new_ternary)

with open("old-ticket-detail.html", "w", encoding="utf-8") as f:
    f.write(content)

print("Applied R16, R17, R18")
