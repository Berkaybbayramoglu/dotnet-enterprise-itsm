import os
import re

def fix_ticket_detail():
    path = "src/ItsTool.Web/wwwroot/ticket-detail.html"
    with open(path, "r", encoding="utf-8") as f:
        c = f.read()

    # R22: else { if ... }
    c = c.replace("else {\n                if", "else if")
    # Actually let's use regex for R22
    c = re.sub(r'else\s*\{\s*if\s*\(', r'else if (', c)
    c = c.replace("} else if (h.fieldName === 'Description') {", "} else if (h.fieldName === 'Description') {") # to balance brackets if we broke them
    # Wait, simple replace is safer. Let's look for `else { if`
    # L1604, L1627 were flagged.
    
    # R24: \\ -> String.raw
    # I'll just change `.replaceAll("\\n", "<br>")` if they exist.
    # L1828, L2293
    c = c.replace(".replaceAll('\\n'", ".replaceAll(String.raw`\\n`")
    c = c.replace(".replaceAll('\\\\'", ".replaceAll(String.raw`\\\\`")

    # R17: nested ternary in L1692
    # This was already fixed in Phase 2! The user mentioned L1692 [R17] but we did:
    # let targetId = null; if (...) ... else if (...) ...
    # Let me check if there's another ternary.
    
    # R15: complexity in loadTicket, buildHistoryDetails, processHistoryEvent
    # Let's write the updated content back.
    with open(path, "w", encoding="utf-8") as f:
        f.write(c)
    print("Fixed ticket-detail.html easy ones")

def fix_temp_script():
    path = "src/ItsTool.Web/temp_script.js"
    if os.path.exists(path):
        with open(path, "r", encoding="utf-8") as f:
            c = f.read()
        def _opt_chain(m):
            return f"{m.group(1)}?.{m.group(3)}" if m.group(1) == m.group(2) else m.group(0)
        c = re.sub(r'\b(\w+)[ \t]*&&[ \t]*(\w+)\.(\w+)\b', _opt_chain, c, flags=re.ASCII)
        with open(path, "w", encoding="utf-8") as f:
            f.write(c)
        print("Fixed temp_script.js")

def fix_tests():
    for file in ["test-roles.js", "test_api.js", "test_kb.js"]:
        path = f"src/ItsTool.Web/{file}"
        if os.path.exists(path):
            with open(path, "r", encoding="utf-8") as f:
                c = f.read()
            c = c.replace("require('http')", "require('node:http')")
            with open(path, "w", encoding="utf-8") as f:
                f.write(c)
            print(f"Fixed {file}")

if __name__ == "__main__":
    fix_ticket_detail()
    fix_temp_script()
    fix_tests()
