import sys

with open("src/ItsTool.Web/wwwroot/kanban.html", "r", encoding="utf-8") as f:
    content = f.read()

# Add drag functions for columns
js_col_drag = """
        window.allowColDrop = function(ev) {
            ev.preventDefault();
        };

        window.colDrag = function(ev) {
            ev.dataTransfer.setData("type", "column");
            ev.dataTransfer.setData("columnId", ev.target.dataset.colId);
        };

        window.colDrop = function(ev) {
            ev.preventDefault();
            const type = ev.dataTransfer.getData("type");
            if (type !== "column") return;
            
            const sourceColId = parseInt(ev.dataTransfer.getData("columnId"));
            const targetEl = ev.target.closest('.column');
            if (!targetEl) return;
            const targetColId = parseInt(targetEl.dataset.colId);
            
            if (sourceColId === targetColId) return;
            
            const board = document.getElementById('board');
            const sourceEl = board.querySelector(`.column[data-col-id="${sourceColId}"]`);
            
            // Insert before target or after if moving right
            const cols = Array.from(board.children);
            const sourceIdx = cols.indexOf(sourceEl);
            const targetIdx = cols.indexOf(targetEl);
            
            if (sourceIdx < targetIdx) {
                targetEl.after(sourceEl);
            } else {
                targetEl.before(sourceEl);
            }
            
            // Save new order
            saveColumnOrder();
        };
        
        function saveColumnOrder() {
            const board = document.getElementById('board');
            const cols = Array.from(board.children);
            const newOrder = cols.map(c => parseInt(c.dataset.colId));
            
            const payload = JSON.parse(atob(window.api.token.split('.')[1]));
            let userId = payload.sub || 'unknown';
            localStorage.setItem(`kanban.colorder.${userId}`, JSON.stringify(newOrder));
            
            showToast('Sütun sırası kaydedildi.', 'success');
        }
        
        window.resetColumnOrder = function() {
            const payload = JSON.parse(atob(window.api.token.split('.')[1]));
            let userId = payload.sub || 'unknown';
            localStorage.removeItem(`kanban.colorder.${userId}`);
            showToast('Sütun sırası sıfırlandı.', 'success');
            window.location.reload();
        };
"""

content = content.replace("        window.allowDrop = function(ev) {", js_col_drag + "\n        window.allowDrop = function(ev) {")

# Update column render
col_render = """
                let payload = { sub: 'unknown' };
                try {
                    payload = JSON.parse(atob(window.api.token.split('.')[1]));
                } catch(e) {}
                const userId = payload.sub;
                
                let savedOrder = localStorage.getItem(`kanban.colorder.${userId}`);
                if (savedOrder) {
                    try {
                        savedOrder = JSON.parse(savedOrder);
                        const sortedStatuses = [];
                        savedOrder.forEach(id => {
                            const st = statuses.find(s => s.id === id);
                            if (st) sortedStatuses.push(st);
                        });
                        statuses.forEach(st => {
                            if (!savedOrder.includes(st.id)) sortedStatuses.push(st);
                        });
                        statuses = sortedStatuses;
                    } catch(e) {}
                }

                const board = document.getElementById('board');
                board.innerHTML = '';
                statuses.forEach(s => {
                    const col = document.createElement('div');
                    col.className = `column col-${s.id}`;
                    col.dataset.colId = s.id;
                    col.ondragover = window.allowColDrop;
                    col.ondrop = window.colDrop;
                    
                    col.innerHTML = `
                        <div class="column-header" draggable="true" ondragstart="window.colDrag(event)" style="cursor: grab;">
                            <span style="text-transform: uppercase; font-size: 12px; letter-spacing: 0.5px; user-select: none;">${s.name}</span>
                            <span class="badge badge-default" id="count-${s.id}">0</span>
                        </div>
                        <div class="column-body" data-status-id="${s.id}" ondragover="allowDrop(event)" ondrop="drop(event)"></div>
                    `;
                    board.appendChild(col);
                });
"""

content = content.replace("                const board = document.getElementById('board');\n                statuses.forEach(s => {\n                    const col = document.createElement('div');\n                    col.className = `column col-${s.id}`;\n                    col.innerHTML = `\n                        <div class=\"column-header\">\n                            <span style=\"text-transform: uppercase; font-size: 12px; letter-spacing: 0.5px;\">${s.name}</span>\n                            <span class=\"badge badge-default\" id=\"count-${s.id}\">0</span>\n                        </div>\n                        <div class=\"column-body\" data-status-id=\"${s.id}\" ondragover=\"allowDrop(event)\" ondrop=\"drop(event)\"></div>\n                    `;\n                    board.appendChild(col);\n                });", col_render)

# Add Reset Button HTML
reset_btn = """
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                    <div style="background: var(--bg-hover); padding: 8px 12px; border-radius: var(--radius); font-size: 13px; color: var(--text-muted); display: flex; align-items: center; gap: 8px;">
                        <svg viewBox="0 0 24 24" width="16" height="16" style="fill: currentColor;"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z"/></svg>
                        Kapalı talepler KAPATILDI kolonunda arşivlenir; buradan reopen edilebilir. Kolon başlıklarını sürükleyerek sıralayabilirsiniz.
                    </div>
                    <button class="btn btn-ghost" onclick="window.resetColumnOrder()">Sırayı Sıfırla</button>
                </div>
"""

content = content.replace("                <div style=\"background: var(--bg-hover); padding: 8px 12px; border-radius: var(--radius); margin-bottom: 16px; font-size: 13px; color: var(--text-muted); display: flex; align-items: center; gap: 8px;\">\n                    <svg viewBox=\"0 0 24 24\" width=\"16\" height=\"16\" style=\"fill: currentColor;\"><path d=\"M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z\"/></svg>\n                    Kapalı talepler KAPATILDI kolonunda arşivlenir; buradan reopen edilebilir.\n                </div>", reset_btn)

# Make sure ticket drop checks type to avoid conflicts
drop_logic = """
        window.drop = async function(ev) {
            ev.preventDefault();
            const type = ev.dataTransfer.getData("type");
            if (type === "column") return; // Let colDrop handle this
            const idStr = ev.dataTransfer.getData("text");
            if (!idStr || !idStr.startsWith('ticket-')) return;
"""

content = content.replace("        window.drop = async function(ev) {\n            ev.preventDefault();\n            const idStr = ev.dataTransfer.getData(\"text\");", drop_logic)

with open("src/ItsTool.Web/wwwroot/kanban.html", "w", encoding="utf-8") as f:
    f.write(content)
