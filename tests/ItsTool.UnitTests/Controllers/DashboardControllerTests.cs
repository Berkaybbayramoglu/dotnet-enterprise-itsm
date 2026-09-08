using System.Collections.Generic;
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

public class DashboardControllerTests
{
    private readonly Mock<IDashboardService> _serviceMock;
    private readonly DashboardController _controller;

    public DashboardControllerTests()
    {
        _serviceMock = new Mock<IDashboardService>();
        _controller = new DashboardController(_serviceMock.Object);

        var user = new ClaimsPrincipal(new ClaimsIdentity(new[]
        {
            new Claim(ClaimTypes.NameIdentifier, "1")
        }, "mock"));

        _controller.ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext { User = user }
        };
    }

    [Fact]
    public async Task GetOverview_ShouldReturnOk()
    {
        var overview = new DashboardOverviewDto(10, 2, 1, 0, 3, 4.5);
        _serviceMock.Setup(s => s.GetOverviewAsync(1)).ReturnsAsync(overview);

        var result = await _controller.GetOverview();

        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(overview, okResult.Value);
    }

    [Fact]
    public async Task GetDistributions_ShouldReturnOk()
    {
        var dist = new DashboardDistributionsDto(new List<TicketDistributionDto>(), new List<TicketDistributionDto>(), new List<TicketDistributionDto>(), new List<TicketDistributionDto>());
        _serviceMock.Setup(s => s.GetDistributionsAsync(1)).ReturnsAsync(dist);

        var result = await _controller.GetDistributions();

        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(dist, okResult.Value);
    }

    [Fact]
    public async Task GetDepartmentWorkload_ShouldReturnOk()
    {
        var workload = new List<DepartmentWorkloadDto> { new(1, "IT", 5, new List<AgentWorkloadDto>()) };
        _serviceMock.Setup(s => s.GetDepartmentWorkloadAsync(1)).ReturnsAsync(workload);

        var result = await _controller.GetDepartmentWorkload();

        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(workload, okResult.Value);
    }

    [Fact]
    public async Task GetSlaCompliance_ShouldReturnOk()
    {
        var compliance = new SlaComplianceDto(95.0, 98.0, 10.5);
        _serviceMock.Setup(s => s.GetSlaComplianceAsync(1)).ReturnsAsync(compliance);

        var result = await _controller.GetSlaCompliance();

        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(compliance, okResult.Value);
    }

    [Fact]
    public async Task GetRecentSurveys_ShouldReturnOk()
    {
        var surveys = new List<TicketSurveyDto>();
        _serviceMock.Setup(s => s.GetRecentSurveysAsync(1)).ReturnsAsync(surveys);

        var result = await _controller.GetRecentSurveys();

        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(surveys, okResult.Value);
    }
}
