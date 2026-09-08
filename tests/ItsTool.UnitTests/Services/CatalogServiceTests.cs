using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ItsTool.Application.DTOs;
using ItsTool.Domain.Entities.Project;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Infrastructure.Data;
using ItsTool.Infrastructure.Services;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class CatalogServiceTests : TestBase
{
    private readonly CatalogService _catalogService;

    public CatalogServiceTests() : base()
    {
        var catRepo = new Repository<Category>(_context);
        var typeRepo = new Repository<TicketType>(_context);
        var statusRepo = new Repository<Status>(_context);
        var prioRepo = new Repository<Priority>(_context);

        _catalogService = new CatalogService(catRepo, typeRepo, statusRepo, prioRepo, _context);
        SeedData();
    }

    private void SeedData()
    {
        _context.Projects.Add(new Project { Id = 1, Name = "Platform", ProjectKey = "PLT", IsActive = true });
        _context.SaveChanges();
    }

    [Fact]
    public async Task Categories_CrudOperations_WorkCorrectly()
    {
        var createDto = new CreateCategoryDto("Hardware", 1, null, "Hardware issues", null);
        var created = await _catalogService.CreateCategoryAsync(createDto);
        Assert.NotNull(created);
        Assert.Equal("Hardware", created.Name);

        var byId = await _catalogService.GetCategoryByIdAsync(created.Id);
        Assert.NotNull(byId);
        Assert.Equal("Hardware", byId.Name);

        var updateDto = new UpdateCategoryDto("Hardware & Peripherals", 1, null, "Updated description", null, true);
        await _catalogService.UpdateCategoryAsync(created.Id, updateDto);

        var updated = await _catalogService.GetCategoryByIdAsync(created.Id);
        Assert.Equal("Hardware & Peripherals", updated!.Name);

        await _catalogService.DeleteCategoryAsync(created.Id);
        var deleted = await _context.Categories.FindAsync(created.Id);
        Assert.True(deleted!.IsDeleted);
    }

    [Fact]
    public async Task TicketTypes_CrudOperations_WorkCorrectly()
    {
        var createDto = new CreateTicketTypeDto("Service Request");
        var created = await _catalogService.CreateTicketTypeAsync(createDto);
        Assert.NotNull(created);
        Assert.Equal("Service Request", created.Name);

        var list = (await _catalogService.GetTicketTypesAsync()).ToList();
        Assert.Single(list);

        var updateDto = new UpdateTicketTypeDto("Service Request Updated", true);
        await _catalogService.UpdateTicketTypeAsync(created.Id, updateDto);

        var updated = await _catalogService.GetTicketTypeByIdAsync(created.Id);
        Assert.Equal("Service Request Updated", updated!.Name);

        await _catalogService.DeleteTicketTypeAsync(created.Id);
        var deleted = await _context.TicketTypes.FindAsync(created.Id);
        Assert.True(deleted!.IsDeleted);
    }

    [Fact]
    public async Task Statuses_CrudOperations_WorkCorrectly()
    {
        var createDto = new CreateStatusDto("Pending Vendor", "#FFAA00", 3, false, false);
        var created = await _catalogService.CreateStatusAsync(createDto);
        Assert.NotNull(created);
        Assert.Equal("Pending Vendor", created.Name);

        var updateDto = new UpdateStatusDto("Pending Supplier", "#FF8800", 4, false, false, true);
        await _catalogService.UpdateStatusAsync(created.Id, updateDto);

        var updated = await _catalogService.GetStatusByIdAsync(created.Id);
        Assert.Equal("Pending Supplier", updated!.Name);

        await _catalogService.DeleteStatusAsync(created.Id);
        var deleted = await _context.Statuses.FindAsync(created.Id);
        Assert.True(deleted!.IsDeleted);
    }

    [Fact]
    public async Task Priorities_CrudOperations_WorkCorrectly()
    {
        var createDto = new CreatePriorityDto("Urgent", "#FF0000", 1, 1);
        var created = await _catalogService.CreatePriorityAsync(createDto);
        Assert.NotNull(created);
        Assert.Equal("Urgent", created.Name);

        var updateDto = new UpdatePriorityDto("Urgent P1", "#CC0000", 1, 1, true);
        await _catalogService.UpdatePriorityAsync(created.Id, updateDto);

        var updated = await _catalogService.GetPriorityByIdAsync(created.Id);
        Assert.Equal("Urgent P1", updated!.Name);

        await _catalogService.DeletePriorityAsync(created.Id);
        var deleted = await _context.Priorities.FindAsync(created.Id);
        Assert.True(deleted!.IsDeleted);
    }
}
