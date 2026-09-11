import test from 'node:test';
import assert from 'node:assert/strict';

class ClassList {
    constructor() {
        this._set = new Set();
    }
    add(c) { this._set.add(c); }
    remove(c) { this._set.delete(c); }
    toggle(c) { if (this._set.has(c)) this._set.delete(c); else this._set.add(c); }
    contains(c) { return this._set.has(c); }
}

class MockElement {
    constructor(tagName = 'DIV', id = '') {
        this.tagName = tagName.toUpperCase();
        this._id = id;
        if (id) elementsById.set(id, this);
        this.classList = new ClassList();
        this.style = {};
        this.dataset = {};
        this.children = [];
        this.parentElement = null;
        this.isContentEditable = false;
        this._listeners = {};
        this.value = '';
    }

    get id() { return this._id; }
    set id(val) {
        this._id = val;
        if (val) elementsById.set(val, this);
    }

    addEventListener(event, handler) {
        if (!this._listeners[event]) this._listeners[event] = [];
        this._listeners[event].push(handler);
    }

    dispatchEvent(event) {
        const handlers = this._listeners[event.type] || [];
        for (const h of handlers) h(event);
    }

    appendChild(child) {
        this.children.push(child);
        child.parentElement = this;
        return child;
    }

    querySelector(sel) {
        const find = (el) => {
            for (const ch of el.children) {
                if (sel.includes(ch.tagName.toLowerCase()) || (ch.id && sel.includes(ch.id))) return ch;
                const found = find(ch);
                if (found) return found;
            }
            return null;
        };
        return find(this);
    }

    querySelectorAll(sel) {
        const results = [];
        const match = (el) => {
            if (sel.includes('.modal-overlay.active') && el.classList.contains('active')) results.push(el);
            else if (sel.includes('.dropdown-menu.show') && el.classList.contains('show')) results.push(el);
            for (const ch of el.children) match(ch);
        };
        match(this);
        return results;
    }

    focus() {
        global.document.activeElement = this;
        this._focused = true;
    }

    select() {
        this._selected = true;
    }

    closest(sel) {
        if (sel.includes('ql-editor') && this.classList.contains('ql-editor')) return this;
        if (sel.includes('contenteditable') && this.isContentEditable) return this;
        return this.parentElement ? this.parentElement.closest(sel) : null;
    }
}

// Setup Global DOM and browser mocks before importing ui.js
const doc = new MockElement('DOCUMENT');
doc.documentElement = new MockElement('HTML');
doc.body = new MockElement('BODY');
doc.documentElement.appendChild(doc.body);
doc.activeElement = doc.body;

const elementsById = new Map();
doc.getElementById = (id) => elementsById.get(id) || null;
doc.register = (id, el) => { el.id = id; elementsById.set(id, el); };
doc.createElement = (tag) => new MockElement(tag);
doc.querySelectorAll = (sel) => doc.documentElement.querySelectorAll(sel);

global.document = doc;
global.window = {
    location: { href: 'http://localhost/' },
    _kbdShortcutsInitialized: false,
    addEventListener: () => {}
};
global.localStorage = {
    _store: { itsm_lang: 'tr' },
    getItem(k) { return this._store[k] || null; },
    setItem(k, v) { this._store[k] = String(v); },
    removeItem(k) { delete this._store[k]; },
    clear() { this._store = {}; }
};
global.t = (k) => k;

// Dynamic import of ui.js
const { initGlobalKeyboardShortcuts } = await import('../../src/ItsTool.Web/wwwroot/js/ui.js');

test('Global Keyboard Shortcuts - ? or Shift+/ opens shortcuts modal', () => {
    window._kbdShortcutsInitialized = false;
    initGlobalKeyboardShortcuts();

    let defaultPrevented = false;
    document.dispatchEvent({
        type: 'keydown',
        key: '?',
        preventDefault: () => { defaultPrevented = true; }
    });

    const modal = document.getElementById('shortcutsHelpModal');
    assert.ok(modal, 'shortcutsHelpModal should be created in DOM');
    assert.ok(modal.classList.contains('active'), 'shortcutsHelpModal should be toggled to active');
    assert.ok(defaultPrevented, 'preventDefault should be called for ?');
});

test('Global Keyboard Shortcuts - / focuses search input', () => {
    const searchInput = new MockElement('INPUT', 'searchInput');
    document.register('searchInput', searchInput);

    window._kbdShortcutsInitialized = false;
    initGlobalKeyboardShortcuts();

    let defaultPrevented = false;
    document.dispatchEvent({
        type: 'keydown',
        key: '/',
        code: 'Slash',
        shiftKey: false,
        ctrlKey: false,
        altKey: false,
        metaKey: false,
        preventDefault: () => { defaultPrevented = true; }
    });

    assert.equal(document.activeElement, searchInput, 'searchInput should be focused');
    assert.ok(searchInput._selected, 'searchInput.select() should be called');
    assert.ok(defaultPrevented, 'preventDefault should be called for /');
});

test('Global Keyboard Shortcuts - Shift+Slash does NOT focus search, it opens help modal', () => {
    const searchInput = new MockElement('INPUT', 'searchInput');
    document.register('searchInput', searchInput);
    document.activeElement = document.body;

    window._kbdShortcutsInitialized = false;
    initGlobalKeyboardShortcuts();

    const existingModal = document.getElementById('shortcutsHelpModal');
    if (existingModal) existingModal.classList.remove('active');

    document.dispatchEvent({
        type: 'keydown',
        key: '?',
        code: 'Slash',
        shiftKey: true,
        ctrlKey: false,
        altKey: false,
        metaKey: false,
        preventDefault: () => {}
    });

    assert.notEqual(document.activeElement, searchInput, 'Search should NOT be focused on Shift+Slash');
    const modal = document.getElementById('shortcutsHelpModal');
    assert.ok(modal && modal.classList.contains('active'), 'Shortcuts modal should be active');

    // Pressing ? again should toggle it closed
    document.dispatchEvent({
        type: 'keydown',
        key: '?',
        shiftKey: false,
        ctrlKey: false,
        altKey: false,
        metaKey: false,
        preventDefault: () => {}
    });
    assert.equal(modal.classList.contains('active'), false, 'Shortcuts modal should close when ? is pressed again');
});

test('Global Keyboard Shortcuts - Escape closes active modals and dropdowns', () => {
    const modal = new MockElement('DIV', 'shortcutsHelpModal');
    modal.classList.add('active');
    document.register('shortcutsHelpModal', modal);
    document.body.appendChild(modal);

    const dropdown = new MockElement('DIV', 'langDropdown');
    dropdown.classList.add('show');
    document.body.appendChild(dropdown);

    const profilePanel = new MockElement('DIV', 'myProfilePanel');
    profilePanel.style.display = 'block';
    document.register('myProfilePanel', profilePanel);

    window._kbdShortcutsInitialized = false;
    initGlobalKeyboardShortcuts();

    document.dispatchEvent({
        type: 'keydown',
        key: 'Escape',
        preventDefault: () => {}
    });

    assert.equal(modal.classList.contains('active'), false, 'Modal should no longer be active');
    assert.equal(dropdown.classList.contains('show'), false, 'Dropdown should no longer be show');
    assert.equal(profilePanel.style.display, 'none', 'Profile panel should be hidden');
});

test('Global Keyboard Shortcuts - n, t, d trigger fast page navigation', () => {
    window._kbdShortcutsInitialized = false;
    initGlobalKeyboardShortcuts();

    document.dispatchEvent({ type: 'keydown', key: 'n', shiftKey: false, ctrlKey: false, altKey: false, metaKey: false });
    assert.equal(window.location.href, '/ticket-create.html', 'n should navigate to /ticket-create.html');

    document.dispatchEvent({ type: 'keydown', key: 't', shiftKey: false, ctrlKey: false, altKey: false, metaKey: false });
    assert.equal(window.location.href, '/tickets.html', 't should navigate to /tickets.html');

    document.dispatchEvent({ type: 'keydown', key: 'd', shiftKey: false, ctrlKey: false, altKey: false, metaKey: false });
    assert.equal(window.location.href, '/dashboard.html', 'd should navigate to /dashboard.html');
});

test('Global Keyboard Shortcuts - typing in input/textarea/contenteditable does NOT trigger shortcuts', () => {
    const input = new MockElement('INPUT');
    document.activeElement = input;

    window._kbdShortcutsInitialized = false;
    initGlobalKeyboardShortcuts();

    window.location.href = '/current.html';
    document.dispatchEvent({ type: 'keydown', key: 'n', shiftKey: false, ctrlKey: false, altKey: false, metaKey: false });
    assert.equal(window.location.href, '/current.html', 'Typing n in INPUT should not navigate');

    document.dispatchEvent({ type: 'keydown', key: '/', shiftKey: false, ctrlKey: false, altKey: false, metaKey: false });
    assert.equal(document.activeElement, input, 'Typing / in INPUT should not trigger search focus');

    // Rich text editor (Quill)
    const quillEditor = new MockElement('DIV');
    quillEditor.classList.add('ql-editor');
    quillEditor.isContentEditable = true;
    document.activeElement = quillEditor;

    document.dispatchEvent({ type: 'keydown', key: 't', shiftKey: false, ctrlKey: false, altKey: false, metaKey: false });
    assert.equal(window.location.href, '/current.html', 'Typing t in Quill should not navigate');
});

test('Global Keyboard Shortcuts - browser native shortcuts with Ctrl/Alt/Meta are ignored', () => {
    document.activeElement = document.body;
    window._kbdShortcutsInitialized = false;
    initGlobalKeyboardShortcuts();

    window.location.href = '/stay.html';
    document.dispatchEvent({ type: 'keydown', key: 't', ctrlKey: true, altKey: false, metaKey: false });
    assert.equal(window.location.href, '/stay.html', 'Ctrl+T should not be intercepted');

    document.dispatchEvent({ type: 'keydown', key: 'n', ctrlKey: true, altKey: false, metaKey: false });
    assert.equal(window.location.href, '/stay.html', 'Ctrl+N should not be intercepted');

    document.dispatchEvent({ type: 'keydown', key: 'd', ctrlKey: false, altKey: true, metaKey: false });
    assert.equal(window.location.href, '/stay.html', 'Alt+D should not be intercepted');
});

test('Global Keyboard Shortcuts - topbar and profile button click triggers shortcuts modal', async () => {
    const { openShortcutsModal } = await import('../../src/ItsTool.Web/wwwroot/js/ui.js');
    const modal = document.getElementById('shortcutsHelpModal');
    if (modal) modal.classList.remove('active');

    // Simulate clicking topbar button
    openShortcutsModal();
    assert.ok(modal && modal.classList.contains('active'), 'Clicking shortcuts button should open modal');

    // Clicking again should close it
    openShortcutsModal();
    assert.equal(modal.classList.contains('active'), false, 'Clicking again should close modal');
});
