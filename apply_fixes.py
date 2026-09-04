import os

def fix_ticket_detail():
    path = "src/ItsTool.Web/wwwroot/ticket-detail.html"
    with open(path, "r", encoding="utf-8") as f:
        c = f.read()
    
    # L164: agent.openTicketCount > 10 ? 'var(--danger)' : agent.openTicketCount > 5 ? '#B36200' : 'var(--text-main)'
    c = c.replace(
        "style=\"color: ${agent.openTicketCount > 10 ? 'var(--danger)' : agent.openTicketCount > 5 ? '#B36200' : 'var(--text-main)'};\"",
        "style=\"color: ${(() => { if (agent.openTicketCount > 10) return 'var(--danger)'; if (agent.openTicketCount > 5) return '#B36200'; return 'var(--text-main)'; })()};\""
    )
    
    # L476
    c = c.replace("prioName.toLowerCase().replace(' ', '_')", "prioName.toLowerCase().replaceAll(' ', '_')")
    
    # L750, L759: <div class="d-flex align-items-center gap-sm" style="cursor:pointer;" onclick="openUserDetails(${uId})">
    c = c.replace(
        """<div class="d-flex align-items-center gap-sm" style="cursor:pointer;" onclick="openUserDetails(${uId})">""",
        """<button type="button" class="btn btn-ghost d-flex align-items-center gap-sm p-0 m-0" style="border:none; text-align:left;" onclick="openUserDetails(${uId})">"""
    )
    c = c.replace(
        """</span></div>`;""",
        """</span></button>`;"""
    )

    # L808: document.getElementById('tReq').innerHTML = `<div class="d-flex align-items-center gap-sm" style="cursor:pointer;" onclick="openUserDetails(${t.requesterUserId})">...</div>`;
    c = c.replace(
        """`<div class="d-flex align-items-center gap-sm" style="cursor:pointer;" onclick="openUserDetails(${t.requesterUserId})">${getAvatar(t.requesterUserId, getReqName, reqUser?.profilePhoto)} ${escapeHtml(getReqName)}</div>`""",
        """`<button type="button" class="btn btn-ghost d-flex align-items-center gap-sm p-0 m-0" style="border:none; text-align:left;" onclick="openUserDetails(${t.requesterUserId})">${getAvatar(t.requesterUserId, getReqName, reqUser?.profilePhoto)} ${escapeHtml(getReqName)}</button>`"""
    )
    
    # L901: <div style="display:flex; align-items:center; gap:8px; font-weight:600; padding:6px; background:var(--bg-hover); border-radius:4px; cursor:pointer;" onclick="const ul = this.nextElementSibling; ul.style.display = ul.style.display === 'none' ? 'block' : 'none'; const svg = this.querySelector('.dept-chevron'); svg.style.transform = ul.style.display === 'none' ? '' : 'rotate(90deg)';">
    c = c.replace(
        """<div style="display:flex; align-items:center; gap:8px; font-weight:600; padding:6px; background:var(--bg-hover); border-radius:4px; cursor:pointer;" onclick="const ul = this.nextElementSibling; ul.style.display = ul.style.display === 'none' ? 'block' : 'none'; const svg = this.querySelector('.dept-chevron'); svg.style.transform = ul.style.display === 'none' ? '' : 'rotate(90deg)';">""",
        """<button type="button" style="display:flex; align-items:center; gap:8px; font-weight:600; padding:6px; background:var(--bg-hover); border-radius:4px; cursor:pointer; width:100%; border:none; text-align:left;" onclick="const ul = this.nextElementSibling; if (ul.style.display === 'none') { ul.style.display = 'block'; this.querySelector('.dept-chevron').style.transform = 'rotate(90deg)'; } else { ul.style.display = 'none'; this.querySelector('.dept-chevron').style.transform = ''; }">"""
    )
    c = c.replace(
        """                                        ${escapeHtml(d.name)}
                                    </div>""",
        """                                        ${escapeHtml(d.name)}
                                    </button>"""
    )

    # L919: <span style="font-weight:500; display:flex; align-items:center; gap:4px; cursor:pointer;" onclick="const ul = this.parentElement.nextElementSibling; ul.style.display = ul.style.display === 'none' ? 'block' : 'none'; const svg = this.querySelector('.grp-chevron'); svg.style.transform = ul.style.display === 'none' ? '' : 'rotate(90deg)';">
    c = c.replace(
        """<span style="font-weight:500; display:flex; align-items:center; gap:4px; cursor:pointer;" onclick="const ul = this.parentElement.nextElementSibling; ul.style.display = ul.style.display === 'none' ? 'block' : 'none'; const svg = this.querySelector('.grp-chevron'); svg.style.transform = ul.style.display === 'none' ? '' : 'rotate(90deg)';">""",
        """<button type="button" style="font-weight:500; display:flex; align-items:center; gap:4px; cursor:pointer; background:none; border:none; padding:0; text-align:left;" onclick="const ul = this.parentElement.nextElementSibling; if (ul.style.display === 'none') { ul.style.display = 'block'; this.querySelector('.grp-chevron').style.transform = 'rotate(90deg)'; } else { ul.style.display = 'none'; this.querySelector('.grp-chevron').style.transform = ''; }">"""
    )
    c = c.replace(
        """                                                    ${escapeHtml(g.name)}
                                                </span>""",
        """                                                    ${escapeHtml(g.name)}
                                                </button>"""
    )
    
    # L1413: c.updatedAt ? (t('log_edited_at') || '(Edited at {0})').replace('{0}', ...) : ...
    c = c.replace(").replace('{0}', new Date(c.updatedAt)", ").replaceAll('{0}', new Date(c.updatedAt)")
    
    # L1504-L1546
    c = c.replace(".replace('{0}', actionKey)", ".replaceAll('{0}', actionKey)")
    c = c.replace(".replace('{1}', h.fieldName || '')", ".replaceAll('{1}', h.fieldName || '')")
    c = c.replace(".replace('{2}', escapeHtml(oldVal))", ".replaceAll('{2}', escapeHtml(oldVal))")
    c = c.replace(".replace('{3}', escapeHtml(newVal))", ".replaceAll('{3}', escapeHtml(newVal))")
    c = c.replace(".replace('{0}', window.resolveTimelineUser(h.newValue))", ".replaceAll('{0}', window.resolveTimelineUser(h.newValue))")
    c = c.replace(".replace('{1}', window.resolveTimelineUser(h.oldValue))", ".replaceAll('{1}', window.resolveTimelineUser(h.oldValue))")
    c = c.replace(".replace('{0}', escapeHtml(window.parseHistoryTransfer(h.newValue)))", ".replaceAll('{0}', escapeHtml(window.parseHistoryTransfer(h.newValue)))")
    c = c.replace(".replace('{1}', escapeHtml(window.parseHistoryTransfer(h.oldValue)))", ".replaceAll('{1}', escapeHtml(window.parseHistoryTransfer(h.oldValue)))")
    c = c.replace(".replace('{0}', escapeHtml(sOld)).replace('{1}', escapeHtml(sNew))", ".replaceAll('{0}', escapeHtml(sOld)).replaceAll('{1}', escapeHtml(sNew))")
    c = c.replace(".replace('{0}', escapeHtml(pOld)).replace('{1}', escapeHtml(pNew))", ".replaceAll('{0}', escapeHtml(pOld)).replaceAll('{1}', escapeHtml(pNew))")
    c = c.replace(".replace('{0}', escapeHtml(cOld)).replace('{1}', escapeHtml(cNew))", ".replaceAll('{0}', escapeHtml(cOld)).replaceAll('{1}', escapeHtml(cNew))")
    c = c.replace(".replace('{0}', escapeHtml(h.newValue))", ".replaceAll('{0}', escapeHtml(h.newValue))")
    c = c.replace(".replace('{0}', escapeHtml(h.oldValue))", ".replaceAll('{0}', escapeHtml(h.oldValue))")
    
    # L1692: const targetId = highlightCommentId ? `comment-${highlightCommentId}` : (highlightHistoryId ? `history-${highlightHistoryId}` : null);
    c = c.replace(
        "const targetId = highlightCommentId ? `comment-${highlightCommentId}` : (highlightHistoryId ? `history-${highlightHistoryId}` : null);",
        "let targetId = null;\n                if (highlightCommentId) targetId = `comment-${highlightCommentId}`;\n                else if (highlightHistoryId) targetId = `history-${highlightHistoryId}`;"
    )
    
    # L1761: ('log_replying_to') || 'Replying to comment #{0}...').replace('{0}', id)
    c = c.replace(").replace('{0}', id)", ").replaceAll('{0}', id)")
    
    # L1810, L2005, L2138: empty catch
    c = c.replace("catch(ex) {}", "catch(ex) { console.warn(ex); }")
    
    # L1829: textarea.value = textarea.value.replace(regex, '').trim(); (intention is multiple? regex has /g?)
    # actually it's `const regex = new RegExp(`\\[attachment:${attId}\\]`, 'g');` so .replace is already global. Let's make it replaceAll to be safe.
    c = c.replace("textarea.value.replace(regex, '')", "textarea.value.replaceAll(regex, '')")
    
    # L2031, 2039: document.body.removeChild(this.closest('.modal-overlay'))
    c = c.replace("document.body.removeChild(this.closest('.modal-overlay'))", "this.closest('.modal-overlay').remove()")
    
    with open(path, "w", encoding="utf-8") as f:
        f.write(c)
    print("Fixed ticket-detail.html")

def fix_dashboard():
    path = "src/ItsTool.Web/wwwroot/dashboard.html"
    with open(path, "r", encoding="utf-8") as f:
        c = f.read()

    # L309, 402
    c = c.replace(
        """<div style="display: flex; align-items: center; gap: 12px; padding: 12px; background: var(--bg-hover); border-radius: 8px; cursor: pointer; transition: 0.2s;" onclick="window.openTicketPreviewWrapper(${tData.id})" onmouseover="this.style.background='var(--border)'" onmouseout="this.style.background='var(--bg-hover)'">""",
        """<button type="button" style="width: 100%; border: none; text-align: left; display: flex; align-items: center; gap: 12px; padding: 12px; background: var(--bg-hover); border-radius: 8px; cursor: pointer; transition: 0.2s;" onclick="window.openTicketPreviewWrapper(${tData.id})" onmouseover="this.style.background='var(--border)'" onmouseout="this.style.background='var(--bg-hover)'">"""
    )
    c = c.replace(
        """<div style="display: flex; align-items: center; gap: 12px; padding: 12px; background: var(--bg-surface); border: 1px solid var(--border); border-radius: 8px; cursor: pointer; transition: 0.2s;" onclick="window.openTicketPreviewWrapper(${tData.id})" onmouseover="this.style.background='var(--bg-hover)'" onmouseout="this.style.background='var(--bg-surface)'">""",
        """<button type="button" style="width: 100%; border: 1px solid var(--border); text-align: left; display: flex; align-items: center; gap: 12px; padding: 12px; background: var(--bg-surface); border-radius: 8px; cursor: pointer; transition: 0.2s;" onclick="window.openTicketPreviewWrapper(${tData.id})" onmouseover="this.style.background='var(--bg-hover)'" onmouseout="this.style.background='var(--bg-surface)'">"""
    )
    # The end tags need to be updated. Since this is in `buildTicketCardHtml` and `buildRecentTicketHtml`, we have to find the end `</div>` manually.
    c = c.replace("""                    </div>
                `;
            }).join('');""", """                    </button>
                `;
            }).join('');""")
    c = c.replace("""                        </div>
                    </div>
                `;
            }).join('');""", """                        </div>
                    </button>
                `;
            }).join('');""")

    # L452-465
    c = c.replace(".replace('Status: ', '')", ".replaceAll('Status: ', '')")
    c = c.replace(".replace('Priority: ', '')", ".replaceAll('Priority: ', '')")

    with open(path, "w", encoding="utf-8") as f:
        f.write(c)
    print("Fixed dashboard.html")

def fix_notifications():
    path = "src/ItsTool.Web/wwwroot/js/notifications.js"
    with open(path, "r", encoding="utf-8") as f:
        c = f.read()

    # L39: <a href="#" ...> -> <button type="button" ...>
    c = c.replace(
        """li.innerHTML = `<a id="btnDeleteAllNotifs" class="dropdown-item text-center" href="#" onclick="deleteAllNotifications(event)" style="padding: 12px 0; color: var(--danger); font-weight: 500; text-decoration: none; display: flex; align-items: center; justify-content: center; gap: 6px; transition: background 0.2s; border-top: 1px solid var(--border);">""",
        """li.innerHTML = `<button type="button" id="btnDeleteAllNotifs" class="dropdown-item text-center" onclick="deleteAllNotifications(event)" style="background:none; border:none; width:100%; padding: 12px 0; color: var(--danger); font-weight: 500; text-decoration: none; display: flex; align-items: center; justify-content: center; gap: 6px; transition: background 0.2s; border-top: 1px solid var(--border);">"""
    )
    c = c.replace("""${t ? t('notif_delete_all') : 'Tümünü Sil'}</a>`;""", """${t ? t('notif_delete_all') : 'Tümünü Sil'}</button>`;""")

    # L148, 218:
    c = c.replace(".replace('Event ', '')", ".replaceAll('Event ', '')")

    # L313: catch(err) {}
    c = c.replace("catch(err) {}", "catch(err) { console.warn('Error loading notifications', err); }")

    with open(path, "w", encoding="utf-8") as f:
        f.write(c)
    print("Fixed notifications.js")

def fix_crud_page():
    path = "src/ItsTool.Web/wwwroot/js/crud-page.js"
    with open(path, "r", encoding="utf-8") as f:
        c = f.read()
    c = c.replace(".replace('<td>', '').replace('</td>', '')", ".replaceAll('<td>', '').replaceAll('</td>', '')")
    with open(path, "w", encoding="utf-8") as f:
        f.write(c)
    print("Fixed crud-page.js")

def fix_mentions():
    path = "src/ItsTool.Web/wwwroot/js/mentions.js"
    with open(path, "r", encoding="utf-8") as f:
        c = f.read()
    c = c.replace("catch(e) {}", "catch(e) { console.warn('Mention processing error', e); }")
    with open(path, "w", encoding="utf-8") as f:
        f.write(c)
    print("Fixed mentions.js")

def fix_ui():
    path = "src/ItsTool.Web/wwwroot/js/ui.js"
    with open(path, "r", encoding="utf-8") as f:
        c = f.read()
    c = c.replace(".replace(' ', '_')", ".replaceAll(' ', '_')")
    with open(path, "w", encoding="utf-8") as f:
        f.write(c)
    print("Fixed ui.js")

if __name__ == "__main__":
    fix_ticket_detail()
    fix_dashboard()
    fix_notifications()
    fix_crud_page()
    fix_mentions()
    fix_ui()
