using ItsTool.Application.DTOs;
using ItsTool.Domain.Entities.Organization;
using ItsTool.Infrastructure.Data;
using ItsTool.Infrastructure.Services;
using Microsoft.EntityFrameworkCore;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class DepartmentServiceTests : TestBase
{
    private readonly Repository<Department> _repository;
    private readonly DepartmentService _service;

    public DepartmentServiceTests() : base()
    {
        _repository = new Repository<Department>(_context);
        _service = new DepartmentService(_repository);
    }

    [Fact]
    public async Task CreateAsync_ShouldCreateDepartment()
    {
        // Arrange
        var dto = new CreateDepartmentDto("IT", "IT Dept", "#000000");

        // Act
        var result = await _service.CreateAsync(dto);

        // Assert
        Assert.NotNull(result);
        Assert.Equal("IT", result.Name);
        var dbDept = await _context.Departments.FirstOrDefaultAsync(d => d.Id == result.Id);
        Assert.NotNull(dbDept);
    }

    [Fact]
    public async Task GetByIdAsync_ShouldReturnDepartment()
    {
        // Arrange
        var dept = new Department { Name = "HR" };
        _context.Departments.Add(dept);
        await _context.SaveChangesAsync();

        // Act
        var result = await _service.GetByIdAsync(dept.Id);

        // Assert
        Assert.NotNull(result);
        Assert.Equal("HR", result.Name);
    }

}
