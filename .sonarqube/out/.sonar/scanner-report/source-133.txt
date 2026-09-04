

export function initMentions(textareaId, ticketId = null) {
    const textarea = document.getElementById(textareaId);
    if (!textarea || textarea.dataset.mentionsInitialized === 'true') return;
    textarea.dataset.mentionsInitialized = 'true';

    let users = [];
    let dropdown = null;
    let currentMentionIndex = -1;
    let mentionStart = -1;

    async function loadUsers() {
        if (users.length > 0) return;
        try {
            const endpoint = ticketId ? `/Ticket/${ticketId}/eligible-users` : '/users';
            const res = await window.api.request(endpoint);
            users = res.items || res; 
        } catch (err) {
            console.error("Failed to load users for mentions", err);
        }
    }

    function createDropdown() {
        dropdown = document.createElement('ul');
        dropdown.className = 'dropdown-menu show';
        dropdown.style.position = 'absolute';
        dropdown.style.zIndex = '9999';
        dropdown.style.display = 'none';
        dropdown.style.maxHeight = '200px';
        dropdown.style.overflowY = 'auto';
        
        textarea.parentNode.style.position = 'relative';
        textarea.parentNode.appendChild(dropdown);
    }

    function hideDropdown() {
        if (dropdown) {
            dropdown.style.display = 'none';
            dropdown.innerHTML = '';
        }
        currentMentionIndex = -1;
        mentionStart = -1;
    }

    function showDropdown(rect, query) {
        if (!dropdown) createDropdown();
        
        const filtered = users.filter(u => {
            const fullName = (u.firstName + ' ' + u.lastName).toLowerCase();
            return fullName.includes(query) || u.email?.toLowerCase().includes(query);
        });
        if (filtered.length === 0) {
            hideDropdown();
            return;
        }

        dropdown.innerHTML = '';
        filtered.forEach((u, idx) => {
            const li = document.createElement('li');
            const a = document.createElement('a');
            a.className = `dropdown-item ${idx === 0 ? 'active' : ''}`;
            a.href = '#';
            const fullName = u.firstName + ' ' + u.lastName;
            a.innerHTML = `<div style="display:flex; align-items:center; gap:8px;">
                <div class="avatar" style="width:24px; height:24px; font-size:10px;">${fullName.charAt(0).toUpperCase()}</div>
                <div>
                    <div style="font-size:13px; font-weight:500;">${fullName}</div>
                    <div style="font-size:11px; color:var(--text-muted);">${u.email}</div>
                </div>
            </div>`;
            a.dataset.userId = u.id;
            a.dataset.name = fullName;
            a.onclick = (e) => {
                e.preventDefault();
                insertMention(fullName, u.id);
            };
            li.appendChild(a);
            dropdown.appendChild(li);
        });

        dropdown.style.top = (textarea.offsetTop + textarea.offsetHeight) + 'px';
        dropdown.style.left = textarea.offsetLeft + 'px';
        dropdown.style.width = textarea.offsetWidth + 'px';
        dropdown.style.display = 'block';
        currentMentionIndex = 0;
    }

    function insertMention(name, userId) {
        const text = textarea.value;
        const before = text.substring(0, mentionStart);
        const after = text.substring(textarea.selectionEnd);
        textarea.value = before + `@${name} ` + after;
        
        let mentionedIds = [];
        try {
            if (textarea.dataset.mentions) mentionedIds = JSON.parse(textarea.dataset.mentions);
        } catch(e) { console.warn('Mention processing error', e); }
        if (!mentionedIds.includes(userId)) mentionedIds.push(userId);
        textarea.dataset.mentions = JSON.stringify(mentionedIds);
        
        textarea.focus();
        textarea.selectionStart = textarea.selectionEnd = before.length + name.length + 2;
        hideDropdown();
    }

    textarea.addEventListener('input', async (e) => {
        await loadUsers();
        const cursor = textarea.selectionEnd;
        const textToCursor = textarea.value.substring(0, cursor);
        const match = textToCursor.match(/(^|\s)@([^\s]*)$/);
        
        if (match) {
            mentionStart = cursor - match[2].length - 1;
            const query = match[2].toLowerCase();
            
            // Get caret coordinates (simplified approximation for textarea)
            const rect = textarea.getBoundingClientRect();
            
            showDropdown(rect, query);
        } else {
            hideDropdown();
        }
    });

    textarea.addEventListener('keydown', (e) => {
        if (dropdown?.style.display === 'block') {
            const items = dropdown.querySelectorAll('.dropdown-item');
            if (e.key === 'ArrowDown') {
                e.preventDefault();
                items[currentMentionIndex].classList.remove('active');
                currentMentionIndex = (currentMentionIndex + 1) % items.length;
                items[currentMentionIndex].classList.add('active');
            } else if (e.key === 'ArrowUp') {
                e.preventDefault();
                items[currentMentionIndex].classList.remove('active');
                currentMentionIndex = (currentMentionIndex - 1 + items.length) % items.length;
                items[currentMentionIndex].classList.add('active');
            } else if (e.key === 'Enter' || e.key === 'Tab') {
                e.preventDefault();
                items[currentMentionIndex].click();
            } else if (e.key === 'Escape') {
                hideDropdown();
            }
        } else if (e.key === 'Backspace' && textarea.selectionStart === textarea.selectionEnd) {
            const cursor = textarea.selectionEnd;
            const textToCursor = textarea.value.substring(0, cursor);
            const match = textToCursor.match(/@([a-zA-ZçğıöşüÇĞİÖŞÜ0-9\s]+)$/);
            if (match && users.length > 0) {
                const possibleName = match[1];
                const possibleNameTrimmed = possibleName.trim();
                const isMention = users.some(u => (u.firstName + ' ' + u.lastName) === possibleNameTrimmed);
                if (isMention) {
                    e.preventDefault();
                    const before = textarea.value.substring(0, cursor - possibleName.length);
                    const after = textarea.value.substring(cursor);
                    textarea.value = before + after;
                    textarea.selectionStart = textarea.selectionEnd = before.length;
                    
                    // Trigger input event to show dropdown for just '@'
                    textarea.dispatchEvent(new Event('input'));
                }
            }
        }
    });

    document.addEventListener('click', (e) => {
        if (e.target !== textarea && !dropdown?.contains(e.target)) {
            hideDropdown();
        }
    });
    
    // Eager load users so they are available for synchronous operations like Backspace
    loadUsers();
}
