export const escapeHtml = (unsafe) => (unsafe || '').toString().replaceAll('&', "&amp;").replaceAll('<', "&lt;").replaceAll('>', "&gt;").replaceAll('"', "&quot;").replaceAll("'", "&#039;");
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

export function showUndoToast(message, undoFn, ms = 6000) {
    let container = document.getElementById('toastContainer');
    if (!container) {
        container = document.createElement('div');
        container.id = 'toastContainer';
        container.className = 'toast-container';
        document.body.appendChild(container);
    }
    
    return new Promise((resolve) => {
        const toast = document.createElement('div');
        toast.className = 'toast info undo-toast';
        toast.setAttribute('role', 'status');
        
        toast.innerHTML = `
            <div class="d-flex align-items-center gap-sm" style="flex: 1; justify-content: space-between;">
                <span style="font-weight: 500;">${message}</span>
                <button type="button" class="btn btn-secondary btn-undo" style="padding: 4px 8px; font-size: 12px; margin-left: 12px;">Undo</button>
            </div>
            <div class="undo-progress" style="animation-duration: ${ms}ms;"></div>
        `;
        
        container.appendChild(toast);
        
        let isUndone = false;
        
        const undoBtn = toast.querySelector('.btn-undo');
        undoBtn.focus(); // A11y focusable

        let timerId = setTimeout(() => {
            if (!isUndone) {
                removeToast(toast);
                resolve(true); // Proceed with action
            }
        }, ms);
        
        undoBtn.addEventListener('click', async () => {
            isUndone = true;
            clearTimeout(timerId);
            removeToast(toast);
            if (undoFn) {
                try { await undoFn(); } catch(e) { console.error("Undo failed:", e); }
            }
            resolve(false); // Action undone
        });
    });
}

function removeToast(toast) {
    toast.style.opacity = '0';
    toast.style.transform = 'translateX(100%)';
    toast.style.transition = 'all 0.3s ease';
    setTimeout(() => toast.remove(), 300);
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


export function showAssigneesModal(encodedData) {
    let data;
    try {
        data = JSON.parse(decodeURIComponent(encodedData));
    } catch(e) {
        console.error("Failed to parse assignees data", e);
        return;
    }

    let modalId = 'assigneesModal';
    let overlay = document.getElementById(modalId);
    if (!overlay) {
        overlay = document.createElement('div');
        overlay.id = modalId;
        overlay.className = 'modal-overlay';
        overlay.innerHTML = `
            <div class="modal" style="width: min(450px, 95%); padding: 0; overflow: hidden;">
                <div class="modal-header" style="border-bottom: 1px solid var(--border); padding: var(--spacing-md) var(--spacing-lg); background: var(--bg-hover);">
                    <h2 style="font-size: 16px; font-weight: 600; margin: 0; display: flex; align-items: center; gap: 8px;">
                        <svg viewBox="0 0 24 24" width="20" height="20" fill="var(--primary)"><path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/></svg>
                        Atananlar Listesi
                    </h2>
                    <button type="button" class="close-btn" onclick="closeModal('${modalId}')" aria-label="Close" style="background: none; border: none; cursor: pointer; color: var(--text-muted);">
                        <svg viewBox="0 0 24 24" width="20" height="20" fill="currentColor"><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/></svg>
                    </button>
                </div>
                <div class="modal-body" id="${modalId}-body" style="padding: 0; max-height: 400px; overflow-y: auto;">
                </div>
            </div>
        `;
        document.body.appendChild(overlay);
    }
    
    const body = document.getElementById(`${modalId}-body`);
    if (data.length === 0) {
        body.innerHTML = `<div style="padding: var(--spacing-xl); text-align: center; color: var(--text-muted);">Bu kayda kimse atanmamış.</div>`;
    } else {
        const escapeHtml = (unsafe) => (unsafe || '').toString().replaceAll('&', "&amp;").replaceAll('<', "&lt;").replaceAll('>', "&gt;").replaceAll('"', "&quot;").replaceAll("'", "&#039;");
        // Expose a global function to toggle group users
        window.toggleAssigneeGroup = function(groupId, el) {
            const rows = document.querySelectorAll('.assignee-subitem-for-' + groupId);
            const icon = el.querySelector('.toggle-icon');
            let isHidden = true;
            rows.forEach(r => {
                if (r.style.display === 'none') {
                    r.style.display = 'flex';
                    isHidden = false;
                } else {
                    r.style.display = 'none';
                    isHidden = true;
                }
            });
            if (icon) {
                icon.style.transform = isHidden ? 'rotate(0deg)' : 'rotate(180deg)';
            }
        };

        const listHtml = data.map(item => {
            const isUser = item.type === 'user';
            const isEmpty = item.type === 'empty';
            const isGroup = item.type === 'group';
            const isSub = item.isSubItem;
            
            if (isEmpty) {
                return `
                <div class="assignee-subitem-for-${item.parentGroupId}" style="display: none; align-items: center; padding: var(--spacing-md) var(--spacing-xl); padding-left: 56px; border-bottom: 1px solid var(--border); background: rgba(0,0,0,0.015);">
                    <div style="font-size: 13px; color: var(--text-muted); font-style: italic;">Bu grupta kayıtlı kullanıcı bulunmuyor.</div>
                </div>`;
            }
            
            const iconSize = isSub ? 28 : 36;
            const iconFontSize = isSub ? 12 : 14;
            
            const iconHtml = isUser 
                ? `<div class="avatar" style="width: ${iconSize}px; height: ${iconSize}px; min-width: ${iconSize}px; font-size: ${iconFontSize}px; background: rgba(var(--primary-rgb), 0.1); color: var(--primary); display: flex; align-items: center; justify-content: center; border-radius: 50%;">${escapeHtml(item.initial)}</div>`
                : `<div class="avatar" style="width: ${iconSize}px; height: ${iconSize}px; min-width: ${iconSize}px; font-size: ${iconFontSize}px; background: rgba(245, 158, 11, 0.1); color: #f59e0b; display: flex; align-items: center; justify-content: center; border-radius: 50%;">
                     <svg viewBox="0 0 24 24" width="${isSub?14:18}" height="${isSub?14:18}" fill="currentColor"><path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/></svg>
                   </div>`;
                   
            const extraInfo = isUser ? `<div style="font-size: ${isSub?11:12}px; color: var(--text-muted);">${escapeHtml(item.email)}</div>` : `<div style="font-size: ${isSub?11:12}px; color: var(--text-muted);">Ekip</div>`;
            const badge = isUser ? `<span class="badge badge-info" style="font-size: 10px;">Kullanıcı</span>` : `<span class="badge badge-warning" style="font-size: 10px;">Ekip</span>`;
            
            const paddingLeft = isSub ? 'var(--spacing-xl)' : 'var(--spacing-lg)';
            const borderLeft = isSub ? '3px solid rgba(var(--primary-rgb), 0.3)' : '3px solid transparent';
            const bgColor = isSub ? 'rgba(0,0,0,0.015)' : 'transparent';
            
            const nestingArrow = isSub ? `<svg viewBox="0 0 24 24" width="16" height="16" style="fill: var(--text-muted); opacity: 0.6; margin-right: 4px; margin-left: -8px;"><path d="M19 15l-6 6-1.42-1.42L15.17 17H5V5h2v10h8.17l-3.59-3.58L13 10l6 6z"/></svg>` : '';
            
            const toggleIcon = isGroup ? `<svg class="toggle-icon" viewBox="0 0 24 24" width="16" height="16" style="fill:currentColor; transition: transform 0.2s;"><path d="M7 10l5 5 5-5z"/></svg>` : '';
            const onClickAttr = isGroup ? `onclick="window.toggleAssigneeGroup(${item.id}, this)"` : '';
            const cursorAttr = isGroup ? 'cursor: pointer;' : 'cursor: default;';
            const displayAttr = isSub ? 'display: none;' : 'display: flex;';
            const classAttr = isSub ? `class="assignee-subitem-for-${item.parentGroupId}"` : '';
            
            return `
                <div ${classAttr} style="${displayAttr} align-items: center; justify-content: space-between; padding: var(--spacing-md) var(--spacing-lg); padding-left: ${paddingLeft}; border-left: ${borderLeft}; border-bottom: 1px solid var(--border); background: ${bgColor}; transition: background 0.2s; ${cursorAttr}" ${onClickAttr} onmouseover="this.style.background='var(--bg-hover)'" onmouseout="this.style.background='${bgColor}'">
                    <div style="display: flex; align-items: center; gap: ${isSub?8:12}px;">
                        ${nestingArrow}
                        ${iconHtml}
                        <div>
                            <div style="font-weight: 500; font-size: ${isSub?13:14}px; color: var(--text-main); display: flex; align-items: center; gap: 8px;">
                                ${escapeHtml(item.name)}
                                ${!isSub ? badge : ''}
                            </div>
                            ${extraInfo}
                        </div>
                    </div>
                    <div style="color: var(--text-muted);">
                        ${toggleIcon}
                    </div>
                </div>
            `;
        }).join('');
        body.innerHTML = listHtml;
    }

    openModal(modalId);
}

export function showInfoModal(title, text) {
    let modalId = 'globalInfoModal';
    let overlay = document.getElementById(modalId);
    if (!overlay) {
        overlay = document.createElement('div');
        overlay.id = modalId;
        overlay.className = 'modal-overlay';
        overlay.innerHTML = `
            <div class="modal" style="width: min(400px, 90%);">
                <div class="modal-header">
                    <h2 id="${modalId}-title">Info</h2>
                    <button type="button" class="close-btn" onclick="closeModal('${modalId}')" aria-label="Close">
                        <svg viewBox="0 0 24 24" width="24" height="24"><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/></svg>
                    </button>
                </div>
                <div class="modal-body">
                    <p id="${modalId}-text" style="font-size: 14px; line-height: 1.5; color: var(--text-main); white-space: pre-wrap;"></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" onclick="closeModal('${modalId}')">OK</button>
                </div>
            </div>
        `;
        document.body.appendChild(overlay);
    }
    document.getElementById(`${modalId}-title`).textContent = title;
    document.getElementById(`${modalId}-text`).textContent = text;
    openModal(modalId);
}

export function showConfirmModal(title, text) {
    return new Promise((resolve) => {
        let modalId = 'globalConfirmModal';
        let overlay = document.getElementById(modalId);
        if (!overlay) {
            overlay = document.createElement('div');
            overlay.id = modalId;
            overlay.className = 'modal-overlay';
            overlay.innerHTML = `
                <div class="modal" style="width: min(400px, 90%);">
                    <div class="modal-header">
                        <h2 id="${modalId}-title">Confirm</h2>
                        <button type="button" class="close-btn" id="${modalId}-close" aria-label="Close">
                            <svg viewBox="0 0 24 24" width="24" height="24"><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/></svg>
                        </button>
                    </div>
                    <div class="modal-body">
                        <p id="${modalId}-text" style="font-size: 14px; line-height: 1.5; color: var(--text-main); white-space: pre-wrap;"></p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-ghost" id="${modalId}-cancel">Cancel</button>
                        <button type="button" class="btn btn-primary" id="${modalId}-ok" style="background-color: var(--danger); border-color: var(--danger);">OK</button>
                    </div>
                </div>
            `;
            document.body.appendChild(overlay);
        }
        document.getElementById(`${modalId}-title`).textContent = title;
        document.getElementById(`${modalId}-text`).textContent = text;
        
        const closeBtn = document.getElementById(`${modalId}-close`);
        const cancelBtn = document.getElementById(`${modalId}-cancel`);
        const okBtn = document.getElementById(`${modalId}-ok`);
        
        const newCloseBtn = closeBtn.cloneNode(true);
        closeBtn.parentNode.replaceChild(newCloseBtn, closeBtn);
        
        const newCancelBtn = cancelBtn.cloneNode(true);
        cancelBtn.parentNode.replaceChild(newCancelBtn, cancelBtn);
        
        const newOkBtn = okBtn.cloneNode(true);
        okBtn.parentNode.replaceChild(newOkBtn, okBtn);
        
        const closeAndResolve = (val) => {
            closeModal(modalId);
            resolve(val);
        };
        
        newCloseBtn.addEventListener('click', () => closeAndResolve(false));
        newCancelBtn.addEventListener('click', () => closeAndResolve(false));
        newOkBtn.addEventListener('click', () => closeAndResolve(true));
        
        openModal(modalId);
    });
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

    
    // Profile Panel Logic
    const avatarEls = document.querySelectorAll('.topbar-right .avatar');
    if (avatarEls.length > 0) {
        const avatarEl = avatarEls[0];
        avatarEl.style.cursor = 'pointer';
        
        const panel = document.createElement('div');
        panel.id = 'myProfilePanel';
        panel.className = 'profile-panel';
        panel.style.display = 'none';
        panel.style.position = 'absolute';
        panel.style.top = '60px';
        panel.style.right = '20px';
        panel.style.width = '300px';
        panel.style.background = '#fff';
        panel.style.boxShadow = 'var(--shadow-lg)';
        panel.style.borderRadius = 'var(--radius-md)';
        panel.style.padding = 'var(--spacing-md)';
        panel.style.zIndex = '1000';
        panel.style.maxHeight = '80vh';
        panel.style.overflowY = 'auto';
        panel.innerHTML = '<div style="text-align:center; padding:20px;">Loading...</div>';
        
        document.body.appendChild(panel);
        
        let loaded = false;
        
        avatarEl.addEventListener('click', async (e) => {
            e.stopPropagation();
            if (panel.style.display === 'none') {
                panel.style.display = 'block';
                if (!loaded && window.api) {
                    try {
                        const me = await window.api.getMe();
                        
                        let rolesHtml = (me.roles || []).map(r => `<span class="badge badge-primary">${r}</span>`).join(' ');
                        let groupsHtml = (me.groups || []).map(g => `<span class="badge badge-default">${g}</span>`).join(' ');
                        
                        let perms = me.permissions || [];
                        perms.sort();
                        
                        let overrides = me.overrides || [];
                        
                        let allPermsDef = [];
                        try {
                            allPermsDef = await window.api.request('/permissions');
                        } catch(e) { console.warn('Could not load permission definitions', e); }
                        
                        let permsHtml = perms.map(p => {
                            const isOverride = overrides.includes(p);
                            const def = allPermsDef.find(x => x.key === p);
                            const desc = def && def.description ? escapeHtml(def.description) : 'Açıklama bulunmuyor.';
                            return `<div style="font-size: 12px; padding: 4px 0; border-bottom: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center;">
                                <div style="display: flex; align-items: center; gap: 4px;">
                                    <span>${p}</span>
                                    <span style="cursor: pointer; color: var(--primary); display: inline-flex;" onclick="window.showInfoModal('${p}', '${desc.replace(/'/g, "\\'")}')">
                                        <svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor"><path d="M11 7h2v2h-2zm0 4h2v6h-2zm1-9C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8z"/></svg>
                                    </span>
                                </div>
                                ${isOverride ? '<span class="badge badge-warning" style="font-size:10px; padding:2px 4px;">override</span>' : ''}
                            </div>`;
                        }).join('');
                        
                        panel.innerHTML = `
                            <div style="text-align:center; margin-bottom: 16px;">
                                <div class="avatar" style="width:48px; height:48px; font-size:20px; margin: 0 auto 8px;">${me.username.charAt(0).toUpperCase()}</div>
                                <div style="font-weight: 600;">${me.username}</div>
                                <div style="font-size: 12px; color: var(--text-muted);">${me.email || ''}</div>
                            </div>
                            <div style="margin-bottom: 12px;">
                                <div style="font-size: 11px; font-weight: 600; color: var(--text-muted); margin-bottom: 4px; text-transform: uppercase;">Roles</div>
                                <div>${rolesHtml || '-'}</div>
                            </div>
                            <div style="margin-bottom: 16px;">
                                <div style="font-size: 11px; font-weight: 600; color: var(--text-muted); margin-bottom: 4px; text-transform: uppercase;">Groups</div>
                                <div>${groupsHtml || '-'}</div>
                            </div>
                            <div>
                                <div style="font-size: 11px; font-weight: 600; color: var(--text-muted); margin-bottom: 4px; text-transform: uppercase;">Effective Permissions</div>
                                <div style="max-height: 200px; overflow-y: auto; background: var(--bg-hover); padding: 8px; border-radius: var(--radius-sm);">
                                    ${permsHtml || '<div style="font-size:12px;">No permissions</div>'}
                                </div>
                            </div>
                        `;
                        loaded = true;
                    } catch (err) { console.error(err); 
                        panel.innerHTML = '<div class="text-danger">Failed to load profile details.</div>';
                     }
                }
            } else {
                panel.style.display = 'none';
            }
        });
        
        document.addEventListener('click', (e) => {
            if (panel.style.display === 'block' && !panel.contains(e.target) && e.target !== avatarEl) {
                panel.style.display = 'none';
            }
        });
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape' && panel.style.display === 'block') {
                panel.style.display = 'none';
            }
        });
    }


    const currentPath = window.location.pathname;
    document.querySelectorAll('.sidebar-nav-item').forEach(l => {
        if (l.getAttribute('href') === currentPath) {
            l.classList.add('active');
        }
    });

    // RBAC Sidebar rendering
    if (window.api?.token) {
        window.api.getMe().then(me => {
            applySidebarRbac(me.permissions || [], (me.roles || []).includes('SuperAdmin'));
        }).catch(e => {
            console.warn('api.getMe() failed, falling back to token claims for sidebar');
            try {
                const payload = JSON.parse(atob(window.api.token.split('.')[1]));
                let perms = [];
                let roles = [];
                if (payload.Permissions) {
                    perms = typeof payload.Permissions === 'string' ? [payload.Permissions] : payload.Permissions;
                }
                if (payload.Roles) {
                    roles = typeof payload.Roles === 'string' ? [payload.Roles] : payload.Roles;
                }
                applySidebarRbac(perms, roles.includes('SuperAdmin'));
            } catch (err) { console.error(err); }
        });
    }

    function applySidebarRbac(perms, isSuperAdmin) {
        if (isSuperAdmin) return; // SuperAdmin sees everything

        if (!perms.includes('config.manage')) {
            document.querySelectorAll('a[href="/projects.html"], a[href="/categories.html"], a[href="/departments.html"], a[href="/groups.html"], a[href="/admin-fields.html"], a[href="/rules.html"], a[href="/webhooks.html"]').forEach(el => {
                if (el) el.style.display = 'none';
            });
        }
        
        if (!perms.includes('user.manage')) {
            document.querySelectorAll('a[href="/users.html"], a[href="/roles.html"]').forEach(el => {
                if (el) el.style.display = 'none';
            });
        }

        if (!perms.includes('config.manage') && !perms.includes('user.manage')) {
            const adminTitle = Array.from(document.querySelectorAll('.sidebar-nav-title')).find(el => el.textContent.includes('Administration'));
            if (adminTitle) adminTitle.style.display = 'none';
        }

        if (!perms.includes('audit.view')) {
            const auditLink = document.querySelector('a[href="/audit-log.html"]');
            if (auditLink) auditLink.style.display = 'none';
        }
    }

    window.openModal = openModal;
    window.closeModal = closeModal;
    window.showToast = showToast;
    window.showUndoToast = showUndoToast;
    window.openTicketPreview = openTicketPreview;
    window.showInfoModal = showInfoModal;
    window.showConfirmModal = showConfirmModal;
    window.showAssigneesModal = showAssigneesModal;
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
        return Number.isNaN(date.getTime()) ? '-' : date.toLocaleString('tr-TR', { dateStyle: 'short', timeStyle: 'short' });
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

window.ui = {
    escapeHtml,
    showToast,
    showUndoToast,
    showConfirmModal,
    openModal,
    closeModal
};
