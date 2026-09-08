using System.Collections.Generic;
using System.Threading.Tasks;
using ItsTool.API.Controllers;
using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using Microsoft.AspNetCore.Mvc;
using Moq;
using Xunit;

namespace ItsTool.UnitTests.Controllers;

public class ProjectsControllerTests
{
    private readonly Mock<IProjectService> _serviceMock;
    private readonly ProjectsController _controller;

    public ProjectsControllerTests()
    {
        _serviceMock = new Mock<IProjectService>();
        _controller = new ProjectsController(_serviceMock.Object);
    }

    [Fact]
    public async Task GetAll_ShouldReturnAllProjects()
    {
        var list = new List<ProjectDto> { new(1, "ITSM", "PRJ-1", "ITSM Core", "Active") };
        _serviceMock.Setup(s => s.GetAllAsync()).ReturnsAsync(list);

        var result = await _controller.GetAll();

        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(list, okResult.Value);
    }

    [Fact]
    public async Task GetById_ShouldReturnOk_WhenFound()
    {
        var prj = new ProjectDto(1, "ITSM", "PRJ-1", "ITSM Core", "Active");
        _serviceMock.Setup(s => s.GetByIdAsync(1)).ReturnsAsync(prj);

        var result = await _controller.GetById(1);

        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(prj, okResult.Value);
    }

    [Fact]
    public async Task GetById_ShouldReturnNotFound_WhenMissing()
    {
        _serviceMock.Setup(s => s.GetByIdAsync(99)).ReturnsAsync((ProjectDto?)null);

        var result = await _controller.GetById(99);

        Assert.IsType<NotFoundResult>(result);
    }

    [Fact]
    public async Task Create_ShouldReturnCreatedAtAction()
    {
        var createDto = new CreateProjectDto("Billing", "BILL", "Billing System");
        var created = new ProjectDto(2, "Billing", "BILL", "Billing System", "Active");
        _serviceMock.Setup(s => s.CreateAsync(createDto)).ReturnsAsync(created);

        var result = await _controller.Create(createDto);

        var createdResult = Assert.IsType<CreatedAtActionResult>(result);
        Assert.Equal(created, createdResult.Value);
    }

    [Fact]
    public async Task Update_ShouldReturnNoContent_WhenSuccessful()
    {
        var updateDto = new UpdateProjectDto("Billing Updated", "BILL", "Updated", "Active");
        _serviceMock.Setup(s => s.UpdateAsync(1, updateDto)).Returns(Task.CompletedTask);

        var result = await _controller.Update(1, updateDto);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task Update_ShouldReturnNotFound_WhenNotFound()
    {
        var updateDto = new UpdateProjectDto("Billing Updated", "BILL", "Updated", "Active");
        _serviceMock.Setup(s => s.UpdateAsync(99, updateDto)).ThrowsAsync(new KeyNotFoundException());

        var result = await _controller.Update(99, updateDto);

        Assert.IsType<NotFoundResult>(result);
    }

    [Fact]
    public async Task Delete_ShouldReturnNoContent()
    {
        _serviceMock.Setup(s => s.DeleteAsync(1)).Returns(Task.CompletedTask);

        var result = await _controller.Delete(1);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task AddMember_ShouldReturnNoContent()
    {
        _serviceMock.Setup(s => s.AddMemberAsync(1, 10)).Returns(Task.CompletedTask);

        var result = await _controller.AddMember(1, 10);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task RemoveMember_ShouldReturnNoContent()
    {
        _serviceMock.Setup(s => s.RemoveMemberAsync(1, 10)).Returns(Task.CompletedTask);

        var result = await _controller.RemoveMember(1, 10);

        Assert.IsType<NoContentResult>(result);
    }
}
