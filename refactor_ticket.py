import re
import sys

def main():
    path = "old-ticket-detail.html"
    with open(path, "r", encoding="utf-8") as f:
        content = f.read()

    # R2: L81
    content = content.replace(
        '<div class="property-label mb-md" style="cursor: pointer; display: flex; align-items: center; gap: 8px;" onclick="toggleSection(\'activitySection\', this)">',
        '<button type="button" class="property-label mb-md" style="cursor: pointer; display: flex; align-items: center; gap: 8px; background:none; border:none; padding:0; font-family:inherit;" onclick="toggleSection(\'activitySection\', this)">'
    )
    # the closing tag for L81 is at L84: "Activity</div>" -> "Activity</button>"
    content = content.replace(
        'Activity\n                            </div>',
        'Activity\n                            </button>'
    )
    
    # R2: L93
    content = content.replace(
        '<div class="property-label mb-md" style="font-size: 16px; color: var(--text-main); cursor: pointer; display: flex; align-items: center; gap: 8px;" onclick="toggleSection(\'commentsSection\', this)">',
        '<button type="button" class="property-label mb-md" style="font-size: 16px; color: var(--text-main); cursor: pointer; display: flex; align-items: center; gap: 8px; background:none; border:none; padding:0; font-family:inherit;" onclick="toggleSection(\'commentsSection\', this)">'
    )
    content = content.replace(
        'Comments & History\n                            </div>',
        'Comments & History\n                            </button>'
    )
    
    # R3: L288
    content = content.replace(
        '<input type="text" id="commentLogSearch" class="form-control" style="width:200px; padding: 4px 8px; font-size: 12px;" placeholder="Search logs...">',
        '<input type="text" id="commentLogSearch" class="form-control" style="width:200px; padding: 4px 8px; font-size: 12px;" placeholder="Search logs..." aria-label="Search logs">'
    )
    
    # R5: L662, L663
    content = content.replace(
        'const uIds = Array.from(uChecks).map(c => parseInt(c.value));',
        'const uIds = Array.from(uChecks).map(c => Number.parseInt(c.value, 10));'
    )
    content = content.replace(
        'const gIds = Array.from(gChecks).map(c => parseInt(c.value));',
        'const gIds = Array.from(gChecks).map(c => Number.parseInt(c.value, 10));'
    )
    
    # R6: L1242
    content = content.replace(
        'if (h.fieldName && !isNaN(h.fieldName)) {',
        'if (h.fieldName && !Number.isNaN(Number(h.fieldName))) {'
    )
    
    # R7: L1264
    content = content.replace(
        'logDiv.dataset.csvRow = `"${new Date(e.timestamp).toISOString()}","${resolveUser(h.createdBy)}","${text}","${(h.oldValue||\'\').replace(/"/g, \'""\')}","${(h.newValue||\'\').replace(/"/g, \'""\')}"`;',
        'logDiv.dataset.csvRow = `"${new Date(e.timestamp).toISOString()}","${resolveUser(h.createdBy)}","${text}","${(h.oldValue||\'\').replaceAll(\'"\', \'""\')}","${(h.newValue||\'\').replaceAll(\'"\', \'""\')}"`;'
    )

    with open(path, "w", encoding="utf-8") as f:
        f.write(content)

    print("Replaced simple things")
    
if __name__ == "__main__":
    main()
