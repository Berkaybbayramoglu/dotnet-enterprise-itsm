using System.Threading.Tasks;
using ItsTool.API.Controllers;
using ItsTool.Application.DTOs;
using ItsTool.Domain.Entities.Config;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using System.Security.Claims;
using Xunit;
using Microsoft.EntityFrameworkCore;
using System.Linq;

namespace ItsTool.UnitTests.Controllers;

public class SavedFilterControllerTests : TestBase
{
    private readonly SavedFilterController _controller;

    public SavedFilterControllerTests() : base()
    {
        _controller = new SavedFilterController(_context);
        
        // Mock User Claims
        var user = new ClaimsPrincipal(new ClaimsIdentity(new Claim[]
        {
            new Claim(ClaimTypes.NameIdentifier, "1")
        }, "mock"));

        _controller.ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext { User = user }
        };
    }

    [Fact]
    public async Task GetMyFilters_ShouldReturnOnlyUserFilters()
    {
        _context.SavedFilters.Add(new SavedFilter { UserId = 1, Name = "F1", QueryJson = "{}" });
        _context.SavedFilters.Add(new SavedFilter { UserId = 2, Name = "F2", QueryJson = "{}" });
        await _context.SaveChangesAsync();

        var result = await _controller.GetMyFilters();
        var okResult = Assert.IsType<OkObjectResult>(result);
        var dtos = Assert.IsAssignableFrom<System.Collections.Generic.IEnumerable<SavedFilterDto>>(okResult.Value);

        Assert.Single(dtos);
        Assert.Equal("F1", dtos.First().Name);
    }
}
