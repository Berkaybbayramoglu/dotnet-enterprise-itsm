using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.KnowledgeBase;
using ItsTool.Infrastructure.Services;
using Moq;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class KnowledgeBaseServiceTests : TestBase
{
    private readonly KnowledgeBaseService _kbService;
    private readonly Mock<IPermissionCalculator> _mockPermCalculator;
    private readonly Mock<ISignalRPusher> _mockSignalRPusher;

    public KnowledgeBaseServiceTests() : base()
    {
        _mockPermCalculator = new Mock<IPermissionCalculator>();
        _mockSignalRPusher = new Mock<ISignalRPusher>();
        _kbService = new KnowledgeBaseService(_context, _mockPermCalculator.Object, _mockSignalRPusher.Object);
    }

    [Fact]
    public async Task SearchArticlesAsync_ShouldHideDraftAndInternal_FromEndUser()
    {
        _mockPermCalculator.Setup(x => x.CalculateEffectivePermissionsAsync(1)).ReturnsAsync(new HashSet<string>()); // End user

        _context.KnowledgeArticles.Add(new KnowledgeArticle { Title = "A1", Status = ArticleStatus.Published, Visibility = ArticleVisibility.Public });
        _context.KnowledgeArticles.Add(new KnowledgeArticle { Title = "A2", Status = ArticleStatus.Draft, Visibility = ArticleVisibility.Public });
        _context.KnowledgeArticles.Add(new KnowledgeArticle { Title = "A3", Status = ArticleStatus.Published, Visibility = ArticleVisibility.Internal });
        await _context.SaveChangesAsync();

        var result = await _kbService.SearchArticlesAsync(1, null, null);

        Assert.Single(result);
        Assert.Equal("A1", result.First().Title);
    }

    [Fact]
    public async Task SearchArticlesAsync_ShouldShowInternal_ToStaff()
    {
        _mockPermCalculator.Setup(x => x.CalculateEffectivePermissionsAsync(1)).ReturnsAsync(new HashSet<string> { "ticket.manage" }); // Staff

        _context.KnowledgeArticles.Add(new KnowledgeArticle { Title = "A1", Status = ArticleStatus.Published, Visibility = ArticleVisibility.Public });
        _context.KnowledgeArticles.Add(new KnowledgeArticle { Title = "A2", Status = ArticleStatus.Published, Visibility = ArticleVisibility.Internal });
        await _context.SaveChangesAsync();

        var result = await _kbService.SearchArticlesAsync(1, null, null);

        Assert.Equal(2, result.Count());
    }

    [Fact]
    public async Task GetArticleAsync_ShouldIncrementViewCount_ForPublished()
    {
        _mockPermCalculator.Setup(x => x.CalculateEffectivePermissionsAsync(1)).ReturnsAsync(new HashSet<string>());

        var article = new KnowledgeArticle { Title = "A1", Status = ArticleStatus.Published, Visibility = ArticleVisibility.Public, ViewCount = 0 };
        _context.KnowledgeArticles.Add(article);
        await _context.SaveChangesAsync();

        var result = await _kbService.GetArticleAsync(article.Id, 1);

        Assert.NotNull(result);
        Assert.Equal(1, result.ViewCount);
        
        var dbArticle = await _context.KnowledgeArticles.FindAsync(article.Id);
        Assert.Equal(1, dbArticle!.ViewCount);
    }
}
