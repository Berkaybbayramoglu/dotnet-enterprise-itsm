using System.Collections.Generic;
using System.Threading.Tasks;
using ItsTool.API.Controllers;
using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using Microsoft.AspNetCore.Mvc;
using Moq;
using Xunit;

namespace ItsTool.UnitTests.Controllers;

public class WorkflowControllerTests
{
    private readonly Mock<IWorkflowService> _serviceMock;
    private readonly WorkflowController _controller;

    public WorkflowControllerTests()
    {
        _serviceMock = new Mock<IWorkflowService>();
        _controller = new WorkflowController(_serviceMock.Object);
    }

    [Fact]
    public async Task GetWorkflows_ShouldReturnOk()
    {
        var list = new List<WorkflowDto>();
        _serviceMock.Setup(s => s.GetWorkflowsAsync(null)).ReturnsAsync(list);

        var result = await _controller.GetWorkflows(null);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(list, ok.Value);
    }

    [Fact]
    public async Task GetWorkflowById_ShouldReturnOk_WhenFound()
    {
        var wf = new WorkflowDto(1, "Approval", "Description", null, true);
        _serviceMock.Setup(s => s.GetWorkflowsAsync(null)).ReturnsAsync(new List<WorkflowDto> { wf });

        var result = await _controller.GetWorkflowById(1);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(wf, ok.Value);
    }

    [Fact]
    public async Task GetWorkflowById_ShouldReturnNotFound_WhenMissing()
    {
        _serviceMock.Setup(s => s.GetWorkflowsAsync(null)).ReturnsAsync(new List<WorkflowDto>());

        var result = await _controller.GetWorkflowById(99);

        Assert.IsType<NotFoundResult>(result);
    }

    [Fact]
    public async Task CreateWorkflow_ShouldReturnCreatedAtAction()
    {
        var dto = new CreateWorkflowDto("New", "Desc", null);
        var created = new WorkflowDto(2, "New", "Desc", null, true);
        _serviceMock.Setup(s => s.CreateWorkflowAsync(dto)).ReturnsAsync(created);

        var result = await _controller.CreateWorkflow(dto);

        var ok = Assert.IsType<CreatedAtActionResult>(result);
        Assert.Equal(created, ok.Value);
    }

    [Fact]
    public async Task UpdateWorkflow_ShouldReturnNoContent_WhenValid()
    {
        var dto = new UpdateWorkflowDto("New", "Desc", null, true);
        _serviceMock.Setup(s => s.UpdateWorkflowAsync(1, dto)).Returns(Task.CompletedTask);

        var result = await _controller.UpdateWorkflow(1, dto);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task UpdateWorkflow_ShouldReturnNotFound_WhenMissing()
    {
        var dto = new UpdateWorkflowDto("New", "Desc", null, true);
        _serviceMock.Setup(s => s.UpdateWorkflowAsync(99, dto)).ThrowsAsync(new KeyNotFoundException());

        var result = await _controller.UpdateWorkflow(99, dto);

        Assert.IsType<NotFoundResult>(result);
    }

    [Fact]
    public async Task DeleteWorkflow_ShouldReturnNoContent()
    {
        _serviceMock.Setup(s => s.DeleteWorkflowAsync(1)).Returns(Task.CompletedTask);

        var result = await _controller.DeleteWorkflow(1);

        Assert.IsType<NoContentResult>(result);
    }
}
