import re

with open("src/ItsTool.Web/wwwroot/admin-fields.html", "r") as f:
    content = f.read()

edit_modal_html = """    <!-- Edit Field Modal -->
    <div id="editModal" class="modal-overlay">
        <div class="modal">
            <form id="editForm">
                <div class="modal-header">
                    <h2>Edit Field</h2>
                    <button type="button" class="close-btn" onclick="closeModal('editModal')" aria-label="Close">
                        <svg viewBox="0 0 24 24" width="24" height="24"><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/></svg>
                    </button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="eId">
                    <div class="form-group">
                        <label class="form-label" for="eKey">Field Key *</label>
                        <input type="text" id="eKey" class="form-control" disabled>
                        <small class="text-muted" style="display:block; margin-top: 4px;">Key cannot be changed after creation.</small>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="eLabel">Field Label *</label>
                        <input type="text" id="eLabel" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="eType">Field Type *</label>
                        <select id="eType" class="form-control" required>
                            <option value="0">Text</option>
                            <option value="1">Number</option>
                            <option value="2">Date</option>
                            <option value="3">Dropdown</option>
                            <option value="4">MultiSelect</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="eRegex">Validation Regex</label>
                        <input type="text" id="eRegex" class="form-control">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-ghost" onclick="closeModal('editModal')">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Confirm Delete Modal -->"""

content = content.replace("    <!-- Confirm Delete Modal -->", edit_modal_html)

js_fields_array = """        let fieldToDelete = null;
        let fieldsList = [];"""
content = content.replace("        let fieldToDelete = null;", js_fields_array)

js_fields_store = """                const fields = await window.api.getFieldDefinitions();
                fieldsList = fields;"""
content = content.replace("                const fields = await window.api.getFieldDefinitions();", js_fields_store)

js_edit_btn = """                        <td>
                            <button type="button" class="btn btn-ghost" style="color: var(--primary); padding: 4px 8px;" onclick="promptEdit(${f.id})">
                                <svg viewBox="0 0 24 24" width="18" height="18" style="fill: currentColor;"><path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/></svg>
                            </button>
                            <button type="button" class="btn btn-ghost" style="color: var(--danger); padding: 4px 8px;" onclick="promptDelete(${f.id})">"""
content = content.replace("""                        <td>
                            <button type="button" class="btn btn-ghost" style="color: var(--danger); padding: 4px 8px;" onclick="promptDelete(${f.id})">""", js_edit_btn)

js_edit_logic = """        window.promptDelete = function(id) {
            fieldToDelete = id;
            openModal('confirmModal');
        };

        window.promptEdit = function(id) {
            const field = fieldsList.find(f => f.id === id);
            if (!field) return;
            document.getElementById('eId').value = field.id;
            document.getElementById('eKey').value = field.key;
            document.getElementById('eLabel').value = field.label;
            
            // Handle numeric or string types
            const typeStr = field.fieldType.toString();
            let selectVal = "0";
            if(typeStr === 'Text' || typeStr === '0') selectVal = "0";
            else if(typeStr === 'Number' || typeStr === '1') selectVal = "1";
            else if(typeStr === 'Date' || typeStr === '2') selectVal = "2";
            else if(typeStr === 'Dropdown' || typeStr === '3') selectVal = "3";
            else if(typeStr === 'MultiSelect' || typeStr === '4') selectVal = "4";
            
            document.getElementById('eType').value = selectVal;
            document.getElementById('eRegex').value = field.validationRegex || "";
            openModal('editModal');
        };

        document.getElementById('editForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            const id = document.getElementById('eId').value;
            const key = document.getElementById('eKey').value;
            const label = document.getElementById('eLabel').value.trim();
            const typeStr = document.getElementById('eType').value;
            const regex = document.getElementById('eRegex').value.trim();
            
            try {
                await window.api.request(`/DynamicForm/definitions/${id}`, {
                    method: 'PUT',
                    body: JSON.stringify({
                        key: key,
                        label: label,
                        fieldType: Number.parseInt(typeStr) || 0,
                        validationRegex: regex || null,
                        isActive: true
                    })
                });
                closeModal('editModal');
                showToast('Field updated successfully');
                loadFields();
            } catch (err) {
                console.error(err);
                showToast('Failed to update field', 'error');
            }
        });"""
content = content.replace("""        window.promptDelete = function(id) {
            fieldToDelete = id;
            openModal('confirmModal');
        };""", js_edit_logic)

with open("src/ItsTool.Web/wwwroot/admin-fields.html", "w") as f:
    f.write(content)
