
        import './js/api.js?v=999';
        import { injectShell } from './js/layout.js?v=999';
        import { bindShellActions } from './js/ui.js?v=999';
        import { t } from './js/i18n.js';
        
        injectShell();
        if (!window.api.token) window.location.href = '/login.html';
        bindShellActions();

        let rawWorkload = [];

        function renderWorkload(data) {
            const container = document.getElementById('workloadContainer');
            if (data.length === 0) {
                container.innerHTML = `<div style="grid-column: 1 / -1; text-align: center; padding: 40px; color: var(--text-muted);">${t('dash_no_data') || 'Veri bulunamadı'}</div>`;
                return;
            }

            container.innerHTML = data.map(dept => `
                <div class="department-card">
                    <h3>
                        ${window.ui?.escapeHtml(dept.departmentName) || dept.departmentName}
                        <span class="badge" title="Toplam Açık İş">${dept.openTicketCount}</span>
                    </h3>
                    <div class="agent-list">
                        ${dept.members && dept.members.length > 0 ? dept.members.map(agent => `
                            <div class="agent-item">
                                <div class="agent-header">
                                    <div class="avatar">${agent.userName ? agent.userName.charAt(0).toUpperCase() : 'U'}</div>
                                    <div class="agent-info">
                                        <div class="agent-name"><span class="user-hover-link" data-user-id="${agent.userId}" style="cursor: pointer;" onclick="if(window.ui && window.ui.showUserDetails) window.ui.showUserDetails(${agent.userId}); else if(window.openUserDetails) window.openUserDetails(${agent.userId});">${window.ui?.escapeHtml(agent.userName) || agent.userName}</span></div>
                                        <div class="progress-bar">
                                            <div class="progress-fill" style="width: ${Math.min(agent.openTicketCount * 10, 100)}%; background: ${(() => { if (agent.openTicketCount > 10) { return 'var(--danger)'; } else if (agent.openTicketCount > 5) { return 'var(--warning)'; } else { return 'var(--info)'; } })()};"></div>
                                        </div>
                                    </div>
                                    <div class="agent-count" style="color: ${(() => { if (agent.openTicketCount > 10) { return 'var(--danger)'; } else if (agent.openTicketCount > 5) { return '#B36200'; } else { return 'var(--text-main)'; } })()};">
                                        ${agent.openTicketCount}
                                    </div>
                                </div>
                            </div>
                        `).join('') : `<div style="font-size:12px; color:var(--text-muted); text-align:center;">Ekip üyesi yok</div>`}
                    </div>
                </div>
            `).join('');
        }

        async function init() {
            try {
                window.globalUsers = await window.api.getUsers();
                rawWorkload = await window.api.request('/dashboard/department-workload') || [];
                document.getElementById('loadingState').style.display = 'none';
                document.getElementById('workloadContainer').style.display = 'grid';
                renderWorkload(rawWorkload);
            } catch (err) {
                console.error(err);
                document.getElementById('loadingState').textContent = 'Veri yüklenemedi.';
                document.getElementById('loadingState').style.color = 'var(--danger)';
            }
        }

        document.getElementById('searchInput').addEventListener('input', (e) => {
            const keyword = e.target.value.toLowerCase();
            if (!keyword) {
                renderWorkload(rawWorkload);
                return;
            }
            
            const filtered = [];
            rawWorkload.forEach(dept => {
                const matchesDept = dept.departmentName?.toLowerCase().includes(keyword);
                const matchingMembers = dept.members?.filter(m => m.userName?.toLowerCase().includes(keyword)) || [];
                
                if (matchesDept || matchingMembers.length > 0) {
                    filtered.push({
                        ...dept,
                        members: matchingMembers.length > 0 ? matchingMembers : dept.members
                    });
                }
            });
            renderWorkload(filtered);
        });

        
        window.globalLookup = await window.api.getLookup().catch(e=>({}));
        window.globalGroups = await window.api.getGroups().catch(e=>[]);
        
        function renderUserTooltipContent(user) {
            const dept = window.globalLookup?.departments?.find(d => d.id == user.departmentId)?.name || 'None';
            const userGroups = user.groupIds && window.globalGroups ? user.groupIds.map(gid => window.globalGroups.find(g => g.id == gid)?.name).filter(n => n).join(', ') : 'None';
            const createdAt = user.createdAt ? new Date(user.createdAt).toLocaleDateString() : 'Unknown';
            const avatar = '<div style="width:32px;height:32px;border-radius:50%;background:var(--primary);color:white;display:flex;align-items:center;justify-content:center;font-weight:bold;">' + (user.firstName ? user.firstName.charAt(0).toUpperCase() : 'U') + '</div>';

            return `
                <div style="display:flex; align-items:center; gap:12px; margin-bottom:8px; border-bottom:1px solid var(--border); padding-bottom:8px;">
                    ${avatar}
                    <div>
                        <div style="font-weight:600; font-size:14px;">${window.ui?.escapeHtml(user.firstName + ' ' + user.lastName)}</div>
                        <div style="font-size:11px; color:var(--text-muted);">@${window.ui?.escapeHtml(user.username)}</div>
                    </div>
                </div>
                <div style="font-size:12px; display:flex; flex-direction:column; gap:4px;">
                    <div><strong style="color:var(--text-muted);">Joined:</strong> ${createdAt}</div>
                    <div><strong style="color:var(--text-muted);">Dept:</strong> ${window.ui?.escapeHtml(dept)}</div>
                    <div><strong style="color:var(--text-muted);">Groups:</strong> ${window.ui?.escapeHtml(userGroups)}</div>
                </div>
            `;
        }

        const userTooltip = document.getElementById('userTooltip');
        document.addEventListener('mouseover', (e) => {
            const target = e.target.closest('.user-hover-link');
            if (target) {
                const userId = target.dataset.userId;
                const user = (window.globalUsers !== undefined ? window.globalUsers : []).find(u => u.id == userId);
                if (user) {
                    userTooltip.innerHTML = renderUserTooltipContent(user);
                    const rect = target.getBoundingClientRect();
                    userTooltip.style.display = 'block';
                    let top = rect.bottom + window.scrollY + 8;
                    let left = rect.left + window.scrollX;
                    if (top + userTooltip.offsetHeight > window.scrollY + window.innerHeight) top = rect.top + window.scrollY - userTooltip.offsetHeight - 8;
                    if (left + userTooltip.offsetWidth > window.scrollX + window.innerWidth) left = rect.right + window.scrollX - userTooltip.offsetWidth;
                    userTooltip.style.top = top + 'px';
                    userTooltip.style.left = left + 'px';
                }
            }
        });
        document.addEventListener('mouseout', (e) => {
            const target = e.target.closest('.user-hover-link');
            if (target) userTooltip.style.display = 'none';
        });

        init();

    