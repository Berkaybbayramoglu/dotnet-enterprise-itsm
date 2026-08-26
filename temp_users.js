        import './js/api.js?v=2';
        import { bindShellActions, showToast, escapeHtml, showUndoToast, openModal, closeModal } from './js/ui.js?v=3';

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
                if (typeof closeModal === 'function') closeModal(target); else if (typeof window.closeModal === 'function') window.closeModal(target);
            } else if (typeof window[action] === 'function') {
                if (flag !== undefined) window[action](id, flag);
                else window[action](id);
            }
        });


        let currentData = [];
        let allRoles = [];
        let allPermissions = [];
        let itemToDelete = null;
        let activeUserId = null;

        window.loadData = async function() {
            try {
                currentData = await window.api.getUsers();
                allRoles = await window.api.getRoles();
                try { allPermissions = await window.api.getPermissions(); } catch (e) { console.error('Failed to load perms', e); }
                const tbody = document.querySelector('#dataTable tbody');
                tbody.innerHTML = '';
                
                if (currentData.length === 0) {
                    tbody.innerHTML = `<tr><td colspan="5" style="text-align: center; padding: var(--spacing-xl); color: var(--text-muted);">No users found.</td></tr>`;
                    return;
                }

                currentData.forEach(item => {
                    const tr = document.createElement('tr');
                    const badge = item.isActive ? '<span class="badge badge-success">Active</span>' : '<span class="badge badge-default">Inactive</span>';
                    tr.innerHTML = `
                        <td style="font-weight: 500;">${escapeHtml(item.firstName)} ${escapeHtml(item.lastName)}</td>
                        <td>${escapeHtml(item.username)}</td>
                        <td class="text-muted">${escapeHtml(item.email)}</td>
                        <td>${badge}</td>
                        <td>
                            <button type="button" class="btn btn-ghost" style="padding: 4px 8px;" data-action="openRolesModal" data-id="${item.id}">Roles</button>
                            <button type="button" class="btn btn-ghost" style="padding: 4px 8px;" data-action="openOverridesModal" data-id="${item.id}">Overrides</button>
                            <button type="button" class="btn btn-ghost" style="padding: 4px 8px;" data-action="openUserModal" data-id="${item.id}">Edit</button>
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
                showToast('Error loading users', 'error');
            }
        };

        window.openUserModal = function(id = null) {
            const form = document.getElementById('userForm');
            form.reset();
            document.getElementById('uId').value = id || '';
            document.getElementById('modalTitle').textContent = id ? 'Edit User' : 'New User';
            
            if (id) {
                const item = currentData.find(x => x.id === id);
                if (item) {
                    document.getElementById('uFirst').value = item.firstName;
                    document.getElementById('uLast').value = item.lastName;
                    document.getElementById('uUsername').value = item.username;
                    document.getElementById('uEmail').value = item.email;
                    document.getElementById('uActive').checked = item.isActive;
                }
                document.getElementById('uPassword').required = false;
            } else {
                document.getElementById('uPassword').required = true;
            }
            openModal('userModal');
        };

        window.openRolesModal = function(id) {
            activeUserId = id;
            const item = currentData.find(x => x.id === id);
            if (!item) return;
            
            document.getElementById('rUserName').textContent = item.username;
            
            // Populate select
            const select = document.getElementById('roleSelect');
            select.innerHTML = '<option value="">-- Select Role --</option>';
            allRoles.forEach(r => {
                if (!item.roleIds || !item.roleIds.includes(r.id)) {
                    select.innerHTML += `<option value="${r.id}">${escapeHtml(r.name)}</option>`;
                }
            });

            // Populate list
            const list = document.getElementById('roleList');
            list.innerHTML = '';
            if (!item.roleIds || item.roleIds.length === 0) {
                list.innerHTML = '<div class="text-muted" style="padding: 8px;">No roles assigned.</div>';
            } else {
                item.roleIds.forEach(rId => {
                    const r = allRoles.find(x => x.id === rId);
                    const label = r ? escapeHtml(r.name) : `Role #${rId}`;
                    list.innerHTML += `
                        <div class="role-item">
                            <span>${label}</span>
                            <button class="btn btn-ghost" style="color: var(--danger); padding: 2px 4px; font-size:12px;" data-action="revokeRole" data-id="${rId}">Revoke</button>
                        </div>
                    `;
                });
            }

            openModal('rolesModal');
        };

        window.openOverridesModal = function(id) {
            activeUserId = id;
            const item = currentData.find(x => x.id === id);
            if (!item) return;
            
            document.getElementById('oUserName').textContent = item.username;

            const list = document.getElementById('overrideList');
            list.innerHTML = '';
            
            allPermissions.forEach(p => {
                const overrideValue = item.permissionOverrides ? item.permissionOverrides[p.id] : undefined;
                const isGranted = overrideValue === true;
                const isRevoked = overrideValue === false;
                
                list.innerHTML += `
                    <div style="display: flex; align-items: center; justify-content: space-between; padding: 8px; border: 1px solid var(--border); border-radius: 4px;">
                        <span>${p.key} <small class="text-muted" style="display:block;">${p.name}</small></span>
                        <div style="display: flex; gap: 4px;">
                            <button type="button" class="btn ${isGranted ? 'btn-success' : 'btn-ghost'}" style="padding: 2px 8px; font-size:12px;" data-action="setOverride" data-id="${p.id}" data-flag="true">Allow</button>
                            <button type="button" class="btn ${isRevoked ? 'btn-danger' : 'btn-ghost'}" style="padding: 2px 8px; font-size:12px;" data-action="setOverride" data-id="${p.id}" data-flag="false">Deny</button>
                        </div>
                    </div>
                `;
            });

            openModal('overridesModal');
        };

        window.setOverride = async function(permId, isGranted) {
            if (!activeUserId) return;
            try {
                await window.api.setPermissionOverride(activeUserId, permId, isGranted);
                showToast('Override saved');
                loadData();
            } catch (err) {
                showToast('Failed to save override', 'error');
                loadData();
            }
        };

        document.getElementById('btnAssignRole').addEventListener('click', async () => {
            const roleId = document.getElementById('roleSelect').value;
            if (!roleId || !activeUserId) return;
            try {
                await window.api.assignRole(activeUserId, roleId);
                showToast('Role assigned');
        loadData(); // removed await for resilience
                window.openRolesModal(activeUserId);
            } catch (err) {
                showToast('Failed to assign role', 'error');
            }
        });

        window.revokeRole = async function(roleId) {
            if (!activeUserId) return;
            try {
                await window.api.revokeRole(activeUserId, roleId);
                showToast('Role revoked');
        loadData(); // removed await for resilience
                window.openRolesModal(activeUserId);
            } catch (err) {
                showToast('Failed to revoke role', 'error');
            }
        };

        window.promptDelete = async function(id) {
            const proceed = await showUndoToast('Öğe silinecek. Geri almak için tıklayın.', null, 4000);
            if (proceed) {
                try {
                    await window.api.deleteUser(id);
                    showToast('Silme işlemi tamamlandı');
                    loadData();
                } catch (e) {
                    showToast('Silme işlemi başarısız', 'error');
                }
            }
        };

        

        document.getElementById('userForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            const id = document.getElementById('uId').value;
            const data = {
                firstName: document.getElementById('uFirst').value.trim(),
                lastName: document.getElementById('uLast').value.trim(),
                username: document.getElementById('uUsername').value.trim(),
                email: document.getElementById('uEmail').value.trim(),
                isActive: document.getElementById('uActive').checked
            };
            
            const pwd = document.getElementById('uPassword').value;
            if (pwd) data.password = pwd; // DTO usually expects password
            
            try {
                if (id) await window.api.updateUser(id, data);
                else await window.api.createUser(data);
                
                closeModal('userModal');
                showToast('User saved');
        loadData(); // removed await for resilience
            } catch (err) {
                showToast('Failed to save user', 'error');
            }
        });

        loadData();
