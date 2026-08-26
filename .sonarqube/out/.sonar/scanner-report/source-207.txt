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
                if (typeof closeModal === 'function') closeModal(target); else if (typeof window.closeModal === 'function') window.closeModal(target);
            } else if (typeof window[action] === 'function') {
                if (flag !== undefined) window[action](id, flag);
                else window[action](id);
            }
        });


        let currentData = [];
        let allUsers = [];
        let itemToDelete = null;
        let activeGroupId = null;

        window.loadData = async function() {
            try {
                currentData = await window.api.getGroups();
                allUsers = await window.api.getUsers();
                const tbody = document.querySelector('#dataTable tbody');
                tbody.innerHTML = '';
                
                if (currentData.length === 0) {
                    tbody.innerHTML = `<tr><td colspan="5" style="text-align: center; padding: var(--spacing-xl); color: var(--text-muted);">No groups found.</td></tr>`;
                    return;
                }

                currentData.forEach(item => {
                    const tr = document.createElement('tr');
                    const memCount = item.memberIds ? item.memberIds.length : 0;
                    tr.innerHTML = `
                        <td class="text-muted">#${item.id}</td>
                        <td style="font-weight: 500;">${escapeHtml(item.name)}</td>
                        <td class="text-muted">${item.departmentId || '-'}</td>
                        <td>${memCount} members</td>
                        <td>
                            <button type="button" class="btn btn-ghost" style="padding: 4px 8px;" data-action="openMembersModal" data-id="${item.id}">Members</button>
                            <button type="button" class="btn btn-ghost" style="padding: 4px 8px;" data-action="openGroupModal" data-id="${item.id}">Edit</button>
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
                showToast('Error loading groups', 'error');
            }
        };

        window.openGroupModal = function(id = null) {
            const form = document.getElementById('groupForm');
            form.reset();
            document.getElementById('gId').value = id || '';
            document.getElementById('modalTitle').textContent = id ? 'Edit Group' : 'New Group';
            
            if (id) {
                const item = currentData.find(x => x.id === id);
                if (item) {
                    document.getElementById('gName').value = item.name;
                    document.getElementById('gDept').value = item.departmentId || '';
                }
            }
            openModal('groupModal');
        };

        window.openMembersModal = function(id) {
            activeGroupId = id;
            const item = currentData.find(x => x.id === id);
            if (!item) return;
            
            document.getElementById('mGroupName').textContent = item.name;
            
            // Populate select
            const select = document.getElementById('userSelect');
            select.innerHTML = '<option value="">-- Select User --</option>';
            allUsers.forEach(u => {
                if (!item.memberIds || !item.memberIds.includes(u.id)) {
                    select.innerHTML += `<option value="${u.id}">${escapeHtml(u.firstName + ' ' + u.lastName)} (${escapeHtml(u.username)})</option>`;
                }
            });

            // Populate list
            const list = document.getElementById('memberList');
            list.innerHTML = '';
            if (!item.memberIds || item.memberIds.length === 0) {
                list.innerHTML = '<div class="text-muted" style="padding: 8px;">No members yet.</div>';
            } else {
                item.memberIds.forEach(uId => {
                    const u = allUsers.find(x => x.id === uId);
                    const label = u ? escapeHtml(`${u.firstName} ${u.lastName} (${u.username})`) : `User #${uId}`;
                    list.innerHTML += `
                        <div class="member-item">
                            <span>${label}</span>
                            <button class="btn btn-ghost" style="color: var(--danger); padding: 2px 4px; font-size:12px;" data-action="removeMember" data-id="${uId}">Remove</button>
                        </div>
                    `;
                });
            }

            openModal('membersModal');
        };

        document.getElementById('btnAddMember').addEventListener('click', async () => {
            const userId = document.getElementById('userSelect').value;
            if (!userId || !activeGroupId) return;
            try {
                await window.api.addGroupMember(activeGroupId, userId);
                showToast('Member added');
        loadData(); // removed await for resilience
                window.openMembersModal(activeGroupId);
            } catch (err) {
                showToast('Failed to add member', 'error');
            }
        });

        window.removeMember = async function(userId) {
            if (!activeGroupId) return;
            try {
                await window.api.removeGroupMember(activeGroupId, userId);
                showToast('Member removed');
        loadData(); // removed await for resilience
                window.openMembersModal(activeGroupId);
            } catch (err) {
                showToast('Failed to remove member', 'error');
            }
        };

        window.promptDelete = async function(id) {
            const proceed = await showUndoToast('Öğe silinecek. Geri almak için tıklayın.', null, 4000);
            if (proceed) {
                try {
                    await window.api.deleteGroup(id);
                    showToast('Silme işlemi tamamlandı');
                    loadData();
                } catch (e) {
                    showToast('Silme işlemi başarısız', 'error');
                }
            }
        };

        

        document.getElementById('groupForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            const id = document.getElementById('gId').value;
            const data = {
                name: document.getElementById('gName').value.trim(),
                departmentId: document.getElementById('gDept').value ? parseInt(document.getElementById('gDept').value) : null
            };
            
            try {
                if (id) await window.api.updateGroup(id, data);
                else await window.api.createGroup(data);
                
                closeModal('groupModal');
                showToast('Group saved');
        loadData(); // removed await for resilience
            } catch (err) {
                showToast('Failed to save group', 'error');
            }
        });

        loadData();
