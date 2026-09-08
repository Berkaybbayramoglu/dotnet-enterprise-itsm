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

public class DynamicFormControllerTests
{
    private readonly Mock<IDynamicFormService> _serviceMock;
    private readonly DynamicFormController _controller;

    public DynamicFormControllerTests()
    {
        _serviceMock = new Mock<IDynamicFormService>();
        _controller = new DynamicFormController(_serviceMock.Object);
    }

    [Fact]
    public async Task GetDefinitions_ShouldReturnOk()
    {
        var list = new List<FieldDefinitionDto>();
        _serviceMock.Setup(s => s.GetFieldDefinitionsAsync()).ReturnsAsync(list);

        var result = await _controller.GetDefinitions();

        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(list, okResult.Value);
    }

    [Fact]
    public async Task GetDefinitionById_ShouldReturnOk_WhenFound()
    {
        var dto = new FieldDefinitionDto(1, "SerialNo", "Serial Number", "Text", null, true);
        _serviceMock.Setup(s => s.GetFieldDefinitionByIdAsync(1)).ReturnsAsync(dto);

        var result = await _controller.GetDefinitionById(1);

        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(dto, okResult.Value);
    }

    [Fact]
    public async Task GetDefinitionById_ShouldReturnNotFound_WhenMissing()
    {
        _serviceMock.Setup(s => s.GetFieldDefinitionByIdAsync(99)).ReturnsAsync((FieldDefinitionDto?)null);

        var result = await _controller.GetDefinitionById(99);

        Assert.IsType<NotFoundResult>(result);
    }

    [Fact]
    public async Task CreateDefinition_ShouldReturnCreatedAtAction_WhenValid()
    {
        var createDto = new CreateFieldDefinitionDto("SerialNo", "Serial Number", "Text", null);
        var created = new FieldDefinitionDto(1, "SerialNo", "Serial Number", "Text", null, true);
        _serviceMock.Setup(s => s.CreateFieldDefinitionAsync(createDto)).ReturnsAsync(created);

        var result = await _controller.CreateDefinition(createDto);

        var createdResult = Assert.IsType<CreatedAtActionResult>(result);
        Assert.Equal(created, createdResult.Value);
    }

    [Fact]
    public async Task CreateDefinition_ShouldReturnBadRequest_WhenInvalid()
    {
        var createDto = new CreateFieldDefinitionDto("SerialNo", "Serial Number", "Text", null);
        _serviceMock.Setup(s => s.CreateFieldDefinitionAsync(createDto)).ThrowsAsync(new InvalidOperationException("Duplicate name"));

        var result = await _controller.CreateDefinition(createDto);

        Assert.IsType<BadRequestObjectResult>(result);
    }

    [Fact]
    public async Task UpdateDefinition_ShouldReturnNoContent_WhenValid()
    {
        var updateDto = new UpdateFieldDefinitionDto("SerialNo", "Serial", "Text", null, true);
        _serviceMock.Setup(s => s.UpdateFieldDefinitionAsync(1, updateDto)).Returns(Task.CompletedTask);

        var result = await _controller.UpdateDefinition(1, updateDto);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task UpdateDefinition_ShouldReturnNotFound_WhenMissing()
    {
        var updateDto = new UpdateFieldDefinitionDto("SerialNo", "Serial", "Text", null, true);
        _serviceMock.Setup(s => s.UpdateFieldDefinitionAsync(99, updateDto)).ThrowsAsync(new KeyNotFoundException());

        var result = await _controller.UpdateDefinition(99, updateDto);

        Assert.IsType<NotFoundResult>(result);
    }

    [Fact]
    public async Task DeleteDefinition_ShouldReturnNoContent()
    {
        _serviceMock.Setup(s => s.DeleteFieldDefinitionAsync(1)).Returns(Task.CompletedTask);

        var result = await _controller.DeleteDefinition(1);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task GetOptions_ShouldReturnOk()
    {
        var list = new List<FieldOptionDto>();
        _serviceMock.Setup(s => s.GetFieldOptionsAsync(1)).ReturnsAsync(list);

        var result = await _controller.GetOptions(1);

        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(list, okResult.Value);
    }

    [Fact]
    public async Task CreateOption_ShouldReturnCreatedAtAction()
    {
        var createDto = new CreateFieldOptionDto(1, "Opt1", "Option 1", 1);
        var created = new FieldOptionDto(1, 1, "Opt1", "Option 1", 1, true);
        _serviceMock.Setup(s => s.CreateFieldOptionAsync(createDto)).ReturnsAsync(created);

        var result = await _controller.CreateOption(createDto);

        var createdResult = Assert.IsType<CreatedAtActionResult>(result);
        Assert.Equal(created, createdResult.Value);
    }

    [Fact]
    public async Task DeleteOption_ShouldReturnNoContent()
    {
        _serviceMock.Setup(s => s.DeleteFieldOptionAsync(1)).Returns(Task.CompletedTask);

        var result = await _controller.DeleteOption(1);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task GetPlacements_ShouldReturnOk()
    {
        var list = new List<FormFieldPlacementDto>();
        _serviceMock.Setup(s => s.GetPlacementsAsync(null, null, null)).ReturnsAsync(list);

        var result = await _controller.GetPlacements(null, null, null);

        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(list, okResult.Value);
    }

    [Fact]
    public async Task CreatePlacement_ShouldReturnCreatedAtAction()
    {
        var createDto = new CreateFormFieldPlacementDto(1, null, null, null, 1, false);
        var created = new FormFieldPlacementDto(1, 1, null, null, null, 1, false, true);
        _serviceMock.Setup(s => s.CreatePlacementAsync(createDto)).ReturnsAsync(created);

        var result = await _controller.CreatePlacement(createDto);

        var createdResult = Assert.IsType<CreatedAtActionResult>(result);
        Assert.Equal(created, createdResult.Value);
    }

    [Fact]
    public async Task DeletePlacement_ShouldReturnNoContent()
    {
        _serviceMock.Setup(s => s.DeletePlacementAsync(1)).Returns(Task.CompletedTask);

        var result = await _controller.DeletePlacement(1);

        Assert.IsType<NoContentResult>(result);
    }
}
