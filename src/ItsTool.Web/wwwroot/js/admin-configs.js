export const adminConfigs = {
    departments: {
        endpoint: '/Departments', pageTitle: 'Departments',
        modalId: 'deptModal', createTitle: 'New Department', auditSafeDelete: true,
        expandable: true,
        onExpand: async (item, container) => {
            try {
                // Fetch groups and users lazily
                if (!window._groupsCache) window._groupsCache = (await window.api.request('/Groups')) || [];
                if (!window._usersCache) {
                    const uRes = await window.api.getUsers();
                    window._usersCache = Array.isArray(uRes) ? uRes : (uRes.items || []);
                }
                
                const deptGroups = window._groupsCache.filter(g => g.departmentId === item.id);
                
                if (deptGroups.length === 0) {
                    container.innerHTML = '<div style="color: var(--text-muted); font-size: 13px;">Bu departmana bağlı grup bulunamadı.</div>';
                    return;
                }
                
                let html = '<div style="display: flex; flex-direction: column; gap: 12px;">';
                deptGroups.forEach(g => {
                    const groupUsers = window._usersCache.filter(u => u.groupIds && u.groupIds.includes(g.id));
                    
                    html += `
                        <div class="card" style="padding: 12px; margin: 0; background: white; border: 1px solid var(--border);">
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                                <div style="font-weight: 600; color: var(--text-main); display: flex; align-items: center; gap: 8px;">
                                    <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor" style="color: #f59e0b;"><path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/></svg>
                                    ${window.ui?.escapeHtml(g.name)} <span class="badge badge-default" style="font-size: 11px;">${groupUsers.length} üye</span>
                                </div>
                                <button type="button" class="btn btn-ghost" style="font-size: 12px; padding: 4px 8px; color: var(--primary);" data-action="moveGroup" data-group-id="${g.id}">Departman Değiştir</button>
                            </div>
                    `;
                    
                    if (groupUsers.length > 0) {
                        html += '<div style="display: flex; flex-direction: column; gap: 4px; padding-left: 24px;">';
                        groupUsers.forEach(u => {
                            const initial = (u.firstName + ' ' + u.lastName).charAt(0).toUpperCase();
                            html += `
                                <div class="user-hover-link" data-user-id="${u.id}" style="display: flex; align-items: center; gap: 8px; padding: 4px 0; cursor: pointer; width: fit-content;">
                                    <div class="avatar" style="width: 24px; height: 24px; font-size: 11px; background: rgba(var(--primary-rgb), 0.1); color: var(--primary); display: flex; align-items: center; justify-content: center; border-radius: 50%;">${initial}</div>
                                    <div style="font-size: 13px; color: var(--text-main);">${window.ui?.escapeHtml(u.firstName + ' ' + u.lastName)}</div>
                                    <div style="font-size: 12px; color: var(--text-muted);">${window.ui?.escapeHtml(u.email)}</div>
                                </div>
                            `;
                        });
                        html += '</div>';
                    } else {
                        html += '<div style="padding-left: 24px; font-size: 12px; color: var(--text-muted);">Kullanıcı atanmamış.</div>';
                    }
                    
                    html += '</div>';
                });
                html += '</div>';
                
                container.innerHTML = html;


            } catch (err) {
                console.error(err);
                container.innerHTML = '<div style="color: var(--danger); font-size: 13px;">Gruplar yüklenirken bir hata oluştu.</div>';
            }
        },
        formFields: { id: 'dId', map: { 'name': 'dName', 'description': 'dDesc', 'color': 'dColor' } },
        columns: [
            { key: 'id', label: 'ID', render: (item) => `<span class="text-muted">#${item.id}</span>` },
            { key: 'color', label: 'Color', render: (item) => item.color ? `<div style="width:16px; height:16px; border-radius:50%; background:${item.color}; border:1px solid var(--border);"></div>` : '-' },
            { key: 'name', label: 'Name', render: (item) => `<span style="font-weight: 500;">${window.ui?.escapeHtml(item.name || '')}</span>` },
            { key: 'description', label: 'Description', render: (item) => window.ui?.escapeHtml(item.description) || '-' }
        ],
        formHtml: `
            <div class="form-group">
                <label class="form-label" for="dName">Name *</label>
                <input id="dName" class="form-control" required placeholder="e.g. IT, HR, Finance">
            </div>
            <div class="form-group">
                <label class="form-label" for="dColor">Folder Color</label>
                <input id="dColor" type="color" class="form-control" style="width: 60px; padding: 2px;">
            </div>
            <div class="form-group">
                <label class="form-label" for="dDesc">Description</label>
                <textarea id="dDesc" class="form-control" rows="3" placeholder="Departman açıklaması..."></textarea>
            </div>`
    },
    categories: {
        endpoint: '/Categories', pageTitle: 'Categories',
        modalId: 'catModal', createTitle: 'New Category', auditSafeDelete: true,
        formFields: { id: 'cId', map: { 'name': 'cName', 'description': 'cDesc' } },
        columns: [
            { key: 'id', label: 'ID', render: (item) => `<span class="text-muted">#${item.id}</span>` },
            { key: 'name', label: 'Name', render: (item) => `<span style="font-weight: 500;">${window.ui?.escapeHtml(item.name || '')}</span>` },
            { key: 'description', label: 'Description', render: (item) => window.ui?.escapeHtml(item.description) || '-' }
        ],
        formHtml: `
            <div class="form-group">
                <label class="form-label" for="cName">Name *</label>
                <input id="cName" class="form-control" required placeholder="e.g. Hardware, Software">
            </div>
            <div class="form-group">
                <label class="form-label" for="cDesc">Description</label>
                <textarea id="cDesc" class="form-control" rows="3"></textarea>
            </div>`
    },
    projects: {
        endpoint: '/Projects', pageTitle: 'Projects',
        modalId: 'projectModal', createTitle: 'New Project', auditSafeDelete: true,
        formFields: { id: 'pId', map: { 'name': 'pName', 'projectKey': 'pKey', 'status': 'pStatus' } },
        columns: [
            { key: 'id', label: 'ID', render: (item) => `<span class="text-muted">#${item.id}</span>` },
            { key: 'projectKey', label: 'Key', render: (item) => `<span style="font-weight: 500;">${window.ui?.escapeHtml(item.projectKey || '')}</span>` },
            { key: 'name', label: 'Name' },
            { key: 'status', label: 'Status', render: (item) => {
                const statusStr = item.status || 'Active';
                let color = 'default';
                if (statusStr === 'Active') color = 'success';
                if (statusStr === 'Inactive') color = 'default';
                if (statusStr === 'Postponed') color = 'warning';
                
                return `
                <select class="badge badge-${color}" style="border:none; cursor:pointer; outline:none; font-weight:bold; appearance:none; padding-right:12px; text-align:center;" onchange="window.updateProjectStatusInline(${item.id}, this.value)">
                    <option value="Active" ${statusStr === 'Active' ? 'selected' : ''} style="background: var(--success-light); color: var(--success); font-weight: bold;">Active</option>
                    <option value="Inactive" ${statusStr === 'Inactive' ? 'selected' : ''} style="background: var(--bg-hover); color: var(--text-muted); font-weight: bold;">Inactive</option>
                    <option value="Postponed" ${statusStr === 'Postponed' ? 'selected' : ''} style="background: var(--warning-light); color: #B36200; font-weight: bold;">Postponed</option>
                </select>`;
            }}
        ],
        formHtml: `
            <div class="form-group">
                <label class="form-label" for="pName">Name *</label>
                <input id="pName" class="form-control" required placeholder="e.g. Customer Portal">
            </div>
            <div class="form-group">
                <label class="form-label" for="pKey">Project Key *</label>
                <input id="pKey" class="form-control" required placeholder="e.g. CP" style="text-transform: uppercase;">
            </div>
            <div class="form-group">
                <label class="form-label" for="pStatus">Status</label>
                <select id="pStatus" class="form-control">
                    <option value="Active">Active</option>
                    <option value="Inactive">Inactive</option>
                    <option value="Postponed">Postponed</option>
                </select>
            </div>`
    },
    groups: {
        endpoint: '/Groups', pageTitle: 'Groups',
        modalId: 'groupModal', createTitle: 'New Group', auditSafeDelete: true,
        expandable: true,
        onExpand: async (item, container) => {
            try {
                if (!window._usersCache) {
                    const uRes = await window.api.getUsers();
                    window._usersCache = Array.isArray(uRes) ? uRes : (uRes.items || []);
                }
                const groupUsers = window._usersCache.filter(u => u.groupIds && u.groupIds.includes(item.id));
                
                if (groupUsers.length === 0) {
                    container.innerHTML = '<div style="color: var(--text-muted); font-size: 13px;">Bu gruba atanmış kullanıcı bulunamadı.</div>';
                    return;
                }
                
                let html = '<div style="display: flex; flex-direction: column; gap: 8px;">';
                html += '<div style="font-weight: 600; color: var(--text-main); font-size: 13px; margin-bottom: 4px;">Grup Üyeleri</div>';
                
                groupUsers.forEach(u => {
                    const initial = (u.firstName + ' ' + u.lastName).charAt(0).toUpperCase();
                    html += `
                        <div class="user-hover-link" data-user-id="${u.id}" style="display: flex; align-items: center; gap: 12px; padding: 8px; background: white; border: 1px solid var(--border); border-radius: var(--radius-md); max-width: 400px; cursor: pointer;">
                            <div class="avatar" style="width: 32px; height: 32px; font-size: 14px; background: rgba(var(--primary-rgb), 0.1); color: var(--primary); display: flex; align-items: center; justify-content: center; border-radius: 50%;">${initial}</div>
                            <div>
                                <div style="font-size: 14px; font-weight: 500; color: var(--text-main);">${window.ui?.escapeHtml(u.firstName + ' ' + u.lastName)}</div>
                                <div style="font-size: 12px; color: var(--text-muted);">${window.ui?.escapeHtml(u.email)}</div>
                            </div>
                        </div>
                    `;
                });
                html += '</div>';
                container.innerHTML = html;
            } catch (err) {
                console.error(err);
                container.innerHTML = '<div style="color: var(--danger); font-size: 13px;">Kullanıcılar yüklenirken bir hata oluştu.</div>';
            }
        },
        formFields: { id: 'gId', map: { 'name': 'gName', 'departmentId': 'gDept' } },
        onModalOpen: async () => {
            const select = document.getElementById('gDept');
            if (select && select.options.length === 0) {
                const depts = (await window.api.request('/Departments')) || [];
                select.innerHTML = '<option value="">Select a Department...</option>' + 
                    depts.map(d => `<option value="${d.id}">${window.ui?.escapeHtml(d.name)}</option>`).join('');
            }
        },
        columns: [
            { key: 'id', label: 'ID', render: (item) => `<span class="text-muted">#${item.id}</span>` },
            { key: 'name', label: 'Name', render: (item) => `<span style="font-weight: 500;">${window.ui?.escapeHtml(item.name || '')}</span>` }
        ],
        formHtml: `
            <div class="form-group">
                <label class="form-label" for="gName">Name *</label>
                <input id="gName" class="form-control" required placeholder="e.g. L1 Support">
            </div>
            <div class="form-group">
                <label class="form-label" for="gDept">Department *</label>
                <select id="gDept" class="form-control" required></select>
            </div>`
    },
    roles: {
        endpoint: '/Roles', pageTitle: 'Roles',
        modalId: 'roleModal', createTitle: 'New Role', auditSafeDelete: true,
        formFields: { id: 'rId', map: { 'name': 'rName', 'description': 'rDesc', 'permissions': 'rPerms', 'isActive': 'rActive' } },
        columns: [
            { key: 'id', label: 'ID', render: (item) => `<span class="text-muted">#${item.id}</span>` },
            { key: 'name', label: 'Name', render: (item) => `<span style="font-weight: 500;">${window.ui?.escapeHtml(item.name || '')}</span>` },
            { key: 'description', label: 'Description', render: (item) => window.ui?.escapeHtml(item.description) || '-' },
            { key: 'isActive', label: 'Status', render: (item) => item.isActive ? `<span class="badge badge-success">Active</span>` : `<span class="badge badge-default">Inactive</span>` }
        ],
        formHtml: `
            <div class="form-group">
                <label class="form-label" for="rName">Name *</label>
                <input id="rName" class="form-control" required placeholder="e.g. Admin, Agent">
            </div>
            <div class="form-group">
                <label class="form-label" for="rDesc">Description</label>
                <textarea id="rDesc" class="form-control" rows="2"></textarea>
            </div>
            <div class="form-group">
                <label class="form-label" for="rPerms">Permissions (Comma separated)</label>
                <input id="rPerms" class="form-control" placeholder="e.g. ticket.view, ticket.manage">
            </div>
            <div class="form-group" style="display: flex; align-items: center; gap: 8px;">
                <input type="checkbox" id="rActive" checked>
                <label class="form-label" for="rActive" style="margin: 0;">Is Active</label>
            </div>`
    },
    permissions: {
        endpoint: '/Permissions', pageTitle: 'Permissions',
        modalId: 'permModal', createTitle: 'New Permission', auditSafeDelete: true,
        formFields: { id: 'pId', map: { 'name': 'pName', 'key': 'pKey', 'description': 'pDesc' } },
        columns: [
            { key: 'id', label: 'ID', render: (item) => `<span class="text-muted">#${item.id}</span>` },
            { key: 'key', label: 'Key', render: (item) => `<span class="badge badge-primary">${window.ui?.escapeHtml(item.key || '')}</span>` },
            { key: 'name', label: 'Name', render: (item) => `<span style="font-weight: 500;">${window.ui?.escapeHtml(item.name || '')}</span>` },
            { key: 'description', label: 'Description', render: (item) => window.ui?.escapeHtml(item.description) || '-' }
        ],
        formHtml: `
            <div class="form-group">
                <label class="form-label" for="pKey">Key (Code) *</label>
                <input id="pKey" class="form-control" required placeholder="e.g. ticket.view">
            </div>
            <div class="form-group">
                <label class="form-label" for="pName">Name *</label>
                <input id="pName" class="form-control" required placeholder="e.g. View Tickets">
            </div>
            <div class="form-group">
                <label class="form-label" for="pDesc">Description</label>
                <textarea id="pDesc" class="form-control" rows="3" placeholder="Explain what this permission allows..."></textarea>
            </div>`
    }
};

if (!window.updateProjectStatusInline) {
    window.updateProjectStatusInline = async function(id, newStatus) {
        if(!window.currentData) return;
        const proj = window.currentData.find(x => x.id === id);
        if (!proj) return;
        
        try {
            await window.api.request(`/Projects/${id}`, {
                method: 'PUT',
                body: JSON.stringify({
                    name: proj.name,
                    projectKey: proj.projectKey,
                    description: proj.description,
                    status: newStatus
                })
            });
            if (window.ui?.showToast) window.ui.showToast('Status updated to ' + newStatus);
            if (window.loadData) window.loadData();
        } catch(e) {
            console.error(e);
            if (window.ui?.showToast) window.ui.showToast('Error updating status', 'error');
            if (window.loadData) window.loadData(); // revert UI change
        }
    };
}

// Move Group Modal Injection
document.addEventListener('click', async (e) => {
    const moveBtn = e.target.closest('[data-action="moveGroup"]');
    if (moveBtn) {
        const groupId = moveBtn.dataset.groupId;
        const currentGroup = window._groupsCache?.find(g => g.id == groupId);
        if (!currentGroup) return;
            
            // Re-use ui.js modal or just prompt/create inline modal. 
            // Better: use an ad-hoc modal for Move Group
            let modal = document.getElementById('moveGroupModal');
            if (!modal) {
                modal = document.createElement('div');
                modal.id = 'moveGroupModal';
                modal.className = 'modal-overlay';
                modal.innerHTML = `
                    <div class="modal">
                        <form id="moveGroupForm">
                            <input type="hidden" id="moveGroupId">
                            <div class="modal-header">
                                <h2>Departman Değiştir</h2>
                                <button type="button" class="close-btn" onclick="document.getElementById('moveGroupModal').classList.remove('active')" aria-label="Close">
                                    <svg viewBox="0 0 24 24" width="24" height="24"><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/></svg>
                                </button>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <label class="form-label">Grup</label>
                                    <input type="text" class="form-control" id="moveGroupName" disabled>
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="moveTargetDept">Hedef Departman</label>
                                    <select id="moveTargetDept" class="form-control" required></select>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-ghost" onclick="document.getElementById('moveGroupModal').classList.remove('active')">İptal</button>
                                <button type="submit" class="btn btn-primary">Taşı</button>
                            </div>
                        </form>
                    </div>
                `;
                document.body.appendChild(modal);
                
                document.getElementById('moveGroupForm').addEventListener('submit', async (ev) => {
                    ev.preventDefault();
                    const gId = document.getElementById('moveGroupId').value;
                    const newDeptId = document.getElementById('moveTargetDept').value;
                    
                    const g = window._groupsCache?.find(x => x.id == gId);
                    if (!g) return;
                    
                    try {
                        await window.api.request(`/Groups/${gId}`, {
                            method: 'PUT',
                            body: JSON.stringify({
                                name: g.name,
                                isActive: g.isActive,
                                departmentId: Number.parseInt(newDeptId, 10)
                            })
                        });
                        
                        document.getElementById('moveGroupModal').classList.remove('active');
                        window.ui?.showToast('Grup başarıyla taşındı.');
                        
                        // Invalidate caches and reload
                        window._groupsCache = null;
                        if (window.loadData) window.loadData();
                    } catch(err) {
                        console.error(err);
                        window.ui?.showToast('Grup taşınırken hata oluştu', 'error');
                    }
                });
            }
            
            document.getElementById('moveGroupId').value = currentGroup.id;
            document.getElementById('moveGroupName').value = currentGroup.name;
            
            const deptSelect = document.getElementById('moveTargetDept');
            deptSelect.innerHTML = window.currentData.map(d => `<option value="${d.id}" ${d.id == currentGroup.departmentId ? 'selected' : ''}>${window.ui?.escapeHtml(d.name)}</option>`).join('');
            
            modal.classList.add('active');
        }
    });

// --- Global User Tooltip Logic for Admin Configs ---
if (typeof document !== 'undefined') {
    document.addEventListener('DOMContentLoaded', () => {
        let userTooltip = document.getElementById('adminUserTooltip');
        if (!userTooltip) {
            userTooltip = document.createElement('div');
            userTooltip.id = 'adminUserTooltip';
            userTooltip.className = 'user-hover-tooltip';
            userTooltip.style.cssText = 'position:absolute; display:none; background:var(--bg-surface); border:1px solid var(--border); box-shadow:0 4px 12px rgba(0,0,0,0.15); padding:12px; border-radius:8px; z-index:10000; width:260px; pointer-events:none;';
            document.body.appendChild(userTooltip);

            document.addEventListener('mouseover', async (e) => {
                const target = e.target.closest('.user-hover-link');
                if (target && window._usersCache) {
                    const userId = target.getAttribute('data-user-id');
                    const user = window._usersCache.find(u => u.id == userId);
                    if (user) {
                        // Ensure we have depts and groups loaded globally if missing
                        if (!window._deptsCache && window.api) {
                            try { window._deptsCache = await window.api.request('/Departments'); } catch(err) { window._deptsCache = []; }
                        }
                        if (!window._groupsCache && window.api) {
                            try { window._groupsCache = await window.api.request('/Groups'); } catch(err) { window._groupsCache = []; }
                        }
                        
                        const dept = window._deptsCache?.find(d => d.id == user.departmentId)?.name || 'No Department';
                        const userGroups = user.groupIds && user.groupIds.length > 0 
                            ? user.groupIds.map(gid => window._groupsCache?.find(g => g.id == gid)?.name || `Group ${gid}`).join(', ') 
                            : 'No Groups';
                        const createdAt = user.createdAt ? new Date(user.createdAt).toLocaleDateString() : 'Unknown';

                        const initial = (user.firstName + ' ' + user.lastName).charAt(0).toUpperCase();
                        const avatarHtml = user.profilePhoto 
                            ? `<img src="${user.profilePhoto}" class="avatar" style="width:32px;height:32px;border-radius:50%;object-fit:cover;">`
                            : `<div class="avatar" style="width:32px;height:32px;font-size:14px;background:rgba(var(--primary-rgb),0.1);color:var(--primary);display:flex;align-items:center;justify-content:center;border-radius:50%;">${initial}</div>`;

                        userTooltip.innerHTML = `
                            <div style="display:flex; align-items:center; gap:12px; margin-bottom:8px; border-bottom:1px solid var(--border); padding-bottom:8px;">
                                ${avatarHtml}
                                <div>
                                    <div style="font-weight:600; font-size:14px;">${window.ui?.escapeHtml(user.firstName + ' ' + user.lastName)}</div>
                                    <div style="font-size:11px; color:var(--text-muted);">@${window.ui?.escapeHtml(user.username)}</div>
                                </div>
                            </div>
                            <div style="font-size:12px; display:flex; flex-direction:column; gap:4px;">
                                <div><strong style="color:var(--text-muted);">Joined:</strong> ${createdAt}</div>
                                <div><strong style="color:var(--text-muted);">Dept:</strong> ${window.ui?.escapeHtml(dept)}</div>
                                <div><strong style="color:var(--text-muted);">Groups:</strong> ${window.ui?.escapeHtml(userGroups)}</div>
                            </div>
                        `;
                        
                        const rect = target.getBoundingClientRect();
                        userTooltip.style.display = 'block';
                        
                        let top = rect.bottom + window.scrollY + 8;
                        let left = rect.left + window.scrollX;
                        if (top + userTooltip.offsetHeight > window.scrollY + window.innerHeight) top = rect.top + window.scrollY - userTooltip.offsetHeight - 8;
                        if (left + userTooltip.offsetWidth > window.scrollX + window.innerWidth) left = window.scrollX + window.innerWidth - userTooltip.offsetWidth - 12;
                        
                        userTooltip.style.top = top + 'px';
                        userTooltip.style.left = left + 'px';
                    }
                }
            });

            document.addEventListener('mouseout', (e) => {
                const target = e.target.closest('.user-hover-link');
                if (target) userTooltip.style.display = 'none';
            });
        }
    });
}
