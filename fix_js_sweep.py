import os
import re
import glob

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    original = content
    # Look for parseInt( not preceded by Number.
    content = re.sub(r'(?<!Number\.)parseInt\(', 'Number.parseInt(', content)
    # Look for isNaN( not preceded by Number.
    content = re.sub(r'(?<!Number\.)isNaN\(', 'Number.isNaN(', content)

    if content != original:
        with open(filepath, 'w') as f:
            f.write(content)
        print(f"Processed {filepath}")

files = glob.glob('src/ItsTool.Web/wwwroot/**/*.html', recursive=True)
files += glob.glob('src/ItsTool.Web/wwwroot/**/*.js', recursive=True)

for f in files:
    process_file(f)

