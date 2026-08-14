using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.Organization;

namespace ItsTool.Infrastructure.Services;

public class DepartmentService : IDepartmentService
{
    private readonly IRepository<Department> _repository;

    public DepartmentService(IRepository<Department> repository)
    {
        _repository = repository;
    }

    public async Task<IEnumerable<DepartmentDto>> GetAllAsync()
    {
        var depts = await _repository.GetAllAsync();
        return depts.Select(d => new DepartmentDto(d.Id, d.Name, d.Description, d.IsActive));
    }

    public async Task<DepartmentDto?> GetByIdAsync(int id)
    {
        var dept = await _repository.GetByIdAsync(id);
        if (dept == null) return null;
        return new DepartmentDto(dept.Id, dept.Name, dept.Description, dept.IsActive);
    }

    public async Task<DepartmentDto> CreateAsync(CreateDepartmentDto dto)
    {
        var dept = new Department
        {
            Name = dto.Name,
            Description = dto.Description
        };
        await _repository.AddAsync(dept);
        return new DepartmentDto(dept.Id, dept.Name, dept.Description, dept.IsActive);
    }

    public async Task UpdateAsync(int id, UpdateDepartmentDto dto)
    {
        var dept = await _repository.GetByIdAsync(id);
        if (dept == null) throw new KeyNotFoundException("Department not found");
        
        dept.Name = dto.Name;
        dept.Description = dto.Description;
        dept.IsActive = dto.IsActive;
        await _repository.UpdateAsync(dept);
    }

    public async Task DeleteAsync(int id)
    {
        await _repository.DeleteAsync(id);
    }
}
