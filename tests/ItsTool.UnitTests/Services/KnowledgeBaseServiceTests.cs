using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.KnowledgeBase;
using ItsTool.Domain.Entities.Organization;
using ItsTool.Infrastructure.Services;
using Moq;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class KnowledgeBaseServiceTests : TestBase
{
    private readonly Mock<IPermissionCalculator> _permCalcMock = new();
    private readonly Mock<ISignalRPusher> _signalRPusherMock = new();
    private readonly KnowledgeBaseService _kbService;

    public KnowledgeBaseServiceTests() : base()
    {
        _kbService = new KnowledgeBaseService(_context, _permCalcMock.Object, _signalRPusherMock.Object);
        SeedData();
    }

    private void SeedData()
    {
        _context.Users.Add(new User { Id = 1, Username = "admin", Email = "admin@itsm.com", FirstName = "Admin", LastName = "User", PasswordHash = "hash" });
        _context.Users.Add(new User { Id = 2, Username = "writer", Email = "writer@itsm.com", FirstName = "Author", LastName = "User", PasswordHash = "hash" });
        _context.KnowledgeCategories.Add(new KnowledgeCategory { Id = 1, Name = "Hardware Troubleshooting" });
        _context.SaveChanges();
    }

    [Fact]
    public async Task Categories_CreateUpdateDelete_WorksCorrectly()
    {
        var createDto = new CreateKbCategoryDto("Software Setup", null);
        var cat = await _kbService.CreateCategoryAsync(createDto);
        Assert.NotNull(cat);
        Assert.Equal("Software Setup", cat.Name);

        var list = (await _kbService.GetCategoriesAsync()).ToList();
        Assert.True(list.Count >= 2);

        var updateDto = new CreateKbCategoryDto("Software Installation", null);
        await _kbService.UpdateCategoryAsync(cat.Id, updateDto);

        var updated = await _context.KnowledgeCategories.FindAsync(cat.Id);
        Assert.Equal("Software Installation", updated!.Name);

        await _kbService.DeleteCategoryAsync(cat.Id);
        var deleted = await _context.KnowledgeCategories.FindAsync(cat.Id);
        Assert.True(deleted!.IsDeleted);
    }

    [Fact]
    public async Task CreateArticleAsync_CreatesDraftArticle()
    {
        _permCalcMock.Setup(p => p.CalculateEffectivePermissionsAsync(2))
            .ReturnsAsync(new HashSet<string> { "kb.manage" });

        var dto = new CreateKbArticleDto(
            CategoryId: 1,
            Title: "VPN Connection Troubleshooting",
            Content: "Step 1: Check credentials. Step 2: Restart client.",
            Status: ArticleStatus.Draft,
            Visibility: ArticleVisibility.Public
        );

        var article = await _kbService.CreateArticleAsync(dto, authorId: 2);

        Assert.NotNull(article);
        Assert.Equal("VPN Connection Troubleshooting", article.Title);
        Assert.Equal(ArticleStatus.Draft, article.Status);

        var entity = await _context.KnowledgeArticles.FindAsync(article.Id);
        Assert.NotNull(entity);
        Assert.Equal(2, entity.AuthorUserId);
    }

    [Fact]
    public async Task Article_ReviewAndApprovalWorkflow_TransitionsStatus()
    {
        _permCalcMock.Setup(p => p.CalculateEffectivePermissionsAsync(1))
            .ReturnsAsync(new HashSet<string> { "kb.manage" });
        _permCalcMock.Setup(p => p.CalculateEffectivePermissionsAsync(2))
            .ReturnsAsync(new HashSet<string> { "kb.manage" });

        var article = new KnowledgeArticle
        {
            Title = "Printer Setup Guide",
            Content = "Follow printer installation steps",
            CategoryId = 1,
            AuthorUserId = 2,
            Status = ArticleStatus.Draft,
            CreatedAt = DateTime.UtcNow
        };
        _context.KnowledgeArticles.Add(article);
        await _context.SaveChangesAsync();

        // Review article
        var reviewDto = new ReviewKbArticleDto(ArticleStatus.Published, "Approved for release");
        await _kbService.ReviewArticleAsync(article.Id, reviewDto, reviewerId: 1);

        var published = await _context.KnowledgeArticles.FindAsync(article.Id);
        Assert.Equal(ArticleStatus.Published, published!.Status);
    }

    [Fact]
    public async Task SearchArticlesAsync_FiltersByKeywordAndCategory()
    {
        var pubArticle = new KnowledgeArticle
        {
            Title = "Outlook Email Configuration",
            Content = "How to configure IMAP and SMTP settings",
            CategoryId = 1,
            AuthorUserId = 1,
            Status = ArticleStatus.Published,
            CreatedAt = DateTime.UtcNow
        };
        _context.KnowledgeArticles.Add(pubArticle);
        await _context.SaveChangesAsync();

        _permCalcMock.Setup(p => p.CalculateEffectivePermissionsAsync(1))
            .ReturnsAsync(new HashSet<string>());

        var results = await _kbService.SearchArticlesAsync(userId: 1, keyword: "Outlook", categoryId: 1);
        Assert.Single(results);
        Assert.Equal("Outlook Email Configuration", results.First().Title);
    }

    [Fact]
    public async Task GetArticleAsync_IncrementsViewCount_WhenPublished()
    {
        var article = new KnowledgeArticle
        {
            Title = "Monitor Resolution Guide",
            Content = "Change display resolution in OS settings",
            CategoryId = 1,
            AuthorUserId = 1,
            Status = ArticleStatus.Published,
            Visibility = ArticleVisibility.Public,
            ViewCount = 5
        };
        _context.KnowledgeArticles.Add(article);
        await _context.SaveChangesAsync();

        _permCalcMock.Setup(p => p.CalculateEffectivePermissionsAsync(2))
            .ReturnsAsync(new HashSet<string>());

        var fetched = await _kbService.GetArticleAsync(article.Id, userId: 2);
        Assert.NotNull(fetched);
        Assert.Equal(6, fetched.ViewCount);
    }
}
