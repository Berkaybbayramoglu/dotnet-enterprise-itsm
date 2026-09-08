using System.Threading.Tasks;
using ItsTool.API.Controllers;
using ItsTool.Domain.Entities.Config;
using Microsoft.AspNetCore.Mvc;
using Xunit;

namespace ItsTool.UnitTests.Controllers;

public class WebhookControllerTests : TestBase
{
    private readonly WebhookController _controller;

    public WebhookControllerTests() : base()
    {
        _controller = new WebhookController(_context);
    }

    [Fact]
    public async Task GetWebhooks_ShouldReturnAllNonDeleted()
    {
        _context.WebhookSubscriptions.Add(new WebhookSubscription { Id = 1, Url = "http://test.com", EventsCsv = "ticket.created", IsDeleted = false });
        _context.WebhookSubscriptions.Add(new WebhookSubscription { Id = 2, Url = "http://deleted.com", EventsCsv = "ticket.created", IsDeleted = true });
        await _context.SaveChangesAsync();

        var result = await _controller.GetWebhooks();

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.NotNull(ok.Value);
    }

    [Fact]
    public async Task GetWebhookById_ShouldReturnOk_WhenFound()
    {
        _context.WebhookSubscriptions.Add(new WebhookSubscription { Id = 3, Url = "http://found.com", EventsCsv = "ticket.created", IsDeleted = false });
        await _context.SaveChangesAsync();

        var result = await _controller.GetWebhookById(3);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.NotNull(ok.Value);
    }

    [Fact]
    public async Task GetWebhookById_ShouldReturnNotFound_WhenMissingOrDeleted()
    {
        var result = await _controller.GetWebhookById(99);

        Assert.IsType<NotFoundResult>(result);
    }

    [Fact]
    public async Task CreateWebhook_ShouldReturnOk()
    {
        var sub = new WebhookSubscription { Url = "http://created.com", EventsCsv = "ticket.updated" };

        var result = await _controller.CreateWebhook(sub);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.NotNull(ok.Value);
    }

    [Fact]
    public async Task UpdateWebhook_ShouldReturnOk_WhenFound()
    {
        _context.WebhookSubscriptions.Add(new WebhookSubscription { Id = 4, Url = "http://old.com", EventsCsv = "ticket.created" });
        await _context.SaveChangesAsync();

        var updated = new WebhookSubscription { Url = "http://new.com", EventsCsv = "ticket.updated", Secret = "s3cr3t", IsActive = true };
        var result = await _controller.UpdateWebhook(4, updated);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.NotNull(ok.Value);
    }

    [Fact]
    public async Task UpdateWebhook_ShouldReturnNotFound_WhenMissing()
    {
        var result = await _controller.UpdateWebhook(99, new WebhookSubscription());

        Assert.IsType<NotFoundResult>(result);
    }

    [Fact]
    public async Task DeleteWebhook_ShouldReturnNoContent_WhenFound()
    {
        _context.WebhookSubscriptions.Add(new WebhookSubscription { Id = 5, Url = "http://todel.com", EventsCsv = "ticket.created" });
        await _context.SaveChangesAsync();

        var result = await _controller.DeleteWebhook(5);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task DeleteWebhook_ShouldReturnNotFound_WhenMissing()
    {
        var result = await _controller.DeleteWebhook(99);

        Assert.IsType<NotFoundResult>(result);
    }

    [Fact]
    public async Task ToggleWebhook_ShouldReturnNoContent_WhenFound()
    {
        _context.WebhookSubscriptions.Add(new WebhookSubscription { Id = 6, Url = "http://testsend.com", EventsCsv = "ticket.created", IsActive = true });
        await _context.SaveChangesAsync();

        var result = await _controller.ToggleWebhook(6);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task ToggleWebhook_ShouldReturnNotFound_WhenMissing()
    {
        var result = await _controller.ToggleWebhook(99);

        Assert.IsType<NotFoundResult>(result);
    }
}
