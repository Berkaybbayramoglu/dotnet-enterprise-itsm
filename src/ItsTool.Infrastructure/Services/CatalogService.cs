using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace ItsTool.Infrastructure.Services;

public class CatalogService : ICatalogService
{
    private readonly IRepository<Category> _categoryRepo;
    private readonly IRepository<TicketType> _ticketTypeRepo;
    private readonly IRepository<Status> _statusRepo;
    private readonly IRepository<Priority> _priorityRepo;
    private readonly ItsToolDbContext _context;

    public CatalogService(
        IRepository<Category> categoryRepo,
        IRepository<TicketType> ticketTypeRepo,
        IRepository<Status> statusRepo,
        IRepository<Priority> priorityRepo,
        ItsToolDbContext context)
    {
        _categoryRepo = categoryRepo;
        _ticketTypeRepo = ticketTypeRepo;
        _statusRepo = statusRepo;
        _priorityRepo = priorityRepo;
        _context = context;
    }

    // Category
    public async Task<IEnumerable<CategoryDto>> GetCategoriesAsync(int? projectId = null)
    {
        var list = await _categoryRepo.GetAllAsync(c => projectId == null || c.ProjectId == projectId);
        return list.Select(c => new CategoryDto(c.Id, c.Name, c.ProjectId, c.ParentCategoryId, c.Description, c.DefaultAssigneeGroupId, c.IsActive));
    }

    public async Task<CategoryDto?> GetCategoryByIdAsync(int id)
    {
        var c = await _categoryRepo.GetByIdAsync(id);
        if (c == null) return null;
        return new CategoryDto(c.Id, c.Name, c.ProjectId, c.ParentCategoryId, c.Description, c.DefaultAssigneeGroupId, c.IsActive);
    }

    public async Task<CategoryDto> CreateCategoryAsync(CreateCategoryDto dto)
    {
        var c = new Category { Name = dto.Name, ProjectId = dto.ProjectId, ParentCategoryId = dto.ParentCategoryId, Description = dto.Description, DefaultAssigneeGroupId = dto.DefaultAssigneeGroupId };
        await _categoryRepo.AddAsync(c);
        return new CategoryDto(c.Id, c.Name, c.ProjectId, c.ParentCategoryId, c.Description, c.DefaultAssigneeGroupId, c.IsActive);
    }

    public async Task UpdateCategoryAsync(int id, UpdateCategoryDto dto)
    {
        var c = await _categoryRepo.GetByIdAsync(id);
        if (c == null) throw new KeyNotFoundException("Category not found");
        c.Name = dto.Name; c.ProjectId = dto.ProjectId; c.ParentCategoryId = dto.ParentCategoryId; c.Description = dto.Description; c.DefaultAssigneeGroupId = dto.DefaultAssigneeGroupId; c.IsActive = dto.IsActive;
        await _categoryRepo.UpdateAsync(c);
    }

    public async Task DeleteCategoryAsync(int id) => await _categoryRepo.DeleteAsync(id);

    // TicketType
    public async Task<IEnumerable<TicketTypeDto>> GetTicketTypesAsync()
    {
        var list = await _ticketTypeRepo.GetAllAsync();
        return list.Select(t => new TicketTypeDto(t.Id, t.Name, t.IsActive));
    }

    public async Task<TicketTypeDto?> GetTicketTypeByIdAsync(int id)
    {
        var t = await _ticketTypeRepo.GetByIdAsync(id);
        if (t == null) return null;
        return new TicketTypeDto(t.Id, t.Name, t.IsActive);
    }

    public async Task<TicketTypeDto> CreateTicketTypeAsync(CreateTicketTypeDto dto)
    {
        var t = new TicketType { Name = dto.Name };
        await _ticketTypeRepo.AddAsync(t);
        return new TicketTypeDto(t.Id, t.Name, t.IsActive);
    }

    public async Task UpdateTicketTypeAsync(int id, UpdateTicketTypeDto dto)
    {
        var t = await _ticketTypeRepo.GetByIdAsync(id);
        if (t == null) throw new KeyNotFoundException("TicketType not found");
        t.Name = dto.Name; t.IsActive = dto.IsActive;
        await _ticketTypeRepo.UpdateAsync(t);
    }

    public async Task DeleteTicketTypeAsync(int id) => await _ticketTypeRepo.DeleteAsync(id);

    // Status
    public async Task<IEnumerable<StatusDto>> GetStatusesAsync()
    {
        var list = await _statusRepo.GetAllAsync();
        return list.Select(s => new StatusDto(s.Id, s.Name, s.ColorHex, s.SortOrder, s.IsClosedStatus, s.IsSystemDefault, s.IsActive));
    }

    public async Task<StatusDto?> GetStatusByIdAsync(int id)
    {
        var s = await _statusRepo.GetByIdAsync(id);
        if (s == null) return null;
        return new StatusDto(s.Id, s.Name, s.ColorHex, s.SortOrder, s.IsClosedStatus, s.IsSystemDefault, s.IsActive);
    }

    public async Task<StatusDto> CreateStatusAsync(CreateStatusDto dto)
    {
        var s = new Status { Name = dto.Name, ColorHex = dto.ColorHex, SortOrder = dto.SortOrder, IsClosedStatus = dto.IsClosedStatus, IsSystemDefault = dto.IsSystemDefault };
        await _statusRepo.AddAsync(s);
        return new StatusDto(s.Id, s.Name, s.ColorHex, s.SortOrder, s.IsClosedStatus, s.IsSystemDefault, s.IsActive);
    }

    public async Task UpdateStatusAsync(int id, UpdateStatusDto dto)
    {
        var s = await _statusRepo.GetByIdAsync(id);
        if (s == null) throw new KeyNotFoundException("Status not found");
        s.Name = dto.Name; s.ColorHex = dto.ColorHex; s.SortOrder = dto.SortOrder; s.IsClosedStatus = dto.IsClosedStatus; s.IsSystemDefault = dto.IsSystemDefault; s.IsActive = dto.IsActive;
        await _statusRepo.UpdateAsync(s);
    }

    public async Task DeleteStatusAsync(int id)
    {
        var inUse = await _context.WorkflowTransitions.AnyAsync(wt => !wt.IsDeleted && (wt.FromStatusId == id || wt.ToStatusId == id));
        if (inUse)
        {
            // Business rule: Status in use by active transition cannot be deleted physically or safely without cascade, we just soft delete it which is default.
            // Wait, actually business rule says: aktif transition'da kullanılan Status silinemez.
            // We should throw an exception.
            throw new InvalidOperationException("Status is currently in use by an active workflow transition and cannot be deleted.");
        }
        await _statusRepo.DeleteAsync(id);
    }

    // Priority
    public async Task<IEnumerable<PriorityDto>> GetPrioritiesAsync()
    {
        var list = await _priorityRepo.GetAllAsync();
        return list.Select(p => new PriorityDto(p.Id, p.Name, p.ColorHex, p.Weight, p.SeverityLevel, p.IsActive));
    }

    public async Task<PriorityDto?> GetPriorityByIdAsync(int id)
    {
        var p = await _priorityRepo.GetByIdAsync(id);
        if (p == null) return null;
        return new PriorityDto(p.Id, p.Name, p.ColorHex, p.Weight, p.SeverityLevel, p.IsActive);
    }

    public async Task<PriorityDto> CreatePriorityAsync(CreatePriorityDto dto)
    {
        var p = new Priority { Name = dto.Name, ColorHex = dto.ColorHex, Weight = dto.Weight, SeverityLevel = dto.SeverityLevel };
        await _priorityRepo.AddAsync(p);
        return new PriorityDto(p.Id, p.Name, p.ColorHex, p.Weight, p.SeverityLevel, p.IsActive);
    }

    public async Task UpdatePriorityAsync(int id, UpdatePriorityDto dto)
    {
        var p = await _priorityRepo.GetByIdAsync(id);
        if (p == null) throw new KeyNotFoundException("Priority not found");
        p.Name = dto.Name; p.ColorHex = dto.ColorHex; p.Weight = dto.Weight; p.SeverityLevel = dto.SeverityLevel; p.IsActive = dto.IsActive;
        await _priorityRepo.UpdateAsync(p);
    }

    public async Task DeletePriorityAsync(int id) => await _priorityRepo.DeleteAsync(id);
}
