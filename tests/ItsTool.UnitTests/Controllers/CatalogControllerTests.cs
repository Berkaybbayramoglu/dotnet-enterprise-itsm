using System.Collections.Generic;
using System.Threading.Tasks;
using ItsTool.API.Controllers;
using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using Microsoft.AspNetCore.Mvc;
using Moq;
using Xunit;

namespace ItsTool.UnitTests.Controllers;

public class CatalogControllerTests
{
    private readonly Mock<ICatalogService> _serviceMock;
    private readonly CatalogController _controller;

    public CatalogControllerTests()
    {
        _serviceMock = new Mock<ICatalogService>();
        _controller = new CatalogController(_serviceMock.Object);
    }

    [Fact]
    public async Task GetCategories_ShouldReturnOk()
    {
        var list = new List<CategoryDto>();
        _serviceMock.Setup(s => s.GetCategoriesAsync(null)).ReturnsAsync(list);

        var result = await _controller.GetCategories(null);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(list, ok.Value);
    }

    [Fact]
    public async Task CreateCategory_ShouldReturnCreatedAtAction()
    {
        var dto = new CreateCategoryDto("Cat", 1, null, "Desc", null);
        var created = new CategoryDto(1, "Cat", 1, null, "Desc", null, true);
        _serviceMock.Setup(s => s.CreateCategoryAsync(dto)).ReturnsAsync(created);

        var result = await _controller.CreateCategory(dto);

        var ok = Assert.IsType<CreatedAtActionResult>(result);
        Assert.Equal(created, ok.Value);
    }

    [Fact]
    public async Task UpdateCategory_ShouldReturnNoContent()
    {
        var dto = new UpdateCategoryDto("Cat", 1, null, "Desc", null, true);
        _serviceMock.Setup(s => s.UpdateCategoryAsync(1, dto)).Returns(Task.CompletedTask);

        var result = await _controller.UpdateCategory(1, dto);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task DeleteCategory_ShouldReturnNoContent()
    {
        _serviceMock.Setup(s => s.DeleteCategoryAsync(1)).Returns(Task.CompletedTask);

        var result = await _controller.DeleteCategory(1);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task GetPriorities_ShouldReturnOk()
    {
        var list = new List<PriorityDto>();
        _serviceMock.Setup(s => s.GetPrioritiesAsync()).ReturnsAsync(list);

        var result = await _controller.GetPriorities();

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(list, ok.Value);
    }

    [Fact]
    public async Task CreatePriority_ShouldReturnCreatedAtAction()
    {
        var dto = new CreatePriorityDto("P1", "#fff", 1, 1);
        var created = new PriorityDto(1, "P1", "#fff", 1, 1, true);
        _serviceMock.Setup(s => s.CreatePriorityAsync(dto)).ReturnsAsync(created);

        var result = await _controller.CreatePriority(dto);

        var ok = Assert.IsType<CreatedAtActionResult>(result);
        Assert.Equal(created, ok.Value);
    }

    [Fact]
    public async Task UpdatePriority_ShouldReturnNoContent()
    {
        var dto = new UpdatePriorityDto("P1", "#fff", 1, 1, true);
        _serviceMock.Setup(s => s.UpdatePriorityAsync(1, dto)).Returns(Task.CompletedTask);

        var result = await _controller.UpdatePriority(1, dto);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task DeletePriority_ShouldReturnNoContent()
    {
        _serviceMock.Setup(s => s.DeletePriorityAsync(1)).Returns(Task.CompletedTask);

        var result = await _controller.DeletePriority(1);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task GetStatuses_ShouldReturnOk()
    {
        var list = new List<StatusDto>();
        _serviceMock.Setup(s => s.GetStatusesAsync()).ReturnsAsync(list);

        var result = await _controller.GetStatuses();

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(list, ok.Value);
    }

    [Fact]
    public async Task CreateStatus_ShouldReturnCreatedAtAction()
    {
        var dto = new CreateStatusDto("Open", "#000", 1, false, false);
        var created = new StatusDto(1, "Open", "#000", 1, false, false, true);
        _serviceMock.Setup(s => s.CreateStatusAsync(dto)).ReturnsAsync(created);

        var result = await _controller.CreateStatus(dto);

        var ok = Assert.IsType<CreatedAtActionResult>(result);
        Assert.Equal(created, ok.Value);
    }

    [Fact]
    public async Task UpdateStatus_ShouldReturnNoContent()
    {
        var dto = new UpdateStatusDto("Open", "#000", 1, false, false, true);
        _serviceMock.Setup(s => s.UpdateStatusAsync(1, dto)).Returns(Task.CompletedTask);

        var result = await _controller.UpdateStatus(1, dto);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task DeleteStatus_ShouldReturnNoContent()
    {
        _serviceMock.Setup(s => s.DeleteStatusAsync(1)).Returns(Task.CompletedTask);

        var result = await _controller.DeleteStatus(1);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task GetTicketTypes_ShouldReturnOk()
    {
        var list = new List<TicketTypeDto>();
        _serviceMock.Setup(s => s.GetTicketTypesAsync()).ReturnsAsync(list);

        var result = await _controller.GetTicketTypes();

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(list, ok.Value);
    }

    [Fact]
    public async Task CreateTicketType_ShouldReturnCreatedAtAction()
    {
        var dto = new CreateTicketTypeDto("Incident");
        var created = new TicketTypeDto(1, "Incident", true);
        _serviceMock.Setup(s => s.CreateTicketTypeAsync(dto)).ReturnsAsync(created);

        var result = await _controller.CreateTicketType(dto);

        var ok = Assert.IsType<CreatedAtActionResult>(result);
        Assert.Equal(created, ok.Value);
    }

    [Fact]
    public async Task UpdateTicketType_ShouldReturnNoContent()
    {
        var dto = new UpdateTicketTypeDto("Incident", true);
        _serviceMock.Setup(s => s.UpdateTicketTypeAsync(1, dto)).Returns(Task.CompletedTask);

        var result = await _controller.UpdateTicketType(1, dto);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task DeleteTicketType_ShouldReturnNoContent()
    {
        _serviceMock.Setup(s => s.DeleteTicketTypeAsync(1)).Returns(Task.CompletedTask);

        var result = await _controller.DeleteTicketType(1);

        Assert.IsType<NoContentResult>(result);
    }
}
