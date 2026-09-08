using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using ItsTool.API.Controllers;
using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using Microsoft.AspNetCore.Mvc;
using Moq;
using Xunit;

namespace ItsTool.UnitTests.Controllers;

public class SlaControllerTests
{
    private readonly Mock<ISlaService> _serviceMock;
    private readonly SlaController _controller;

    public SlaControllerTests()
    {
        _serviceMock = new Mock<ISlaService>();
        _controller = new SlaController(_serviceMock.Object);
    }

    [Fact]
    public async Task GetPolicies_ShouldReturnOk()
    {
        var policies = new List<SlaPolicyDetailDto> { new(1, "Global", null, null, null, true, false, new List<SlaTargetItemDto>()) };
        _serviceMock.Setup(s => s.GetPoliciesAsync(null)).ReturnsAsync(policies);

        var result = await _controller.GetPolicies(null);

        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(policies, okResult.Value);
    }

    [Fact]
    public async Task GetPolicyById_ShouldReturnOk_WhenFound()
    {
        var policy = new SlaPolicyDetailDto(1, "Global", null, null, null, true, false, new List<SlaTargetItemDto>());
        _serviceMock.Setup(s => s.GetPolicyByIdAsync(1)).ReturnsAsync(policy);

        var result = await _controller.GetPolicyById(1);

        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(policy, okResult.Value);
    }

    [Fact]
    public async Task GetPolicyById_ShouldReturnNotFound_WhenMissing()
    {
        _serviceMock.Setup(s => s.GetPolicyByIdAsync(99)).ReturnsAsync((SlaPolicyDetailDto?)null);

        var result = await _controller.GetPolicyById(99);

        Assert.IsType<NotFoundResult>(result);
    }

    [Fact]
    public async Task CreatePolicy_ShouldReturnCreatedAtAction()
    {
        var createDto = new CreateSlaPolicyDto("App SLA", "Desc", 1, true);
        var created = new SlaPolicyDto(2, "App SLA", "Desc", 1, true, true);
        _serviceMock.Setup(s => s.CreatePolicyAsync(createDto)).ReturnsAsync(created);

        var result = await _controller.CreatePolicy(createDto);

        var createdResult = Assert.IsType<CreatedAtActionResult>(result);
        Assert.Equal(created, createdResult.Value);
    }

    [Fact]
    public async Task UpdatePolicy_ShouldReturnNoContent_WhenSuccessful()
    {
        var updateDto = new UpdateSlaPolicyDto("Updated", "Desc", 1, false, true);
        _serviceMock.Setup(s => s.UpdatePolicyAsync(1, updateDto)).Returns(Task.CompletedTask);

        var result = await _controller.UpdatePolicy(1, updateDto);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task UpdatePolicy_ShouldReturnNotFound_WhenMissing()
    {
        var updateDto = new UpdateSlaPolicyDto("Updated", "Desc", 1, false, true);
        _serviceMock.Setup(s => s.UpdatePolicyAsync(99, updateDto)).ThrowsAsync(new KeyNotFoundException());

        var result = await _controller.UpdatePolicy(99, updateDto);

        Assert.IsType<NotFoundResult>(result);
    }

    [Fact]
    public async Task DeletePolicy_ShouldReturnNoContent_WhenSuccessful()
    {
        _serviceMock.Setup(s => s.DeletePolicyAsync(2)).Returns(Task.CompletedTask);

        var result = await _controller.DeletePolicy(2);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task DeletePolicy_ShouldReturnBadRequest_WhenCannotDelete()
    {
        _serviceMock.Setup(s => s.DeletePolicyAsync(1)).ThrowsAsync(new InvalidOperationException("Cannot delete global"));

        var result = await _controller.DeletePolicy(1);

        var badRequest = Assert.IsType<BadRequestObjectResult>(result);
        Assert.NotNull(badRequest.Value);
    }

    [Fact]
    public async Task BatchUpdateTargets_ShouldReturnNoContent()
    {
        var batchDto = new BatchUpdateSlaTargetsDto(new List<UpdateSlaTargetItemDto>
        {
            new(1, 1, null, 30, 240, true)
        });
        _serviceMock.Setup(s => s.BatchUpdateTargetsAsync(1, batchDto)).Returns(Task.CompletedTask);

        var result = await _controller.BatchUpdateTargets(1, batchDto);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task BatchUpdateTargets_ShouldReturnNotFound_WhenMissing()
    {
        var batchDto = new BatchUpdateSlaTargetsDto(new List<UpdateSlaTargetItemDto>());
        _serviceMock.Setup(s => s.BatchUpdateTargetsAsync(99, batchDto)).ThrowsAsync(new KeyNotFoundException());

        var result = await _controller.BatchUpdateTargets(99, batchDto);

        Assert.IsType<NotFoundResult>(result);
    }

    [Fact]
    public async Task GetTargets_ShouldReturnOk()
    {
        var targets = new List<SlaTargetDto>();
        _serviceMock.Setup(s => s.GetTargetsAsync(1)).ReturnsAsync(targets);

        var result = await _controller.GetTargets(1);

        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(targets, okResult.Value);
    }

    [Fact]
    public async Task CreateTarget_ShouldReturnCreatedAtAction()
    {
        var createDto = new CreateSlaTargetDto(1, 1, null, 15, 60);
        var created = new SlaTargetDto(10, 1, 1, null, 15, 60, true);
        _serviceMock.Setup(s => s.CreateTargetAsync(createDto)).ReturnsAsync(created);

        var result = await _controller.CreateTarget(createDto);

        var createdResult = Assert.IsType<CreatedAtActionResult>(result);
        Assert.Equal(created, createdResult.Value);
    }

    [Fact]
    public async Task UpdateTarget_ShouldReturnNoContent_WhenSuccessful()
    {
        var updateDto = new UpdateSlaTargetDto(1, null, 20, 120, true);
        _serviceMock.Setup(s => s.UpdateTargetAsync(10, updateDto)).Returns(Task.CompletedTask);

        var result = await _controller.UpdateTarget(10, updateDto);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task UpdateTarget_ShouldReturnNotFound_WhenMissing()
    {
        var updateDto = new UpdateSlaTargetDto(1, null, 20, 120, true);
        _serviceMock.Setup(s => s.UpdateTargetAsync(99, updateDto)).ThrowsAsync(new KeyNotFoundException());

        var result = await _controller.UpdateTarget(99, updateDto);

        Assert.IsType<NotFoundResult>(result);
    }

    [Fact]
    public async Task DeleteTarget_ShouldReturnNoContent()
    {
        _serviceMock.Setup(s => s.DeleteTargetAsync(10)).Returns(Task.CompletedTask);

        var result = await _controller.DeleteTarget(10);

        Assert.IsType<NoContentResult>(result);
    }
}
