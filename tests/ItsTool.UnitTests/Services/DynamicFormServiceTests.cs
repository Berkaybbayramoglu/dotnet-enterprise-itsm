using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ItsTool.Application.DTOs;
using ItsTool.Domain.Entities.Config;
using ItsTool.Infrastructure.Data;
using ItsTool.Infrastructure.Services;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class DynamicFormServiceTests : TestBase
{
    private readonly DynamicFormService _formService;

    public DynamicFormServiceTests() : base()
    {
        var defRepo = new Repository<FieldDefinition>(_context);
        var optRepo = new Repository<FieldOption>(_context);
        var placeRepo = new Repository<FormFieldPlacement>(_context);
        _formService = new DynamicFormService(defRepo, optRepo, placeRepo, _context);
    }

    [Fact]
    public async Task FieldDefinitions_Crud_WorksCorrectly()
    {
        var createDto = new CreateFieldDefinitionDto("serial_no", "Serial Number", "Text", "^[A-Z0-9]+$");
        var created = await _formService.CreateFieldDefinitionAsync(createDto);

        Assert.NotNull(created);
        Assert.Equal("serial_no", created.Key);

        var byId = await _formService.GetFieldDefinitionByIdAsync(created.Id);
        Assert.NotNull(byId);
        Assert.Equal("Serial Number", byId.Label);

        var updateDto = new UpdateFieldDefinitionDto("serial_no", "Device Serial Number", "Text", "^[A-Z0-9]+$", true);
        await _formService.UpdateFieldDefinitionAsync(created.Id, updateDto);

        var updated = await _formService.GetFieldDefinitionByIdAsync(created.Id);
        Assert.Equal("Device Serial Number", updated!.Label);

        await _formService.DeleteFieldDefinitionAsync(created.Id);
        var deleted = await _context.FieldDefinitions.FindAsync(created.Id);
        Assert.True(deleted!.IsDeleted);
    }

    [Fact]
    public async Task FieldOptions_Crud_WorksCorrectly()
    {
        var def = new FieldDefinition { Key = "env", Label = "Environment", FieldType = FieldType.Dropdown, IsActive = true };
        _context.FieldDefinitions.Add(def);
        await _context.SaveChangesAsync();

        var createDto = new CreateFieldOptionDto(def.Id, "prod", "Production", 1);
        var created = await _formService.CreateFieldOptionAsync(createDto);

        Assert.NotNull(created);
        Assert.Equal("prod", created.Value);

        var options = (await _formService.GetFieldOptionsAsync(def.Id)).ToList();
        Assert.Single(options);

        var updateDto = new UpdateFieldOptionDto("prod_live", "Production (Live)", 1, true);
        await _formService.UpdateFieldOptionAsync(created.Id, updateDto);

        var updated = await _context.FieldOptions.FindAsync(created.Id);
        Assert.Equal("prod_live", updated!.Value);

        await _formService.DeleteFieldOptionAsync(created.Id);
        var deleted = await _context.FieldOptions.FindAsync(created.Id);
        Assert.True(deleted!.IsDeleted);
    }

    [Fact]
    public async Task FormFieldPlacements_Crud_WorksCorrectly()
    {
        var def = new FieldDefinition { Key = "os", Label = "Operating System", FieldType = FieldType.Text, IsActive = true };
        _context.FieldDefinitions.Add(def);
        await _context.SaveChangesAsync();

        var createDto = new CreateFormFieldPlacementDto(def.Id, 1, null, null, 1, true);
        var created = await _formService.CreatePlacementAsync(createDto);

        Assert.NotNull(created);
        Assert.Equal(def.Id, created.FieldDefinitionId);

        var placements = (await _formService.GetPlacementsAsync(1, null, null)).ToList();
        Assert.Single(placements);

        var updateDto = new UpdateFormFieldPlacementDto(1, null, null, 2, false, true);
        await _formService.UpdatePlacementAsync(created.Id, updateDto);

        var updated = await _context.FormFieldPlacements.FindAsync(created.Id);
        Assert.False(updated!.IsRequired);

        await _formService.DeletePlacementAsync(created.Id);
        var deleted = await _context.FormFieldPlacements.FindAsync(created.Id);
        Assert.True(deleted!.IsDeleted);
    }
}
