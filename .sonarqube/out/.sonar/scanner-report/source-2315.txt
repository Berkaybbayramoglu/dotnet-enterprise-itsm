import re

def fix_ticket_detail():
    path = "src/ItsTool.Web/wwwroot/ticket-detail.html"
    with open(path, "r") as f:
        content = f.read()

    # R19: L737 `const [_, gData]` -> `const [, gData]`
    content = content.replace("const [_, gData]", "const [, gData]")

    # R22 & R17: L1593-L1598
    old_block_1 = """            } else {
                if (h.action === 'CommentReplied' || h.action === 'CommentAdded' || h.action === 'InternalNoteAdded') {
                    const hasAttachment = h.newValue && h.newValue.includes('[attachment:');
                    if (hasAttachment) {
                        text = h.action === 'CommentReplied' ? (t('log_replied_attachment') || `replied with an attachment`) : (h.action === 'InternalNoteAdded' ? (t('log_note_attachment') || `added an internal note with an attachment`) : (t('log_comment_attachment') || `added a comment with an attachment`));
                    } else {
                        text = h.action === 'CommentReplied' ? (t('log_replied') || `replied to a comment`) : (h.action === 'InternalNoteAdded' ? (t('log_added_note') || `added an internal note`) : (t('log_added_comment') || `added a comment`));
                    }
                }
            }"""
    
    new_block_1 = """            } else if (h.action === 'CommentReplied' || h.action === 'CommentAdded' || h.action === 'InternalNoteAdded') {
                const hasAttachment = h.newValue && h.newValue.includes('[attachment:');
                if (hasAttachment) {
                    if (h.action === 'CommentReplied') text = t('log_replied_attachment') || `replied with an attachment`;
                    else if (h.action === 'InternalNoteAdded') text = t('log_note_attachment') || `added an internal note with an attachment`;
                    else text = t('log_comment_attachment') || `added a comment with an attachment`;
                } else {
                    if (h.action === 'CommentReplied') text = t('log_replied') || `replied to a comment`;
                    else if (h.action === 'InternalNoteAdded') text = t('log_added_note') || `added an internal note`;
                    else text = t('log_added_comment') || `added a comment`;
                }
            }"""
    content = content.replace(old_block_1, new_block_1)

    # R24: L1821 String.raw
    content = content.replace('csvContent += "Timestamp,User,Action,OldValue,NewValue\\\\n";', 'csvContent += String.raw`Timestamp,User,Action,OldValue,NewValue\\n`;')
    
    # R39: L1873
    content = content.replace('for (let i = 0; i < input.files.length; i++) {', 'for (const file of input.files) {')
    content = content.replace('formData.append(\'file\', input.files[i]);', 'formData.append(\'file\', file);')

    # R23: L2082
    content = content.replace('document.body.removeChild(btn.closest(\'.modal-overlay\'));', 'btn.closest(\'.modal-overlay\').remove();')

    # R25: L2307
    content = content.replace("target.getAttribute('data-user-id')", "target.dataset.userId")

    # R18: L2308, L2312
    content = content.replace("typeof globalUsers !== 'undefined'", "globalUsers !== undefined")
    content = content.replace("typeof globalGroups !== 'undefined'", "globalGroups !== undefined")

    with open(path, "w") as f:
        f.write(content)

fix_ticket_detail()
print("Fixed basic stuff in ticket-detail.html")
