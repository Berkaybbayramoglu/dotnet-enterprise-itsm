with open("fix_ui.js", "r") as f:
    text = f.read()
text = text.replace(r"/replaceAll\(\\\"\'\\\", \\\"\\\\\'\\\"\)/g", r"String.raw`replaceAll(\"'\", \"\\'\")`")
with open("fix_ui.js", "w") as f:
    f.write(text)
