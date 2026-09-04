import re

with open("old-ticket-detail.html", "r", encoding="utf-8") as f:
    html = f.read()

# Extract the entire loadTicket function
# It starts at "async function loadTicket() {"
start_idx = html.find("async function loadTicket() {")
# We know it ends right before "window.openUserDetails = async function(userId) {"
end_idx = html.find("        window.openUserDetails = async function(userId) {")

old_func = html[start_idx:end_idx]

# We want to replace it with a much cleaner version.
# We will define helper functions outside.

new_funcs = """
        async function fetchTicketContext() {
            try { 
                globalLookup = await window.api.getLookup(); 
                globalUsers = await window.api.getUsers();
                globalGroups = await window.api.getGroups();
            } catch (e) { 
                console.warn('Lookup failed', e); 
            }
        }

        function highlightIfRequested() {
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('highlight') === 'true') {
                setTimeout(() => {
                    const header = document.querySelector('.content-area');
                    if (header) header.classList.add('row-highlight');
                }, 100);
            }
        }

        function renderAssignments(t, users, groups, lookup) {
            if (!t.assignments || t.assignments.length === 0) {
                return '<span class="text-muted">Unassigned</span>';
            }
            
            const uniqueAssignmentsMap = new Map();
            t.assignments.filter(a => a.isActive).forEach(a => {
                let key = null;
                if (a.userId) key = `u_${a.userId}`;
                else if (a.groupId) key = `g_${a.groupId}`;
                if (key && !uniqueAssignmentsMap.has(key)) {
                    uniqueAssignmentsMap.set(key, a);
                }
            });
            const activeAssignments = Array.from(uniqueAssignmentsMap.values());
            
            if (activeAssignments.length === 0) {
                return '<span class="text-muted">No active assignments</span>';
            }
            
            const grouped = {};
            activeAssignments.forEach(a => {
                if (a.groupId) {
                    const g = groups.find(x => x.id === a.groupId);
                    const dId = g?.departmentId || 'none';
                    if (!grouped[dId]) grouped[dId] = { groups: {}, usersWithoutGroup: [] };
                    if (!grouped[dId].groups[a.groupId]) grouped[dId].groups[a.groupId] = { groupData: g, users: [] };
                }
            });
            
            activeAssignments.forEach(a => {
                if (a.userId) {
                    const u = users.find(x => x.id === a.userId);
                    const dId = u?.departmentId || 'none';
                    if (!grouped[dId]) grouped[dId] = { groups: {}, usersWithoutGroup: [] };
                    
                    let placedInGroup = false;
                    if (u?.groupIds && u.groupIds.length > 0) {
                        for (let gId of u.groupIds) {
                            if (grouped[dId].groups[gId]) {
                                grouped[dId].groups[gId].users.push(u);
                                placedInGroup = true;
                                break;
                            }
                        }
                    }
                    if (!placedInGroup) grouped[dId].usersWithoutGroup.push(u);
                }
            });

            const deptsLookup = lookup !== undefined && lookup.departments ? lookup.departments : [];
            let deptBlocks = [];
            for (const [deptId, deptData] of Object.entries(grouped)) {
                let deptName = 'No Department';
                if (deptId !== 'none') {
                    const d = deptsLookup.find(x => x.id == deptId);
                    if (d) deptName = d.name;
                }

                let blockHtml = `<div class="assignee-dept-block" style="margin-bottom: 8px; margin-left: 0 !important; padding-left: 0 !important; border: none;">
                  <div class="d-flex align-items-center gap-sm" style="font-size: 12px; font-weight: 600; color: var(--text-muted); margin-bottom: 4px; text-transform: uppercase;">
                      <svg viewBox="0 0 24 24" width="14" height="14" style="fill:currentColor"><path d="M10 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2h-8l-2-2z"/></svg>
                      ${escapeHtml(deptName)}
                  </div>
                  <div style="padding-left: 16px; display: flex; flex-direction: column; gap: 4px;">`;

                for (const [gId, gData] of Object.entries(deptData.groups)) {
                    const gName = gData.groupData ? gData.groupData.name : 'Unknown Group';
                    blockHtml += `<div class="d-flex align-items-center gap-sm" style="font-size: 13px;"><svg viewBox="0 0 24 24" width="20" height="20" style="fill:var(--text-muted)"><path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/></svg> <span style="font-weight:500; color:var(--text-main);">${escapeHtml(gName)}</span></div>`;
                    if (gData.users.length > 0) {
                        blockHtml += `<div style="padding-left: 20px; display: flex; flex-direction: column; gap: 4px; margin-top: 2px;">`;
                        gData.users.forEach(u => {
                            const uName = u ? (u.firstName + ' ' + u.lastName) : 'Unknown User';
                            const uId = u ? u.id : 0;
                            blockHtml += `<div class="d-flex align-items-center gap-sm" style="cursor:pointer;" onclick="openUserDetails(${uId})">${getAvatar(uId, uName, u?.profilePhoto, 20)} <span style="color:var(--primary); font-weight:500; font-size: 13px;">${escapeHtml(uName)}</span></div>`;
                        });
                        blockHtml += `</div>`;
                    }
                }

                deptData.usersWithoutGroup.forEach(u => {
                    const uName = u ? (u.firstName + ' ' + u.lastName) : 'Unknown User';
                    const uId = u ? u.id : 0;
                    blockHtml += `<div class="d-flex align-items-center gap-sm" style="cursor:pointer;" onclick="openUserDetails(${uId})">${getAvatar(uId, uName, u?.profilePhoto, 20)} <span style="color:var(--primary); font-weight:500; font-size: 13px;">${escapeHtml(uName)}</span></div>`;
                });

                blockHtml += `</div></div>`;
                deptBlocks.push(blockHtml);
            }
            return deptBlocks.join('');
        }

        window.openAssignModal = async () => {
            const container = document.getElementById('assignTreeContainer');
            container.innerHTML = '<div style="text-align:center; padding: 20px;">Loading tree...</div>';
            openModal('manageAssigneesModal');
            
            try {
                const deptsRes = await window.api.request('/departments').catch(() => ({ items: [] }));
                const grpsRes = await window.api.request('/groups').catch(() => ({ items: [] }));
                const usrsRes = await window.api.getUsers();
                const depts = Array.isArray(deptsRes) ? deptsRes : (deptsRes.items || []);
                const grps = Array.isArray(grpsRes) ? grpsRes : (grpsRes.items || []);
                const usrs = Array.isArray(usrsRes) ? usrsRes : (usrsRes.items || []);
                
                let html = '<ul style="list-style:none; padding:0; margin:0; font-size:14px;">';
                depts.forEach(d => {
                    html += `
                        <li style="margin-bottom: 8px;">
                            <div style="display:flex; align-items:center; gap:8px; font-weight:600; padding:6px; background:var(--bg-hover); border-radius:4px; cursor:pointer;" onclick="const ul = this.nextElementSibling; ul.style.display = ul.style.display === 'none' ? 'block' : 'none'; const svg = this.querySelector('.dept-chevron'); svg.style.transform = ul.style.display === 'none' ? '' : 'rotate(90deg)';">
                                <svg class="dept-chevron" viewBox="0 0 24 24" width="16" height="16" style="transition: transform 0.2s;"><path d="M8.59 16.59L13.17 12 8.59 7.41 10 6l6 6-6 6-1.41-1.41z"/></svg>
                                <svg viewBox="0 0 24 24" width="16" height="16" style="fill:${d.color || 'currentColor'};"><path d="M10 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2h-8l-2-2z"/></svg>
                                ${escapeHtml(d.name)}
                            </div>
                            <ul style="list-style:none; padding-left:24px; margin-top:8px; display:none;">
                    `;
                    const dGroups = grps.filter(g => g.departmentId === d.id);
                    if (dGroups.length === 0) {
                        html += `<li style="color:var(--text-muted); font-size:12px; padding:4px;">No groups</li>`;
                    } else {
                        dGroups.forEach(g => {
                            const isGrpSelected = currentTicket?.assignments?.some(a => a.isActive && a.groupId === g.id);
                            html += `
                                <li style="margin-bottom: 4px;">
                                    <div style="display:flex; align-items:center; gap:8px; padding:4px;">
                                        <input type="checkbox" class="group-checkbox" value="${g.id}" ${isGrpSelected ? 'checked' : ''}>
                                        <span style="font-weight:500; display:flex; align-items:center; gap:4px; cursor:pointer;" onclick="const ul = this.parentElement.nextElementSibling; ul.style.display = ul.style.display === 'none' ? 'block' : 'none'; const svg = this.querySelector('.grp-chevron'); svg.style.transform = ul.style.display === 'none' ? '' : 'rotate(90deg)';">
                                            <svg class="grp-chevron" viewBox="0 0 24 24" width="16" height="16" style="transition: transform 0.2s;"><path d="M8.59 16.59L13.17 12 8.59 7.41 10 6l6 6-6 6-1.41-1.41z"/></svg>
                                            <svg viewBox="0 0 24 24" width="14" height="14" style="fill:var(--text-muted)"><path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/></svg>
                                            ${escapeHtml(g.name)}
                                        </span>
                                    </div>
                                    <ul style="list-style:none; padding-left:24px; margin-top:4px; display:none;">
                            `;
                            const gUsers = usrs.filter(u => u.groupIds && u.groupIds.includes(g.id));
                            if (gUsers.length === 0) {
                                html += `<li style="color:var(--text-muted); font-size:12px; padding:4px;">No users</li>`;
                            } else {
                                gUsers.forEach(u => {
                                    const isUsrSelected = currentTicket?.assignments?.some(a => a.isActive && a.userId === u.id);
                                    html += `
                                        <li style="padding:2px 4px;">
                                            <label style="display:flex; align-items:center; gap:8px; cursor:pointer;">
                                                <input type="checkbox" class="user-checkbox" value="${u.id}" ${isUsrSelected ? 'checked' : ''}>
                                                ${getAvatar(u.id, u.firstName, u.profilePhoto, 16)}
                                                <span style="font-size:13px;">${escapeHtml(u.firstName + ' ' + u.lastName)} <span style="color:var(--text-muted);">(@${escapeHtml(u.username)})</span></span>
                                            </label>
                                        </li>
                                    `;
                                });
                            }
                            html += `</ul></li>`;
                        });
                    }
                    html += `</ul></li>`;
                });
                html += '</ul>';
                container.innerHTML = html;
            } catch (err) {
                container.innerHTML = '<div style="color:var(--danger); padding:20px; text-align:center;">Failed to load tree data.</div>';
            }
        };

        window.openAssignmentTree = async () => {
            openModal('assignmentTreeModal');
            const container = document.getElementById('assignmentTreeContainer');
            container.innerHTML = '<div style="text-align:center; padding: 20px;">Loading tree...</div>';
            try {
                const tree = await window.api.request(`/Ticket/${ticketId}/assignments/tree`);
                
                function renderNode(node) {
                    let assigneeName = '';
                    let icon = '';
                    if (node.userId) {
                        const u = globalUsers.find(x => x.id === node.userId);
                        assigneeName = u ? (u.firstName + ' ' + u.lastName) : (node.assigneeName || 'Unknown User');
                        icon = `<svg viewBox="0 0 24 24" width="16" height="16" style="fill:var(--primary); margin-right:4px; vertical-align:middle;"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>`;
                    } else if (node.groupId) {
                        const g = globalGroups.find(x => x.id === node.groupId);
                        assigneeName = g ? g.name : (node.assigneeName || 'Unknown Group');
                        icon = `<svg viewBox="0 0 24 24" width="16" height="16" style="fill:var(--text-muted); margin-right:4px; vertical-align:middle;"><path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/></svg>`;
                    }
                    
                    const assigner = globalUsers.find(x => x.id === node.assignedByUserId);
                    const assignerName = assigner ? assigner.username : 'System';
                    const date = new Date(node.createdAt).toLocaleString();
                    
                    let status = '';
                    if (node.isAssigneeDeleted) status += '<span class="badge badge-danger" style="font-size:10px; margin-right:4px;">Deleted</span>';
                    status += node.isActive ? '<span class="badge badge-success" style="font-size:10px;">Active</span>' : '<span class="badge badge-default" style="font-size:10px;">Inactive</span>';
                    
                    let html = `<div style="border-left: 2px solid var(--border); padding-left: 16px; margin-left: 8px; margin-top: 8px; position:relative;">
                        <div style="position:absolute; left:0; top: 12px; width:16px; border-top: 2px solid var(--border);"></div>
                        <div style="background: var(--bg-main); border: 1px solid var(--border); padding: 8px; border-radius: var(--radius-sm); margin-bottom: 8px; display:inline-block;">
                            <div style="font-size: 14px; font-weight: 500;">${icon}${escapeHtml(assigneeName)} ${status}</div>
                            <div style="font-size: 11px; color: var(--text-muted); margin-top: 4px;">Assigned by: ${escapeHtml(assignerName)} on ${date}</div>
                        </div>`;
                    
                    if (node.children && node.children.length > 0) {
                        html += `<div style="margin-left: 16px;">`;
                        node.children.forEach(child => html += renderNode(child));
                        html += `</div>`;
                    }
                    html += `</div>`;
                    return html;
                }
                
                if (!tree || tree.length === 0) {
                    container.innerHTML = '<div class="text-muted">No assignments found in history.</div>';
                } else {
                    let rootHtml = '';
                    tree.forEach(rootNode => rootHtml += renderNode(rootNode));
                    container.innerHTML = rootHtml;
                }
            } catch(e) {
                container.innerHTML = `<div style="color:var(--danger)">Failed to load assignment tree.</div>`;
            }
        };

        async function populateStatusSelect(ticketId, currentStatusId) {
            try {
                const allowedStatuses = await window.api.request(`/Ticket/${ticketId}/allowed-transitions`);
                const select = document.getElementById('statusSelect');
                select.innerHTML = '';
                allowedStatuses.forEach(s => {
                    const opt = document.createElement('option');
                    opt.value = s.id;
                    opt.textContent = s.name;
                    select.appendChild(opt);
                });
                select.value = currentStatusId;
            } catch(e) {
                console.error("Failed to load allowed transitions", e);
            }
        }

        async function loadTicket() {
            if (!ticketId) {
                document.querySelector('.content-area').innerHTML = '<div style="padding: 40px; text-align: center; color: var(--text-muted);"><h3>Bilet ID bulunamadı</h3><p>Lütfen geçerli bir bilet seçerek tekrar deneyin.</p></div>';
                return;
            }
            
            try {
                await fetchTicketContext();
                highlightIfRequested();

                const t = await window.api.request(`/Ticket/${ticketId}`);
                currentTicket = t;
                
                await loadDynamicFieldsMeta();
                await renderTicketData();
                
                const projName = globalLookup.projects?.find(x => x.id === t.projectId)?.name || '-';
                document.getElementById('tProject').textContent = projName;
                
                const reqUser = globalUsers.find(u => u.id === t.requesterUserId);
                const getReqName = reqUser?.username || `User ${t.requesterUserId}`;
                document.getElementById('tReq').innerHTML = `<div class="d-flex align-items-center gap-sm" style="cursor:pointer;" onclick="openUserDetails(${t.requesterUserId})">${getAvatar(t.requesterUserId, getReqName, reqUser?.profilePhoto)} ${escapeHtml(getReqName)}</div>`;

                document.getElementById('tAssigned').innerHTML = renderAssignments(t, globalUsers, globalGroups, globalLookup);
                
                await populateStatusSelect(ticketId, t.statusId);

                if (t.statusId === 5) {
                    document.getElementById('csatLink').style.display = 'block';
                    document.getElementById('surveyBtn').href = `/survey.html?id=${t.id}`;
                } else {
                    document.getElementById('csatLink').style.display = 'none';
                }

                document.getElementById('content').style.display = 'grid';
                loadTimeline();
                highlightIfRequested();

            } catch (e) { 
                const errEl = document.querySelector('.content-area');
                if (errEl) {
                    errEl.innerHTML = '<div style="padding: 20px; text-align: center; color: var(--danger);">Veri yüklenemedi — API\\'yi kontrol et</div>';
                }
                showToast('Error loading ticket', 'error'); 
            }
        }
"""

new_html = html[:start_idx] + new_funcs + "\n" + html[end_idx:]

with open("old-ticket-detail.html", "w", encoding="utf-8") as f:
    f.write(new_html)

print("Applied R15 completely!")
