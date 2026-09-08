using System.Collections.Generic;
using System.Threading.Tasks;
using ItsTool.API.Controllers;
using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using Microsoft.AspNetCore.Mvc;
using Moq;
using Xunit;

namespace ItsTool.UnitTests.Controllers;

public class LookupControllerTests
{
    [Fact]
    public async Task GetLookups_ShouldReturnAllLookupCollections()
    {
        var catalogMock = new Mock<ICatalogService>();
        var projectMock = new Mock<IProjectService>();
        var deptMock = new Mock<IDepartmentService>();

        catalogMock.Setup(s => s.GetCategoriesAsync(null)).ReturnsAsync(new List<CategoryDto>());
        catalogMock.Setup(s => s.GetTicketTypesAsync()).ReturnsAsync(new List<TicketTypeDto>());
        catalogMock.Setup(s => s.GetPrioritiesAsync()).ReturnsAsync(new List<PriorityDto>());
        catalogMock.Setup(s => s.GetStatusesAsync()).ReturnsAsync(new List<StatusDto>());
        projectMock.Setup(s => s.GetAllAsync()).ReturnsAsync(new List<ProjectDto>());
        deptMock.Setup(s => s.GetAllAsync()).ReturnsAsync(new List<DepartmentDto>());

        var controller = new LookupController(catalogMock.Object, projectMock.Object, deptMock.Object);

        var result = await controller.GetLookups();

        Assert.IsType<OkObjectResult>(result);
    }
}
