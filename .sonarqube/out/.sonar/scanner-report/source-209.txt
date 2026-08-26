import sys

with open("src/ItsTool.Web/wwwroot/kb-article.html", "r", encoding="utf-8") as f:
    content = f.read()

# Add Admin Action Bar
action_bar = """
                    <div id="adminActionBar" style="display: none; justify-content: flex-end; gap: 8px; margin-bottom: 16px;">
                        <button type="button" class="btn btn-ghost" id="btnTogglePublish"></button>
                        <button type="button" class="btn btn-secondary" id="btnEditArticle">Edit</button>
                        <button type="button" class="btn btn-danger" id="btnDeleteArticle">Delete</button>
                    </div>
"""

content = content.replace('<h1 id="articleTitle"', action_bar + '\n                    <h1 id="articleTitle"')

# Add Modal
modal_html = """
    <!-- Article Edit Modal -->
    <div id="articleModal" class="modal-overlay">
        <div class="modal" style="max-width: 600px;">
            <div class="modal-header">
                <h2>Edit Article</h2>
                <button type="button" class="close-btn" onclick="closeModal('articleModal')" aria-label="Close">
                    <svg viewBox="0 0 24 24" width="24" height="24"><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/></svg>
                </button>
            </div>
            <div class="modal-body">
                <form id="articleForm">
                    <div class="form-group">
                        <label class="form-label">Title</label>
                        <input type="text" id="editArticleTitle" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Category</label>
                        <select id="editArticleCategory" class="form-control" required></select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Visibility</label>
                        <select id="editArticleVisibility" class="form-control" required>
                            <option value="0">Public</option>
                            <option value="1">Internal</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Status</label>
                        <select id="editArticleStatus" class="form-control" required>
                            <option value="0">Draft</option>
                            <option value="1">Published</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Content</label>
                        <textarea id="editArticleContent" class="form-control" rows="8" required></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-ghost" onclick="closeModal('articleModal')">Cancel</button>
                <button type="button" class="btn btn-primary" id="btnSaveArticle">Save</button>
            </div>
        </div>
    </div>
"""

content = content.replace('    <script type="module">', modal_html + '\n    <script type="module">')

# Add JS logic
js_imports = "import { bindShellActions, showToast, showUndoToast, openModal, closeModal } from './js/ui.js';\n        window.closeModal = closeModal;"
content = content.replace("import { bindShellActions, showToast } from './js/ui.js';", js_imports)

js_logic = """
        let loadedArticle = null;
        let isManager = false;

        try {
            const payload = JSON.parse(atob(window.api.token.split('.')[1]));
            let perms = [];
            if (payload.Permissions) {
                perms = typeof payload.Permissions === 'string' ? [payload.Permissions] : payload.Permissions;
            }
            if (perms.includes('kb.manage')) {
                isManager = true;
                document.getElementById('adminActionBar').style.display = 'flex';
                
                // Load categories for edit modal
                window.api.request('/kb/categories').then(cats => {
                    const sel = document.getElementById('editArticleCategory');
                    cats.forEach(c => {
                        sel.innerHTML += `<option value="${c.id}">${escapeHtml(c.name)}</option>`;
                    });
                });
            }
        } catch(e) {}

        document.getElementById('btnEditArticle')?.addEventListener('click', () => {
            if(!loadedArticle) return;
            document.getElementById('editArticleTitle').value = loadedArticle.title;
            document.getElementById('editArticleCategory').value = loadedArticle.categoryId;
            document.getElementById('editArticleVisibility').value = loadedArticle.visibility;
            document.getElementById('editArticleStatus').value = loadedArticle.status;
            document.getElementById('editArticleContent').value = loadedArticle.content;
            openModal('articleModal');
        });

        document.getElementById('btnSaveArticle')?.addEventListener('click', async () => {
            const data = {
                title: document.getElementById('editArticleTitle').value,
                categoryId: parseInt(document.getElementById('editArticleCategory').value),
                visibility: parseInt(document.getElementById('editArticleVisibility').value),
                status: parseInt(document.getElementById('editArticleStatus').value),
                content: document.getElementById('editArticleContent').value
            };
            try {
                await window.api.request(`/kb/articles/${articleId}`, { method: 'PUT', body: JSON.stringify(data) });
                closeModal('articleModal');
                showToast('Article updated successfully.');
                loadArticle();
            } catch(e) { showToast('Update failed', 'error'); }
        });

        document.getElementById('btnTogglePublish')?.addEventListener('click', async () => {
            if(!loadedArticle) return;
            const newStatus = loadedArticle.status === 0 ? 1 : 0;
            const oldStatus = loadedArticle.status;
            
            try {
                loadedArticle.status = newStatus;
                await window.api.request(`/kb/articles/${articleId}`, { method: 'PUT', body: JSON.stringify(loadedArticle) });
                loadArticle(); // Refresh UI
                
                showUndoToast(newStatus === 1 ? 'Article published.' : 'Article unpublished.', async () => {
                    loadedArticle.status = oldStatus;
                    await window.api.request(`/kb/articles/${articleId}`, { method: 'PUT', body: JSON.stringify(loadedArticle) });
                    loadArticle();
                });
            } catch(e) {
                loadedArticle.status = oldStatus;
                showToast('Failed to change publish status.', 'error');
            }
        });

        document.getElementById('btnDeleteArticle')?.addEventListener('click', () => {
            showUndoToast('Article will be deleted.', async () => {
                // Cancelled
                console.log('Delete cancelled by Undo.');
            }).then(async (proceed) => {
                if (proceed) {
                    try {
                        await window.api.request(`/kb/articles/${articleId}`, { method: 'DELETE' });
                        window.location.href = '/kb.html';
                    } catch(e) { showToast('Delete failed.', 'error'); }
                }
            });
        });
"""

content = content.replace("document.getElementById('articleContent').innerHTML = escapeHtml(a.content);", "document.getElementById('articleContent').innerHTML = escapeHtml(a.content);\n                loadedArticle = a;\n                if(isManager) {\n                    const tBtn = document.getElementById('btnTogglePublish');\n                    tBtn.textContent = a.status === 0 ? 'Publish' : 'Unpublish';\n                }")

content = content.replace("loadArticle();\n    </script>", js_logic + "\n        loadArticle();\n    </script>")

with open("src/ItsTool.Web/wwwroot/kb-article.html", "w", encoding="utf-8") as f:
    f.write(content)
