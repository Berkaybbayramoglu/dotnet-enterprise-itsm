import re

with open("src/ItsTool.Web/wwwroot/kanban.html", "r") as f:
    content = f.read()

# Add getLookup to initKanban
init_kanban_old = """        async function initKanban() {
            try {
                // Simplified status mock
                statuses = [
                    { id: 1, name: 'Open' },
                    { id: 2, name: 'In Progress' },
                    { id: 3, name: 'Pending' },
                    { id: 4, name: 'Resolved' },
                    { id: 5, name: 'Closed' }
                ];"""

init_kanban_new = """        let lookupData = {};
        async function initKanban() {
            try {
                lookupData = await window.api.getLookup();
                // Override statuses with real ones if available
                if (lookupData.statuses && lookupData.statuses.length > 0) {
                    statuses = lookupData.statuses;
                } else {
                    statuses = [
                        { id: 1, name: 'Open' },
                        { id: 2, name: 'In Progress' },
                        { id: 3, name: 'Pending' },
                        { id: 4, name: 'Resolved' },
                        { id: 5, name: 'Closed' }
                    ];
                }"""
content = content.replace(init_kanban_old, init_kanban_new)

# Modify showPreview(t)
preview_old = """        function showPreview(t) {
            const content = document.getElementById('previewContent');
            content.innerHTML = `
                <div style="margin-bottom: var(--spacing-sm);"><strong>Ticket:</strong> ${escapeHtml(t.ticketNumber)}</div>
                <div style="margin-bottom: var(--spacing-sm);"><strong>Title:</strong> ${escapeHtml(t.title)}</div>
                <div style="margin-bottom: var(--spacing-sm);"><strong>Description:</strong> ${escapeHtml(t.description || '').substring(0, 100)}${(t.description && t.description.length > 100) ? '...' : ''}</div>
                <div style="margin-bottom: var(--spacing-sm);"><strong>Priority:</strong> ${t.priorityId || 'Normal'}</div>
                <div style="margin-bottom: var(--spacing-sm);"><strong>Assignee:</strong> User ID ${t.assignedUserId || 'Unassigned'}</div>
                <div style="margin-bottom: var(--spacing-sm);"><strong>Requester:</strong> User ID ${t.requesterUserId || 'Unknown'}</div>
            `;
            document.getElementById('previewDetailLink').href = `/ticket-detail.html?id=${t.id}`;
            openModal('previewModal');
        }"""

preview_new = """        function showPreview(t) {
            const content = document.getElementById('previewContent');
            
            // Map IDs to Names
            const projName = lookupData.projects?.find(x => x.id === t.projectId)?.name || '-';
            const catName = lookupData.categories?.find(x => x.id === t.categoryId)?.name || '-';
            
            // Priority mapping
            const prioName = lookupData.priorities?.find(x => x.id === t.priorityId)?.name || 'Normal';
            const prioColors = { 'Critical': 'danger', 'High': 'warning', 'Medium': 'info', 'Low': 'success' };
            const prioColor = prioColors[prioName] || 'default';
            
            // Status mapping
            const statusName = statuses.find(x => x.id === t.statusId)?.name || 'Unknown';
            
            // Assignee & Requester mapping (requires user fetch or mockup, API lookup might not have all users)
            const assigneeName = t.assignedUserId ? `User ${t.assignedUserId}` : 'Atanmamış';
            const reqName = t.requesterUserId ? `User ${t.requesterUserId}` : 'Unknown';
            
            const formatDate = (d) => {
                if(!d) return '-';
                const date = new Date(d);
                return isNaN(date.getTime()) ? '-' : date.toLocaleString('tr-TR', { dateStyle: 'short', timeStyle: 'short' });
            };

            const headerEl = document.querySelector('#previewModal .modal-header h2');
            if (headerEl) {
                headerEl.innerHTML = `${escapeHtml(t.ticketNumber)} <span class="badge badge-primary" style="font-size: 12px; margin-left: 8px;">${escapeHtml(statusName)}</span>`;
            }

            content.innerHTML = `
                <div style="font-size: 16px; font-weight: 600; margin-bottom: var(--spacing-md); color: var(--text);">${escapeHtml(t.title)}</div>
                <div style="display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden; margin-bottom: var(--spacing-md); color: var(--text-muted); font-size: 14px;">
                    ${escapeHtml(t.description || '')}
                </div>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: var(--spacing-md); background: var(--bg-hover); padding: var(--spacing-md); border-radius: var(--radius-md);">
                    <div>
                        <div style="font-size: 12px; color: var(--text-muted); margin-bottom: 4px;">Priority</div>
                        <span class="badge badge-${prioColor}">${escapeHtml(prioName)}</span>
                    </div>
                    <div>
                        <div style="font-size: 12px; color: var(--text-muted); margin-bottom: 4px;">Project / Category</div>
                        <div style="font-size: 14px; font-weight: 500;">${escapeHtml(projName)} <span style="color:var(--text-muted);">/</span> ${escapeHtml(catName)}</div>
                    </div>
                    <div>
                        <div style="font-size: 12px; color: var(--text-muted); margin-bottom: 4px;">Requester</div>
                        <div style="display: flex; align-items: center; gap: 8px; font-size: 14px;">
                            ${getAvatar(t.requesterUserId, reqName)} ${escapeHtml(reqName)}
                        </div>
                    </div>
                    <div>
                        <div style="font-size: 12px; color: var(--text-muted); margin-bottom: 4px;">Assignee</div>
                        <div style="display: flex; align-items: center; gap: 8px; font-size: 14px;">
                            ${t.assignedUserId ? getAvatar(t.assignedUserId, assigneeName) : ''} ${escapeHtml(assigneeName)}
                        </div>
                    </div>
                    <div>
                        <div style="font-size: 12px; color: var(--text-muted); margin-bottom: 4px;">SLA Status</div>
                        <span class="badge badge-success">On Track</span>
                    </div>
                    <div>
                        <div style="font-size: 12px; color: var(--text-muted); margin-bottom: 4px;">Created At</div>
                        <div style="font-size: 14px;">${formatDate(t.createdAt)}</div>
                    </div>
                </div>
            `;
            document.getElementById('previewDetailLink').href = `/ticket-detail.html?id=${t.id}`;
            openModal('previewModal');
        }"""
content = content.replace(preview_old, preview_new)

with open("src/ItsTool.Web/wwwroot/kanban.html", "w") as f:
    f.write(content)
