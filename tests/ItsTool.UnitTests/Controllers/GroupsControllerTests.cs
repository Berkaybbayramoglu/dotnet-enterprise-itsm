using System.Collections.Generic;
using System.Threading.Tasks;
using ItsTool.API.Controllers;
using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using Microsoft.AspNetCore.Mvc;
using Moq;
using Xunit;

namespace ItsTool.UnitTests.Controllers;

public class GroupsControllerTests
{
    private readonly Mock<IGroupService> _serviceMock;
    private readonly GroupsController _controller;

    public GroupsControllerTests()
    {
        _serviceMock = new Mock<IGroupService>();
        _controller = new GroupsController(_serviceMock.Object);
    }

    [Fact]
    public async Task GetAll_ShouldReturnAllGroups()
    {
        var list = new List<GroupDto> { new(1, "Support L1", true, 1) };
        _serviceMock.Setup(s => s.GetAllAsync()).ReturnsAsync(list);

        var result = await _controller.GetAll();

        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(list, okResult.Value);
    }

    [Fact]
    public async Task GetById_ShouldReturnOk_WhenFound()
    {
        var grp = new GroupDto(1, "Support L1", true, 1);
        _serviceMock.Setup(s => s.GetByIdAsync(1)).ReturnsAsync(grp);

        var result = await _controller.GetById(1);

        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(grp, okResult.Value);
    }

    [Fact]
    public async Task GetById_ShouldReturnNotFound_WhenMissing()
    {
        _serviceMock.Setup(s => s.GetByIdAsync(99)).ReturnsAsync((GroupDto?)null);

        var result = await _controller.GetById(99);

        Assert.IsType<NotFoundResult>(result);
    }

    [Fact]
    public async Task Create_ShouldReturnCreatedAtAction()
    {
        var createDto = new CreateGroupDto("Support L2", 1);
        var created = new GroupDto(2, "Support L2", true, 1);
        _serviceMock.Setup(s => s.CreateAsync(createDto)).ReturnsAsync(created);

        var result = await _controller.Create(createDto);

        var createdResult = Assert.IsType<CreatedAtActionResult>(result);
        Assert.Equal(created, createdResult.Value);
    }

    [Fact]
    public async Task Update_ShouldReturnNoContent_WhenSuccessful()
    {
        var updateDto = new UpdateGroupDto("Support L1 Updated", true, 1);
        _serviceMock.Setup(s => s.UpdateAsync(1, updateDto)).Returns(Task.CompletedTask);

        var result = await _controller.Update(1, updateDto);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task Update_ShouldReturnNotFound_WhenNotFound()
    {
        var updateDto = new UpdateGroupDto("Support L1 Updated", true, 1);
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
        _serviceMock.Setup(s => s.AddMemberAsync(1, 5)).Returns(Task.CompletedTask);

        var result = await _controller.AddMember(1, 5);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task RemoveMember_ShouldReturnNoContent()
    {
        _serviceMock.Setup(s => s.RemoveMemberAsync(1, 5)).Returns(Task.CompletedTask);

        var result = await _controller.RemoveMember(1, 5);

        Assert.IsType<NoContentResult>(result);
    }
}
