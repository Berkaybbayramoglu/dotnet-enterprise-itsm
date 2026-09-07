import { setLanguage, t, getCurrentLanguage } from './i18n.js';
(function() {
    try {
        const savedTheme = localStorage.getItem('itsm_theme') || 'light';
        document.documentElement.dataset.theme = savedTheme;
    } catch(e) { console.error('Theme init failed', e); }
})();

export const escapeHtml = (unsafe) => (unsafe || '').toString().replaceAll('&', "&amp;").replaceAll('<', "&lt;").replaceAll('>', "&gt;").replaceAll('"', "&quot;").replaceAll("'", "&#039;");

export const getAvatar = (id, fallback) => {
    if (!id || id === '-') return `<div class="avatar" style="background: var(--bg-hover); color: var(--text-muted); border: 1px dashed var(--border);">?</div>`;
    return `<div class="avatar" title="${fallback}">${String(fallback || id).charAt(0).toUpperCase()}</div>`;
};

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
    
    let icon = '';
    if (type === 'success') {
        icon = '<svg viewBox="0 0 24 24" width="24" height="24" style="fill: var(--success);"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/></svg>';
    } else if (type === 'info') {
        icon = '<svg viewBox="0 0 24 24" width="24" height="24" style="fill: var(--primary);"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z"/></svg>';
    } else if (type === 'warning') {
        icon = '<svg viewBox="0 0 24 24" width="24" height="24" style="fill: #f59e0b;"><path d="M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z"/></svg>';
    } else {
        icon = '<svg viewBox="0 0 24 24" width="24" height="24" style="fill: var(--danger);"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"/></svg>';
    }
        
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
        toast.className = 'toast undo-toast';
        toast.style.background = 'var(--bg-surface)';
        toast.style.color = 'var(--text-main)';
        toast.style.borderLeft = '4px solid var(--info)';
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


function createAssigneeRow(item, escapeHtml) {
    if (item.type === 'empty') return createAssigneeEmptyRow(item, escapeHtml);
    if (item.type === 'group') return createAssigneeGroupRow(item, escapeHtml);
    return createAssigneeUserRow(item, escapeHtml);
}

function createAssigneeEmptyRow(item, escapeHtml) {
    return `
        <div class="assignee-subitem-for-${item.parentGroupId}" style="display: none; align-items: center; padding: var(--spacing-md) var(--spacing-xl); padding-left: 56px; border-bottom: 1px solid var(--border); background: rgba(0,0,0,0.015);">
            <div style="font-size: 13px; color: var(--text-muted); font-style: italic;">Bu grupta kayıtlı kullanıcı bulunmuyor.</div>
        </div>`;
}

function createAssigneeGroupRow(item, escapeHtml) {
    const iconHtml = `<div class="avatar" style="width: 36px; height: 36px; min-width: 36px; font-size: 14px; background: rgba(245, 158, 11, 0.1); color: #f59e0b; display: flex; align-items: center; justify-content: center; border-radius: 50%;">
             <svg viewBox="0 0 24 24" width="18" height="18" fill="currentColor"><path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/></svg>
           </div>`;
    const extraInfo = `<div style="font-size: 12px; color: var(--text-muted);">Ekip</div>`;
    const badge = `<span class="badge badge-warning" style="font-size: 10px;">Ekip</span>`;
    const toggleIcon = `<svg class="toggle-icon" viewBox="0 0 24 24" width="16" height="16" style="fill:currentColor; transition: transform 0.2s;"><path d="M7 10l5 5 5-5z"/></svg>`;
    
    return `
        <button type="button" style="display: flex; width: 100%; font: inherit; color: inherit; text-align: left; align-items: center; justify-content: space-between; padding: var(--spacing-md) var(--spacing-lg); padding-left: var(--spacing-lg); border-left: 3px solid transparent; border-bottom: 1px solid var(--border); border-top: none; border-right: none; background: transparent; transition: background 0.2s; cursor: pointer;" onclick="window.toggleAssigneeGroup(${item.id}, this)" onmouseover="this.style.background='var(--bg-hover)'" onmouseout="this.style.background='transparent'">
            <div style="display: flex; align-items: center; gap: 12px;">
                ${iconHtml}
                <div>
                    <div style="font-weight: 500; font-size: 14px; color: var(--text-main); display: flex; align-items: center; gap: 8px;">
                        ${escapeHtml(item.name)}
                        ${badge}
                    </div>
                    ${extraInfo}
                </div>
            </div>
            <div style="color: var(--text-muted);">
                ${toggleIcon}
            </div>
        </button>
    `;
}

function createAssigneeUserRow(item, escapeHtml) {
    const isSub = item.isSubItem;
    const iconSize = isSub ? 28 : 36;
    const iconFontSize = isSub ? 12 : 14;
    const iconHtml = `<div class="avatar" style="width: ${iconSize}px; height: ${iconSize}px; min-width: ${iconSize}px; font-size: ${iconFontSize}px; background: rgba(var(--primary-rgb), 0.1); color: var(--primary); display: flex; align-items: center; justify-content: center; border-radius: 50%;">${escapeHtml(item.initial)}</div>`;
    
    const fs = isSub ? 11 : 12;
    const extraInfo = `<div style="font-size: ${fs}px; color: var(--text-muted);">${escapeHtml(item.email)}</div>`;
    const badge = `<span class="badge badge-info" style="font-size: 10px;">Kullanıcı</span>`;
    
    const paddingLeft = isSub ? 'var(--spacing-xl)' : 'var(--spacing-lg)';
    const borderLeft = isSub ? '3px solid rgba(var(--primary-rgb), 0.3)' : '3px solid transparent';
    const bgColor = isSub ? 'rgba(0,0,0,0.015)' : 'transparent';
    const nestingArrow = isSub ? `<svg viewBox="0 0 24 24" width="16" height="16" style="fill: var(--text-muted); opacity: 0.6; margin-right: 4px; margin-left: -8px;"><path d="M19 15l-6 6-1.42-1.42L15.17 17H5V5h2v10h8.17l-3.59-3.58L13 10l6 6z"/></svg>` : '';
    const displayAttr = isSub ? 'display: none;' : 'display: flex;';
    const classAttr = isSub ? `class="assignee-subitem-for-${item.parentGroupId}"` : '';
    const avatarMargin = isSub ? 8 : 12;
    const nameFs = isSub ? 13 : 14;

    return `
        <button type="button" ${classAttr} style="${displayAttr} width: 100%; font: inherit; color: inherit; text-align: left; align-items: center; justify-content: space-between; padding: var(--spacing-md) var(--spacing-lg); padding-left: ${paddingLeft}; border-left: ${borderLeft}; border-bottom: 1px solid var(--border); border-top: none; border-right: none; background: ${bgColor}; transition: background 0.2s; cursor: pointer;" onmouseover="this.style.background='var(--bg-hover)'" onmouseout="this.style.background='${bgColor}'" onclick="if(window.ui && window.ui.showUserDetails) window.ui.showUserDetails(${item.id})">
            <div style="display: flex; align-items: center; gap: ${avatarMargin}px;">
                ${nestingArrow}
                ${iconHtml}
                <div>
                    <div style="font-weight: 500; font-size: ${nameFs}px; color: var(--text-main); display: flex; align-items: center; gap: 8px;">
                        ${escapeHtml(item.name)}
                        ${!isSub ? badge : ''}
                    </div>
                    ${extraInfo}
                </div>
            </div>
        </button>
    `;
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

        const listHtml = data.map(item => createAssigneeRow(item, escapeHtml)).join('');
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
    
    // Theme Switcher Logic
    const topbarRight = document.querySelector('.topbar-right');
    if (topbarRight) {
        // Insert Theme Selector before Avatar
        const themeContainer = document.createElement('div');
        themeContainer.style.position = 'relative';
        
        const themeBtn = document.createElement('button');
        themeBtn.className = 'btn btn-ghost';
        themeBtn.style.padding = '6px';
        themeBtn.style.borderRadius = '50%';
        themeBtn.title = 'Switch Theme';
        themeBtn.innerHTML = `<svg viewBox="0 0 24 24" width="20" height="20" fill="currentColor"><path d="M12 3c-4.97 0-9 4.03-9 9s4.03 9 9 9c.83 0 1.5-.67 1.5-1.5 0-.39-.15-.74-.39-1.01-.23-.26-.38-.61-.38-.99 0-.83.67-1.5 1.5-1.5H16c2.76 0 5-2.24 5-5 0-4.42-4.03-8-9-8zm-5.5 9c-.83 0-1.5-.67-1.5-1.5S5.67 9 6.5 9 8 9.67 8 10.5 7.33 12 6.5 12zm3-4C8.67 8 8 7.33 8 6.5S8.67 5 9.5 5s1.5.67 1.5 1.5S10.33 8 9.5 8zm5 0c-.83 0-1.5-.67-1.5-1.5S13.67 5 14.5 5s1.5.67 1.5 1.5S15.33 8 14.5 8zm3 4c-.83 0-1.5-.67-1.5-1.5S16.67 9 17.5 9s1.5.67 1.5 1.5-.67 1.5-1.5 1.5z"/></svg>`;
        themeContainer.appendChild(themeBtn);

        const themeDropdown = document.createElement('div');
        themeDropdown.className = 'dropdown-menu';
        themeDropdown.style.top = '40px';
        themeDropdown.style.width = '160px';
        
        const themes = [
            { id: 'light', name: 'Light (Default)' },
            { id: 'dark', name: 'Dark Classic' },
            { id: 'dracula', name: 'Dracula' },
            { id: 'monokai', name: 'Monokai' },
            { id: 'github-dark', name: 'GitHub Dark' }
        ];
        
        const currentTheme = localStorage.getItem('itsm_theme') || 'light';
        themeDropdown.innerHTML = `<div class="dropdown-header">${t('topbar_theme') || 'Select Theme'}</div><hr class="dropdown-divider">` + 
            themes.map(tObj => `<div class="dropdown-item theme-option ${tObj.id === currentTheme ? 'active' : ''}" data-theme-id="${tObj.id}" style="display:flex; justify-content:space-between; align-items:center;">
                ${tObj.name}
                ${tObj.id === currentTheme ? '<svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg>' : ''}
            </div>`).join('');
            
        themeContainer.appendChild(themeDropdown);
        topbarRight.insertBefore(themeContainer, topbarRight.firstChild);

        themeBtn.addEventListener('click', (e) => {
            themeDropdown.classList.toggle('show');
        });

        themeDropdown.querySelectorAll('.theme-option').forEach(opt => {
            opt.addEventListener('click', () => {
                const selectedTheme = opt.dataset.themeId;
                document.documentElement.dataset.theme = selectedTheme;
                localStorage.setItem('itsm_theme', selectedTheme);
                
                // Move checkmark and active class visually
                themeDropdown.querySelectorAll('.theme-option').forEach(el => {
                    el.classList.remove('active');
                    const svg = el.querySelector('svg');
                    if (svg) svg.remove();
                });
                opt.classList.add('active');
                opt.insertAdjacentHTML('beforeend', '<svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg>');
                
                themeDropdown.classList.remove('show');
            });
        });

        document.addEventListener('click', (e) => {
            if (!themeContainer.contains(e.target)) {
                themeDropdown.classList.remove('show');
            }
        });

        // Language Switcher Logic
        const langContainer = document.createElement('div');
        langContainer.style.position = 'relative';
        
        const langBtn = document.createElement('button');
        langBtn.className = 'btn btn-ghost';
        langBtn.style.padding = '6px';
        langBtn.style.borderRadius = '50%';
        langBtn.title = 'Switch Language';
        // Globe icon
        langBtn.innerHTML = `<svg viewBox="0 0 24 24" width="20" height="20" fill="currentColor"><path d="M11.99 2C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zm6.93 6h-2.95c-.32-1.25-.78-2.45-1.38-3.56 1.84.63 3.37 1.91 4.33 3.56zM12 4.04c.83 1.2 1.48 2.53 1.91 3.96h-3.82c.43-1.43 1.08-2.76 1.91-3.96zM4.26 14C4.09 13.36 4 12.69 4 12s.09-1.36.26-2h3.38c-.08.66-.14 1.32-.14 2s.06 1.34.14 2H4.26zm.82 2h2.95c.32 1.25.78 2.45 1.38 3.56-1.84-.63-3.37-1.9-4.33-3.56zm2.95-8H5.08c.96-1.66 2.49-2.93 4.33-3.56C8.81 5.55 8.35 6.75 8.03 8zM12 19.96c-.83-1.2-1.48-2.53-1.91-3.96h3.82c-.43 1.43-1.08 2.76-1.91 3.96zM14.34 14H9.66c-.09-.66-.16-1.32-.16-2s.07-1.35.16-2h4.68c.09.65.16 1.32.16 2s-.07 1.34-.16 2zm.25 5.56c.6-1.11 1.06-2.31 1.38-3.56h2.95c-.96 1.65-2.49 2.93-4.33 3.56zM16.36 14c.08-.66.14-1.32.14-2s-.06-1.34-.14-2h3.38c.17.64.26 1.31.26 2s-.09 1.36-.26 2h-3.38z"/></svg>`;
        langContainer.appendChild(langBtn);

        const langDropdown = document.createElement('div');
        langDropdown.className = 'dropdown-menu';
        langDropdown.style.top = '40px';
        langDropdown.style.width = '120px';
        
        const langs = [
            { id: 'tr', name: 'Türkçe' },
            { id: 'en', name: 'English' }
        ];
        
        const currentLang = getCurrentLanguage();
        langDropdown.innerHTML = `<div class="dropdown-header">${t('topbar_language') || 'Language'}</div><hr class="dropdown-divider">` + 
            langs.map(l => `<div class="dropdown-item lang-option ${l.id === currentLang ? 'active' : ''}" data-lang-id="${l.id}" style="display:flex; justify-content:space-between; align-items:center;">
                ${l.name}
                ${l.id === currentLang ? '<svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg>' : ''}
            </div>`).join('');
            
        langContainer.appendChild(langDropdown);
        topbarRight.insertBefore(langContainer, topbarRight.firstChild);

        langBtn.addEventListener('click', (e) => {
            langDropdown.classList.toggle('show');
        });

        langDropdown.querySelectorAll('.lang-option').forEach(opt => {
            opt.addEventListener('click', () => {
                const selectedLang = opt.dataset.langId;
                setLanguage(selectedLang);
                langDropdown.classList.remove('show');
            });
        });

        document.addEventListener('click', (e) => {
            if (!langContainer.contains(e.target)) {
                langDropdown.classList.remove('show');
            }
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
        panel.style.background = 'var(--bg-surface)';
        panel.style.color = 'var(--text-main)';
        panel.style.border = '1px solid var(--border)';
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
                            const desc = def?.description ? escapeHtml(def.description) : 'Açıklama bulunmuyor.';
                            return `<div style="font-size: 12px; padding: 4px 0; border-bottom: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center;">
                                <div style="display: flex; align-items: center; gap: 4px;">
                                    <span>${p}</span>
                                    <button type="button" style="border: none; background: none; padding: 0; cursor: pointer; color: var(--primary); display: inline-flex;" onclick="window.showInfoModal('${p}', '${desc.replaceAll(`'`, String.raw`\'`).replaceAll(`"`, `&quot;`)}')">
                                        <svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor"><path d="M11 7h2v2h-2zm0 4h2v6h-2zm1-9C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8z"/></svg>
                                    </button>
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
                                <div style="font-size: 11px; font-weight: 600; color: var(--text-muted); margin-bottom: 4px; text-transform: uppercase;">${t('users_lbl_roles') || 'Roles'}</div>
                                <div>${rolesHtml || '-'}</div>
                            </div>
                            <div style="margin-bottom: 16px;">
                                <div style="font-size: 11px; font-weight: 600; color: var(--text-muted); margin-bottom: 4px; text-transform: uppercase;">${t('users_lbl_groups') || 'Groups'}</div>
                                <div>${groupsHtml || '-'}</div>
                            </div>
                            <div style="margin-bottom: 16px;">
                                <div style="font-size: 11px; font-weight: 600; color: var(--text-muted); margin-bottom: 4px; text-transform: uppercase;">${t('kb_lbl_contributions') || 'KB Contributions'}</div>
                                <div style="display: flex; align-items: center; gap: 8px;">
                                    <span class="badge badge-success" style="font-size: 13px; padding: 4px 8px;">${me.kbArticleCount || 0} Makale Önerisi</span>
                                </div>
                            </div>
                            <div>
                                <div style="font-size: 11px; font-weight: 600; color: var(--text-muted); margin-bottom: 4px; text-transform: uppercase;">${t('users_lbl_eff_perms') || 'Effective Permissions'}</div>
                                <div style="max-height: 200px; overflow-y: auto; background: var(--bg-hover); padding: 8px; border-radius: var(--radius-sm);">
                                    ${permsHtml || `<div style="font-size:12px;">${t('users_roles_none') || 'No permissions'}</div>`}
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
                let permsClaim = payload.permission || payload.Permissions;
                if (permsClaim) {
                    perms = typeof permsClaim === 'string' ? [permsClaim] : permsClaim;
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

export function openTicketPreview(ticketData, lookupData) {
    let modalOverlay = document.getElementById('previewModal');
    if (!modalOverlay) {
        modalOverlay = document.createElement('div');
        modalOverlay.id = 'previewModal';
        modalOverlay.className = 'modal-overlay';
        modalOverlay.innerHTML = `
            <div class="modal" style="max-width: 500px;">
                <div class="modal-header">
                    <h2>${t('ticket_detail_title') || 'Ticket Preview'}</h2>
                    <button type="button" class="close-btn" onclick="closeModal('previewModal')" aria-label="Close">
                        <svg viewBox="0 0 24 24" width="24" height="24"><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/></svg>
                    </button>
                </div>
                <div class="modal-body" id="previewContent"></div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-ghost" onclick="closeModal('previewModal')">${t('users_btn_cancel') || 'Close'}</button>
                    <a href="#" id="previewDetailLink" class="btn btn-primary">${t('notif_detail_btn') || 'Detaya Git'}</a>
                </div>
            </div>
        `;
        document.body.appendChild(modalOverlay);
        if (!window.closeModal) window.closeModal = closeModal;
    }

    const content = document.getElementById('previewContent');
    const projName = lookupData.projects?.find(x => x.id === ticketData.projectId)?.name || '-';
    const catName = lookupData.categories?.find(x => x.id === ticketData.categoryId)?.name || '-';
    const prioName = lookupData.priorities?.find(x => x.id === ticketData.priorityId)?.name || 'Normal';
    const prioColors = { 'Critical': 'danger', 'High': 'warning', 'Medium': 'info', 'Low': 'success' };
    const prioColor = prioColors[prioName] || 'default';
    const statusName = lookupData.statuses?.find(x => x.id === ticketData.statusId)?.name || 'Unknown';
    const getFullName = (id) => {
        const u = window.globalUsers?.find(x => x.id === id);
        if (u && (u.firstName || u.lastName)) return `${u.firstName || ''} ${u.lastName || ''}`.trim();
        if (u && u.username) return u.username;
        return `User ${id}`;
    };
    const assigneeName = ticketData.assignedUserId ? getFullName(ticketData.assignedUserId) : t('t_unassigned') || 'Unassigned';
    const reqName = ticketData.requesterUserId ? getFullName(ticketData.requesterUserId) : 'Unknown';
    
    const formatDate = (d) => {
        if(!d) return '-';
        const date = new Date(d);
        return Number.isNaN(date.getTime()) ? '-' : date.toLocaleString('tr-TR', { dateStyle: 'short', timeStyle: 'short' });
    };

    const escapeHtml = (unsafe) => (unsafe || '').toString().replaceAll('&', "&amp;").replaceAll('<', "&lt;").replaceAll('>', "&gt;").replaceAll('"', "&quot;").replaceAll("'", "&#039;");

    const headerEl = modalOverlay.querySelector('.modal-header h2');
    if (headerEl) {
        const translatedStatus = t('db_' + statusName.toLowerCase().replaceAll(' ', '_')) || statusName;
        headerEl.innerHTML = \`\${escapeHtml(ticketData.ticketNumber)} <span class="badge badge-primary" style="font-size: 12px; margin-left: 8px; text-transform: uppercase;">\${escapeHtml(translatedStatus)}</span>\`;
    }

    const reqBtnHtml = ticketData.requesterUserId ? `<button type="button" class="btn btn-ghost p-0 m-0 d-flex align-items-center gap-sm" style="border:none;" onclick="window.ui.showUserDetails(${ticketData.requesterUserId})">${getAvatar(ticketData.requesterUserId, reqName)} ${escapeHtml(reqName)}</button>` : `<div style="display: flex; align-items: center; gap: 8px; font-size: 14px;">${escapeHtml(reqName)}</div>`;
    const assignBtnHtml = ticketData.assignedUserId ? `<button type="button" class="btn btn-ghost p-0 m-0 d-flex align-items-center gap-sm" style="border:none;" onclick="window.ui.showUserDetails(${ticketData.assignedUserId})">${getAvatar(ticketData.assignedUserId, assigneeName)} ${escapeHtml(assigneeName)}</button>` : `<div style="display: flex; align-items: center; gap: 8px; font-size: 14px;">${escapeHtml(assigneeName)}</div>`;

    content.innerHTML = `
        <div style="font-size: 16px; font-weight: 600; margin-bottom: var(--spacing-md); color: var(--text);">${escapeHtml(ticketData.title)}</div>
        <div style="display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden; margin-bottom: var(--spacing-md); color: var(--text-muted); font-size: 14px;">
            ${escapeHtml(ticketData.description || '')}
        </div>
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: var(--spacing-md); background: var(--bg-hover); padding: var(--spacing-md); border-radius: var(--radius-md);">
            <div><div style="font-size: 12px; color: var(--text-muted); margin-bottom: 4px;">${t('ticket_prop_priority') || 'Priority'}</div><span class="badge badge-${prioColor}">${escapeHtml(t('db_' + prioName.toLowerCase().replaceAll(' ', '_')) || prioName)}</span></div>
            <div><div style="font-size: 12px; color: var(--text-muted); margin-bottom: 4px;">${t('ticket_prop_project') || 'Project'} / ${t('ticket_prop_category') || 'Category'}</div><div style="font-size: 14px; font-weight: 500;">${escapeHtml(projName)} <span style="color:var(--text-muted);">/</span> ${escapeHtml(catName)}</div></div>
            <div><div style="font-size: 12px; color: var(--text-muted); margin-bottom: 4px;">${t('ticket_prop_requester') || 'Requester'}</div>${reqBtnHtml}</div>
            <div><div style="font-size: 12px; color: var(--text-muted); margin-bottom: 4px;">${t('ticket_prop_assignee') || 'Assignee'}</div>${assignBtnHtml}</div>
            <div><div style="font-size: 12px; color: var(--text-muted); margin-bottom: 4px;">${t('ticket_prop_sla_status') || 'SLA Status'}</div><span class="badge badge-success">${t('ticket_sla_on_track') || 'On Track'}</span></div>
            <div><div style="font-size: 12px; color: var(--text-muted); margin-bottom: 4px;">${t('audit_col_time') || 'Created At'}</div><div style="font-size: 14px;">${formatDate(ticketData.createdAt)}</div></div>
        </div>
    `;
    document.getElementById('previewDetailLink').href = `/ticket-detail.html?id=${ticketData.id}`;
    openModal('previewModal');
}

window.ui = {
    escapeHtml,
    showToast,
    showUndoToast,
    showConfirmModal,
    openModal,
    closeModal,
    getAvatar,
    showUserDetails
};
export async function showUserDetails(userId) {
    if (!userId) return;
    try {
        const user = await window.api.request(`/Users/${userId}`);
        if (!user) return;
        
        let modalOverlay = document.getElementById('globalUserModal');
        if (!modalOverlay) {
            modalOverlay = document.createElement('div');
            modalOverlay.id = 'globalUserModal';
            modalOverlay.className = 'modal-overlay';
            modalOverlay.innerHTML = `
                <div class="modal" style="max-width: 450px;">
                    <div class="modal-header">
                        <h2>User Details</h2>
                        <button type="button" class="close-btn" onclick="closeModal('globalUserModal')" aria-label="Close">
                            <svg viewBox="0 0 24 24" width="24" height="24"><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/></svg>
                        </button>
                    </div>
                    <div class="modal-body" style="text-align: center; padding: 24px;">
                        <div id="guAvatar" style="margin-bottom: 16px;"></div>
                        <h3 id="guName" style="margin-bottom: 4px;"></h3>
                        <div id="guUsername" style="color: var(--text-muted); margin-bottom: 16px; font-size: 14px;"></div>
                        
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; text-align: left; background: var(--bg-hover); padding: 16px; border-radius: 8px;">
                            <div>
                                <div style="font-size: 12px; color: var(--text-muted); margin-bottom: 4px;">Email</div>
                                <div id="guEmail" style="font-weight: 500; font-size: 14px; word-break: break-all;"></div>
                            </div>
                            <div>
                                <div style="font-size: 12px; color: var(--text-muted); margin-bottom: 4px;">Department</div>
                                <div id="guDept" style="font-weight: 500; font-size: 14px;"></div>
                            </div>
                            <div>
                                <div style="font-size: 12px; color: var(--text-muted); margin-bottom: 4px;">Status</div>
                                <div id="guStatus"></div>
                            </div>
                            <div style="grid-column: span 2; margin-top: 8px;">
                                <div style="font-size: 12px; color: var(--text-muted); margin-bottom: 4px;">Groups</div>
                                <div id="guGroups" style="font-weight: 500; font-size: 14px; word-break: break-word;"></div>
                            </div>
                        </div>
                    </div>
                </div>
            `;
            document.body.appendChild(modalOverlay);
        }
        
        document.getElementById('guAvatar').innerHTML = getAvatar(user.id, user.firstName, user.profilePhoto, 80);
        document.getElementById('guName').textContent = user.firstName + ' ' + user.lastName;
        document.getElementById('guUsername').textContent = '@' + user.username;
        document.getElementById('guEmail').textContent = user.email || '-';
        
        let deptName = '-';
        if (user.departmentId) {
            try {
                const depts = (window.globalLookup && window.globalLookup.departments) ? window.globalLookup.departments : await window.api.request('/Departments');
                const d = depts.find(x => x.id == user.departmentId);
                if (d) deptName = d.name;
            } catch (e) { console.error(e); }
        }
        document.getElementById('guDept').textContent = deptName;
        document.getElementById('guStatus').innerHTML = user.isActive ? '<span class="badge badge-success">Active</span>' : '<span class="badge badge-default">Inactive</span>';
        let groupsStr = '-';
        if (user.groupIds && user.groupIds.length > 0) {
            try {
                const allGroups = window.globalGroups || await window.api.getGroups().catch(e=>[]);
                groupsStr = user.groupIds.map(id => {
                    const g = allGroups.find(x => x.id == id);
                    return g ? g.name : `Group ${id}`;
                }).join(', ');
            } catch(e) { console.error(e); }
        }
        document.getElementById('guGroups').textContent = groupsStr;
        
        
        openModal('globalUserModal');
    } catch(e) {
        console.error(e);
        showToast('Failed to load user details', 'error');
    }
}
