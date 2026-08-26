import re

def fix_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    orig = content

    # Add for= to label without for
    # E.g. <label class="form-label">Title</label>\n<input type="text" id="editArticleTitle"
    # We can match label without for, and grab the id of the next input/select
    def repl(m):
        label_start = m.group(1)
        label_text = m.group(2)
        tag_space = m.group(3)
        input_type = m.group(4)
        input_id = m.group(5)
        return f'{label_start} for="{input_id}">{label_text}</label>{tag_space}<{input_type} id="{input_id}"'

    content = re.sub(r'(<label[^>]*?(?<!for="[^"]")(?<!for=\'[^\']))>(.*?)</label>(\s*)<(input|select|textarea)[^>]*?id="([^"]+)"', repl, content)

    # For groups L168 <select id="userSelect" class="form-control" style="flex: 1;">
    content = content.replace('<select id="userSelect" class="form-control"', '<select id="userSelect" class="form-control" aria-label="Select User"')

    if orig != content:
        with open(filepath, 'w') as f:
            f.write(content)
        print(f"Fixed {filepath}")

import glob
for f in glob.glob('src/ItsTool.Web/wwwroot/**/*.html', recursive=True):
    fix_file(f)
