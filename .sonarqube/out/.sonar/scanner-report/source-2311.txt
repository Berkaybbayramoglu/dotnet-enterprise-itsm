import re

with open("old-ticket-detail.html", "r", encoding="utf-8") as f:
    lines = f.readlines()

start = -1
end = -1
for i, line in enumerate(lines):
    if "async function loadTicket()" in line:
        start = i
    if start != -1 and line.strip() == "window.openUserDetails = async function(userId) {":
        end = i - 1
        break

with open("load_ticket_code.txt", "w", encoding="utf-8") as f:
    f.writelines(lines[start:end])
print(f"Lines {start} to {end}")
