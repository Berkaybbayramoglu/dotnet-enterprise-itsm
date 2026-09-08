using System.Collections.Generic;
using System.Security.Claims;
using System.Threading.Tasks;
using ItsTool.API.Controllers;
using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.KnowledgeBase;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Moq;
using Xunit;

namespace ItsTool.UnitTests.Controllers;

public class KnowledgeBaseControllerTests
{
    private readonly Mock<IKnowledgeBaseService> _serviceMock;
    private readonly KnowledgeBaseController _controller;

    public KnowledgeBaseControllerTests()
    {
        _serviceMock = new Mock<IKnowledgeBaseService>();
        _controller = new KnowledgeBaseController(_serviceMock.Object);

        var user = new ClaimsPrincipal(new ClaimsIdentity(new[]
        {
            new Claim(ClaimTypes.NameIdentifier, "1")
        }, "mock"));

        _controller.ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext { User = user }
        };
    }

    [Fact]
    public async Task GetCategories_ShouldReturnOk()
    {
        var list = new List<KbCategoryDto>();
        _serviceMock.Setup(s => s.GetCategoriesAsync()).ReturnsAsync(list);

        var result = await _controller.GetCategories();

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(list, ok.Value);
    }

    [Fact]
    public async Task CreateCategory_ShouldReturnOk()
    {
        var dto = new CreateKbCategoryDto("General", null);
        var created = new KbCategoryDto(1, "General", null);
        _serviceMock.Setup(s => s.CreateCategoryAsync(dto)).ReturnsAsync(created);

        var result = await _controller.CreateCategory(dto);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(created, ok.Value);
    }

    [Fact]
    public async Task UpdateCategory_ShouldReturnNoContent()
    {
        var dto = new CreateKbCategoryDto("Updated", null);
        _serviceMock.Setup(s => s.UpdateCategoryAsync(1, dto)).Returns(Task.CompletedTask);

        var result = await _controller.UpdateCategory(1, dto);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task DeleteCategory_ShouldReturnNoContent()
    {
        _serviceMock.Setup(s => s.DeleteCategoryAsync(1)).Returns(Task.CompletedTask);

        var result = await _controller.DeleteCategory(1);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task SearchArticles_ShouldReturnOk()
    {
        var list = new List<KbArticleSummaryDto>();
        _serviceMock.Setup(s => s.SearchArticlesAsync(1, "test", null)).ReturnsAsync(list);

        var result = await _controller.SearchArticles("test", null);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(list, ok.Value);
    }

    [Fact]
    public async Task GetArticle_ShouldReturnOk_WhenFound()
    {
        var dto = new KbArticleDto(1, 1, "Title", "Content", 1, "Author", null, ArticleStatus.Draft, ArticleVisibility.Public, 0, DateTime.UtcNow, null);
        _serviceMock.Setup(s => s.GetArticleAsync(1, 1)).ReturnsAsync(dto);

        var result = await _controller.GetArticle(1);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(dto, ok.Value);
    }

    [Fact]
    public async Task GetArticle_ShouldReturnNotFound_WhenMissing()
    {
        _serviceMock.Setup(s => s.GetArticleAsync(99, 1)).ReturnsAsync((KbArticleDto?)null);

        var result = await _controller.GetArticle(99);

        Assert.IsType<NotFoundResult>(result);
    }

    [Fact]
    public async Task CreateArticle_ShouldReturnOk()
    {
        var dto = new CreateKbArticleDto(1, "New", "Content", ArticleStatus.Draft, ArticleVisibility.Public);
        var created = new KbArticleDto(1, 1, "New", "Content", 1, "Author", null, ArticleStatus.Draft, ArticleVisibility.Public, 0, DateTime.UtcNow, null);
        _serviceMock.Setup(s => s.CreateArticleAsync(dto, 1)).ReturnsAsync(created);

        var result = await _controller.CreateArticle(dto);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(created, ok.Value);
    }

    [Fact]
    public async Task UpdateArticle_ShouldReturnNoContent()
    {
        var dto = new UpdateKbArticleDto(1, "Upd", "Content", ArticleStatus.Draft, ArticleVisibility.Public);
        _serviceMock.Setup(s => s.UpdateArticleAsync(1, dto, 1)).Returns(Task.CompletedTask);

        var result = await _controller.UpdateArticle(1, dto);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task ReviewArticle_ShouldReturnNoContent_WhenSuccessful()
    {
        var dto = new ReviewKbArticleDto(ArticleStatus.Published, null);
        _serviceMock.Setup(s => s.ReviewArticleAsync(1, dto, 1)).Returns(Task.CompletedTask);

        var result = await _controller.ReviewArticle(1, dto);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task DeleteArticle_ShouldReturnNoContent()
    {
        _serviceMock.Setup(s => s.DeleteArticleAsync(1, 1)).Returns(Task.CompletedTask);

        var result = await _controller.DeleteArticle(1);

        Assert.IsType<NoContentResult>(result);
    }
}
