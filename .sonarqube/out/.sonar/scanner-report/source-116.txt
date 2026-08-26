using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.Config;
using ItsTool.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace ItsTool.Infrastructure.Services;

public class DynamicFormService : IDynamicFormService
{
    private readonly IRepository<FieldDefinition> _defRepo;
    private readonly IRepository<FieldOption> _optRepo;
    private readonly IRepository<FormFieldPlacement> _placementRepo;
    private readonly ItsToolDbContext _context;

    public DynamicFormService(
        IRepository<FieldDefinition> defRepo,
        IRepository<FieldOption> optRepo,
        IRepository<FormFieldPlacement> placementRepo,
        ItsToolDbContext context)
    {
        _defRepo = defRepo;
        _optRepo = optRepo;
        _placementRepo = placementRepo;
        _context = context;
    }

    public async Task<IEnumerable<FieldDefinitionDto>> GetFieldDefinitionsAsync()
    {
        var list = await _defRepo.GetAllAsync();
        return list.Select(f => new FieldDefinitionDto(f.Id, f.Key, f.Label, f.FieldType.ToString(), f.ValidationRegex, f.IsActive));
    }

    public async Task<FieldDefinitionDto?> GetFieldDefinitionByIdAsync(int id)
    {
        var f = await _defRepo.GetByIdAsync(id);
        if (f == null) return null;
        return new FieldDefinitionDto(f.Id, f.Key, f.Label, f.FieldType.ToString(), f.ValidationRegex, f.IsActive);
    }

    public async Task<FieldDefinitionDto> CreateFieldDefinitionAsync(CreateFieldDefinitionDto dto)
    {
        var exists = await _context.FieldDefinitions.AnyAsync(f => f.Key == dto.Key && !f.IsDeleted);
        if (exists) throw new InvalidOperationException("Field Definition Key must be unique.");

        if (!Enum.TryParse<FieldType>(dto.FieldType, true, out var fType)) throw new ArgumentException("Invalid FieldType");

        var f = new FieldDefinition { Key = dto.Key, Label = dto.Label, FieldType = fType, ValidationRegex = dto.ValidationRegex };
        await _defRepo.AddAsync(f);
        return new FieldDefinitionDto(f.Id, f.Key, f.Label, f.FieldType.ToString(), f.ValidationRegex, f.IsActive);
    }

    public async Task UpdateFieldDefinitionAsync(int id, UpdateFieldDefinitionDto dto)
    {
        var f = await _defRepo.GetByIdAsync(id);
        if (f == null) throw new KeyNotFoundException("FieldDefinition not found");

        var exists = await _context.FieldDefinitions.AnyAsync(fd => fd.Key == dto.Key && fd.Id != id && !fd.IsDeleted);
        if (exists) throw new InvalidOperationException("Field Definition Key must be unique.");

        if (!Enum.TryParse<FieldType>(dto.FieldType, true, out var fType)) throw new ArgumentException("Invalid FieldType");

        f.Key = dto.Key; f.Label = dto.Label; f.FieldType = fType; f.ValidationRegex = dto.ValidationRegex; f.IsActive = dto.IsActive;
        await _defRepo.UpdateAsync(f);
    }

    public async Task DeleteFieldDefinitionAsync(int id) => await _defRepo.DeleteAsync(id);

    public async Task<IEnumerable<FieldOptionDto>> GetFieldOptionsAsync(int fieldDefinitionId)
    {
        var list = await _optRepo.GetAllAsync(o => o.FieldDefinitionId == fieldDefinitionId);
        return list.Select(o => new FieldOptionDto(o.Id, o.FieldDefinitionId, o.Value, o.Label, o.SortOrder, o.IsActive));
    }

    public async Task<FieldOptionDto?> GetFieldOptionByIdAsync(int id)
    {
        var o = await _optRepo.GetByIdAsync(id);
        if (o == null) return null;
        return new FieldOptionDto(o.Id, o.FieldDefinitionId, o.Value, o.Label, o.SortOrder, o.IsActive);
    }

    public async Task<FieldOptionDto> CreateFieldOptionAsync(CreateFieldOptionDto dto)
    {
        var o = new FieldOption { FieldDefinitionId = dto.FieldDefinitionId, Value = dto.Value, Label = dto.Label, SortOrder = dto.SortOrder };
        await _optRepo.AddAsync(o);
        return new FieldOptionDto(o.Id, o.FieldDefinitionId, o.Value, o.Label, o.SortOrder, o.IsActive);
    }

    public async Task UpdateFieldOptionAsync(int id, UpdateFieldOptionDto dto)
    {
        var o = await _optRepo.GetByIdAsync(id);
        if (o == null) throw new KeyNotFoundException("FieldOption not found");
        o.Value = dto.Value; o.Label = dto.Label; o.SortOrder = dto.SortOrder; o.IsActive = dto.IsActive;
        await _optRepo.UpdateAsync(o);
    }

    public async Task DeleteFieldOptionAsync(int id) => await _optRepo.DeleteAsync(id);

    public async Task<IEnumerable<FormFieldPlacementDto>> GetPlacementsAsync(int? projectId, int? categoryId, int? ticketTypeId)
    {
        var list = await _placementRepo.GetAllAsync(p => 
            p.ProjectId == projectId && p.CategoryId == categoryId && p.TicketTypeId == ticketTypeId);
        return list.Select(p => new FormFieldPlacementDto(p.Id, p.FieldDefinitionId, p.ProjectId, p.CategoryId, p.TicketTypeId, p.SortOrder, p.IsRequired, p.IsActive));
    }

    public async Task<FormFieldPlacementDto?> GetPlacementByIdAsync(int id)
    {
        var p = await _placementRepo.GetByIdAsync(id);
        if (p == null) return null;
        return new FormFieldPlacementDto(p.Id, p.FieldDefinitionId, p.ProjectId, p.CategoryId, p.TicketTypeId, p.SortOrder, p.IsRequired, p.IsActive);
    }

    public async Task<FormFieldPlacementDto> CreatePlacementAsync(CreateFormFieldPlacementDto dto)
    {
        var exists = await _context.FormFieldPlacements.AnyAsync(p => 
            p.FieldDefinitionId == dto.FieldDefinitionId && 
            p.ProjectId == dto.ProjectId && 
            p.CategoryId == dto.CategoryId && 
            p.TicketTypeId == dto.TicketTypeId && 
            !p.IsDeleted);

        if (exists) throw new InvalidOperationException("This field is already placed in this scope.");

        var p = new FormFieldPlacement { FieldDefinitionId = dto.FieldDefinitionId, ProjectId = dto.ProjectId, CategoryId = dto.CategoryId, TicketTypeId = dto.TicketTypeId, SortOrder = dto.SortOrder, IsRequired = dto.IsRequired };
        await _placementRepo.AddAsync(p);
        return new FormFieldPlacementDto(p.Id, p.FieldDefinitionId, p.ProjectId, p.CategoryId, p.TicketTypeId, p.SortOrder, p.IsRequired, p.IsActive);
    }

    public async Task UpdatePlacementAsync(int id, UpdateFormFieldPlacementDto dto)
    {
        var p = await _placementRepo.GetByIdAsync(id);
        if (p == null) throw new KeyNotFoundException("FormFieldPlacement not found");

        var exists = await _context.FormFieldPlacements.AnyAsync(fp => 
            fp.Id != id &&
            fp.FieldDefinitionId == p.FieldDefinitionId && 
            fp.ProjectId == dto.ProjectId && 
            fp.CategoryId == dto.CategoryId && 
            fp.TicketTypeId == dto.TicketTypeId && 
            !fp.IsDeleted);

        if (exists) throw new InvalidOperationException("This field is already placed in this scope.");

        p.ProjectId = dto.ProjectId; p.CategoryId = dto.CategoryId; p.TicketTypeId = dto.TicketTypeId; p.SortOrder = dto.SortOrder; p.IsRequired = dto.IsRequired; p.IsActive = dto.IsActive;
        await _placementRepo.UpdateAsync(p);
    }

    public async Task DeletePlacementAsync(int id) => await _placementRepo.DeleteAsync(id);
}
