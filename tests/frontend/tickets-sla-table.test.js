import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const repoRoot = path.resolve(__dirname, '../..');

test('i18n.js - Contains all required SLA & ticket action keys in TR and EN', () => {
    const i18nPath = path.join(repoRoot, 'src/ItsTool.Web/wwwroot/js/i18n.js');
    const content = fs.readFileSync(i18nPath, 'utf8');

    const requiredKeys = [
        'sla_first_resp_breached',
        'sla_res_breached',
        'sla_days_left',
        'sla_mins_left',
        'sla_short_hr',
        'sla_met',
        'sla_completed',
        'sla_paused',
        'sla_target_prefix',
        'sla_resolution_prefix',
        'sla_expired',
        'sla_on_track',
        'sla_on_hold',
        'ticket_btn_delete'
    ];

    // Check that each key exists in the file at least twice (once in en, once in tr)
    for (const key of requiredKeys) {
        const matches = content.match(new RegExp(`"${key}"\\s*:`, 'g'));
        assert.ok(matches && matches.length >= 2, `Key "${key}" must be defined in both EN and TR (found ${matches ? matches.length : 0})`);
    }

    assert.ok(content.includes('export function t(key, fallback = null)'), 't() must support fallback parameter');
});

test('tickets.html - Table layout, column widths, and SLA badge styling', () => {
    const htmlPath = path.join(repoRoot, 'src/ItsTool.Web/wwwroot/tickets.html');
    const content = fs.readFileSync(htmlPath, 'utf8');

    // Overflow auto & minimum table width
    assert.ok(content.includes('overflow-x: auto;'), 'table-container must have overflow-x: auto');
    assert.ok(content.includes('min-width: 920px;'), 'table must have min-width of at least 920px');

    // Column widths total 100%
    assert.ok(content.includes('width: 25%;'), 'Ticket col should be 25%');
    assert.ok(content.includes('width: 11%;'), 'Status col should be 11%');
    assert.ok(content.includes('width: 10%;'), 'Priority col should be 10%');
    assert.ok(content.includes('width: 15%;'), 'Assignee col should be 15%');
    assert.ok(content.includes('width: 20%;'), 'SLA col should be 20%');
    assert.ok(content.includes('width: 19%;'), 'Actions col should be 19%');

    // CSS rules
    assert.ok(content.includes('.sla-badge'), 'Must define .sla-badge');
    assert.ok(content.includes('text-transform: none;'), '.sla-badge must disable uppercase text-transform');
    assert.ok(content.includes('.row-actions .btn'), '.row-actions .btn must have compact padding');

    // renderSlaCell uses sla-badge class
    assert.ok(content.includes('class="sla-badge"'), 'renderSlaCell must use sla-badge class');
    assert.ok(content.includes('class="sla-subtext"'), 'renderSlaCell must use sla-subtext class');

    // Button translations
    assert.ok(content.includes("t('ticket_btn_delete', 'Sil')"), 'Delete button must use localized key');
    assert.ok(content.includes("t('ticket_btn_edit', 'Düzenle')"), 'Edit button must use localized key');
});
