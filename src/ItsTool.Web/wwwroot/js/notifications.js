import { t } from './i18n.js';

let hubConnection = null;

export async function initNotifications() {
    const token = window.api ? window.api.token : localStorage.getItem('jwt_token');
    if (!token) return;

    function getUserIdFromToken() {
        try {
            const payload = JSON.parse(atob(token.split('.')[1]));
            return payload['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'] || payload.nameid || payload.sub;
        } catch { return null; }
    }

    const userId = getUserIdFromToken();
    if (!userId) return;

    // Fetch initial notifications
    await loadNotifications();

    // Setup SignalR
    hubConnection = new signalR.HubConnectionBuilder()
        .withUrl("http://localhost:5246/hubs/notification", {
            accessTokenFactory: () => token
        })
        .withAutomaticReconnect()
        .build();

    hubConnection.on("ReceiveNotification", (payload) => {
        // payload = { type, title, body, entityId, priority, createdAt }
        showToastNotification(payload);
        loadNotifications(); // reload list
    });

    const notifList = document.getElementById('notificationList');
    if (notifList && !document.getElementById('btnDeleteAllNotifs')) {
        const li = document.createElement('li');
        li.innerHTML = `<a id="btnDeleteAllNotifs" class="dropdown-item text-center" href="#" onclick="deleteAllNotifications(event)" style="padding: 12px 0; color: var(--danger); font-weight: 500; text-decoration: none; display: flex; align-items: center; justify-content: center; gap: 6px; transition: background 0.2s; border-top: 1px solid var(--border);">
            <svg viewBox="0 0 24 24" width="18" height="18" fill="currentColor"><path d="M16 9v10H8V9h8m-1.5-6h-5l-1 1H5v2h14V4h-3.5l-1-1zM18 7H6v12c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7z"/></svg>
            ${t ? t('topbar_delete_all') : 'Tamamını Sil'}
        </a>`;
        notifList.appendChild(li);
    }
    
    try {
        await hubConnection.start();
        console.log("SignalR Connected for notifications.");
    } catch (err) {
        console.error("SignalR Connection Error: ", err);
    }
}

// Dropdown toggle logic runs unconditionally
if (typeof document !== 'undefined') {
    document.addEventListener('click', (e) => {
        const toggle = e.target.closest('#bellDropdown');
        const menu = document.getElementById('notificationList');
        if (toggle) {
            menu.classList.toggle('show');
        } else if (menu && !menu.contains(e.target)) {
            menu.classList.remove('show');
        }
    });
}

async function loadNotifications() {
    try {
        const res = await window.api.request(`/notifications`);
        const data = res; // window.api.request parses json
        
        const container = document.getElementById('notificationItems');
        const badge = document.getElementById('notificationBadge');
        if (!container || !badge) return;

        container.innerHTML = '';
        let unreadCount = 0;

        if (data.length === 0) {
            container.innerHTML = '<div class="p-3 text-center text-muted"><small>No notifications</small></div>';
        } else {
            data.forEach(n => {
                if (!n.isRead) unreadCount++;
                
                let priorityHtml = n.priority === 'High' ? '<span class="badge" style="background:var(--danger);font-size:10px;">High</span>' : '';
                let bgClass = n.isRead ? 'background: var(--bg-hover); opacity: 0.8;' : 'background: var(--bg-surface);';
                let readTick = n.isRead ? '<svg viewBox="0 0 24 24" width="16" height="16" style="fill:var(--success);"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg>' : '';
                
                let bodyText = n.body;
                let commentId = null;
                if (n.type === 'comment.mention' && bodyText.includes('|')) {
                    const p = bodyText.split('|');
                    bodyText = p[0];
                    commentId = p[1];
                }

                let linkUrl = '#';
                if (n.entityType === 'Ticket' && n.entityId) {
                    linkUrl = `/ticket-detail.html?id=${n.entityId}`;
                    if (commentId) linkUrl += `&highlight=true&commentId=${commentId}`;
                } else if (n.entityType === 'KnowledgeArticle' && n.entityId) {
                    linkUrl = `/kb-article.html?id=${n.entityId}`;
                }
                
                let displayTitle = n.title;
                if (n.type === 'comment.mention') displayTitle = 'Etiketlendiniz';
                else if (n.type === 'ticket.comment.added') displayTitle = 'Yeni Yorum';
                else if (n.type === 'ticket.created') displayTitle = 'Bilet Oluşturuldu';
                else if (n.type === 'sla.breached') displayTitle = 'SLA İhlali';
                else if (n.type === 'sla.risk') displayTitle = 'SLA Riski';
                else displayTitle = displayTitle.replace('Event ', '');
                
                let readIcon = n.isRead 
                    ? '<div class="already-read-icon" style="display:flex; align-items:center; justify-content:center; width:24px; height:24px; cursor:default;"><svg viewBox="0 0 24 24" width="18" height="18" style="fill:var(--success);" title="Okundu"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg></div>' 
                    : '<button class="mark-read-btn" style="background:none; border:none; padding:0; display:flex; align-items:center; justify-content:center; width:24px; height:24px; cursor:pointer;" title="Okundu Olarak İşaretle"><svg viewBox="0 0 24 24" width="18" height="18" style="fill:var(--text-muted); opacity: 0.5; transition: opacity 0.2s;" onmouseover="this.style.opacity=1" onmouseout="this.style.opacity=0.5"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg></button>';
                
                const item = document.createElement('div');
                item.className = `dropdown-item py-2 px-3 border-bottom`;
                item.style = `white-space: normal; position: relative; ${bgClass} cursor: default;`;
                item.innerHTML = `
                    <div style="display: flex; gap: 12px; align-items: flex-start;">
                        <div style="flex: 1;">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <div class="d-flex align-items-center gap-2">
                                    <strong style="font-size: 14px;">${displayTitle}</strong>
                                    ${priorityHtml}
                                </div>
                            </div>
                            <div style="font-size: 13px; color: var(--text-muted); line-height: 1.4; margin-bottom: 8px;">${bodyText}</div>
                            
                            <div class="d-flex justify-content-between align-items-center">
                                <div style="font-size: 11px; color: #999;">${new Date(n.createdAt).toLocaleString()}</div>
                                <div class="d-flex gap-sm">
                                    <button type="button" class="btn btn-outline-secondary" style="padding: 2px 8px; font-size: 11px; border-radius: 4px;" onclick="event.preventDefault(); event.stopPropagation(); window.showInfoModal('${t ? t('notif_detail') : 'Bildirim Detayı'}', '${bodyText.replaceAll("'", "\\'")}');">${t ? t('notif_detail_btn') : 'Detay'}</button>
                                    <a href="${linkUrl}" class="btn btn-primary" style="padding: 2px 8px; font-size: 11px; border-radius: 4px; color: white; text-decoration: none;" onclick="event.stopPropagation();">Git</a>
                                </div>
                            </div>
                        </div>
                        <div style="display: flex; flex-direction: column; gap: 8px; align-items: center; margin-top: 2px;">
                            ${readIcon}
                            <button class="delete-notification-btn" data-id="${n.id}" style="background:none; border:none; color:var(--danger); padding:0; display:flex; align-items:center; justify-content:center; width:24px; height:24px; cursor:pointer; opacity: 0.7; transition: opacity 0.2s;" onmouseover="this.style.opacity=1" onmouseout="this.style.opacity=0.7" title="Sil">
                                <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><path d="M16 9v10H8V9h8m-1.5-6h-5l-1 1H5v2h14V4h-3.5l-1-1zM18 7H6v12c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7z"/></svg>
                            </button>
                        </div>
                    </div>
                `;
                
                item.addEventListener('click', async (e) => {
                    if (e.target.closest('.delete-notification-btn')) {
                        e.preventDefault();
                        e.stopPropagation();
                        try {
                            await window.api.request(`/notifications/${n.id}`, { method: 'DELETE' });
                            loadNotifications();
                        } catch(err) { console.error(err); }
                        return;
                    }
                    if (e.target.closest('.mark-read-btn') || e.target.closest('.already-read-icon')) {
                        e.preventDefault();
                        e.stopPropagation();
                        if (!n.isRead) {
                            try {
                                await window.api.request(`/notifications/${n.id}/read`, { method: 'POST' });
                                loadNotifications();
                            } catch(err) { console.error(err); }
                        }
                        return;
                    }
                    if (e.target.closest('.btn')) {
                        return; // handled by inline handlers (like Detay/Git)
                    }
                    e.preventDefault();
                    if (!n.isRead) {
                        try {
                            await window.api.request(`/notifications/${n.id}/read`, { method: 'POST' });
                        } catch(err) {}
                    }
                    if (linkUrl !== '#') {
                        window.location.href = linkUrl;
                    } else {
                        loadNotifications();
                    }
                });
                
                container.appendChild(item);
            });
        }

        if (unreadCount > 0) {
            badge.style.display = 'block';
            badge.innerText = unreadCount > 9 ? '9+' : unreadCount;
        } else {
            badge.style.display = 'none';
        }

    } catch (err) {
        console.error("Error loading notifications:", err);
    }
}

window.deleteAllNotifications = async function(e) {
    e.preventDefault();
    if (!confirm(t ? t('notif_confirm_delete') : 'Tüm bildirimleri kalıcı olarak silmek istediğinize emin misiniz?')) return;
    try {
        await window.api.request(`/notifications/all`, { method: 'DELETE' });
        loadNotifications();
    } catch(err) {
        console.error(err);
    }
}

window.markAllAsRead = async function(e) {
    e.preventDefault();
    try {
        await window.api.request(`/notifications/read-all`, { method: 'POST' });
        loadNotifications();
    } catch(err) {
        console.error(err);
    }
}

function showToastNotification(payload) {
    // We can use Bootstrap toast if available or simple custom toast
    let toastContainer = document.getElementById('toast-container');
    if (!toastContainer) {
        toastContainer = document.createElement('div');
        toastContainer.id = 'toast-container';
        toastContainer.style.position = 'fixed';
        toastContainer.style.top = '20px';
        toastContainer.style.right = '20px';
        toastContainer.style.zIndex = '9999';
        document.body.appendChild(toastContainer);
    }

    const toastId = 'toast_' + Date.now();
    const borderCol = payload.priority === 'High' ? 'var(--danger)' : 'var(--primary)';
    const iconColor = payload.priority === 'High' ? 'var(--danger)' : 'var(--primary)';
    
    let bodyText = payload.body;
    let commentId = null;
    if (payload.type === 'comment.mention' && bodyText.includes('|')) {
        const p = bodyText.split('|');
        bodyText = p[0];
        commentId = p[1];
    }
    
    let displayTitle = payload.title;
    let iconSvg = '';
    
    if (payload.type === 'comment.mention') { 
        displayTitle = 'Etiketlendiniz'; 
        iconSvg = '<svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10h5v-2h-5c-4.34 0-8-3.66-8-8s3.66-8 8-8 8 3.66 8 8v1.43c0 .79-.71 1.57-1.5 1.57s-1.5-.78-1.5-1.57V12c0-2.76-2.24-5-5-5s-5 2.24-5 5 2.24 5 5 5c1.38 0 2.64-.56 3.54-1.47.65.89 1.77 1.47 2.96 1.47 1.97 0 3.5-1.6 3.5-3.57V12c0-5.52-4.48-10-10-10zm0 13c-1.66 0-3-1.34-3-3s1.34-3 3-3 3 1.34 3 3-1.34 3-3 3z"/></svg>';
    }
    else if (payload.type === 'ticket.comment.added') { displayTitle = 'Yeni Yorum'; }
    else if (payload.type === 'ticket.created') { displayTitle = 'Bilet Oluşturuldu'; }
    else if (payload.type === 'sla.breached') { displayTitle = 'SLA İhlali'; }
    else if (payload.type === 'sla.risk') { displayTitle = 'SLA Riski'; }
    else { displayTitle = displayTitle.replace('Event ', ''); }
    
    if (!iconSvg) {
        iconSvg = '<svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><path d="M12 22c1.1 0 2-.9 2-2h-4c0 1.1.89 2 2 2zm6-6v-5c0-3.07-1.64-5.64-4.5-6.32V4c0-.83-.67-1.5-1.5-1.5s-1.5.67-1.5 1.5v.68C7.63 5.36 6 7.92 6 11v5l-2 2v1h16v-1l-2-2z"/></svg>';
    }

    let linkUrl = '#';
    if (payload.entityId) {
        if (payload.entityType === 'Ticket') {
            linkUrl = `/ticket-detail.html?id=${payload.entityId}`;
            if (commentId) linkUrl += `&highlight=true&commentId=${commentId}`;
        } else if (payload.entityType === 'KnowledgeArticle') {
            linkUrl = `/kb-article.html?id=${payload.entityId}`;
        }
    }

    const toastHtml = `
        <div id="${toastId}" role="alert" aria-live="assertive" aria-atomic="true" style="display: flex; flex-direction: column; margin-bottom: 10px; width: 280px; border: none; border-left: 3px solid ${borderCol}; border-radius: 4px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); background: var(--bg-surface); opacity: 1; transition: opacity 0.4s ease;">
            <div style="display: flex; align-items: center; padding: 10px 12px 4px 12px;">
                <div style="color: ${iconColor}; margin-right: 8px; display: flex; align-items: center;">
                    ${iconSvg}
                </div>
                <strong style="font-size: 13px; color: var(--text-main); font-weight: 600; flex: 1;">${displayTitle}</strong>
                <button type="button" onclick="document.getElementById('${toastId}').remove()" style="font-size: 14px; margin-left: 8px; background: transparent; border: none; cursor: pointer; color: var(--text-muted); opacity: 0.6; padding: 0 4px; line-height: 1;">&times;</button>
            </div>
            <div style="padding: 4px 12px 12px 12px; font-size: 12px; color: var(--text-muted); line-height: 1.4;">
                <div style="margin-bottom: 8px;">${bodyText}</div>
                <div style="text-align: right;">
                    <a href="${linkUrl}" class="btn btn-sm btn-outline-primary" style="display: inline-block; font-size: 11px; padding: 2px 8px; border-radius: 4px; text-decoration: none; cursor: pointer;">Bilete Git</a>
                </div>
            </div>
        </div>
    `;
    
    toastContainer.insertAdjacentHTML('beforeend', toastHtml);
    setTimeout(() => {
        const el = document.getElementById(toastId);
        if (el) {
            el.style.opacity = '0';
            el.style.transition = 'opacity 0.4s ease';
            setTimeout(() => el.remove(), 400);
        }
    }, 6000);
}
