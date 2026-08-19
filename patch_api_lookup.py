with open("src/ItsTool.Web/wwwroot/js/api.js", "r") as f:
    content = f.read()

if "async getLookup()" not in content:
    old_str = "    // Tickets\n    async searchTickets(filter = {}) {"
    new_str = "    // Lookup\n    async getLookup() { return this.request('/lookup'); }\n\n    // Tickets\n    async searchTickets(filter = {}) {"
    content = content.replace(old_str, new_str)
    
    with open("src/ItsTool.Web/wwwroot/js/api.js", "w") as f:
        f.write(content)
