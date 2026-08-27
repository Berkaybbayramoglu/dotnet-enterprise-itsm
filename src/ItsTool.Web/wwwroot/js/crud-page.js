export function initCrudPage(cfg) {
    const { endpoint, formFields, modalId, createTitle, auditSafeDelete, columns, rootId, pageTitle, formHtml } = cfg;
    
    // 1. RENDER SKELETON
    const root = document.getElementById(rootId || 'crudRoot');
    root.innerHTML = `
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: var(--spacing-lg);">
            <h1 style="font-size: 24px; font-weight: 600; color: var(--text-main); margin: 0;">${pageTitle}</h1>
            <button class="btn btn-primary" onclick="window.openCrudModal()">+ New ${pageTitle}</button>
        </div>
        <div class="card" style="padding: 0;">
            <div style="overflow-x: auto;">
                <table class="table" id="dataTable">
                    <thead>
                        <tr>
                            ${columns.map(c => `<th>${c.label || (c.key.charAt(0).toUpperCase() + c.key.slice(1))}</th>`).join('')}
                            <th style="width: 100px;">Actions</th>
                        </tr>
                    </thead>
                    <tbody id="dataTableBody"></tbody>
                </table>
            </div>
        </div>
        
        <!-- Modal -->
        <div id="${modalId}" class="modal-overlay">
            <div class="modal">
                <form id="${modalId}Form">
                    <input type="hidden" id="${formFields.id}">
                    <div class="modal-header">
                        <h2 id="${modalId}Title">New Record</h2>
                        <button type="button" class="close-btn" data-action="closeModal" data-target="${modalId}" aria-label="Close">
                            <svg viewBox="0 0 24 24" width="24" height="24"><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/></svg>
                        </button>
                    </div>
                    <div class="modal-body" id="modalFormBody">
                        ${formHtml || ''}
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-ghost" data-action="closeModal" data-target="${modalId}">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save</button>
                    </div>
                </form>
            </div>
        </div>
    `;

    const tbody = document.getElementById('dataTableBody');
    const form = document.getElementById(`${modalId}Form`);
    const modalTitleEl = document.getElementById(`${modalId}Title`);
    let currentData = [];

    // Helper: renderTable
    const buildCellHtml = (item, col) => {
        if (col.render) return `<td>${col.render(item)}</td>`;
        return `<td>${window.ui?.escapeHtml(item[col.key] || '')}</td>`;
    };

    const renderTable = (data) => {
        if (data.length === 0) {
            tbody.innerHTML = '<tr><td colspan="100" style="text-align: center; padding: 20px; color: var(--text-muted);">No records found</td></tr>';
            return;
        }
        
        tbody.innerHTML = '';
        data.forEach(item => {
            const tr = document.createElement('tr');
            let html = columns.map(col => buildCellHtml(item, col)).join('');
            html += `
                <td>
                    <button type="button" class="btn btn-ghost" style="padding: 4px 8px;" data-action="edit" data-id="${item.id}">Edit</button>
                    <button type="button" class="btn btn-ghost" style="color: var(--danger); padding: 4px 8px;" data-action="delete" data-id="${item.id}">Del</button>
                </td>
            `;
            tr.innerHTML = html;
            tbody.appendChild(tr);
        });
    };

    window.loadData = async function() {
        if (!window.api.token) return;
        try {
            tbody.innerHTML = '<tr><td colspan="100" style="text-align: center; padding: 20px;">Loading...</td></tr>';
            currentData = (await window.api.request(endpoint)) || [];
            window.currentData = currentData;
            renderTable(currentData);
            
            // Check for highlight parameter
            const urlParams = new URLSearchParams(window.location.search);
            const highlightId = urlParams.get('highlight');
            if (highlightId) {
                setTimeout(() => {
                    const row = document.querySelector(`tr[data-id="${highlightId}"]`) || 
                                Array.from(document.querySelectorAll('tr')).find(r => r.textContent.includes(`#${highlightId}`));
                    if (row) {
                        row.scrollIntoView({ behavior: 'smooth', block: 'center' });
                        row.classList.add('row-highlight');
                    }
                }, 100);
            }
        } catch (err) {
            console.error(err);
            tbody.innerHTML = `<tr><td colspan="100" style="text-align: center; padding: var(--spacing-xl); color: var(--danger);">Veri yüklenemedi</td></tr>`;
            if (window.ui?.showToast) window.ui.showToast('Error loading data', 'error');
        }
    };

    const populateForm = (item) => {
        if (!item) return;
        for (const key in formFields.map) {
            const input = document.getElementById(formFields.map[key]);
            if (input) input[input.type === 'checkbox' ? 'checked' : 'value'] = item[key] || '';
        }
    };

    window.openCrudModal = function(id = null) {
        form.reset();
        document.getElementById(formFields.id).value = id || '';
        modalTitleEl.textContent = id ? 'Edit' : (createTitle || 'New Record');
        
        if (id) populateForm(currentData.find(x => x.id === id));
        if (window.ui?.openModal) window.ui.openModal(modalId);
    };

    const getFormData = () => {
        const id = document.getElementById(formFields.id).value;
        const payload = {};
        for (const key in formFields.map) {
            const input = document.getElementById(formFields.map[key]);
            if (input) payload[key] = input.type === 'checkbox' ? input.checked : input.value;
        }
        return { id, payload };
    };

    const persistData = async (id, payload) => {
        if (id) {
            await window.api.request(`${endpoint}/${id}`, { method: 'PUT', body: JSON.stringify(payload) });
            if (window.ui?.showToast) window.ui.showToast('Record updated successfully');
        } else {
            await window.api.request(endpoint, { method: 'POST', body: JSON.stringify(payload) });
            if (window.ui?.showToast) window.ui.showToast('Record created successfully');
        }
    };

    const submitForm = async (e) => {
        e.preventDefault();
        const { id, payload } = getFormData();
        try {
            await persistData(id, payload);
            if (window.ui?.closeModal) window.ui.closeModal(modalId);
            await window.loadData();
        } catch (err) {
            console.error(err);
            if (window.ui?.showToast) window.ui.showToast(err.message || 'Error saving record', 'error');
        }
    };

    const performUndoableDelete = async (id, item, tr) => {
        const payload = { ...item };
        delete payload.id;
        if (tr) tr.remove();
        
        await window.api.request(`${endpoint}/${id}`, { method: 'DELETE' });
        window.ui.showUndoToast('Record deleted', async () => {
            try {
                await window.api.request(endpoint, { method: 'POST', body: JSON.stringify(payload) });
                await window.loadData();
                window.ui.showToast('Delete undone successfully');
            } catch(err) {
                console.error(err);
                window.ui.showToast('Failed to undo', 'error');
            }
        });
    };

    const deleteRecord = async (id, tr) => {
        try {
            if (auditSafeDelete && window.ui?.showUndoToast) {
                await performUndoableDelete(id, currentData.find(x => x.id === id), tr);
            } else {
                await window.api.request(`${endpoint}/${id}`, { method: 'DELETE' });
                if (window.ui?.showToast) window.ui.showToast('Record deleted successfully');
                await window.loadData();
            }
        } catch (err) {
            console.error(err);
            if (window.ui?.showToast) window.ui.showToast(err.message || 'Error deleting record', 'error');
            await window.loadData();
        }
    };

    const wireActions = async (e) => {
        const editBtn = e.target.closest('[data-action="edit"]');
        if (editBtn) window.openCrudModal(Number.parseInt(editBtn.dataset.id, 10));

        const delBtn = e.target.closest('[data-action="delete"]');
        if (delBtn) {
            if (!confirm('Are you sure you want to delete this record?')) return;
            await deleteRecord(Number.parseInt(delBtn.dataset.id, 10), delBtn.closest('tr'));
        }

        const closeBtn = e.target.closest('[data-action="closeModal"]');
        if (closeBtn) {
            const target = closeBtn.dataset.target;
            if (target && window.ui?.closeModal) window.ui.closeModal(target);
        }
    };

    form.addEventListener('submit', submitForm);
    document.addEventListener('click', wireActions);
}
