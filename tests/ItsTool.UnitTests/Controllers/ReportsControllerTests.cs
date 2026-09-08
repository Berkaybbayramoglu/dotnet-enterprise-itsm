using System.IO;
using System.Security.Claims;
using System.Threading.Tasks;
using ItsTool.API.Controllers;
using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Moq;
using Xunit;

namespace ItsTool.UnitTests.Controllers;

public class ReportsControllerTests
{
    [Fact]
    public async Task ExportTicketsCsv_ShouldReturnFileResult()
    {
        var mockService = new Mock<IReportService>();
        var stream = new MemoryStream(new byte[] { 1, 2, 3 });
        mockService.Setup(s => s.ExportTicketsToCsvAsync(It.IsAny<TicketSearchFilterDto>(), 1))
            .ReturnsAsync(stream);

        var controller = new ReportsController(mockService.Object);

        var user = new ClaimsPrincipal(new ClaimsIdentity(new[]
        {
            new Claim("UserId", "1")
        }, "mock"));

        controller.ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext { User = user }
        };

        var result = await controller.ExportTicketsCsv(new TicketSearchFilterDto());

        var fileResult = Assert.IsType<FileStreamResult>(result);
        Assert.Equal("text/csv", fileResult.ContentType);
    }
}
