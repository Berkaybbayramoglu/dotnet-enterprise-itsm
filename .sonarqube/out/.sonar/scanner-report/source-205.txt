        import './js/api.js';
        import { bindShellActions, showToast, escapeHtml, showUndoToast } from './js/ui.js';

        if (!window.api.token) window.location.href = '/login.html';
        bindShellActions();

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


        let currentData = [];
        let itemToDelete = null;
        let activeRoleId = null;
        let allPermissions = [];

        window.loadData = async function() {
            try {
                currentData = await window.api.getRoles();
                try { allPermissions = await window.api.getPermissions(); } catch (e) { console.error('Failed to load perms', e); }
                const tbody = document.querySelector('#dataTable tbody');
                tbody.innerHTML = '';
                
                if (currentData.length === 0) {
                    tbody.innerHTML = `<tr><td colspan="3" style="text-align: center; padding: var(--spacing-xl); color: var(--text-muted);">No roles found.</td></tr>`;
                    return;
                }

                currentData.forEach(item => {
                    const tr = document.createElement('tr');
                    tr.innerHTML = `
                        <td class="text-muted">#${item.id}</td>
                        <td style="font-weight: 500;">${escapeHtml(item.name)}</td>
                        <td>
                            <button type="button" class="btn btn-ghost" style="padding: 4px 8px;" data-action="openPermsModal" data-id="${item.id}">Perms</button>
                            <button type="button" class="btn btn-ghost" style="padding: 4px 8px;" data-action="openRoleModal" data-id="${item.id}">Edit</button>
                            <button type="button" class="btn btn-ghost" style="color: var(--danger); padding: 4px 8px;" data-action="promptDelete" data-id="${item.id}">Del</button>
                        </td>
                    `;
                    tbody.appendChild(tr);
                });
            } catch (err) {
                let errEl = document.querySelector('tbody') || document.querySelector('#overviewCards') || document.querySelector('#board') || document.querySelector('#articleList') || document.querySelector('.content-area');
                if (errEl) {
                    if (errEl.tagName === 'TBODY') {
                        errEl.innerHTML = '<tr><td colspan="100" style="text-align: center; padding: var(--spacing-xl); color: var(--danger);">Veri yüklenemedi — API\'yi kontrol et</td></tr>';
                    } else {
                        errEl.innerHTML = '<div style="padding: 20px; text-align: center; color: var(--danger);">Veri yüklenemedi — API\'yi kontrol et</div>';
                    }
                }

                console.error(err);
                showToast('Error loading roles', 'error');
            }
        };

        window.openRoleModal = function(id = null) {
            const form = document.getElementById('roleForm');
            form.reset();
            document.getElementById('rId').value = id || '';
            document.getElementById('modalTitle').textContent = id ? 'Edit Role' : 'New Role';
            
            if (id) {
                const item = currentData.find(x => x.id === id);
                if (item) {
                    document.getElementById('rName').value = item.name;
                }
            }
            openModal('roleModal');
        };

        window.openPermsModal = function(id) {
            activeRoleId = id;
            const item = currentData.find(x => x.id === id);
            if (!item) return;
            
            document.getElementById('pRoleName').textContent = item.name;

            // Populate list
            const list = document.getElementById('permList');
            list.innerHTML = '';
            
            allPermissions.forEach(p => {
                const isAssigned = item.permissionIds && item.permissionIds.includes(p.id);
                list.innerHTML += `
                    <label style="display: flex; align-items: center; gap: 8px; padding: 8px; border: 1px solid var(--border); border-radius: 4px; cursor: pointer;">
                        <input type="checkbox" onchange="window.togglePerm(${p.id}, this.checked)" ${isAssigned ? 'checked' : ''}>
                        <span>${p.key} <small class="text-muted" style="display:block;">${p.name}</small></span>
                    </label>
                `;
            });

            openModal('permsModal');
        };

        window.togglePerm = async function(permId, isChecked) {
            if (!activeRoleId) return;
            try {
                if (isChecked) {
                    await window.api.assignPermission(activeRoleId, permId);
                    showToast('Permission assigned');
                } else {
                    await window.api.revokePermission(activeRoleId, permId);
                    showToast('Permission revoked');
                }
                loadData();
            } catch (err) {
                showToast('Failed to update permission', 'error');
                loadData();
            }
        };

        window.promptDelete = async function(id) {
            const proceed = await showUndoToast('Öğe silinecek. Geri almak için tıklayın.', null, 4000);
            if (proceed) {
                try {
                    await window.api.deleteRole(id);
                    showToast('Silme işlemi tamamlandı');
                    loadData();
                } catch (e) {
                    showToast('Silme işlemi başarısız', 'error');
                }
            }
        };

        

        document.getElementById('roleForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            const id = document.getElementById('rId').value;
            const data = {
                name: document.getElementById('rName').value.trim()
            };
            
            try {
                if (id) await window.api.updateRole(id, data);
                else await window.api.createRole(data);
                
                closeModal('roleModal');
                showToast('Role saved');
        loadData(); // removed await for resilience
            } catch (err) {
                showToast('Failed to save role', 'error');
            }
        });

        loadData();
