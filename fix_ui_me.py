import sys

with open("src/ItsTool.Web/wwwroot/js/ui.js", "r", encoding="utf-8") as f:
    content = f.read()

me_panel_html = """
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
                        
                        let permsHtml = perms.map(p => {
                            const isOverride = overrides.includes(p);
                            return `<div style="font-size: 12px; padding: 4px 0; border-bottom: 1px solid var(--border); display: flex; justify-content: space-between;">
                                <span>${p}</span>
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
                    } catch(err) {
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
"""

content = content.replace("const currentPath = window.location.pathname;", me_panel_html + "\n\n    const currentPath = window.location.pathname;")

with open("src/ItsTool.Web/wwwroot/js/ui.js", "w", encoding="utf-8") as f:
    f.write(content)
