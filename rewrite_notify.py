import re

with open("src/ItsTool.Infrastructure/Services/NotificationDispatcher.cs", "r", encoding="utf-8") as f:
    code = f.read()

# Replace strings with constants
constants = """    private const string PriorityNormal = "Normal";
    private const string CategoryStatusUpdates = "StatusUpdates";
    private const string EventCommentMention = "comment.mention";
    private const string CategoryMentions = "Mentions";
    private const string DefaultBaseUrl = "http://localhost:5000";

"""
code = code.replace("public class NotificationDispatcher : INotificationDispatcher\n{", "public class NotificationDispatcher : INotificationDispatcher\n{\n" + constants)

# R47: private sealed class
code = code.replace("private class ResolvedRecipient", "private sealed class ResolvedRecipient")

# Priority and Category literals
code = code.replace('Priority { get; set; } = "Normal";', 'Priority { get; set; } = PriorityNormal;')
code = code.replace('Category { get; set; } = "StatusUpdates";', 'Category { get; set; } = CategoryStatusUpdates;')

code = code.replace('"Normal"', "PriorityNormal")
code = code.replace('"StatusUpdates"', "CategoryStatusUpdates")
code = code.replace('"comment.mention"', "EventCommentMention")
code = code.replace('"Mentions"', "CategoryMentions")
code = code.replace('"http://localhost:5000"', "DefaultBaseUrl")

# R31: Count vs Any
GROUP_COUNT_COND = "groupIds.Count == 0"
code = code.replace("!recipients.Any()", "recipients.Count == 0")
code = code.replace("groupIds.Any()", "groupIds.Count > 0")
code = code.replace("!groupIds.Count > 0", GROUP_COUNT_COND) # careful
code = code.replace("!groupIds.Any()", GROUP_COUNT_COND)
code = code.replace("!deptIds.Any()", "deptIds.Count == 0")
code = code.replace("!recipients.Count == 0", "recipients.Count > 0")

# fix up any !groupIds.Count > 0 if we made a mistake
code = code.replace("!groupIds.Count > 0", GROUP_COUNT_COND)

# R48: Contains("|") -> Contains('|')
code = code.replace("Contains(\"|\")", "Contains('|')")
code = code.replace("Split('|', 2)", "Split('|', 2)") # already correct in original but just in case
# The split with one arg was Split('|') in original, which is char.

# R49: bool emailEnabled = pref == null ? true : pref.EmailEnabled;
code = code.replace("bool emailEnabled = pref == null ? true : pref.EmailEnabled;", "bool emailEnabled = pref?.EmailEnabled ?? true;")

with open("src/ItsTool.Infrastructure/Services/NotificationDispatcher.cs", "w", encoding="utf-8") as f:
    f.write(code)
