using ItsTool.Application.DTOs;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Infrastructure.Data;
using ItsTool.Infrastructure.Services;
using Microsoft.EntityFrameworkCore;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class CatalogServiceTests : TestBase
{
    private readonly Repository<Category> _categoryRepo;
    private readonly Repository<TicketType> _ticketTypeRepo;
    private readonly Repository<Status> _statusRepo;
    private readonly Repository<Priority> _priorityRepo;
    private readonly CatalogService _service;

    public CatalogServiceTests() : base()
    {
        _categoryRepo = new Repository<Category>(_context);
        _ticketTypeRepo = new Repository<TicketType>(_context);
        _statusRepo = new Repository<Status>(_context);
        _priorityRepo = new Repository<Priority>(_context);
        _service = new CatalogService(_categoryRepo, _ticketTypeRepo, _statusRepo, _priorityRepo, _context);
    }

    [Fact]
    public async Task CreateCategoryAsync_ShouldCreateCategory()
    {
        var dto = new CreateCategoryDto("Network", 1, null, "Desc", null);
        var result = await _service.CreateCategoryAsync(dto);

        Assert.NotNull(result);
        Assert.Equal("Network", result.Name);
    }

    [Fact]
    public async Task GetCategoriesAsync_ShouldFilterByProject()
    {
        _context.Categories.Add(new Category { Name = "Cat1", ProjectId = 1 });
        _context.Categories.Add(new Category { Name = "Cat2", ProjectId = 2 });
        await _context.SaveChangesAsync();

        var list = await _service.GetCategoriesAsync(1);
        Assert.Single(list);
        Assert.Equal("Cat1", list.First().Name);
    }

    [Fact]
    public async Task DeleteStatusAsync_ShouldThrowIfInUse()
    {
        var s = new Status { Name = "S1" };
        _context.Statuses.Add(s);
        await _context.SaveChangesAsync();

        var wt = new ItsTool.Domain.Entities.Workflow.WorkflowTransition { WorkflowId = 1, FromStatusId = s.Id, ToStatusId = 2, TransitionName = "t" };
        _context.WorkflowTransitions.Add(wt);
        await _context.SaveChangesAsync();

        await Assert.ThrowsAsync<InvalidOperationException>(() => _service.DeleteStatusAsync(s.Id));
    }
}
