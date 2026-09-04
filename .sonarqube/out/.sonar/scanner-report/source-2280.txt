import os
import re

rules = {
    'R1': r'<a[^>]*href="#"[^>]*onclick',
    'R2': r'<(div|span)[^>]*onclick',
    'R5': r'(?<!Number\.)parseInt\(',
    'R6': r'(?<!Number\.)isNaN\(',
    'R7': r'\.replace\([^/]',
    'R14': r'require\(\'(fs|path)\'\)',
    'R17': r'\?.*:.*\?.*:',
    'R18': r'typeof\s+[a-zA-Z0-9_]+\s*===\s*[\'"]undefined[\'"]',
    'R20': r'catch\s*\([a-zA-Z0-9_]*\)\s*\{\s*\}',
    'R22': r'else\s*\{\s*if\s*\(',
    'R23': r'\.removeChild\(',
    'R25': r'\.[g|s]etAttribute\([\'"]data-',
    'R31': r'\.Any\(\)',
    'R39': r'for\s*\(\s*let\s+[a-zA-Z0-9_]+\s*=\s*0;\s*[a-zA-Z0-9_]+\s*<\s*[a-zA-Z0-9_.]+\.length;\s*[a-zA-Z0-9_]+\+\+\s*\)',
    'R42': r'replaceAll\(/[^.*+?()\[\]\\$^{}|]+/g',
    'R45': r'\.ToLower\(\)\s*==\s*[a-zA-Z0-9_.]+\.ToLower\(\)'
}

results = {}

for root, _, files in os.walk('src'):
    if 'lib' in root or 'node_modules' in root or 'bin' in root or 'obj' in root or 'signalr' in root:
        continue
    for file in files:
        if file.endswith(('.html', '.js', '.cs')):
            path = os.path.join(root, file)
            # Exclude known minified or library files if any
            if 'signalr' in path or 'jquery' in path or 'bootstrap' in path or 'test_delete' in path:
                continue
            with open(path, 'r', encoding='utf-8') as f:
                try:
                    content = f.read()
                    lines = content.split('\n')
                    for i, line in enumerate(lines):
                        for rule_name, pattern in rules.items():
                            if re.search(pattern, line):
                                if path not in results:
                                    results[path] = []
                                results[path].append((i+1, rule_name, line.strip()))
                except Exception as e:
                    pass

for path, matches in results.items():
    print(f"File: {path}")
    for m in matches:
        print(f"  Line {m[0]}: [{m[1]}] {m[2]}")
