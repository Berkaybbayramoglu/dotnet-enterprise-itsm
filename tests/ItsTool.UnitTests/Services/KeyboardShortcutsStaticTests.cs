using System;
using System.IO;
using System.Linq;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class KeyboardShortcutsStaticTests
{
    private static string GetRepositoryRoot()
    {
        var current = AppDomain.CurrentDomain.BaseDirectory;
        var dir = new DirectoryInfo(current);
        while (dir != null && !File.Exists(Path.Combine(dir.FullName, "ItsTool.sln")))
        {
            dir = dir.Parent;
        }
        return dir?.FullName ?? throw new InvalidOperationException("Repository root not found");
    }

    [Fact]
    public void UiJs_ContainsGlobalKeyboardShortcutsImplementation()
    {
        var repoRoot = GetRepositoryRoot();
        var uiJsPath = Path.Combine(repoRoot, "src", "ItsTool.Web", "wwwroot", "js", "ui.js");
        Assert.True(File.Exists(uiJsPath), $"ui.js must exist at {uiJsPath}");

        var content = File.ReadAllText(uiJsPath);

        Assert.Contains("initGlobalKeyboardShortcuts", content);
        Assert.Contains("openShortcutsModal", content);
        Assert.Contains("shortcutsHelpModal", content);
        Assert.Contains("topbarShortcutsBtn", content);
        Assert.Contains("profileShortcutsBtn", content);
        Assert.Contains("Escape", content);
        Assert.Contains("searchInput", content);
    }

    [Fact]
    public void I18nJs_ContainsKeyboardShortcutTranslations_InBothLanguages()
    {
        var repoRoot = GetRepositoryRoot();
        var i18nPath = Path.Combine(repoRoot, "src", "ItsTool.Web", "wwwroot", "js", "i18n.js");
        Assert.True(File.Exists(i18nPath), $"i18n.js must exist at {i18nPath}");

        var content = File.ReadAllText(i18nPath);

        var requiredKeys = new[]
        {
            "kbd_shortcuts_title",
            "kbd_help",
            "kbd_search",
            "kbd_close",
            "kbd_new_ticket",
            "kbd_tickets",
            "kbd_dashboard"
        };

        foreach (var key in requiredKeys)
        {
            Assert.Contains($"\"{key}\":", content);
        }
    }

    [Fact]
    public void Readme_ContainsKeyboardShortcutsSection()
    {
        var repoRoot = GetRepositoryRoot();
        var readmePath = Path.Combine(repoRoot, "README.md");
        Assert.True(File.Exists(readmePath), $"README.md must exist at {readmePath}");

        var content = File.ReadAllText(readmePath);

        Assert.Contains("Klavye Kısayolları", content);
        Assert.Contains("Esc", content);
        Assert.Contains("Hızlı Arama", content);
    }

    [Theory]
    [InlineData("tickets.html")]
    [InlineData("ticket-detail.html")]
    [InlineData("dashboard.html")]
    [InlineData("audit-log.html")]
    [InlineData("sla.html")]
    [InlineData("calendar.html")]
    [InlineData("ticket-create.html")]
    public void CoreHtmlPages_CallBindShellActions(string htmlFileName)
    {
        var repoRoot = GetRepositoryRoot();
        var filePath = Path.Combine(repoRoot, "src", "ItsTool.Web", "wwwroot", htmlFileName);
        Assert.True(File.Exists(filePath), $"{htmlFileName} must exist");

        var content = File.ReadAllText(filePath);
        Assert.Contains("bindShellActions()", content);
    }
}
