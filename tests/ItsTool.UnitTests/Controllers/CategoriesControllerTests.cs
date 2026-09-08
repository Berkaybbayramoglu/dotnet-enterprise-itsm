using System.Collections.Generic;
using System.Threading.Tasks;
using ItsTool.API.Controllers;
using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using Microsoft.AspNetCore.Mvc;
using Moq;
using Xunit;

namespace ItsTool.UnitTests.Controllers;

public class CategoriesControllerTests
{
    private readonly Mock<ICatalogService> _catalogServiceMock;
    private readonly CategoriesController _controller;

    public CategoriesControllerTests()
    {
        _catalogServiceMock = new Mock<ICatalogService>();
        _controller = new CategoriesController(_catalogServiceMock.Object);
    }

    [Fact]
    public async Task GetAll_ShouldReturnAllCategories()
    {
        var list = new List<CategoryDto> { new(1, "Hardware", 1, null, "HW", null, true), new(2, "Software", 1, null, "SW", null, true) };
        _catalogServiceMock.Setup(s => s.GetCategoriesAsync(null)).ReturnsAsync(list);

        var result = await _controller.GetAll();

        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(list, okResult.Value);
    }

    [Fact]
    public async Task GetById_ShouldReturnOk_WhenFound()
    {
        var cat = new CategoryDto(1, "Hardware", 1, null, "HW", null, true);
        _catalogServiceMock.Setup(s => s.GetCategoryByIdAsync(1)).ReturnsAsync(cat);

        var result = await _controller.GetById(1);

        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(cat, okResult.Value);
    }

    [Fact]
    public async Task GetById_ShouldReturnNotFound_WhenMissing()
    {
        _catalogServiceMock.Setup(s => s.GetCategoryByIdAsync(99)).ReturnsAsync((CategoryDto?)null);

        var result = await _controller.GetById(99);

        Assert.IsType<NotFoundResult>(result);
    }

    [Fact]
    public async Task Create_ShouldReturnCreatedAtAction()
    {
        var createDto = new CreateCategoryDto("Network", 1, null, "NET", null);
        var created = new CategoryDto(3, "Network", 1, null, "NET", null, true);
        _catalogServiceMock.Setup(s => s.CreateCategoryAsync(createDto)).ReturnsAsync(created);

        var result = await _controller.Create(createDto);

        var createdResult = Assert.IsType<CreatedAtActionResult>(result);
        Assert.Equal(created, createdResult.Value);
    }

    [Fact]
    public async Task Update_ShouldReturnNoContent_WhenSuccessful()
    {
        var updateDto = new UpdateCategoryDto("Hardware Updated", 1, null, "HW2", null, true);
        _catalogServiceMock.Setup(s => s.UpdateCategoryAsync(1, updateDto)).Returns(Task.CompletedTask);

        var result = await _controller.Update(1, updateDto);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task Update_ShouldReturnNotFound_WhenNotFound()
    {
        var updateDto = new UpdateCategoryDto("Hardware Updated", 1, null, "HW2", null, true);
        _catalogServiceMock.Setup(s => s.UpdateCategoryAsync(99, updateDto)).ThrowsAsync(new KeyNotFoundException());

        var result = await _controller.Update(99, updateDto);

        Assert.IsType<NotFoundResult>(result);
    }

    [Fact]
    public async Task Delete_ShouldReturnNoContent()
    {
        _catalogServiceMock.Setup(s => s.DeleteCategoryAsync(1)).Returns(Task.CompletedTask);

        var result = await _controller.Delete(1);

        Assert.IsType<NoContentResult>(result);
    }
}
