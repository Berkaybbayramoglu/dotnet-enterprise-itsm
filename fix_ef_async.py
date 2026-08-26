import os
import re

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    # _context.Property.Any() -> await _context.Property.AnyAsync()
    content = re.sub(r'_context\.([a-zA-Z0-9_]+)\.Any\(\)', r'await _context.\1.AnyAsync()', content)
    
    # _context.Property.FirstOrDefault( -> await _context.Property.FirstOrDefaultAsync(
    content = re.sub(r'_context\.([a-zA-Z0-9_]+)\.FirstOrDefault\(', r'await _context.\1.FirstOrDefaultAsync(', content)
    
    # _context.Property.Where(...).ToList() -> await _context.Property.Where(...).ToListAsync()
    # Need to be careful with nested parentheses. 
    # Actually, let's just target _context.XXX.Where(...).ToList() 
    # Or just replace `.ToList()` where it's part of a _context chain.
    content = re.sub(r'(_context\.[^;]+)\.ToList\(\)', r'await \1.ToListAsync()', content)
    # Fix the case where await is added twice
    content = re.sub(r'await\s+await\s+', 'await ', content)

    # Let's also handle the specific case of existingTransitions Any check which was checking local memory, wait, existingTransitions is memory or query?
    # var existingTransitions = _context.WorkflowTransitions.Where(...).ToList();
    # This evaluates to List. So existingTransitions.Any() is fine.
    
    with open(filepath, 'w') as f:
        f.write(content)
    print(f"Processed {filepath}")

import glob
files = glob.glob('src/ItsTool.Infrastructure/**/*.cs', recursive=True)
for f in files:
    process_file(f)

