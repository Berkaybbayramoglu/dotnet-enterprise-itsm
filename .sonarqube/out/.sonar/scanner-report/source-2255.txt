import re

with open('src/ItsTool.Web/wwwroot/js/notifications.js', 'r') as f:
    content = f.read()

helpers = """
function getNotificationTitle(type, defaultTitle) {
    if (type === 'comment.mention') return 'Etiketlendiniz';
    if (type === 'ticket.comment.added') return 'Yeni Yorum';
    if (type === 'ticket.created') return 'Bilet Oluşturuldu';
    if (type === 'sla.breached') return 'SLA İhlali';
    if (type === 'sla.risk') return 'SLA Riski';
    return (defaultTitle || '').replace('Event ', '');
}

function getNotificationLink(n, commentId) {
    if (n.entityType === 'Ticket' && n.entityId) {
        return `/ticket-detail.html?id=${n.entityId}` + (commentId ? `&highlight=true&commentId=${commentId}` : '');
    }
    if (n.entityType === 'KnowledgeArticle' && n.entityId) {
        return `/kb-article.html?id=${n.entityId}`;
    }
    return '#';
}

function parseNotificationBody(n) {
    let bodyText = n.body || '';
    let commentId = null;
    if (n.type === 'comment.mention' && bodyText.includes('|')) {
        const p = bodyText.split('|');
        bodyText = p[0];
        commentId = p[1];
    }
    return { bodyText, commentId };
}

function createNotificationItem(n) {
    const priorityHtml = n.priority === 'High' ? '<span class="badge" style="background:var(--danger);font-size:10px;">High</span>' : '';
    const bgClass = n.isRead ? 'background: var(--bg-hover); opacity: 0.8;' : 'background: var(--bg-surface);';
    
    const { bodyText, commentId } = parseNotificationBody(n);
    const linkUrl = getNotificationLink(n, commentId);
    const displayTitle = getNotificationTitle(n.type, n.title);
    
    const readIcon = n.isRead 
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
                        <button type="button" class="btn btn-outline-secondary" style="padding: 2px 8px; font-size: 11px; border-radius: 4px;" onclick="event.preventDefault(); event.stopPropagation(); window.showInfoModal('${t ? t('notif_detail') : 'Bildirim Detayı'}', '${bodyText.replaceAll("'", String.raw`\\'`).replaceAll('"', '&quot;')}');">${t ? t('notif_detail_btn') : 'Detay'}</button>
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
            return; // handled by inline handlers
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
    
    return item;
}
"""

new_load = """async function loadNotifications() {
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
                container.appendChild(createNotificationItem(n));
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
"""

# Replace in content
pattern = re.compile(r'async function loadNotifications\(\) \{.*?\n\}\n', re.DOTALL)
content = pattern.sub(new_load + "\n", content)

# Append helpers to the end
content = content + "\n" + helpers

# Fix String.raw issue in showToastNotification at line ~292
# Wait, let's fix the String.raw issue inside showToastNotification as well if there's any?
# L87 is already fixed because readTick is removed. L134 is fixed because we used String.raw inside createNotificationItem.
# Is there another one? No, the user just said "String.raw bulgusu [R24]" under notifications.js.

with open('src/ItsTool.Web/wwwroot/js/notifications.js', 'w') as f:
    f.write(content)

