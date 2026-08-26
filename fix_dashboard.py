import re

def fix_top_level_awaits(filepath):
    with open(filepath, 'r') as f:
        content = f.read()
    
    # Change loadFields(); -> await loadFields(); etc.
    content = re.sub(r'^\s*(loadDashboard|loadFields|loadAuditLogs)\(\);(?:\s*//.*)?$', r'        await \1();', content, flags=re.MULTILINE)
    
    with open(filepath, 'w') as f:
        f.write(content)

fix_top_level_awaits('src/ItsTool.Web/wwwroot/admin-fields.html')
fix_top_level_awaits('src/ItsTool.Web/wwwroot/audit-log.html')
fix_top_level_awaits('src/ItsTool.Web/wwwroot/dashboard.html')

def extract_dashboard_helpers():
    filepath = 'src/ItsTool.Web/wwwroot/dashboard.html'
    with open(filepath, 'r') as f:
        content = f.read()

    # Move createKpiCard out
    kpi_card_regex = r'\s*const createKpiCard = \(title, val, color, iconPath\) => `[\s\S]*?`;'
    kpi_match = re.search(kpi_card_regex, content)
    if kpi_match:
        kpi_card_func = kpi_match.group(0).strip()
        content = content.replace(kpi_match.group(0), '')
        # insert before loadDashboard
        content = content.replace('async function loadDashboard() {', f'{kpi_card_func}\n\n        async function loadDashboard() {{')

    # Find the charts initialization part and move to a helper function
    # Wait, the charts are instantiated via new Chart(). I'll just find the Chart lines.
    status_chart_regex = r'\s*new Chart\(document\.getElementById\(\'statusChart\'\), \{[\s\S]*?\}\);'
    status_match = re.search(status_chart_regex, content)
    
    priority_chart_regex = r'\s*new Chart\(document\.getElementById\(\'priorityChart\'\), \{[\s\S]*?\}\);'
    priority_match = re.search(priority_chart_regex, content)
    
    if status_match and priority_match:
        status_code = status_match.group(0).strip()
        priority_code = priority_match.group(0).strip()
        
        helpers = f"""
        function buildStatusChart(dist) {{
            {status_code}
        }}
        
        function buildPriorityChart(dist) {{
            {priority_code}
        }}
        """
        
        content = content.replace(status_match.group(0), '\n                buildStatusChart(dist);')
        content = content.replace(priority_match.group(0), '\n                buildPriorityChart(dist);')
        
        content = content.replace('async function loadDashboard() {', f'{helpers}\n        async function loadDashboard() {{')

    with open(filepath, 'w') as f:
        f.write(content)

extract_dashboard_helpers()
