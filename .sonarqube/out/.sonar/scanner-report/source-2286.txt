        import './js/api.js?v=2';
        import { injectShell } from './js/layout.js';
        import { bindShellActions, showToast, openModal, closeModal } from './js/ui.js?v=2';
        injectShell();

        if (!window.api.token) window.location.href = '/login.html';
        bindShellActions();

        const getAvatar = (id, fallback, profilePhoto, size = 32) => {
            if (profilePhoto) return `<img src="${profilePhoto}" class="avatar" style="width:${size}px;height:${size}px;border-radius:50%;object-fit:cover;" title="${fallback}">`;
            if (!id || id === '-') return `<div class="avatar" style="width:${size}px;height:${size}px;background: var(--bg-hover); color: var(--text-muted); border: 1px dashed var(--border); display:flex;align-items:center;justify-content:center;border-radius:50%;">?</div>`;
            const initial = String(fallback || id).charAt(0).toUpperCase();
            return `<div class="avatar" style="width:${size}px;height:${size}px;display:flex;align-items:center;justify-content:center;border-radius:50%;" title="${fallback}">${initial}</div>`;
        };

        const urlParams = new URLSearchParams(window.location.search);
        const ticketId = urlParams.get('id');

        let currentTicket = null;
        let dynamicPlacements = [];
        let isEditMode = false;
        
        let globalLookup = {};
        let globalUsers = [];
        let globalGroups = [];

        window.openTransferModal = async function() {
            try {
                const projects = await window.api.getProjects();
                const groups = await window.api.getGroups();
                
                const pSelect = document.getElementById('transferProject');
                pSelect.innerHTML = '<option value="">-- No Change --</option>';
                projects.forEach(p => {
                    pSelect.innerHTML += `<option value="${p.id}">${escapeHtml(p.name)}</option>`;
                });
                if(currentTicket.projectId) pSelect.value = currentTicket.projectId;

                const gSelect = document.getElementById('transferGroup');
                gSelect.innerHTML = '<option value="">-- No Change --</option>';
                groups.forEach(g => {
                    gSelect.innerHTML += `<option value="${g.id}">${escapeHtml(g.name)}</option>`;
                });
                if(currentTicket.assignedGroupId) gSelect.value = currentTicket.assignedGroupId;

                openModal('transferModal');

                const urlParams = new URLSearchParams(window.location.search);
                const highlightId = urlParams.get('highlight');
                if (highlightId === 'true') {
                    setTimeout(() => {
                        const header = document.querySelector('.content-area');
                        if (header) {
                            header.classList.add('row-highlight');
                        }
                    }, 100);
                }
            } catch (e) { console.error(e); 
                showToast('Failed to load transfer data', 'error');
             }
        };

        document.getElementById('btnSubmitTransfer').addEventListener('click', async () => {
            const pid = document.getElementById('transferProject').value;
            const gid = document.getElementById('transferGroup').value;
            
            const dto = {
                projectId: pid ? Number.parseInt(pid) : null,
                groupId: gid ? Number.parseInt(gid) : null
            };

            try {
                await window.api.request(`/Ticket/${ticketId}/transfer`, { method: 'POST', body: JSON.stringify(dto) });
                closeModal('transferModal');
                showToast('Ticket transferred successfully');
                window.location.reload();
            } catch (err) { console.error(err); 
                showToast(err.message || 'Transfer failed', 'error');
             }
        });

        async function loadDynamicFieldsMeta() {
            try {
                const placements = await window.api.getPlacements(currentTicket.projectId, currentTicket.categoryId, currentTicket.typeId);
                dynamicPlacements = [];
                placements.sort((a,b) => a.sortOrder - b.sortOrder);
                for (const place of placements) {
                    const def = await window.api.request(`/DynamicForm/definitions/${place.fieldDefinitionId}`);
                    let options = [];
                    if (def.fieldType === 3 || def.fieldType === 4) {
                        options = await window.api.getFieldOptions(def.id);
                    }
                    dynamicPlacements.push({ place, def, options, isRequired: place.isRequired });
                }
            } catch(e) { console.error("Failed to load dynamic fields meta", e); }
        }

        function renderTicketData() {
            document.getElementById('tNumber').textContent = currentTicket.ticketNumber;
            document.getElementById('tTitle').textContent = currentTicket.title;
            document.getElementById('tDesc').textContent = currentTicket.description || 'No description provided.';
            
            const prioName = globalLookup.priorities?.find(x => x.id === currentTicket.priorityId)?.name || 'Normal';
            const catName = globalLookup.categories?.find(x => x.id === currentTicket.categoryId)?.name || '-';
            
            document.getElementById('tPriority').innerHTML = `<span class="badge badge-info">${escapeHtml(prioName)}</span>`;
            document.getElementById('tCategory').textContent = catName;
            
            const dynContainer = document.getElementById('dynamicFieldsDisplay');
            dynContainer.innerHTML = '';
            dynamicPlacements.forEach(dp => {
                const val = currentTicket.customFields ? currentTicket.customFields[dp.def.key] : '-';
                dynContainer.innerHTML += `<div class="property-group"><div class="property-label">${escapeHtml(dp.def.label)}</div><div class="property-value">${escapeHtml(val || '-')}</div></div>`;
            });
        }

        async function loadTicket() {
            if (!ticketId) {
                document.querySelector('.content-area').innerHTML = '<div style="padding: 40px; text-align: center; color: var(--text-muted);"><h3>Bilet ID bulunamadı</h3><p>Lütfen geçerli bir bilet seçerek tekrar deneyin.</p></div>';
                return;
            }
            try {
                let lookup = {};
                let users = [];
                try { 
                    lookup = await window.api.getLookup(); 
                    users = await window.api.getUsers();
                    globalLookup = lookup;
                    globalUsers = users;
                    globalGroups = await window.api.getGroups();
    
                const urlParams = new URLSearchParams(window.location.search);
                const highlightId = urlParams.get('highlight');
                if (highlightId === 'true') {
                    setTimeout(() => {
                        const header = document.querySelector('.content-area');
                        if (header) {
                            header.classList.add('row-highlight');
                        }
                    }, 100);
                }
            } catch (e) { console.error(e);  console.warn('Lookup failed', e);  }

                const t = await window.api.request(`/Ticket/${ticketId}`);
                currentTicket = t;
                
                await loadDynamicFieldsMeta();
        await renderTicketData();
                
                const projName = lookup.projects?.find(x => x.id === t.projectId)?.name || '-';

                
                // Get group name using the same API since we don't have lookup.groups populated initially here, wait let's use the fetch:
                let groupName = '-';
                if (t.assignedGroupId) {
                    try {
                        const groups = await window.api.getGroups();
                        const grp = groups.find(x => x.id === t.assignedGroupId);
                        if (grp) groupName = grp.name;
                    } catch(e) { console.warn(e); }
                }
                
                document.getElementById('tProject').textContent = projName;
                document.getElementById('tProject').textContent = projName;
                
                const reqUser = users.find(u => u.id === t.requesterUserId);
                const getReqName = reqUser?.username || `User ${t.requesterUserId}`;
                document.getElementById('tReq').innerHTML = `<div class="d-flex align-items-center gap-sm" style="cursor:pointer;" onclick="openUserDetails(${t.requesterUserId})">${getAvatar(t.requesterUserId, getReqName, reqUser?.profilePhoto)} ${escapeHtml(getReqName)}</div>`;

                let assignHTML = '';
                if (t.assignments && t.assignments.length > 0) {
                    // Deduplicate assignments by userId or groupId
                    const uniqueAssignmentsMap = new Map();
                    t.assignments.filter(a => a.isActive).forEach(a => {
                        const key = a.userId ? `u_${a.userId}` : (a.groupId ? `g_${a.groupId}` : null);
                        if (key && !uniqueAssignmentsMap.has(key)) {
                            uniqueAssignmentsMap.set(key, a);
                        }
                    });
                    const activeAssignments = Array.from(uniqueAssignmentsMap.values());
                    
                    if (activeAssignments.length === 0) {
                        assignHTML = '<span class="text-muted">No active assignments</span>';
                    } else {
                        // Group by department
                        const grouped = {};
                        const resolveDeptId = (a) => {
                            if (a.userId) {
                                const u = users.find(x => x.id === a.userId);
                                return u?.departmentId || 'none';
                            } else if (a.groupId) {
                                const g = globalGroups.find(x => x.id === a.groupId);
                                return g?.departmentId || 'none';
                            }
                            return 'none';
                        };

                        activeAssignments.forEach(a => {
                            const deptId = resolveDeptId(a);
                            if (!grouped[deptId]) grouped[deptId] = [];
                            grouped[deptId].push(a);
                        });

                        const deptsLookup = typeof globalLookup !== 'undefined' && globalLookup.departments ? globalLookup.departments : [];

                            let deptBlocks = [];
                            for (const [deptId, assigns] of Object.entries(grouped)) {
                                let deptName = 'No Department';
                                if (deptId !== 'none') {
                                    const d = deptsLookup.find(x => x.id == deptId);
                                    if (d) deptName = d.name;
                                }

                                let blockHtml = '';
                                blockHtml += `<div class="assignee-dept-block" style="margin-bottom: 8px; margin-left: 0 !important; padding-left: 0 !important; border: none;">`;
                                blockHtml += `  <div class="d-flex align-items-center gap-sm" style="font-size: 12px; font-weight: 600; color: var(--text-muted); margin-bottom: 4px; text-transform: uppercase;">`;
                                blockHtml += `      <svg viewBox="0 0 24 24" width="14" height="14" style="fill:currentColor"><path d="M10 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2h-8l-2-2z"/></svg>`;
                                blockHtml += `      ${escapeHtml(deptName)}`;
                                blockHtml += `  </div>`;
                                blockHtml += `  <div style="padding-left: 16px; display: flex; flex-direction: column; gap: 4px;">`;

                                assigns.forEach(a => {
                                    if (a.userId) {
                                        const u = users.find(x => x.id === a.userId);
                                        const uName = u ? (u.firstName + ' ' + u.lastName) : 'Unknown User';
                                        blockHtml += `      <div class="d-flex align-items-center gap-sm" style="cursor:pointer;" onclick="openUserDetails(${a.userId})">${getAvatar(a.userId, uName, u?.profilePhoto, 20)} <span style="color:var(--primary); font-weight:500; font-size: 13px;">${escapeHtml(uName)}</span></div>`;
                                    } else if (a.groupId) {
                                        const g = globalGroups.find(x => x.id === a.groupId);
                                        const gName = g ? g.name : 'Unknown Group';
                                        blockHtml += `      <div class="d-flex align-items-center gap-sm" style="font-size: 13px;"><svg viewBox="0 0 24 24" width="20" height="20" style="fill:var(--text-muted)"><path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/></svg> <span style="font-weight:500; color:var(--text-main);">${escapeHtml(gName)}</span></div>`;
                                    }
                                });

                                blockHtml += `  </div>`;
                                blockHtml += `</div>`;
                                deptBlocks.push(blockHtml);
                            }
                            assignHTML = deptBlocks.join('');
                        }
                } else {
                    assignHTML = '<span class="text-muted">Unassigned</span>';
                }
                document.getElementById('tAssigned').innerHTML = assignHTML;

                // Setup Manage Assignees Modal
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
                        
                        // Departments level
                        depts.forEach(d => {
                            html += `
                                <li style="margin-bottom: 8px;">
                                    <div style="display:flex; align-items:center; gap:8px; font-weight:600; padding:6px; background:var(--bg-hover); border-radius:4px; cursor:pointer;" onclick="const ul = this.nextElementSibling; ul.style.display = ul.style.display === 'none' ? 'block' : 'none'; const svg = this.querySelector('.dept-chevron'); svg.style.transform = ul.style.display === 'none' ? '' : 'rotate(90deg)';">
                                        <svg class="dept-chevron" viewBox="0 0 24 24" width="16" height="16" style="transition: transform 0.2s; transform: rotate(90deg);"><path d="M8.59 16.59L13.17 12 8.59 7.41 10 6l6 6-6 6-1.41-1.41z"/></svg>
                                        <svg viewBox="0 0 24 24" width="16" height="16" style="fill:${d.color || 'currentColor'};"><path d="M10 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2h-8l-2-2z"/></svg>
                                        ${escapeHtml(d.name)}
                                    </div>
                                    <ul style="list-style:none; padding-left:24px; margin-top:8px; display:block;">
                            `;
                            
                            const dGroups = grps.filter(g => g.departmentId === d.id);
                            if (dGroups.length === 0) {
                                html += `<li style="color:var(--text-muted); font-size:12px; padding:4px;">No groups</li>`;
                            } else {
                                dGroups.forEach(g => {
                                    const isGrpSelected = t.assignments?.some(a => a.isActive && a.groupId === g.id);
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
                                            const isUsrSelected = t.assignments?.some(a => a.isActive && a.userId === u.id);
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
                        console.error("Error loading assign tree", err);
                        container.innerHTML = '<div style="color:var(--danger); padding:20px; text-align:center;">Failed to load tree data.</div>';
                    }
                };

                document.getElementById('btnSubmitAssign').onclick = async () => {
                    const uChecks = document.querySelectorAll('.user-checkbox:checked');
                    const gChecks = document.querySelectorAll('.group-checkbox:checked');
                    
                    const uIds = Array.from(uChecks).map(c => parseInt(c.value));
                    const gIds = Array.from(gChecks).map(c => parseInt(c.value));
                    
                    try {
                        const req = { userIds: uIds, groupIds: gIds };
                        await window.api.request(`/Ticket/${ticketId}/assign`, { method: 'POST', body: JSON.stringify(req) });
                        showToast('Assignments updated successfully');
                        window.location.reload();
                    } catch (e) {
                        console.error(e);
                        showToast('Assignment failed', 'error');
                    }
                };

                // Setup Assignment Tree Modal
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
                                const u = users.find(x => x.id === node.userId);
                                assigneeName = u ? (u.firstName + ' ' + u.lastName) : (node.assigneeName || 'Unknown User');
                                icon = `<svg viewBox="0 0 24 24" width="16" height="16" style="fill:var(--primary); margin-right:4px; vertical-align:middle;"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>`;
                            } else if (node.groupId) {
                                const g = globalGroups.find(x => x.id === node.groupId);
                                assigneeName = g ? g.name : (node.assigneeName || 'Unknown Group');
                                icon = `<svg viewBox="0 0 24 24" width="16" height="16" style="fill:var(--text-muted); margin-right:4px; vertical-align:middle;"><path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/></svg>`;
                            }
                            
                            const assigner = users.find(x => x.id === node.assignedByUserId);
                            const assignerName = assigner ? assigner.username : 'System';
                            const date = new Date(node.createdAt).toLocaleString();
                            
                            let status = '';
                            if (node.isAssigneeDeleted) {
                                status += '<span class="badge badge-danger" style="font-size:10px; margin-right:4px;">Deleted</span>';
                            }
                            status += node.isActive ? '<span class="badge badge-success" style="font-size:10px;">Active</span>' : '<span class="badge badge-default" style="font-size:10px;">Inactive</span>';
                            
                            let html = `<div style="border-left: 2px solid var(--border); padding-left: 16px; margin-left: 8px; margin-top: 8px; position:relative;">
                                <div style="position:absolute; left:0; top: 12px; width:16px; border-top: 2px solid var(--border);"></div>
                                <div style="background: var(--bg-main); border: 1px solid var(--border); padding: 8px; border-radius: var(--radius-sm); margin-bottom: 8px; display:inline-block;">
                                    <div style="font-size: 14px; font-weight: 500;">${icon}${escapeHtml(assigneeName)} ${status}</div>
                                    <div style="font-size: 11px; color: var(--text-muted); margin-top: 4px;">Assigned by: ${escapeHtml(assignerName)} on ${date}</div>
                                </div>
                            `;
                            
                            if (node.children && node.children.length > 0) {
                                html += `<div style="margin-left: 16px;">`;
                                node.children.forEach(child => {
                                    html += renderNode(child);
                                });
                                html += `</div>`;
                            }
                            html += `</div>`;
                            return html;
                        }
                        
                        if (!tree || tree.length === 0) {
                            container.innerHTML = '<div class="text-muted">No assignments found in history.</div>';
                        } else {
                            let rootHtml = '';
                            tree.forEach(rootNode => {
                                rootHtml += renderNode(rootNode);
                            });
                            container.innerHTML = rootHtml;
                        }
                    } catch(e) {
                        console.error(e);
                        container.innerHTML = `<div style="color:var(--danger)">Failed to load assignment tree.</div>`;
                    }
                };

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
                    select.value = t.statusId;
                } catch(e) {
                    console.error("Failed to load allowed transitions", e);
                }

                if (t.statusId === 5) {
                    document.getElementById('csatLink').style.display = 'block';
                    document.getElementById('surveyBtn').href = `/survey.html?id=${t.id}`;
                } else {
                    document.getElementById('csatLink').style.display = 'none';
                }

                document.getElementById('content').style.display = 'grid';
                loadTimeline();

                const urlParams = new URLSearchParams(window.location.search);
                const highlightId = urlParams.get('highlight');
                if (highlightId === 'true') {
                    setTimeout(() => {
                        const header = document.querySelector('.content-area');
                        if (header) {
                            header.classList.add('row-highlight');
                        }
                    }, 100);
                }
            } catch (e) { console.error(e); 
                let errEl = document.querySelector('tbody') || document.querySelector('.content-area');
                if (errEl) {
                    errEl.innerHTML = '<div style="padding: 20px; text-align: center; color: var(--danger);">Veri yüklenemedi — API\'yi kontrol et</div>';
                 }
                console.error(e);
                showToast('Error loading ticket', 'error'); 
            }
        }

        window.openUserDetails = async function(userId) {
            if (!userId) return;
            try {
                const user = await window.api.request(`/Users/${userId}`);
                if (!user) return;
                
                document.getElementById('aModalAvatar').innerHTML = getAvatar(user.id, user.firstName, user.profilePhoto, 80);
                document.getElementById('aModalName').textContent = user.firstName + ' ' + user.lastName;
                document.getElementById('aModalUsername').textContent = '@' + user.username;
                document.getElementById('aModalEmail').textContent = user.email;
                
                let deptName = '-';
                if (user.departmentId) {
                    try {
                        const depts = await window.api.request('/Departments');
                        const d = depts.find(x => x.id === user.departmentId);
                        if (d) deptName = d.name;
        
                const urlParams = new URLSearchParams(window.location.search);
                const highlightId = urlParams.get('highlight');
                if (highlightId === 'true') {
                    setTimeout(() => {
                        const header = document.querySelector('.content-area');
                        if (header) {
                            header.classList.add('row-highlight');
                        }
                    }, 100);
                }
            } catch (e) { console.error(e); }
                }
                document.getElementById('aModalDept').textContent = deptName;
                document.getElementById('aModalStatus').innerHTML = user.isActive ? '<span class="badge badge-success">Active</span>' : '<span class="badge badge-default">Inactive</span>';
                
                openModal('assigneeModal');
            } catch(e) {
                console.error(e);
                showToast('Failed to load user details', 'error');
            }
        };

        function renderDynamicSelect(def, dp, val) {
            let inputStr = `<select class="form-control dyn-input" data-key="${def.key}" style="max-width:300px;" ${dp.isRequired ? 'required' : ''} ${def.fieldType === 4 ? 'multiple' : ''}>`;
            inputStr += `<option value="">Select option...</option>`;
            dp.options.forEach(o => {
                const sel = val === o.value ? 'selected' : '';
                inputStr += `<option value="${escapeHtml(o.value)}" ${sel}>${escapeHtml(o.label)}</option>`;
            });
            inputStr += `</select>`;
            return inputStr;
        }

        function buildEditDynamicFields(currentTicket, dynamicPlacements) {
            let html = '';
            for (const dp of dynamicPlacements) {
                const def = dp.def;
                const val = currentTicket.customFields ? currentTicket.customFields[def.key] : '';
                let inputStr = '';
                if (def.fieldType === 3 || def.fieldType === 4) {
                    inputStr = renderDynamicSelect(def, dp, val);
                } else {
                    const typeMap = {0: 'text', 1: 'number', 2: 'date'};
                    inputStr = `<input type="${typeMap[def.fieldType]}" class="form-control dyn-input" data-key="${def.key}" style="max-width:300px;" ${dp.isRequired ? 'required' : ''} value="${escapeHtml(val || '')}">`;
                }
                html += `<div class="property-group"><div class="property-label">${escapeHtml(def.label)}${dp.isRequired ? ' *' : ''}</div><div class="property-value">${inputStr}</div></div>`;
            }
            return html;
        }

        window.toggleEditMode = function() {
            if (!currentTicket) return;
            isEditMode = true;
            document.getElementById('btnEditInline').style.display = 'none';
            document.getElementById('editActions').style.display = 'flex';

            const tTitle = document.getElementById('tTitle');
            tTitle.innerHTML = `<input type="text" id="inlineEditTitle" class="form-control" style="font-size:24px; font-weight:bold; width:100%;" value="${escapeHtml(currentTicket.title)}">`;

            const tDesc = document.getElementById('tDesc');
            tDesc.innerHTML = `<textarea id="inlineEditDesc" class="form-control" rows="4" style="width:100%;">${escapeHtml(currentTicket.description || '')}</textarea>`;

            const tPriority = document.getElementById('tPriority');
            let prioHtml = '<select id="inlineEditPriority" class="form-control">';
            (globalLookup.priorities || []).forEach(p => {
                prioHtml += `<option value="${p.id}" ${p.id === currentTicket.priorityId ? 'selected' : ''}>${escapeHtml(p.name)}</option>`;
            });
            prioHtml += '</select>';
            tPriority.innerHTML = prioHtml;

            const tCategory = document.getElementById('tCategory');
            let catHtml = '<select id="inlineEditCategory" class="form-control">';
            (globalLookup.categories || []).forEach(c => {
                catHtml += `<option value="${c.id}" ${c.id === currentTicket.categoryId ? 'selected' : ''}>${escapeHtml(c.name)}</option>`;
            });
            catHtml += '</select>';
            tCategory.innerHTML = catHtml;

            const dynContainer = document.getElementById('dynamicFieldsDisplay');
            dynContainer.innerHTML = buildEditDynamicFields(currentTicket, dynamicPlacements);
        };

        window.toggleSidebarEdit = function() {
            if (!currentTicket) return;
            document.getElementById('btnEditSidebar').style.display = 'none';
            document.getElementById('sidebarEditActions').style.display = 'flex';

            const tPriority = document.getElementById('tPriority');
            let prioHtml = '<select id="sidebarEditPriority" class="form-control form-control-sm">';
            (globalLookup.priorities || []).forEach(p => {
                prioHtml += `<option value="${p.id}" ${p.id === currentTicket.priorityId ? 'selected' : ''}>${escapeHtml(p.name)}</option>`;
            });
            prioHtml += '</select>';
            tPriority.innerHTML = prioHtml;

            const tCategory = document.getElementById('tCategory');
            let catHtml = '<select id="sidebarEditCategory" class="form-control form-control-sm">';
            (globalLookup.categories || []).forEach(c => {
                catHtml += `<option value="${c.id}" ${c.id === currentTicket.categoryId ? 'selected' : ''}>${escapeHtml(c.name)}</option>`;
            });
            catHtml += '</select>';
            tCategory.innerHTML = catHtml;

            const tProject = document.getElementById('tProject');
            let projHtml = '<select id="sidebarEditProject" class="form-control form-control-sm"><option value="">No Project</option>';
            (globalLookup.projects || []).forEach(p => {
                projHtml += `<option value="${p.id}" ${p.id === currentTicket.projectId ? 'selected' : ''}>${escapeHtml(p.name)}</option>`;
            });
            projHtml += '</select>';
            tProject.innerHTML = projHtml;

        };

        window.cancelSidebarEdit = async function() {
            document.getElementById('btnEditSidebar').style.display = 'inline-block';
            document.getElementById('sidebarEditActions').style.display = 'none';
            await renderTicketData();
        };

        window.saveSidebarEdit = async function() {
            if (!currentTicket) return;

            const categoryId = Number(document.getElementById('sidebarEditCategory').value);
            const priorityId = Number(document.getElementById('sidebarEditPriority').value);
            const projectId = document.getElementById('sidebarEditProject').value ? Number(document.getElementById('sidebarEditProject').value) : -1;

            try {
                // Update basic ticket details (Title and Description don't change, we use current)
                if (categoryId !== currentTicket.categoryId || priorityId !== currentTicket.priorityId) {
                    await window.api.request(`/Ticket/${ticketId}`, {
                        method: 'PUT',
                        body: JSON.stringify({
                            title: currentTicket.title,
                            description: currentTicket.description,
                            categoryId: categoryId,
                            priorityId: priorityId,
                            customFields: currentTicket.customFields || {}
                        })
                    });
                }
                
                // Update project using transfer endpoint if it changed
                if (projectId !== currentTicket.projectId) {
                    await window.api.request(`/Ticket/${ticketId}/transfer`, {
                        method: 'POST',
                        body: JSON.stringify({ projectId, groupId: -1 })
                    });
                }

                showToast('Properties updated successfully');
                document.getElementById('btnEditSidebar').style.display = 'inline-block';
                document.getElementById('sidebarEditActions').style.display = 'none';
                await loadTicket();
            } catch (e) {
                console.error(e);
                showToast('Failed to update properties', 'error');
            }
        };

        window.cancelEditMode = async function() {
            isEditMode = false;
            document.getElementById('btnEditInline').style.display = 'inline-block';
            document.getElementById('editActions').style.display = 'none';
            await renderTicketData();
        };

        window.saveEditMode = async function() {
            if (!currentTicket) return;

            const titleInput = document.getElementById('inlineEditTitle');
            if(titleInput.value.trim() === '') {
                showToast('Title is required', 'error');
                return;
            }

            const title = titleInput.value;
            const description = document.getElementById('inlineEditDesc').value;
            
            const customFields = {};
            let validationFailed = false;
            const dynContainer = document.getElementById('dynamicFieldsDisplay');
            const inputs = dynContainer.querySelectorAll('.dyn-input');
            inputs.forEach(inp => {
                if (inp.hasAttribute('required') && !inp.value) {
                    validationFailed = true;
                }
                if (inp.dataset.key) {
                    customFields[inp.dataset.key] = inp.value;
                }
            });

            if(validationFailed) {
                showToast('Lütfen zorunlu alanları doldurun.', 'error');
                return;
            }

            const categoryId = document.getElementById('inlineEditCategory') ? Number(document.getElementById('inlineEditCategory').value) : currentTicket.categoryId;
            const priorityId = document.getElementById('inlineEditPriority') ? Number(document.getElementById('inlineEditPriority').value) : currentTicket.priorityId;

            const payload = {
                title,
                description,
                categoryId: categoryId,
                priorityId: priorityId,
                customFields
            };

            try {
                await window.api.request(`/Ticket/${ticketId}`, {
                    method: 'PUT',
                    body: JSON.stringify(payload)
                });
                showToast('Talep güncellendi');
                isEditMode = false;
                document.getElementById('btnEditInline').style.display = 'inline-block';
                document.getElementById('editActions').style.display = 'none';
                loadTicket(); // full reload to get latest history
            } catch(err) {
                console.error(err);
                if(err.message) {
                    showToast(err.message, 'error'); // Usually from backend 400 Bad Request
                } else {
                    showToast('Update failed. Dinamik alan kurallarına dikkat edin.', 'error');
                }
            }
        };

        async function loadTimeline() {
            try {
                const events = await window.api.request(`/Ticket/${ticketId}/timeline`);
                const commentsList = document.getElementById('commentsList');
                const historyList = document.getElementById('historyList');
                const commentLogsList = document.getElementById('commentLogsList');
                commentsList.innerHTML = '';
                historyList.innerHTML = '';
                commentLogsList.innerHTML = '';
                
                const threads = new Map();
                
                const getRootId = (commentId) => {
                    let current = events.find(e => e.eventType === 'Comment' && e.data.id === commentId)?.data;
                    while(current && current.parentCommentId) {
                        const parent = events.find(e => e.eventType === 'Comment' && e.data.id === current.parentCommentId)?.data;
                        if(parent) current = parent;
                        else break;
                    }
                    return current ? current.id : commentId;
                };

                events.forEach(e => {
                    if (e.eventType === 'Comment') {
                        const rootId = getRootId(e.data.id);
                        e.rootId = rootId;
                        if (!threads.has(rootId)) {
                            threads.set(rootId, { rootId, maxTimestamp: new Date(e.timestamp).getTime(), events: [] });
                        }
                        const thread = threads.get(rootId);
                        thread.events.push(e);
                        const ts = new Date(e.timestamp).getTime();
                        if (ts > thread.maxTimestamp) thread.maxTimestamp = ts;
                    }
                });

                const finalEvents = [];
                events.forEach(e => {
                    if (e.eventType === 'History') {
                        finalEvents.push({ ...e, sortTime: new Date(e.timestamp).getTime(), isThread: false });
                    } else if (e.eventType === 'Comment') {
                        if (e.data.id === e.rootId) {
                            finalEvents.push({ sortTime: threads.get(e.rootId).maxTimestamp, isThread: true, thread: threads.get(e.rootId).events });
                        }
                    }
                });

                finalEvents.sort((a, b) => a.sortTime - b.sortTime);

                finalEvents.forEach(fe => {
                    if (fe.isThread) {
                        fe.thread.forEach(e => {
                            const resolveUser = (id) => {
                                if (!id || id === 'none' || id === 'null') return 'None';
                                const u = globalUsers.find(x => x.id == id);
                                return u ? escapeHtml(u.firstName + ' ' + u.lastName) : `User ${id}`;
                            };
                            
                            const div = document.createElement('div');
                            const c = e.data;
                            const isEdited = c.isEdited ? `<span style="font-size: 11px; color: var(--text-muted); font-style: italic;" title="${c.updatedAt ? new Date(c.updatedAt).toLocaleString() : ''}">(Edited ${c.updatedAt ? 'at ' + new Date(c.updatedAt).toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'}) : ''})</span>` : '';
                            
                            div.className = `comment ${c.isInternal ? 'internal' : ''}`;
                            div.id = `comment-${c.id}`;
                            
                            let connectorHtml = '';
                            if (c.parentCommentId) {
                                div.className += ' reply-container';
                                connectorHtml = '<div class="comment-reply-connector"></div>';
                            }
                            
                            div.innerHTML = `
                                ${connectorHtml}
                                <div class="comment-header">
                                    <div class="d-flex align-items-center gap-sm">
                                        ${getAvatar(c.authorUserId, c.authorUserId)}
                                        <strong class="user-hover-link" data-user-id="${c.authorUserId}" style="cursor: pointer;">${resolveUser(c.authorUserId)}</strong>
                                        <span>${new Date(e.timestamp).toLocaleString()}</span>
                                        ${isEdited}
                                    </div>
                                    <div class="d-flex align-items-center gap-sm">
                                        ${c.isInternal ? '<span class="badge badge-warning">Internal Note</span>' : ''}
                                        <button class="btn btn-ghost" style="padding:2px 4px; font-size:12px;" onclick="inlineReplyToComment(${c.id}, ${c.isInternal})">Reply</button>
                                        <button class="btn btn-ghost" style="padding:2px 4px; font-size:12px;" onclick="inlineEditComment(${c.id})">Edit</button>
                                        <button class="btn btn-ghost" style="padding:2px 4px; font-size:12px; color: var(--danger);" onclick="deleteComment(${c.id})">Delete</button>
                                    </div>
                                </div>
                                <div id="comment-content-${c.id}" class="comment-body">${escapeHtml(c.content)}</div>
                                <div id="comment-edit-${c.id}" style="display:none; margin-top: 8px;">
                                    <textarea class="form-control mb-sm" rows="3" id="edit-textarea-${c.id}"></textarea>
                                    <div class="d-flex gap-sm">
                                        <button class="btn btn-primary btn-sm" onclick="saveEditComment(${c.id})">Save</button>
                                        <button class="btn btn-ghost btn-sm" onclick="cancelEditComment(${c.id})">Cancel</button>
                                    </div>
                                </div>
                            `;
                            
                            if (c.parentCommentId) {
                                const parentDiv = document.getElementById(`comment-${c.parentCommentId}`);
                                if (parentDiv) {
                                    let repliesContainer = parentDiv.querySelector('.replies-list');
                                    if (!repliesContainer) {
                                        repliesContainer = document.createElement('div');
                                        repliesContainer.className = 'replies-list';
                                        parentDiv.appendChild(repliesContainer);
                                    }
                                    repliesContainer.appendChild(div);
                                } else {
                                    commentsList.appendChild(div);
                                }
                            } else {
                                commentsList.appendChild(div);
                            }
                        });
                    } else {
                        const e = fe;
                        const resolveUser = (id) => {
                            if (!id || id === 'none' || id === 'null') return 'None';
                            const u = globalUsers.find(x => x.id == id);
                            return u ? escapeHtml(u.firstName + ' ' + u.lastName) : `User ${id}`;
                        };
                        const parseGrp = (str) => {
                            if(!str) return 'None';
                            const m = str.match(/Grp:(\d+)/);
                            if(m && m[1]) {
                                const g = globalGroups.find(x => x.id == m[1]);
                                return g ? escapeHtml(g.name) : `Group ${m[1]}`;
                            }
                            return 'None';
                        };
                        
                        const div = document.createElement('div');
                        const h = e.data;
                        let text = '';
                        const isCommentLogOnly = h.action === 'CommentAdded' || h.action === 'InternalNoteAdded' || h.action === 'CommentReplied';
                        
                        if (!isCommentLogOnly) {
                            div.className = 'history-event';
                            div.id = `history-${h.id}`;
                            text = `${h.action} <strong>${h.fieldName || ''}</strong> from <em>${escapeHtml(h.oldValue || 'none')}</em> to <em>${escapeHtml(h.newValue || 'none')}</em>`;
                            
                            if (h.action === 'Assigned' && h.fieldName === 'AssignedUserId') {
                                text = `assigned this ticket to <strong>${resolveUser(h.newValue)}</strong> (was ${resolveUser(h.oldValue)})`;
                            } else if (h.action === 'Transferred') {
                                const parseTransfer = (val) => {
                                    if (!val || val === 'Proj:,Grp:') return 'none';
                                    const mProj = val.match(/Proj:(-?\d*)/);
                                    const mGrp = val.match(/Grp:(-?\d*)/);
                                    const pId = mProj && mProj[1] ? mProj[1] : null;
                                    const gId = mGrp && mGrp[1] ? mGrp[1] : null;
                                    
                                    const pName = pId && pId !== '-1' ? (globalLookup.projects?.find(x => x.id == pId)?.name || `Project ${pId}`) : 'No Project';
                                    const gName = gId && gId !== '-1' ? (globalGroups?.find(x => x.id == gId)?.name || `Group ${gId}`) : 'No Group';
                                    
                                    return `Proj:${pId || 'none'},Grp:${gId || 'none'} (${pName}, ${gName})`;
                                };
                                text = `transferred this ticket to <strong>${escapeHtml(parseTransfer(h.newValue))}</strong> (was ${escapeHtml(parseTransfer(h.oldValue))})`;
                            } else if (h.action === 'StatusChanged' || h.action === 'Reopened') {
                                const sOld = globalLookup.statuses?.find(x => x.id == h.oldValue)?.name || h.oldValue;
                                const sNew = globalLookup.statuses?.find(x => x.id == h.newValue)?.name || h.newValue;
                                text = `changed status from <em>${escapeHtml(sOld)}</em> to <em>${escapeHtml(sNew)}</em>`;
                            } else if (h.fieldName === 'PriorityId' || h.fieldName === 'Priority') {
                                const pOld = globalLookup.priorities?.find(x => x.id == h.oldValue)?.name || h.oldValue;
                                const pNew = globalLookup.priorities?.find(x => x.id == h.newValue)?.name || h.newValue;
                                text = `changed priority from <em>${escapeHtml(pOld)}</em> to <em>${escapeHtml(pNew)}</em>`;
                            } else if (h.fieldName === 'CategoryId' || h.fieldName === 'Category') {
                                const cOld = globalLookup.categories?.find(x => x.id == h.oldValue)?.name || h.oldValue;
                                const cNew = globalLookup.categories?.find(x => x.id == h.newValue)?.name || h.newValue;
                                text = `changed category from <em>${escapeHtml(cOld)}</em> to <em>${escapeHtml(cNew)}</em>`;
                            } else if (h.fieldName === 'ProjectId' || h.fieldName === 'Project') {
                                const pOld = globalLookup.projects?.find(x => x.id == h.oldValue)?.name || h.oldValue;
                                const pNew = globalLookup.projects?.find(x => x.id == h.newValue)?.name || h.newValue;
                                text = `changed project from <em>${escapeHtml(pOld)}</em> to <em>${escapeHtml(pNew)}</em>`;
                            } else if (h.action === 'CommentEdited') {
                                text = `edited a comment`;
                            } else if (h.action === 'CommentDeleted') {
                                text = `deleted a comment`;
                            }
                            div.innerHTML = `<strong class="user-hover-link" data-user-id="${h.createdBy}" style="cursor: pointer;">${resolveUser(h.createdBy)}</strong> ${text} at ${new Date(e.timestamp).toLocaleString()}`;
                        } else {
                            if (h.action === 'CommentReplied') {
                                text = `replied to a comment`;
                            } else if (h.action === 'CommentAdded') {
                                text = `added a comment`;
                            } else if (h.action === 'InternalNoteAdded') {
                                text = `added an internal note`;
                            }
                        }
                        
                        if (h.action === 'CommentEdited' || h.action === 'CommentDeleted' || isCommentLogOnly) {
                                let detailsHtml = '';
                                
                                if (h.action === 'CommentAdded' || h.action === 'InternalNoteAdded' || h.action === 'CommentReplied') {
                                    if (h.newValue) {
                                        detailsHtml = `<div style="background:var(--bg-hover); padding: 4px 8px; margin-top:4px; border-radius:4px; border:1px solid var(--border); font-size:11px;">${escapeHtml(h.newValue)}</div>`;
                                    }
                                    if (h.action === 'CommentReplied' && h.oldValue) {
                                        // h.oldValue contains parent ID usually for replies or we can link to it. Wait, TicketService sets OldValue=null for replies.
                                        // Let's just add a link if we can parse the parent. Actually we didn't save parent id in history.
                                        // We will just provide the content.
                                    }
                                    // Add a link to jump to comment if it still exists
                                    const commentExists = events.some(ev => ev.eventType === 'Comment' && ev.data.id == h.fieldName);
                                    if (commentExists) {
                                        detailsHtml += `<a href="#" onclick="event.preventDefault(); document.getElementById('commentLogsModal').classList.remove('active'); setTimeout(() => { const c = document.getElementById('comment-${h.fieldName}'); if(c) { c.scrollIntoView({behavior:'smooth', block:'center'}); c.style.boxShadow = '0 0 0 4px var(--primary-light)'; setTimeout(()=>c.style.boxShadow='none', 3000); } }, 300);" style="font-size:10px; display:inline-block; margin-top:4px;">Jump to comment</a>`;
                                    }
                                } else if (h.action === 'CommentEdited' && h.oldValue && h.newValue) {
                                    const oldEnc = btoa(unescape(encodeURIComponent(h.oldValue)));
                                    const newEnc = btoa(unescape(encodeURIComponent(h.newValue)));
                                    let origAuthor = 'Unknown';
                                    let origCreatedAt = 'Unknown';
                                    if (h.fieldName && !isNaN(h.fieldName)) {
                                        const origEvent = events.find(ev => ev.eventType === 'Comment' && ev.data.id == h.fieldName);
                                        if (origEvent) {
                                            origAuthor = resolveUser(origEvent.data.authorUserId);
                                            origCreatedAt = new Date(origEvent.timestamp).toLocaleString();
                                        }
                                    }
                                    const editorName = resolveUser(h.createdBy);
                                    const editedAt = new Date(e.timestamp).toLocaleString();
                                    
                                    detailsHtml = `<button class="btn btn-ghost" style="font-size:10px; padding:2px 4px; margin-top:4px;" onclick="showEditDetails('${oldEnc}', '${newEnc}', '${escapeHtml(origAuthor)}', '${escapeHtml(editorName)}', '${origCreatedAt}', '${editedAt}')">Detay Gör</button>`;
                                } else if (h.action === 'CommentDeleted' && h.oldValue) {
                                    detailsHtml = `<div style="background:#ffeeee; padding: 4px 8px; margin-top:4px; border-radius:4px; border:1px solid #ffcccc; font-size:11px; color:#aa0000;"><del>${escapeHtml(h.oldValue)}</del></div>`;
                                }
                                
                                const logDiv = document.createElement('div');
                                logDiv.className = 'history-event comment-log-item';
                                logDiv.id = `history-${h.id}`;
                                logDiv.style.borderLeft = '2px solid var(--primary)';
                                logDiv.style.backgroundColor = 'transparent';
                                logDiv.style.padding = '4px 0 4px 8px';
                                logDiv.dataset.searchText = `${resolveUser(h.createdBy)} ${text} ${h.oldValue||''} ${h.newValue||''}`.toLowerCase();
                                logDiv.dataset.csvRow = `"${new Date(e.timestamp).toISOString()}","${resolveUser(h.createdBy)}","${text}","${(h.oldValue||'').replace(/"/g, '""')}","${(h.newValue||'').replace(/"/g, '""')}"`;
                                
                                logDiv.innerHTML = `<div style="font-size:11px; color:var(--text-main);"><strong>${resolveUser(h.createdBy)}</strong> ${text}</div><div style="font-size:10px; color:var(--text-muted);">${new Date(e.timestamp).toLocaleString()}</div>${detailsHtml}`;
                                commentLogsList.appendChild(logDiv);
                            } else {
                                if(div.innerHTML) historyList.appendChild(div);
                            }
                        }
                    }
                });
                
                // Deep link handling
                const urlParams = new URLSearchParams(window.location.search);
                const highlightCommentId = urlParams.get('commentId');
                const highlightHistoryId = urlParams.get('historyId');
                const targetId = highlightCommentId ? `comment-${highlightCommentId}` : (highlightHistoryId ? `history-${highlightHistoryId}` : null);
                
                if (targetId) {
                    setTimeout(() => {
                        const target = document.getElementById(targetId);
                        if (target) {
                            // Open activity section if target is inside it and it's closed
                            const activitySection = document.getElementById('activitySection');
                            if (activitySection && activitySection.contains(target) && activitySection.style.display === 'none') {
                                activitySection.style.display = 'block';
                            }
                            
                            // Open comment logs modal if target is inside it
                            const modal = target.closest('.modal-overlay');
                            if (modal) {
                                modal.classList.add('active');
                            }
                            
                            target.scrollIntoView({ behavior: 'smooth', block: 'center' });
                            target.style.transition = 'box-shadow 0.5s';
                            target.style.boxShadow = '0 0 0 4px var(--primary-light)';
                            setTimeout(() => { target.style.boxShadow = 'none'; }, 3000);
                        }
                    }, 500);
                }
            } catch(e) { console.error(e); }
        }

        window.inlineReplyToComment = (id, forceInternal = false) => {
            const parentDiv = document.getElementById(`comment-${id}`);
            if(!parentDiv) return;
            
            let existingBox = document.getElementById('inline-reply-box');
            if (existingBox) existingBox.remove();

            const box = document.createElement('div');
            box.id = 'inline-reply-box';
            box.className = 'reply-container';
            box.style.borderLeft = '3px solid var(--primary)';
            box.style.paddingLeft = '16px';
            box.style.marginBottom = '12px';
            
            box.innerHTML = `
                <div class="comment-reply-connector"></div>
                <textarea class="form-control mb-sm" rows="3" id="inline-reply-text" placeholder="Replying to comment #${id}..."></textarea>
                <div style="margin-bottom: 8px;">
                    <label style="font-size: 13px; color: var(--text-muted); cursor: ${forceInternal ? 'not-allowed' : 'pointer'};">
                        <input type="checkbox" id="inline-reply-internal" ${forceInternal ? 'checked disabled' : ''}> Internal Note
                    </label>
                </div>
                <div class="d-flex gap-sm">
                    <button class="btn btn-primary btn-sm" onclick="submitInlineReply(${id}, ${forceInternal})">Reply</button>
                    <button class="btn btn-ghost btn-sm" onclick="document.getElementById('inline-reply-box').remove()">Cancel</button>
                </div>
            `;
            
            let repliesContainer = parentDiv.querySelector('.replies-list');
            if (!repliesContainer) {
                repliesContainer = document.createElement('div');
                repliesContainer.className = 'replies-list';
                parentDiv.appendChild(repliesContainer);
            }
            repliesContainer.appendChild(box);
            
            const textArea = document.getElementById('inline-reply-text');
            textArea.focus();
            textArea.scrollIntoView({ behavior: 'smooth', block: 'center' });
        };

        window.submitInlineReply = async (parentId, forceInternal = false) => {
            const content = document.getElementById('inline-reply-text').value;
            if(!content.trim()) return;
            
            // Read checkbox, but if it's forced internal, we ignore the checkbox (which might be disabled)
            const isInternal = forceInternal || document.getElementById('inline-reply-internal').checked;
            
            try {
                await window.api.request(`/Ticket/${ticketId}/comments`, {
                    method: 'POST',
                    body: JSON.stringify({ content: content, isInternal: isInternal, parentCommentId: parentId })
                });
                showToast('Reply added');
                loadTimeline();
            } catch (e) {
                console.error(e);
                showToast('Failed to add reply', 'error');
            }
        };

        window.inlineEditComment = (id) => {
            const contentDiv = document.getElementById(`comment-content-${id}`);
            document.getElementById(`comment-edit-${id}`).style.display = 'block';
            document.getElementById(`edit-textarea-${id}`).value = contentDiv.innerText || contentDiv.textContent;
            contentDiv.style.display = 'none';
        };

        window.cancelEditComment = (id) => {
            document.getElementById(`comment-content-${id}`).style.display = 'block';
            document.getElementById(`comment-edit-${id}`).style.display = 'none';
        };

        window.saveEditComment = async (id) => {
            const newContent = document.getElementById(`edit-textarea-${id}`).value;
            if(!newContent.trim()) return;
            try {
                await window.api.request(`/Ticket/${ticketId}/comments/${id}`, {
                    method: 'PUT',
                    body: JSON.stringify({ content: newContent })
                });
                showToast('Comment updated');
                loadTimeline();
            } catch(e) {
                console.error(e);
                showToast('Failed to edit comment. You may not have permission.', 'error');
            }
        };

        window.deleteComment = async (id) => {
            const overlay = document.createElement('div');
            overlay.className = 'modal-overlay active';
            overlay.id = 'deleteConfirmModal';
            overlay.style.display = 'flex';
            
            overlay.innerHTML = `
                <div class="modal" style="width: 400px;">
                    <div class="modal-header">
                        <h2>Delete Comment</h2>
                        <button type="button" class="close-btn" onclick="document.body.removeChild(this.closest('.modal-overlay'))" aria-label="Close">
                            <svg viewBox="0 0 24 24" width="24" height="24"><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/></svg>
                        </button>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure you want to delete this comment? You can undo this action shortly after.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-ghost" onclick="document.body.removeChild(this.closest('.modal-overlay'))">Cancel</button>
                        <button type="button" class="btn btn-primary" style="background-color: var(--danger);" onclick="confirmDeleteComment(${id}, this)">Delete</button>
                    </div>
                </div>
            `;
            document.body.appendChild(overlay);
        };
        
        window.confirmDeleteComment = async (id, btn) => {
            try {
                btn.disabled = true;
                btn.innerText = 'Deleting...';
                await window.api.request(`/Ticket/${ticketId}/comments/${id}`, { method: 'DELETE' });
                
                const duration = 5000; // 5 seconds
                const undoHtml = `
                    <div style="position:relative; width:100%; min-width: 250px; overflow: hidden; padding-bottom: 4px;">
                        <div style="display:flex; justify-content:space-between; align-items:center;">
                            <span>Comment deleted.</span>
                            <button class="btn btn-ghost" style="padding: 2px 8px; font-size: 12px; color: white; border: 1px solid white;" onclick="restoreComment(${id}, this)">Undo</button>
                        </div>
                        <div style="position:absolute; bottom:0; left:0; height:3px; background:var(--primary); width:100%; transition: width ${duration}ms linear;" id="undoProgress-${id}"></div>
                    </div>
                `;
                
                const toast = document.createElement('div');
                toast.className = 'toast show';
                toast.style.backgroundColor = 'var(--text-main)';
                toast.style.color = 'white';
                toast.style.padding = '12px 16px';
                toast.innerHTML = undoHtml;
                document.getElementById('toastContainer').appendChild(toast);
                
                // Start animation
                requestAnimationFrame(() => {
                    requestAnimationFrame(() => {
                        const progress = document.getElementById(`undoProgress-${id}`);
                        if (progress) progress.style.width = '0%';
                    });
                });
                
                setTimeout(() => {
                    if (toast.parentNode) {
                        toast.classList.remove('show');
                        setTimeout(() => toast.remove(), 300);
                    }
                }, duration);
                
                document.body.removeChild(btn.closest('.modal-overlay'));
                loadTimeline();
            } catch(e) {
                console.error(e);
                showToast('Failed to delete comment: ' + e.message, 'error');
                btn.disabled = false;
                btn.innerText = 'Delete';
            }
        };

        window.restoreComment = async (id, btn) => {
            try {
                btn.disabled = true;
                btn.innerText = 'Restoring...';
                await window.api.request(`/Ticket/${ticketId}/comments/${id}/restore`, { method: 'POST' });
                const toast = btn.closest('.toast');
                if(toast) {
                    toast.classList.remove('show');
                    setTimeout(() => toast.remove(), 300);
                }
                showToast('Comment restored successfully', 'success');
                loadTimeline();
            } catch(e) {
                console.error(e);
                showToast('Failed to restore comment', 'error');
                btn.disabled = false;
                btn.innerText = 'Undo';
            }
        };

        document.getElementById('commentForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            const content = document.getElementById('commentText').value;
            const isInternal = document.getElementById('isInternalComment').checked;
            try {
                await window.api.request(`/Ticket/${ticketId}/comments`, {
                    method: 'POST',
                    body: JSON.stringify({ content: content, isInternal: isInternal, parentCommentId: null })
                });
                const commentText = document.getElementById('commentText');
                commentText.value = '';
                
                document.getElementById('isInternalComment').checked = false;
                
                showToast('Comment added');
                loadTimeline();
            } catch(e) { 
                console.error(e);
                showToast('Error adding comment', 'error'); 
            }
        });

        document.getElementById('statusSelect').addEventListener('change', async (e) => {
            const newStatus = Number.parseInt(e.target.value);
            const statusName = e.target.options[e.target.selectedIndex].text;
            try {
                await window.api.request(`/Ticket/${ticketId}/status`, {
                    method: 'POST',
                    body: JSON.stringify(newStatus)
                });
                showToast('Status updated');
                loadTicket(); // Refresh to update allowed transitions
            } catch(e) { 
                console.error(e);
                showToast(`Geçersiz geçiş: ${statusName} durumuna geçilemez.`, 'error');
                loadTicket(); // Reset dropdown to previous state
            }
        });

        function escapeHtml(unsafe) {
            return (unsafe || '').toString()
                .replaceAll('&', "&amp;")
                .replaceAll('<', "&lt;")
                .replaceAll('>', "&gt;")
                .replaceAll('"', "&quot;")
                .replaceAll("'", "&#039;");
        }
        await loadTicket();

        window.showEditDetails = (oldB64, newB64, authorName, editorName, createdAt, updatedAt) => {
            const oldVal = decodeURIComponent(escape(atob(oldB64)));
            const newVal = decodeURIComponent(escape(atob(newB64)));
            const modal = document.createElement('div');
            modal.className = 'modal-overlay active';
            modal.style.display = 'flex';
            modal.style.zIndex = '9999';
            modal.innerHTML = `
                <div class="modal" style="width: min(800px, 90%);">
                    <div class="modal-header">
                        <h2>Comment Edit Details</h2>
                        <button type="button" class="close-btn" onclick="this.closest('.modal-overlay').remove()">
                            <svg viewBox="0 0 24 24" width="24" height="24"><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/></svg>
                        </button>
                    </div>
                    <div class="modal-body" style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                        <div>
                            <div style="margin-bottom: 8px; font-size: 12px; color: var(--text-muted);">
                                <strong>Original Author:</strong> ${authorName}<br>
                                <strong>Written At:</strong> ${createdAt}
                            </div>
                            <strong style="color:var(--error); font-size:12px; text-transform:uppercase;">Before (Eski Hali)</strong>
                            <div style="background:var(--bg-hover); padding:8px; border-radius:4px; font-size:13px; margin-top:4px; white-space:pre-wrap; min-height:60px;">${escapeHtml(oldVal)}</div>
                        </div>
                        <div>
                            <div style="margin-bottom: 8px; font-size: 12px; color: var(--text-muted);">
                                <strong>Edited By:</strong> ${editorName}<br>
                                <strong>Edited At:</strong> ${updatedAt}
                            </div>
                            <strong style="color:var(--success); font-size:12px; text-transform:uppercase;">After (Yeni Hali)</strong>
                            <div style="background:var(--bg-hover); padding:8px; border-radius:4px; font-size:13px; margin-top:4px; white-space:pre-wrap; min-height:60px;">${escapeHtml(newVal)}</div>
                        </div>
                    </div>
                </div>
            `;
            document.body.appendChild(modal);
        };
        
        window.toggleSection = (id, headerEl) => {
            const sec = document.getElementById(id);
            const icon = headerEl.querySelector('svg');
            if (sec.style.display === 'none') {
                sec.style.display = 'block';
                if(icon) icon.style.transform = 'rotate(0deg)';
            } else {
                sec.style.display = 'none';
                if(icon) icon.style.transform = 'rotate(-90deg)';
            }
        };

        // Comment Log Search Filtering
        document.getElementById('commentLogSearch')?.addEventListener('input', (e) => {
            const query = e.target.value.toLowerCase();
            const items = document.querySelectorAll('.comment-log-item');
            items.forEach(item => {
                if (item.dataset.searchText && item.dataset.searchText.includes(query)) {
                    item.style.display = 'block';
                } else {
                    item.style.display = 'none';
                }
            });
        });

        // Comment Log CSV Download
        window.downloadCommentLogs = () => {
            const items = document.querySelectorAll('.comment-log-item');
            if (items.length === 0) {
                showToast('No logs to download', 'error');
                return;
            }
            
            let csvContent = "data:text/csv;charset=utf-8,";
            csvContent += "Timestamp,User,Action,OldValue,NewValue\\n"; // Header
            
            items.forEach(item => {
                if (item.dataset.csvRow) {
                    csvContent += item.dataset.csvRow + "\\n";
                }
            });
            
            const encodedUri = encodeURI(csvContent);
            const link = document.createElement("a");
            link.setAttribute("href", encodedUri);
            link.setAttribute("download", `ticket_${ticketId}_comment_logs.csv`);
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        };
        // --- User Tooltip Logic ---
        const userTooltip = document.createElement('div');
        userTooltip.className = 'user-hover-tooltip';
        userTooltip.style.cssText = 'position:absolute; display:none; background:var(--bg-surface); border:1px solid var(--border); box-shadow:0 4px 12px rgba(0,0,0,0.15); padding:12px; border-radius:8px; z-index:10000; width:260px; pointer-events:none;';
        document.body.appendChild(userTooltip);

        document.addEventListener('mouseover', (e) => {
            const target = e.target.closest('.user-hover-link');
            if (target) {
                const userId = target.getAttribute('data-user-id');
                const user = (typeof globalUsers !== 'undefined' ? globalUsers : []).find(u => u.id == userId);
                if (user) {
                    const dept = (typeof globalLookup !== 'undefined' && globalLookup.departments ? globalLookup.departments : []).find(d => d.id == user.departmentId)?.name || 'No Department';
                    const userGroups = user.groupIds && user.groupIds.length > 0 
                        ? user.groupIds.map(gid => (typeof globalGroups !== 'undefined' ? globalGroups : []).find(g => g.id == gid)?.name || `Group ${gid}`).join(', ') 
                        : 'No Groups';
                    const createdAt = user.createdAt ? new Date(user.createdAt).toLocaleDateString() : 'Unknown';

                    userTooltip.innerHTML = `
                        <div style="display:flex; align-items:center; gap:12px; margin-bottom:8px; border-bottom:1px solid var(--border); padding-bottom:8px;">
                            ${getAvatar(user.id, user.firstName, user.profilePhoto, 32)}
                            <div>
                                <div style="font-weight:600; font-size:14px;">${escapeHtml(user.firstName + ' ' + user.lastName)}</div>
                                <div style="font-size:11px; color:var(--text-muted);">@${escapeHtml(user.username)}</div>
                            </div>
                        </div>
                        <div style="font-size:12px; display:flex; flex-direction:column; gap:4px;">
                            <div><strong style="color:var(--text-muted);">Joined:</strong> ${createdAt}</div>
                            <div><strong style="color:var(--text-muted);">Dept:</strong> ${escapeHtml(dept)}</div>
                            <div><strong style="color:var(--text-muted);">Groups:</strong> ${escapeHtml(userGroups)}</div>
                        </div>
                    `;
                    
                    const rect = target.getBoundingClientRect();
                    userTooltip.style.display = 'block';
                    
                    // Position calculations
                    let top = rect.bottom + window.scrollY + 8;
                    let left = rect.left + window.scrollX;
                    
                    // Check if it goes off bottom
                    if (top + userTooltip.offsetHeight > window.scrollY + window.innerHeight) {
                        top = rect.top + window.scrollY - userTooltip.offsetHeight - 8;
                    }
                    
                    // Check if it goes off right edge
                    if (left + userTooltip.offsetWidth > window.scrollX + window.innerWidth) {
                        left = window.scrollX + window.innerWidth - userTooltip.offsetWidth - 12;
                    }
                    
                    userTooltip.style.top = top + 'px';
                    userTooltip.style.left = left + 'px';
                }
            }
        });

        document.addEventListener('mouseout', (e) => {
            const target = e.target.closest('.user-hover-link');
            if (target) {
                userTooltip.style.display = 'none';
            }
        });
        
