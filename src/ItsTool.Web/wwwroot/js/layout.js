import { initNotifications } from './notifications.js?v=3';

export function injectShell() {
    // Inject SignalR script
    if (!document.querySelector('script[src="js/lib/signalr.min.js"]')) {
        const script = document.createElement('script');
        script.src = 'js/lib/signalr.min.js';
        script.onload = () => initNotifications();
        document.head.appendChild(script);
    } else {
        initNotifications();
    }

    // Inject CSS for Dropdown
    if (!document.getElementById('bell-dropdown-style')) {
        const style = document.createElement('style');
        style.id = 'bell-dropdown-style';
        style.innerHTML = `
            .dropdown-menu { display: none; position: absolute; right: 0; top: 100%; background: var(--bg-surface); border: 1px solid var(--border); border-radius: var(--radius-md); box-shadow: 0 4px 12px rgba(0,0,0,0.15); z-index: 1000; list-style: none; padding: 0; margin: 8px 0 0 0; }
            .dropdown-menu.show { display: block; }
            .dropdown-item { display: block; padding: 8px 16px; color: var(--text-main); text-decoration: none; cursor: pointer; }
            .dropdown-item:hover, .dropdown-item.active { background: var(--bg-hover); }
            .dropdown-header { padding: 8px 16px; margin:0; font-size: 14px; font-weight: 600; color: var(--text-main); }
            .dropdown-divider { height: 1px; margin: 8px 0; overflow: hidden; background-color: var(--border); border: none; }
        `;
        document.head.appendChild(style);
    }

    const shellHtml = `
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <svg viewBox="0 0 24 24" width="24" height="24" style="fill: var(--primary); margin-right: 8px;"><path d="M12 2L2 22h20L12 2zm0 3.83L18.17 19H5.83L12 5.83z"/></svg> ITSM Tool
            </div>
            <nav class="sidebar-nav">
                <a href="/dashboard.html" class="sidebar-nav-item">
                    <svg viewBox="0 0 24 24"><path d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z"/></svg> Dashboard
                </a>
                <a href="/tickets.html" class="sidebar-nav-item">
                    <svg viewBox="0 0 24 24"><path d="M3 3v18h18V3H3zm16 16H5V5h14v14zM7 7h10v2H7zm0 4h10v2H7zm0 4h7v2H7z"/></svg> Tickets
                </a>
                <a href="/kanban.html" class="sidebar-nav-item">
                    <svg viewBox="0 0 24 24"><path d="M3 3v18h18V3H3zm6 14H5V5h4v12zm6 0h-4V5h4v12zm6 0h-4V5h4v12z"/></svg> Kanban
                </a>
                <a href="/kb.html" class="sidebar-nav-item">
                    <svg viewBox="0 0 24 24"><path d="M14 2H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 1.99 2H18c1.1 0 2-.9 2-2V8l-6-6zm2 16H8v-2h8v2zm0-4H8v-2h8v2zm-3-5V3.5L18.5 9H13z"/></svg> Knowledge Base
                </a>
                
                <div class="sidebar-nav-title" style="padding: 16px 20px 8px; font-size: 11px; text-transform: uppercase; color: var(--text-muted); font-weight: 600; letter-spacing: 0.5px;">Administration</div>
                <a href="/admin-crud.html?type=projects" class="sidebar-nav-item" data-type="projects">
                    <svg viewBox="0 0 24 24"><path d="M4 4h16v16H4V4zm2 2v12h12V6H6zm2 2h8v2H8V8zm0 4h8v2H8v-2z"/></svg> Projects
                </a>
                <a href="/admin-crud.html?type=categories" class="sidebar-nav-item" data-type="categories">
                    <svg viewBox="0 0 24 24"><path d="M3 3h8v8H3V3zm10 0h8v8h-8V3zM3 13h8v8H3v-8zm15 0h-2v3h-3v2h3v3h2v-3h3v-2h-3v-3z"/></svg> Categories
                </a>
                <a href="/admin-crud.html?type=departments" class="sidebar-nav-item" data-type="departments">
                    <svg viewBox="0 0 24 24"><path d="M12 7V3H2v18h20V7H12zM6 19H4v-2h2v2zm0-4H4v-2h2v2zm0-4H4V9h2v2zm0-4H4V5h2v2zm4 12H8v-2h2v2zm0-4H8v-2h2v2zm0-4H8V9h2v2zm0-4H8V5h2v2zm10 12h-8v-2h2v-2h-2v-2h2v-2h-2V9h8v10zm-2-8h-2v2h2v-2zm0 4h-2v2h2v-2z"/></svg> Departments
                </a>
                <a href="/admin-crud.html?type=groups" class="sidebar-nav-item" data-type="groups">
                    <svg viewBox="0 0 24 24"><path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/></svg> Groups
                </a>
                <a href="/users.html" class="sidebar-nav-item">
                    <svg viewBox="0 0 24 24"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg> Users
                </a>
                <a href="/admin-crud.html?type=roles" class="sidebar-nav-item" data-type="roles">
                    <svg viewBox="0 0 24 24" width="20" height="20" style="fill: currentColor; opacity: 0.7;"><path d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4zm-2 16l-4-4 1.41-1.41L10 14.17l6.59-6.59L18 9l-8 8z"/></svg> Roles
                </a>
                <a href="/admin-crud.html?type=permissions" class="sidebar-nav-item" data-type="permissions">
                    <svg viewBox="0 0 24 24" width="20" height="20" style="fill: currentColor; opacity: 0.7;"><path d="M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm-6 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zm3.1-9H8.9V6c0-1.71 1.39-3.1 3.1-3.1 1.71 0 3.1 1.39 3.1 3.1v2z"/></svg> Permissions
                </a>
                <a href="/audit-log.html" class="sidebar-nav-item">
                    <svg viewBox="0 0 24 24"><path d="M19 3h-4.18C14.4 1.84 13.3 1 12 1c-1.3 0-2.4.84-2.82 2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 0c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm2 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/></svg> Audit Logs
                </a>
                <a href="/webhooks.html" class="sidebar-nav-item">
                    <svg viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm5 11h-4v4h-2v-4H7v-2h4V7h2v4h4v2z"/></svg> Webhooks
                </a>
                <a href="/admin-fields.html" class="sidebar-nav-item">
                    <svg viewBox="0 0 24 24"><path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm0 16H5V5h14v14zM7 10h2v7H7zm4-3h2v10h-2zm4 6h2v4h-2z"/></svg> Custom Fields
                </a>
                <a href="/rules.html" class="sidebar-nav-item">
                    <svg viewBox="0 0 24 24"><path d="M19 15v4H5v-4h14m1-2H4c-.55 0-1 .45-1 1v6c0 .55.45 1 1 1h16c.55 0 1-.45 1-1v-6c0-.55-.45-1-1-1zM7 18.5c-.82 0-1.5-.67-1.5-1.5s.68-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5zM19 5v4H5V5h14m1-2H4c-.55 0-1 .45-1 1v6c0 .55.45 1 1 1h16c.55 0 1-.45 1-1V4c0-.55-.45-1-1-1zM7 8.5c-.82 0-1.5-.67-1.5-1.5S6.18 5.5 7 5.5s1.5.67 1.5 1.5S7.82 8.5 7 8.5z"/></svg> Automations
                </a>
            </nav>
        </aside>

        
    `;

    const shellContainer = document.querySelector('[data-shell]');
    if (shellContainer) {
        shellContainer.insertAdjacentHTML('afterbegin', shellHtml);
        
        // Active link highlighting
        const path = window.location.pathname;
        const search = window.location.search;
        let activeLink = document.querySelector(`.sidebar-nav-item[href="${path}${search}"]`);
        
        if (!activeLink && path === '/admin-crud.html') {
            const urlParams = new URLSearchParams(search);
            const type = urlParams.get('type');
            if (type) {
                activeLink = document.querySelector(`.sidebar-nav-item[data-type="${type}"]`);
            }
        } else if (!activeLink) {
            activeLink = document.querySelector(`.sidebar-nav-item[href="${path}"]`);
        }
        
        let perms = [];
        let isSuperAdmin = false;
        try {
            const token = localStorage.getItem('jwt_token');
            if (token) {
                const payload = JSON.parse(atob(token.split('.')[1]));
                if (payload.permission) {
                    perms = Array.isArray(payload.permission) ? payload.permission : [payload.permission];
                }
                if (payload['http://schemas.microsoft.com/ws/2008/06/identity/claims/role']) {
                    const roles = payload['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'];
                    isSuperAdmin = Array.isArray(roles) ? roles.includes('SuperAdmin') : roles === 'SuperAdmin';
                }
            }
        } catch (e) { console.error("Error decoding token in layout", e); }
        
        if (!perms.includes('admin.manage') && !isSuperAdmin) {
            document.querySelectorAll('a[href="/users.html"], a[href="/admin-crud.html?type=roles"], a[href="/admin-crud.html?type=permissions"]').forEach(el => {
                if (el) el.style.display = 'none';
            });
        }
        
        if (activeLink) {
            activeLink.classList.add('active');
            
            // Automatically scroll the sidebar so the active item is visible
            setTimeout(() => {
                const nav = document.querySelector('.sidebar-nav');
                if (nav) {
                    const linkRect = activeLink.getBoundingClientRect();
                    const navRect = nav.getBoundingClientRect();
                    if (linkRect.bottom > navRect.bottom || linkRect.top < navRect.top) {
                        activeLink.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    }
                }
            }, 100);
        }
        const overlay = document.getElementById('sidebarOverlay');
        if (!overlay) {
            const ol = document.createElement('div');
            ol.className = 'sidebar-overlay';
            ol.id = 'sidebarOverlay';
            document.body.appendChild(ol);
        }
    }
}
