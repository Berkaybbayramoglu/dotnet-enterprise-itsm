const jsdom = require("jsdom");
const { JSDOM } = jsdom;

let assignHTML = "";
assignHTML += `
    <div style="margin-bottom: 8px;">
        <div class="d-flex align-items-center gap-sm" style="font-size: 12px; font-weight: 600; color: var(--text-muted); margin-bottom: 4px; text-transform: uppercase;">
            <svg viewBox="0 0 24 24" width="14" height="14" style="fill:currentColor"><path d="M10 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2h-8l-2-2z"/></svg>
            BILGI
        </div>
        <div style="padding-left: 16px; display: flex; flex-direction: column; gap: 4px;">
`;
assignHTML += `<div class="d-flex align-items-center gap-sm" style="font-size: 13px;"><svg viewBox="0 0 24 24" width="20" height="20" style="fill:var(--text-muted)"><path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/></svg> <span style="font-weight:500; color:var(--text-main);">G1</span></div>`;

assignHTML += `
        </div>
    </div>
`;

assignHTML += `
    <div style="margin-bottom: 8px;">
        <div class="d-flex align-items-center gap-sm" style="font-size: 12px; font-weight: 600; color: var(--text-muted); margin-bottom: 4px; text-transform: uppercase;">
            <svg viewBox="0 0 24 24" width="14" height="14" style="fill:currentColor"><path d="M10 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2h-8l-2-2z"/></svg>
            FINANCE
        </div>
        <div style="padding-left: 16px; display: flex; flex-direction: column; gap: 4px;">
`;
assignHTML += `<div class="d-flex align-items-center gap-sm" style="font-size: 13px;"><svg viewBox="0 0 24 24" width="20" height="20" style="fill:var(--text-muted)"><path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/></svg> <span style="font-weight:500; color:var(--text-main);">G2</span></div>`;

assignHTML += `
        </div>
    </div>
`;

const dom = new JSDOM(`<div id="tAssigned">${assignHTML}</div>`);
const tAssigned = dom.window.document.getElementById("tAssigned");
console.log(tAssigned.children.length); // should be 2
console.log(tAssigned.children[0].children.length); // should be 2
console.log(tAssigned.children[1].children.length); // should be 2
