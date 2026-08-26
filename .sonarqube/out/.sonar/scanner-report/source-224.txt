import re

with open("src/ItsTool.Web/wwwroot/dashboard.html", "r") as f:
    content = f.read()

# Replace the HTML content area
html_old = """            <div class="content-area">
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: var(--spacing-md); margin-bottom: var(--spacing-lg);" id="overviewCards">
                    <!-- Populated by JS -->
                </div>

                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(400px, 1fr)); gap: var(--spacing-lg);">
                    <div class="card">
                        <canvas id="statusChart"></canvas>
                    </div>
                    <div class="card">
                        <canvas id="priorityChart"></canvas>
                    </div>
                </div>
            </div>"""

html_new = """            <div class="content-area" style="max-width: 1440px; margin: 0 auto; padding: 20px;">
                <!-- KPI Row -->
                <div style="display: grid; grid-template-columns: repeat(6, 1fr); gap: 16px; margin-bottom: 16px;" id="overviewCards">
                    <!-- Populated by JS -->
                </div>

                <!-- Charts Row -->
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 16px;">
                    <div class="card" style="padding: 20px;">
                        <div style="font-weight: 600; margin-bottom: 16px;">Tickets by Status</div>
                        <div style="height: 260px; position: relative;" id="statusChartContainer">
                            <canvas id="statusChart"></canvas>
                        </div>
                    </div>
                    <div class="card" style="padding: 20px;">
                        <div style="font-weight: 600; margin-bottom: 16px;">Tickets by Priority</div>
                        <div style="height: 260px; position: relative;" id="priorityChartContainer">
                            <canvas id="priorityChart"></canvas>
                        </div>
                    </div>
                </div>

                <!-- New Row: Team Workload & Recent Tickets -->
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                    <div class="card" style="padding: 20px;">
                        <div style="font-weight: 600; margin-bottom: 16px;">Takım Yükü</div>
                        <div id="workloadList" style="display: flex; flex-direction: column; gap: 12px;">
                            <!-- Populated by JS -->
                        </div>
                    </div>
                    <div class="card" style="padding: 20px;">
                        <div style="font-weight: 600; margin-bottom: 16px;">Son Talepler</div>
                        <div id="recentTicketsList" style="display: flex; flex-direction: column; gap: 8px;">
                            <!-- Populated by JS -->
                        </div>
                    </div>
                </div>
            </div>"""
content = content.replace(html_old, html_new)

# Replace the JS logic
js_old = """        async function loadDashboard() {
            try {
                const overview = await window.api.getDashboardOverview();
                const dist = await window.api.getDashboardDistributions();

                const cardsHtml = `
                    <div class="card" style="border-left: 4px solid var(--info);">
                        <div class="text-muted" style="font-size: 12px; font-weight: 600; text-transform: uppercase;">Open Tickets</div>
                        <div style="font-size: 32px; font-weight: 700; margin-top: var(--spacing-xs);">${overview.openTickets ?? 0}</div>
                    </div>
                    <div class="card" style="border-left: 4px solid var(--danger);">
                        <div class="text-muted" style="font-size: 12px; font-weight: 600; text-transform: uppercase;">Critical</div>
                        <div style="font-size: 32px; font-weight: 700; color: var(--danger); margin-top: var(--spacing-xs);">${overview.criticalTickets ?? 0}</div>
                    </div>
                    <div class="card" style="border-left: 4px solid var(--warning);">
                        <div class="text-muted" style="font-size: 12px; font-weight: 600; text-transform: uppercase;">SLA Risk</div>
                        <div style="font-size: 32px; font-weight: 700; color: var(--warning); margin-top: var(--spacing-xs);">${overview.slaRiskTickets ?? 0}</div>
                    </div>
                    <div class="card" style="border-left: 4px solid var(--danger);">
                        <div class="text-muted" style="font-size: 12px; font-weight: 600; text-transform: uppercase;">SLA Breached</div>
                        <div style="font-size: 32px; font-weight: 700; color: var(--danger); margin-top: var(--spacing-xs);">${overview.slaBreachedTickets ?? 0}</div>
                    </div>
                    <div class="card" style="border-left: 4px solid var(--text-muted);">
                        <div class="text-muted" style="font-size: 12px; font-weight: 600; text-transform: uppercase;">Unassigned</div>
                        <div style="font-size: 32px; font-weight: 700; margin-top: var(--spacing-xs);">${overview.unassignedTickets ?? 0}</div>
                    </div>
                    <div class="card" style="border-left: 4px solid var(--success);">
                        <div class="text-muted" style="font-size: 12px; font-weight: 600; text-transform: uppercase;">Avg CSAT</div>
                        <div style="font-size: 32px; font-weight: 700; color: var(--success); margin-top: var(--spacing-xs);">${overview.csatAverage ?? 0}</div>
                    </div>
                `;
                document.getElementById('overviewCards').innerHTML = cardsHtml;

                new Chart(document.getElementById('statusChart'), {
                    type: 'doughnut',
                    data: {
                        labels: dist.byStatus.map(d => d.key),
                        datasets: [{ data: dist.byStatus.map(d => d.count), backgroundColor: ['#0052CC','#00875A','#FF991F','#DE350B','#42526E'] }]
                    },
                    options: { plugins: { title: { display: true, text: 'Tickets by Status', font: { size: 16 } } }, cutout: '70%' }
                });

                new Chart(document.getElementById('priorityChart'), {
                    type: 'bar',
                    data: {
                        labels: dist.byPriority.map(d => d.key),
                        datasets: [{ label: 'Count', data: dist.byPriority.map(d => d.count), backgroundColor: '#0052CC' }]
                    },
                    options: { plugins: { title: { display: true, text: 'Tickets by Priority', font: { size: 16 } } } }
                });"""

js_new = """        async function loadDashboard() {
            try {
                const overview = await window.api.getDashboardOverview();
                const dist = await window.api.getDashboardDistributions();
                
                let workload = [];
                try { workload = await window.api.request('/dashboard/agent-workload'); } catch(e) { console.warn("agent-workload error", e); }
                
                let recentTickets = [];
                try { 
                    const res = await window.api.searchTickets({ pageSize: 5 }); 
                    recentTickets = res.items || [];
                } catch(e) { console.warn("searchTickets error", e); }
                
                let lookup = {};
                try { lookup = await window.api.getLookup(); } catch(e) {}

                const createKpiCard = (title, val, color, iconPath) => `
                    <div class="card" style="display: flex; align-items: center; gap: 12px; height: 96px; padding: 16px; border-left: 4px solid var(--${color});">
                        <div style="width: 40px; height: 40px; border-radius: 8px; background: rgba(var(--${color}-rgb), 0.1); display: flex; align-items: center; justify-content: center; color: var(--${color});">
                            <svg viewBox="0 0 24 24" width="24" height="24" style="fill: currentColor;">${iconPath}</svg>
                        </div>
                        <div>
                            <div class="text-muted" style="font-size: 12px; font-weight: 600; text-transform: uppercase;">${title}</div>
                            <div style="font-size: 28px; font-weight: 700; color: var(--${title === 'Avg CSAT' || title === 'Open Tickets' || title === 'Unassigned' ? 'text' : color}); line-height: 1.2;">${val}</div>
                        </div>
                    </div>
                `;

                document.getElementById('overviewCards').innerHTML = `
                    ${createKpiCard('Open Tickets', overview.openTickets ?? 0, 'info', '<path d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z"/>')}
                    ${createKpiCard('Critical', overview.criticalTickets ?? 0, 'danger', '<path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"/>')}
                    ${createKpiCard('SLA Risk', overview.slaRiskTickets ?? 0, 'warning', '<path d="M11.99 2C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zM12 20c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8zm.5-13H11v6l5.25 3.15.75-1.23-4.5-2.67z"/>')}
                    ${createKpiCard('SLA Breached', overview.slaBreachedTickets ?? 0, 'danger', '<path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"/>')}
                    ${createKpiCard('Unassigned', overview.unassignedTickets ?? 0, 'default', '<path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>')}
                    ${createKpiCard('Avg CSAT', overview.csatAverage ?? 0, 'success', '<path d="M11.99 2C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zm4.24 16L12 15.45 7.77 18l1.12-4.81-3.73-3.23 4.92-.42L12 5l1.92 4.53 4.92.42-3.73 3.23L16.23 18z"/>')}
                `;

                // Workload List
                const workloadHtml = workload.length === 0 
                    ? '<div style="color:var(--text-muted); font-size: 14px; text-align: center; padding: 20px;">Henüz veri yok</div>'
                    : workload.map(w => `
                        <div style="display: flex; align-items: center; gap: 12px; font-size: 14px;">
                            <div class="avatar" style="width:32px; height:32px; font-size:14px;">${w.userName ? w.userName.charAt(0).toUpperCase() : 'U'}</div>
                            <div style="flex:1;">
                                <div style="font-weight: 500;">${w.userName || 'User ' + w.userId}</div>
                                <div style="width: 100%; height: 4px; background: var(--border); border-radius: 2px; margin-top: 4px; overflow: hidden;">
                                    <div style="height: 100%; background: var(--primary); width: ${Math.min(w.openTicketCount * 10, 100)}%;"></div>
                                </div>
                            </div>
                            <div style="font-weight: 600;">${w.openTicketCount}</div>
                        </div>
                    `).join('');
                document.getElementById('workloadList').innerHTML = workloadHtml;

                // Recent Tickets List
                const getStatusName = (id) => lookup.statuses?.find(s => s.id === id)?.name || 'Unknown';
                const recentHtml = recentTickets.length === 0
                    ? '<div style="color:var(--text-muted); font-size: 14px; text-align: center; padding: 20px;">Henüz veri yok</div>'
                    : recentTickets.map(t => `
                        <div style="display: flex; align-items: center; gap: 12px; padding: 12px; background: var(--bg-hover); border-radius: 8px; cursor: pointer; transition: 0.2s;" onclick="window.location.href='/ticket-detail.html?id=${t.id}'" onmouseover="this.style.background='var(--border)'" onmouseout="this.style.background='var(--bg-hover)'">
                            <div style="font-family: monospace; font-weight: 600; color: var(--primary);">${t.ticketNumber}</div>
                            <div style="flex: 1; font-weight: 500; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">${t.title}</div>
                            <span class="badge badge-default" style="font-size: 11px;">${getStatusName(t.statusId)}</span>
                        </div>
                    `).join('');
                document.getElementById('recentTicketsList').innerHTML = recentHtml;

                if (!dist.byStatus || dist.byStatus.length === 0) {
                    document.getElementById('statusChartContainer').innerHTML = '<div style="display:flex; height:100%; align-items:center; justify-content:center; color:var(--text-muted);">Henüz veri yok</div>';
                } else {
                    new Chart(document.getElementById('statusChart'), {
                        type: 'doughnut',
                        data: {
                            labels: dist.byStatus.map(d => d.key),
                            datasets: [{ data: dist.byStatus.map(d => d.count), backgroundColor: ['#0052CC','#00875A','#FF991F','#DE350B','#42526E'] }]
                        },
                        options: { maintainAspectRatio: false, plugins: { legend: { position: 'bottom' } }, cutout: '62%' }
                    });
                }

                if (!dist.byPriority || dist.byPriority.length === 0) {
                    document.getElementById('priorityChartContainer').innerHTML = '<div style="display:flex; height:100%; align-items:center; justify-content:center; color:var(--text-muted);">Henüz veri yok</div>';
                } else {
                    new Chart(document.getElementById('priorityChart'), {
                        type: 'bar',
                        data: {
                            labels: dist.byPriority.map(d => d.key),
                            datasets: [{ label: 'Count', data: dist.byPriority.map(d => d.count), backgroundColor: '#0052CC' }]
                        },
                        options: { maintainAspectRatio: false, plugins: { legend: { display: false } } }
                    });
                }"""
content = content.replace(js_old, js_new)

with open("src/ItsTool.Web/wwwroot/dashboard.html", "w") as f:
    f.write(content)
