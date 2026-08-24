// ui.js - Reusable UI components

export function showToast(message, type = 'success') {
    let container = document.getElementById('toastContainer');
    if (!container) {
        container = document.createElement('div');
        container.id = 'toastContainer';
        container.className = 'toast-container';
        document.body.appendChild(container);
    }
    
    const toast = document.createElement('div');
    toast.className = `toast ${type}`;
    
    const icon = type === 'success' 
        ? '<svg viewBox="0 0 24 24" width="24" height="24" style="fill: var(--success);"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/></svg>'
        : '<svg viewBox="0 0 24 24" width="24" height="24" style="fill: var(--danger);"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"/></svg>';
        
    toast.innerHTML = `
        <div class="d-flex align-items-center gap-sm">
            ${icon}
            <span style="font-weight: 500;">${message}</span>
        </div>
    `;
    
    container.appendChild(toast);
    
    setTimeout(() => {
        toast.style.opacity = '0';
        toast.style.transform = 'translateX(100%)';
        toast.style.transition = 'all 0.3s ease';
        setTimeout(() => toast.remove(), 300);
    }, 3000);
}

let lastActiveElement = null;

export function openModal(modalId) {
    const overlay = document.getElementById(modalId);
    if (!overlay) return;
    
    lastActiveElement = document.activeElement;
    overlay.classList.add('active');
    
    // Focus first input
    const firstInput = overlay.querySelector('input, select, textarea, button');
    if (firstInput) {
        setTimeout(() => firstInput.focus(), 50);
    }

    // Backdrop click
    const clickHandler = (e) => {
        if (e.target === overlay) closeModal(modalId);
    };
    overlay.addEventListener('mousedown', clickHandler);
    overlay._backdropClickHandler = clickHandler;

    // Esc key
    const keyHandler = (e) => {
        if (e.key === 'Escape' && overlay.classList.contains('active')) {
            closeModal(modalId);
        }
    };
    document.addEventListener('keydown', keyHandler);
    overlay._escKeyHandler = keyHandler;
}

export function closeModal(modalId) {
    const overlay = document.getElementById(modalId);
    if (!overlay) return;
    
    overlay.classList.remove('active');
    
    if (overlay._backdropClickHandler) {
        overlay.removeEventListener('mousedown', overlay._backdropClickHandler);
        delete overlay._backdropClickHandler;
    }
    if (overlay._escKeyHandler) {
        document.removeEventListener('keydown', overlay._escKeyHandler);
        delete overlay._escKeyHandler;
    }
    
    if (lastActiveElement) {
        lastActiveElement.focus();
        lastActiveElement = null;
    }
}

export function bindShellActions() {
    const logoutBtn = document.getElementById('shellLogoutBtn');
    if (logoutBtn) {
        logoutBtn.addEventListener('click', () => {
            if(window.api) window.api.clearToken();
            window.location.reload();
        });
    }

    // Hamburger Menu Logic
    const mobileMenuBtn = document.getElementById('mobileMenuBtn');
    const sidebar = document.querySelector('.sidebar');
    const sidebarOverlay = document.getElementById('sidebarOverlay');
    
    if (mobileMenuBtn && sidebar && sidebarOverlay) {
        mobileMenuBtn.addEventListener('click', () => {
            sidebar.classList.toggle('open');
            sidebarOverlay.classList.toggle('active');
        });
        sidebarOverlay.addEventListener('click', () => {
            sidebar.classList.remove('open');
            sidebarOverlay.classList.remove('active');
        });
    }

    const currentPath = window.location.pathname;
    document.querySelectorAll('.sidebar-nav-item').forEach(l => {
        if (l.getAttribute('href') === currentPath) {
            l.classList.add('active');
        }
    });

    // RBAC Sidebar rendering
    if (window.api && window.api.token) {
        try {
            const payload = JSON.parse(atob(window.api.token.split('.')[1]));
            let perms = [];
            if (payload.Permissions) {
                perms = typeof payload.Permissions === 'string' ? [payload.Permissions] : payload.Permissions;
            }
            
            if (!perms.includes('config.manage')) {
                document.querySelectorAll('a[href="/projects.html"], a[href="/categories.html"], a[href="/departments.html"], a[href="/groups.html"], a[href="/users.html"], a[href="/roles.html"], a[href="/admin-fields.html"], a[href="/rules.html"], a[href="/webhooks.html"]').forEach(el => {
                    el.style.display = 'none';
                });
                // Hide administration section title
                const adminTitle = Array.from(document.querySelectorAll('.sidebar-nav-title')).find(el => el.textContent.includes('Administration'));
                if (adminTitle) adminTitle.style.display = 'none';
            }
            if (!perms.includes('audit.view')) {
                const auditLink = document.querySelector('a[href="/audit-log.html"]');
                if (auditLink) auditLink.style.display = 'none';
            }
        } catch (e) {
            console.error('Failed to parse token permissions', e);
        }
    }
}

export function openTicketPreview(t, lookupData) {
    let modalOverlay = document.getElementById('previewModal');
    if (!modalOverlay) {
        modalOverlay = document.createElement('div');
        modalOverlay.id = 'previewModal';
        modalOverlay.className = 'modal-overlay';
        modalOverlay.innerHTML = `
            <div class="modal" style="max-width: 500px;">
                <div class="modal-header">
                    <h2>Ticket Preview</h2>
                    <button type="button" class="close-btn" onclick="closeModal('previewModal')" aria-label="Close">
                        <svg viewBox="0 0 24 24" width="24" height="24"><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/></svg>
                    </button>
                </div>
                <div class="modal-body" id="previewContent"></div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-ghost" onclick="closeModal('previewModal')">Close</button>
                    <a href="#" id="previewDetailLink" class="btn btn-primary">Detaya Git</a>
                </div>
            </div>
        `;
        document.body.appendChild(modalOverlay);
        if (!window.closeModal) window.closeModal = closeModal;
    }

    const content = document.getElementById('previewContent');
    const projName = lookupData.projects?.find(x => x.id === t.projectId)?.name || '-';
    const catName = lookupData.categories?.find(x => x.id === t.categoryId)?.name || '-';
    const prioName = lookupData.priorities?.find(x => x.id === t.priorityId)?.name || 'Normal';
    const prioColors = { 'Critical': 'danger', 'High': 'warning', 'Medium': 'info', 'Low': 'success' };
    const prioColor = prioColors[prioName] || 'default';
    const statusName = lookupData.statuses?.find(x => x.id === t.statusId)?.name || 'Unknown';
    const assigneeName = t.assignedUserId ? `User ${t.assignedUserId}` : 'Atanmamış';
    const reqName = t.requesterUserId ? `User ${t.requesterUserId}` : 'Unknown';
    
    const formatDate = (d) => {
        if(!d) return '-';
        const date = new Date(d);
        return isNaN(date.getTime()) ? '-' : date.toLocaleString('tr-TR', { dateStyle: 'short', timeStyle: 'short' });
    };

    const escapeHtml = (unsafe) => (unsafe || '').toString().replaceAll('&', "&amp;").replaceAll('<', "&lt;").replaceAll('>', "&gt;").replaceAll('"', "&quot;").replaceAll("'", "&#039;");
    const getAvatar = (id, fallback) => {
        if (!id || id === '-') return `<div class="avatar" style="background: var(--bg-hover); color: var(--text-muted); border: 1px dashed var(--border);">?</div>`;
        return `<div class="avatar" title="${fallback}">${String(fallback || id).charAt(0).toUpperCase()}</div>`;
    };

    const headerEl = modalOverlay.querySelector('.modal-header h2');
    if (headerEl) {
        headerEl.innerHTML = `${escapeHtml(t.ticketNumber)} <span class="badge badge-primary" style="font-size: 12px; margin-left: 8px;">${escapeHtml(statusName)}</span>`;
    }

    content.innerHTML = `
        <div style="font-size: 16px; font-weight: 600; margin-bottom: var(--spacing-md); color: var(--text);">${escapeHtml(t.title)}</div>
        <div style="display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden; margin-bottom: var(--spacing-md); color: var(--text-muted); font-size: 14px;">
            ${escapeHtml(t.description || '')}
        </div>
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: var(--spacing-md); background: var(--bg-hover); padding: var(--spacing-md); border-radius: var(--radius-md);">
            <div><div style="font-size: 12px; color: var(--text-muted); margin-bottom: 4px;">Priority</div><span class="badge badge-${prioColor}">${escapeHtml(prioName)}</span></div>
            <div><div style="font-size: 12px; color: var(--text-muted); margin-bottom: 4px;">Project / Category</div><div style="font-size: 14px; font-weight: 500;">${escapeHtml(projName)} <span style="color:var(--text-muted);">/</span> ${escapeHtml(catName)}</div></div>
            <div><div style="font-size: 12px; color: var(--text-muted); margin-bottom: 4px;">Requester</div><div style="display: flex; align-items: center; gap: 8px; font-size: 14px;">${getAvatar(t.requesterUserId, reqName)} ${escapeHtml(reqName)}</div></div>
            <div><div style="font-size: 12px; color: var(--text-muted); margin-bottom: 4px;">Assignee</div><div style="display: flex; align-items: center; gap: 8px; font-size: 14px;">${t.assignedUserId ? getAvatar(t.assignedUserId, assigneeName) : ''} ${escapeHtml(assigneeName)}</div></div>
            <div><div style="font-size: 12px; color: var(--text-muted); margin-bottom: 4px;">SLA Status</div><span class="badge badge-success">On Track</span></div>
            <div><div style="font-size: 12px; color: var(--text-muted); margin-bottom: 4px;">Created At</div><div style="font-size: 14px;">${formatDate(t.createdAt)}</div></div>
        </div>
    `;
    document.getElementById('previewDetailLink').href = `/ticket-detail.html?id=${t.id}`;
    openModal('previewModal');
}
