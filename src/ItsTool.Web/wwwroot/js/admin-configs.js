export const adminConfigs = {
    departments: {
        endpoint: '/Departments', pageTitle: 'Departments',
        modalId: 'deptModal', createTitle: 'New Department', auditSafeDelete: true,
        formFields: { id: 'dId', map: { 'name': 'dName' } },
        columns: [
            { key: 'id', label: 'ID', render: (item) => `<span class="text-muted">#${item.id}</span>` },
            { key: 'name', label: 'Name', render: (item) => `<span style="font-weight: 500;">${window.ui?.escapeHtml(item.name || '')}</span>` }
        ],
        formHtml: `
            <div class="form-group">
                <label class="form-label" for="dName">Name *</label>
                <input id="dName" class="form-control" required placeholder="e.g. IT, HR, Finance">
            </div>`
    },
    categories: {
        endpoint: '/Categories', pageTitle: 'Categories',
        modalId: 'catModal', createTitle: 'New Category', auditSafeDelete: true,
        formFields: { id: 'cId', map: { 'name': 'cName', 'description': 'cDesc' } },
        columns: [
            { key: 'id', label: 'ID', render: (item) => `<span class="text-muted">#${item.id}</span>` },
            { key: 'name', label: 'Name', render: (item) => `<span style="font-weight: 500;">${window.ui?.escapeHtml(item.name || '')}</span>` },
            { key: 'description', label: 'Description' }
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
                if (statusStr === 'Warning') color = 'warning';
                return `<span class="badge badge-${color}">${statusStr}</span>`;
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
                </select>
            </div>`
    },
    groups: {
        endpoint: '/Groups', pageTitle: 'Groups',
        modalId: 'groupModal', createTitle: 'New Group', auditSafeDelete: true,
        formFields: { id: 'gId', map: { 'name': 'gName', 'description': 'gDesc' } },
        columns: [
            { key: 'id', label: 'ID', render: (item) => `<span class="text-muted">#${item.id}</span>` },
            { key: 'name', label: 'Name', render: (item) => `<span style="font-weight: 500;">${window.ui?.escapeHtml(item.name || '')}</span>` },
            { key: 'description', label: 'Description' }
        ],
        formHtml: `
            <div class="form-group">
                <label class="form-label" for="gName">Name *</label>
                <input id="gName" class="form-control" required placeholder="e.g. L1 Support">
            </div>
            <div class="form-group">
                <label class="form-label" for="gDesc">Description</label>
                <textarea id="gDesc" class="form-control" rows="3"></textarea>
            </div>`
    },
    roles: {
        endpoint: '/Roles', pageTitle: 'Roles',
        modalId: 'roleModal', createTitle: 'New Role', auditSafeDelete: true,
        formFields: { id: 'rId', map: { 'name': 'rName', 'description': 'rDesc', 'permissions': 'rPerms' } },
        columns: [
            { key: 'id', label: 'ID', render: (item) => `<span class="text-muted">#${item.id}</span>` },
            { key: 'name', label: 'Name', render: (item) => `<span style="font-weight: 500;">${window.ui?.escapeHtml(item.name || '')}</span>` },
            { key: 'description', label: 'Description' }
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
            </div>`
    }
};
