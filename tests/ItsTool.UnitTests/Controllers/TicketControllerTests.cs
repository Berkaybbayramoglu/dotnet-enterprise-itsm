using System;
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

public class TicketControllerTests
{
    private readonly Mock<ITicketService> _serviceMock;
    private readonly TicketController _controller;

    public TicketControllerTests()
    {
        _serviceMock = new Mock<ITicketService>();
        _controller = new TicketController(_serviceMock.Object);

        var user = new ClaimsPrincipal(new ClaimsIdentity(new[]
        {
            new Claim(ClaimTypes.NameIdentifier, "1"),
            new Claim(ClaimTypes.Role, "SuperAdmin"),
            new Claim("permission", "ticket.manage"),
            new Claim("permission", "ticket.view"),
            new Claim("permission", "ticket.create"),
            new Claim("permission", "ticket.edit"),
            new Claim("permission", "ticket.delete"),
            new Claim("permission", "ticket.comment.edit"),
            new Claim("permission", "ticket.comment.delete"),
            new Claim("permission", "ticket.comment.internal")
        }, "mock"));

        _controller.ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext { User = user }
        };
    }

    private static TicketDto CreateDummyTicketDto(int id) =>
        new(id, $"T-{id}", "Title", "Desc", 1, 1, 1, 1, 1, 1, new List<TicketAssigneeDto>());

    [Fact]
    public async Task CreateTicket_ShouldReturnCreatedAtAction_WhenValid()
    {
        var createDto = new CreateTicketDto("Title", "Desc", 1, 1, 1, 1, 1, new Dictionary<string, string>());
        var created = CreateDummyTicketDto(10);
        _serviceMock.Setup(s => s.CreateTicketAsync(It.IsAny<CreateTicketDto>())).ReturnsAsync(created);

        var result = await _controller.CreateTicket(createDto);

        var createdResult = Assert.IsType<CreatedAtActionResult>(result);
        Assert.Equal(created, createdResult.Value);
    }

    [Fact]
    public async Task CreateTicket_ShouldReturnBadRequest_WhenThrowsInvalidOp()
    {
        var createDto = new CreateTicketDto("Title", "Desc", 1, 1, 1, 1, 1, new Dictionary<string, string>());
        _serviceMock.Setup(s => s.CreateTicketAsync(It.IsAny<CreateTicketDto>())).ThrowsAsync(new InvalidOperationException("Invalid"));

        var result = await _controller.CreateTicket(createDto);

        Assert.IsType<BadRequestObjectResult>(result);
    }

    [Fact]
    public async Task GetTicket_ShouldReturnOk_WhenFound()
    {
        var ticket = CreateDummyTicketDto(1);
        _serviceMock.Setup(s => s.GetTicketByIdAsync(1)).ReturnsAsync(ticket);

        var result = await _controller.GetTicket(1);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(ticket, ok.Value);
    }

    [Fact]
    public async Task GetTicket_ShouldReturnNotFound_WhenMissing()
    {
        _serviceMock.Setup(s => s.GetTicketByIdAsync(99)).ReturnsAsync((TicketDto?)null);

        var result = await _controller.GetTicket(99);

        Assert.IsType<NotFoundResult>(result);
    }

    [Fact]
    public async Task GetEligibleUsers_ShouldReturnOk()
    {
        var users = new List<UserDto>();
        _serviceMock.Setup(s => s.GetEligibleUsersForTicketAsync(1)).ReturnsAsync(users);

        var result = await _controller.GetEligibleUsers(1);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(users, ok.Value);
    }

    [Fact]
    public async Task DeleteTicket_ShouldReturnNoContent_WhenAuthorized()
    {
        _serviceMock.Setup(s => s.DeleteTicketAsync(1, 1)).Returns(Task.CompletedTask);

        var result = await _controller.DeleteTicket(1);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task DeleteTicket_ShouldReturnForbid_WhenLacksPermission()
    {
        _controller.ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext { User = new ClaimsPrincipal(new ClaimsIdentity()) }
        };

        var result = await _controller.DeleteTicket(1);

        Assert.IsType<ForbidResult>(result);
    }

    [Fact]
    public async Task RestoreTicket_ShouldReturnNoContent_WhenAuthorized()
    {
        _serviceMock.Setup(s => s.RestoreTicketAsync(1, 1)).Returns(Task.CompletedTask);

        var result = await _controller.RestoreTicket(1);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task UpdateTicket_ShouldReturnNoContent_WhenValid()
    {
        var updateDto = new UpdateTicketDto("Title", "Desc", 1, 1, new Dictionary<string, string>());
        _serviceMock.Setup(s => s.UpdateTicketAsync(1, updateDto, 1)).Returns(Task.CompletedTask);

        var result = await _controller.UpdateTicket(1, updateDto);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task UpdateTicket_ShouldReturnNotFound_WhenMissing()
    {
        var updateDto = new UpdateTicketDto("Title", "Desc", 1, 1, new Dictionary<string, string>());
        _serviceMock.Setup(s => s.UpdateTicketAsync(99, updateDto, 1)).ThrowsAsync(new KeyNotFoundException());

        var result = await _controller.UpdateTicket(99, updateDto);

        Assert.IsType<NotFoundResult>(result);
    }

    [Fact]
    public async Task GetAllowedTransitions_ShouldReturnOk()
    {
        var transitions = new List<StatusDto>();
        _serviceMock.Setup(s => s.GetAllowedTransitionsAsync(1, 1)).ReturnsAsync(transitions);

        var result = await _controller.GetAllowedTransitions(1);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(transitions, ok.Value);
    }

    [Fact]
    public async Task ChangeStatus_ShouldReturnNoContent_WhenValid()
    {
        _serviceMock.Setup(s => s.ChangeStatusAsync(1, It.IsAny<ChangeStatusDto>())).Returns(Task.CompletedTask);

        var result = await _controller.ChangeStatus(1, 2);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task AssignTicket_ShouldReturnNoContent()
    {
        _serviceMock.Setup(s => s.AssignTicketAsync(1, It.IsAny<AssignTicketDto>())).Returns(Task.CompletedTask);

        var req = new TicketController.AssignTicketRequest(new List<int> { 1 }, new List<int>(), null);
        var result = await _controller.AssignTicket(1, req);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task GetAssignmentTree_ShouldReturnOk()
    {
        var tree = new List<TicketAssigneeDto>();
        _serviceMock.Setup(s => s.GetAssignmentTreeAsync(1)).ReturnsAsync(tree);

        var result = await _controller.GetAssignmentTree(1);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(tree, ok.Value);
    }

    [Fact]
    public async Task TransferTicket_ShouldReturnNoContent()
    {
        var dto = new TransferTicketDto(1, 1, 1);
        _serviceMock.Setup(s => s.TransferTicketAsync(1, It.IsAny<TransferTicketDto>())).Returns(Task.CompletedTask);

        var result = await _controller.TransferTicket(1, dto);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task AddComment_ShouldReturnOk()
    {
        var createDto = new CreateCommentDto("Comment", false, 1, null, null);
        var commentDto = new TicketCommentDto(1, 1, 1, "Comment", false, DateTime.UtcNow);
        _serviceMock.Setup(s => s.AddCommentAsync(1, It.IsAny<CreateCommentDto>())).ReturnsAsync(commentDto);

        var result = await _controller.AddComment(1, createDto);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(commentDto, ok.Value);
    }

    [Fact]
    public async Task UpdateComment_ShouldReturnOk()
    {
        var updateDto = new UpdateCommentDto("Updated");
        var commentDto = new TicketCommentDto(1, 1, 1, "Updated", false, DateTime.UtcNow);
        _serviceMock.Setup(s => s.UpdateCommentAsync(1, 1, updateDto, 1, true)).ReturnsAsync(commentDto);

        var result = await _controller.UpdateComment(1, 1, updateDto);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(commentDto, ok.Value);
    }

    [Fact]
    public async Task DeleteComment_ShouldReturnNoContent()
    {
        _serviceMock.Setup(s => s.DeleteCommentAsync(1, 1, 1, true)).Returns(Task.CompletedTask);

        var result = await _controller.DeleteComment(1, 1);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task RestoreComment_ShouldReturnNoContent()
    {
        _serviceMock.Setup(s => s.RestoreCommentAsync(1, 1, 1, true)).Returns(Task.CompletedTask);

        var result = await _controller.RestoreComment(1, 1);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task GetComments_ShouldReturnOk()
    {
        var list = new List<TicketCommentDto>();
        _serviceMock.Setup(s => s.GetCommentsAsync(1, true)).ReturnsAsync(list);

        var result = await _controller.GetComments(1);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(list, ok.Value);
    }

    [Fact]
    public async Task GetAttachments_ShouldReturnOk()
    {
        var list = new List<TicketAttachmentDto>();
        _serviceMock.Setup(s => s.GetAttachmentsAsync(1)).ReturnsAsync(list);

        var result = await _controller.GetAttachments(1);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(list, ok.Value);
    }

    [Fact]
    public async Task DeleteAttachment_ShouldReturnNoContent_WhenValid()
    {
        _serviceMock.Setup(s => s.DeleteAttachmentAsync(1, 2, 1, true)).Returns(Task.CompletedTask);

        var result = await _controller.DeleteAttachment(1, 2);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task GetTimeline_ShouldReturnOk()
    {
        var list = new List<TimelineEventDto>();
        _serviceMock.Setup(s => s.GetTimelineAsync(1, true)).ReturnsAsync(list);

        var result = await _controller.GetTimeline(1);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(list, ok.Value);
    }

    [Fact]
    public async Task Search_ShouldReturnOk()
    {
        var paged = new PagedResult<TicketDto> { Items = new List<TicketDto>(), TotalCount = 0, Page = 1, PageSize = 10 };
        _serviceMock.Setup(s => s.SearchTicketsAsync(It.IsAny<TicketSearchFilterDto>(), 1)).ReturnsAsync(paged);

        var result = await _controller.Search(new TicketSearchFilterDto());

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(paged, ok.Value);
    }

    [Fact]
    public async Task SubmitSurvey_ShouldReturnCreatedAtAction()
    {
        var surveyDto = new SubmitTicketSurveyDto(5, "Great support!");
        var surveyResult = new TicketSurveyDto(1, 1, 5, "Great support!", DateTime.UtcNow);
        _serviceMock.Setup(s => s.SubmitSurveyAsync(1, surveyDto, 1)).ReturnsAsync(surveyResult);

        var result = await _controller.SubmitSurvey(1, surveyDto);

        var created = Assert.IsType<CreatedAtActionResult>(result);
        Assert.Equal(surveyResult, created.Value);
    }
}
