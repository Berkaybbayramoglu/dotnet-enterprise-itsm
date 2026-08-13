using ItsTool.Application.DTOs;
using ItsTool.Domain.Entities.Config;
using ItsTool.Infrastructure.Data;
using ItsTool.Infrastructure.Services;
using Microsoft.EntityFrameworkCore;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class DynamicFormServiceTests : TestBase
{
    private readonly Repository<FieldDefinition> _defRepo;
    private readonly Repository<FieldOption> _optRepo;
    private readonly Repository<FormFieldPlacement> _placementRepo;
    private readonly DynamicFormService _service;

    public DynamicFormServiceTests() : base()
    {
        _defRepo = new Repository<FieldDefinition>(_context);
        _optRepo = new Repository<FieldOption>(_context);
        _placementRepo = new Repository<FormFieldPlacement>(_context);
        _service = new DynamicFormService(_defRepo, _optRepo, _placementRepo, _context);
    }

    [Fact]
    public async Task CreateFieldDefinitionAsync_ShouldThrowIfKeyNotUnique()
    {
        var f = new FieldDefinition { Key = "test.key", Label = "A", FieldType = FieldType.Text };
        _context.FieldDefinitions.Add(f);
        await _context.SaveChangesAsync();

        var dto = new CreateFieldDefinitionDto("test.key", "B", "Text", null);
        await Assert.ThrowsAsync<InvalidOperationException>(() => _service.CreateFieldDefinitionAsync(dto));
    }

    [Fact]
    public async Task CreatePlacementAsync_ShouldThrowIfDuplicateScope()
    {
        var p = new FormFieldPlacement { FieldDefinitionId = 1, ProjectId = 1 };
        _context.FormFieldPlacements.Add(p);
        await _context.SaveChangesAsync();

        var dto = new CreateFormFieldPlacementDto(1, 1, null, null, 1, true);
        await Assert.ThrowsAsync<InvalidOperationException>(() => _service.CreatePlacementAsync(dto));
    }

    [Fact]
    public async Task CreateFieldDefinitionAsync_ShouldCreate()
    {
        var dto = new CreateFieldDefinitionDto("uniq.key", "N", "Text", null);
        var res = await _service.CreateFieldDefinitionAsync(dto);
        Assert.Equal("uniq.key", res.Key);
    }
}
