using System.Collections.Generic;
using System.Threading.Tasks;
using ItsTool.API.Controllers;
using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using Microsoft.AspNetCore.Mvc;
using Moq;
using Xunit;

namespace ItsTool.UnitTests.Controllers;

public class DepartmentsControllerTests
{
    private readonly Mock<IDepartmentService> _serviceMock;
    private readonly DepartmentsController _controller;

    public DepartmentsControllerTests()
    {
        _serviceMock = new Mock<IDepartmentService>();
        _controller = new DepartmentsController(_serviceMock.Object);
    }

    [Fact]
    public async Task GetAll_ShouldReturnAllDepartments()
    {
        var list = new List<DepartmentDto> { new(1, "IT", "Information Tech", true, "#FF0000") };
        _serviceMock.Setup(s => s.GetAllAsync()).ReturnsAsync(list);

        var result = await _controller.GetAll();

        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(list, okResult.Value);
    }

    [Fact]
    public async Task GetById_ShouldReturnOk_WhenFound()
    {
        var dept = new DepartmentDto(1, "IT", "Information Tech", true, "#FF0000");
        _serviceMock.Setup(s => s.GetByIdAsync(1)).ReturnsAsync(dept);

        var result = await _controller.GetById(1);

        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(dept, okResult.Value);
    }

    [Fact]
    public async Task GetById_ShouldReturnNotFound_WhenMissing()
    {
        _serviceMock.Setup(s => s.GetByIdAsync(99)).ReturnsAsync((DepartmentDto?)null);

        var result = await _controller.GetById(99);

        Assert.IsType<NotFoundResult>(result);
    }

    [Fact]
    public async Task Create_ShouldReturnCreatedAtAction()
    {
        var createDto = new CreateDepartmentDto("HR", "Human Resources", "#00FF00");
        var created = new DepartmentDto(2, "HR", "Human Resources", true, "#00FF00");
        _serviceMock.Setup(s => s.CreateAsync(createDto)).ReturnsAsync(created);

        var result = await _controller.Create(createDto);

        var createdResult = Assert.IsType<CreatedAtActionResult>(result);
        Assert.Equal(created, createdResult.Value);
    }

    [Fact]
    public async Task Update_ShouldReturnNoContent_WhenSuccessful()
    {
        var updateDto = new UpdateDepartmentDto("IT Ops", "Updated", true, "#0000FF");
        _serviceMock.Setup(s => s.UpdateAsync(1, updateDto)).Returns(Task.CompletedTask);

        var result = await _controller.Update(1, updateDto);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task Update_ShouldReturnNotFound_WhenNotFound()
    {
        var updateDto = new UpdateDepartmentDto("IT Ops", "Updated", true, "#0000FF");
        _serviceMock.Setup(s => s.UpdateAsync(99, updateDto)).ThrowsAsync(new KeyNotFoundException());

        var result = await _controller.Update(99, updateDto);

        Assert.IsType<NotFoundResult>(result);
    }

    [Fact]
    public async Task Delete_ShouldReturnNoContent_WhenSuccessful()
    {
        _serviceMock.Setup(s => s.DeleteAsync(1)).Returns(Task.CompletedTask);

        var result = await _controller.Delete(1);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task Delete_ShouldReturnNotFound_WhenKeyNotFound()
    {
        _serviceMock.Setup(s => s.DeleteAsync(99)).ThrowsAsync(new KeyNotFoundException());

        var result = await _controller.Delete(99);

        Assert.IsType<NotFoundResult>(result);
    }
}
