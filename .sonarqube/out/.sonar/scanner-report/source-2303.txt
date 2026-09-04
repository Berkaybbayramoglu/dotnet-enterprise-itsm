import re

with open('src/ItsTool.Web/wwwroot/js/layout.js', 'r') as f:
    content = f.read()

# We want to replace the `injectShell` function.
# Let's extract the shellHtml constant first.
shell_html_match = re.search(r'const shellHtml = `(.*?)`;', content, re.DOTALL)
shell_html = shell_html_match.group(0)

# Replace the whole injectShell function
new_inject_shell = """
function injectSignalR() {
    if (!document.querySelector('script[src="js/lib/signalr.min.js"]')) {
        const script = document.createElement('script');
        script.src = 'js/lib/signalr.min.js';
        script.onload = () => initNotifications();
        document.head.appendChild(script);
    } else {
        initNotifications();
    }
}

function injectDropdownStyle() {
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
}

function highlightActiveLink() {
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
    
    if (activeLink) activeLink.classList.add('active');
    return activeLink;
}

function applyRbacToSidebar() {
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
        document.querySelectorAll('.sidebar-nav-title, .sidebar-nav-title ~ a').forEach(el => {
            if (el) el.style.display = 'none';
        });
    }
}

function scrollSidebarToActive(activeLink) {
    setTimeout(() => {
        const nav = document.querySelector('.sidebar-nav');
        if (nav && activeLink) {
            const linkRect = activeLink.getBoundingClientRect();
            const navRect = nav.getBoundingClientRect();
            if (linkRect.bottom > navRect.bottom || linkRect.top < navRect.top) {
                activeLink.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
        }
    }, 100);
}

function ensureSidebarOverlay() {
    const overlay = document.getElementById('sidebarOverlay');
    if (!overlay) {
        const ol = document.createElement('div');
        ol.className = 'sidebar-overlay';
        ol.id = 'sidebarOverlay';
        document.body.appendChild(ol);
    }
}

export function injectShell() {
    injectSignalR();
    injectDropdownStyle();

""" + shell_html + """
    
    const shellContainer = document.querySelector('[data-shell]');
    if (shellContainer) {
        shellContainer.insertAdjacentHTML('afterbegin', shellHtml);
        
        const activeLink = highlightActiveLink();
        applyRbacToSidebar();
        
        if (activeLink) {
            scrollSidebarToActive(activeLink);
        }
        
        ensureSidebarOverlay();

        if (typeof applyTranslations === 'function') {
            applyTranslations();
        }
    }
}
"""

# Replace in content
header = """// layout.js - Common UI Layout Injector
import { applyTranslations } from './i18n.js';
import { initNotifications } from './notifications.js?v=3';
"""

with open('src/ItsTool.Web/wwwroot/js/layout.js', 'w') as f:
    f.write(header + "\n" + new_inject_shell)

