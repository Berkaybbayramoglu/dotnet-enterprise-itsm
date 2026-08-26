import re

with open("src/ItsTool.Web/wwwroot/kanban.html", "r", encoding="utf-8") as f:
    content = f.read()

# Replace colDrag to add 'dragging' class
col_drag = """        window.colDrag = function(ev) {
            ev.dataTransfer.setData("type", "column");
            const col = ev.target.closest('.column');
            if (col) {
                ev.dataTransfer.setData("columnId", col.dataset.colId);
                col.classList.add('dragging');
            }
"""
content = re.sub(r'window\.colDrag = function\(ev\) \{\n\s*ev\.dataTransfer\.setData\("type", "column"\);\n\s*const col = ev\.target\.closest\(\'\.column\'\);\n\s*if \(col\) \{\n\s*ev\.dataTransfer\.setData\("columnId", col\.dataset\.colId\);\n\s*\}', col_drag.strip(), content)

# Replace window.allowColDrop
allow_col_drop = """        window.allowColDrop = function(ev) {
            ev.preventDefault();
            const targetEl = ev.target.closest('.column');
            if (targetEl) {
                document.querySelectorAll('.column').forEach(c => c.classList.remove('drag-over'));
                targetEl.classList.add('drag-over');
            }
        };
"""
content = re.sub(r'window\.allowColDrop = function\(ev\) \{\n\s*ev\.preventDefault\(\);\n\s*\};', allow_col_drop.strip(), content)

# Clean up classes on colDrop
col_drop = """        window.colDrop = function(ev) {
            document.querySelectorAll('.column').forEach(c => {
                c.classList.remove('drag-over');
                c.classList.remove('dragging');
            });
            ev.preventDefault();
"""
content = re.sub(r'window\.colDrop = function\(ev\) \{\n\s*ev\.preventDefault\(\);', col_drop.strip(), content)

# Clean up classes on dragend for column
if 'window.colDragEnd =' not in content:
    # Let's just add it to colDrag element
    content = content.replace('ondragstart="window.colDrag(event)"', 'ondragstart="window.colDrag(event)" ondragend="window.dragEnd(event)"')

drag_end = """
        window.dragEnd = function(ev) {
            document.querySelectorAll('.dragging').forEach(el => el.classList.remove('dragging'));
            document.querySelectorAll('.drag-over').forEach(el => el.classList.remove('drag-over'));
        };
"""
if 'window.dragEnd = function(ev)' not in content:
    content = content.replace("window.colDrop = function(ev) {", drag_end.strip() + "\n\n        window.colDrop = function(ev) {")

# Add same for card drag
content = content.replace('ondragstart="window.drag(event)"', 'ondragstart="window.drag(event)" ondragend="window.dragEnd(event)"')

card_drag = """        window.drag = function(ev) {
            isDragging = true;
            ev.dataTransfer.setData("text", ev.target.closest('.card').id);
            ev.target.closest('.card').classList.add('dragging');
        };"""
content = re.sub(r'window\.drag = function\(ev\) \{\n\s*isDragging = true;\n\s*ev\.dataTransfer\.setData\("text", ev\.target\.id\);\n\s*\};', card_drag.strip(), content)

card_allow_drop = """        window.allowDrop = function(ev) {
            ev.preventDefault();
            const type = ev.dataTransfer.getData("type");
            if (type !== "column") {
                document.querySelectorAll('.column-body').forEach(c => c.classList.remove('drag-over'));
                const colBody = ev.target.closest('.column-body');
                if (colBody) colBody.classList.add('drag-over');
            }
        };"""
content = re.sub(r'window\.allowDrop = function\(ev\) \{\n\s*ev\.preventDefault\(\);\n\s*\};', card_allow_drop.strip(), content)

card_drop = """        window.drop = async function(ev) {
            document.querySelectorAll('.dragging, .drag-over').forEach(el => {
                el.classList.remove('dragging');
                el.classList.remove('drag-over');
            });
            ev.preventDefault();
"""
content = re.sub(r'window\.drop = async function\(ev\) \{\n\s*ev\.preventDefault\(\);', card_drop.strip(), content)

with open("src/ItsTool.Web/wwwroot/kanban.html", "w", encoding="utf-8") as f:
    f.write(content)

