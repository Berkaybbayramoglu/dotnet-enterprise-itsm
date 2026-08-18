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

export function openModal(modalId) {
    const overlay = document.getElementById(modalId);
    if (overlay) overlay.classList.add('active');
}

export function closeModal(modalId) {
    const overlay = document.getElementById(modalId);
    if (overlay) overlay.classList.remove('active');
}

export function bindShellActions() {
    const logoutBtn = document.getElementById('shellLogoutBtn');
    if (logoutBtn) {
        logoutBtn.addEventListener('click', () => {
            if(window.api) window.api.clearToken();
            window.location.reload();
        });
    }

    const currentPath = window.location.pathname;
    document.querySelectorAll('.sidebar-nav-item').forEach(l => {
        if (l.getAttribute('href') === currentPath) {
            l.classList.add('active');
        }
    });
}
