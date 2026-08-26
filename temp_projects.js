        import './js/api.js?v=2';
        import { bindShellActions, showToast, escapeHtml, showUndoToast } from './js/ui.js?v=2';

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
        let itemToDelete = null;

        window.loadData = async function() {
            try {
                currentData = await window.api.getProjects();
                const tbody = document.querySelector('#dataTable tbody');
                tbody.innerHTML = '';
                
                if (currentData.length === 0) {
                    tbody.innerHTML = `<tr><td colspan="5" style="text-align: center; padding: var(--spacing-xl); color: var(--text-muted);">No projects found.</td></tr>`;
                    return;
                }

                currentData.forEach(item => {
                    const tr = document.createElement('tr');
                    const badge = item.isActive ? '<span class="badge badge-success">Active</span>' : '<span class="badge badge-default">Inactive</span>';
                    tr.innerHTML = `
                        <td class="text-muted">#${item.id}</td>
                        <td style="font-weight: 500;">${escapeHtml(item.projectKey)}</td>
                        <td>${escapeHtml(item.name)}</td>
                        <td>${badge}</td>
                        <td>
                            <button type="button" class="btn btn-ghost" style="padding: 4px 8px;" data-action="openProjectModal" data-id="${item.id}">Edit</button>
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
                showToast('Error loading projects', 'error');
            }
        };

        window.openProjectModal = function(id = null) {
            const form = document.getElementById('projectForm');
            form.reset();
            document.getElementById('pId').value = id || '';
            document.getElementById('modalTitle').textContent = id ? 'Edit Project' : 'New Project';
            
            if (id) {
                const item = currentData.find(x => x.id === id);
                if (item) {
                    document.getElementById('pName').value = item.name;
                    document.getElementById('pKey').value = item.projectKey;
                    document.getElementById('pActive').checked = item.isActive;
                }
            }
            openModal('projectModal');
        };

        window.promptDelete = async function(id) {
            const proceed = await showUndoToast('Öğe silinecek. Geri almak için tıklayın.', null, 4000);
            if (proceed) {
                try {
                    await window.api.deleteProject(id);
                    showToast('Silme işlemi tamamlandı');
                    loadData();
                } catch (e) {
                    showToast('Silme işlemi başarısız', 'error');
                }
            }
        };

        

        document.getElementById('projectForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            const id = document.getElementById('pId').value;
            const data = {
                name: document.getElementById('pName').value.trim(),
                projectKey: document.getElementById('pKey').value.trim(),
                isActive: document.getElementById('pActive').checked
            };
            
            try {
                if (id) await window.api.updateProject(id, data);
                else await window.api.createProject(data);
                
                closeModal('projectModal');
                showToast('Project saved');
        loadData(); // removed await for resilience
            } catch (err) {
                showToast('Failed to save project', 'error');
            }
        });

        loadData();
