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

public class NotificationsControllerTests
{
    private readonly Mock<INotificationService> _serviceMock;
    private readonly NotificationsController _controller;

    public NotificationsControllerTests()
    {
        _serviceMock = new Mock<INotificationService>();
        _controller = new NotificationsController(_serviceMock.Object);

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
    public async Task GetMyNotifications_ShouldReturnOk()
    {
        var list = new List<NotificationDto> { new(1, 1, "Type", "Title", "Body", false, 10, "Ticket", "Normal", DateTime.UtcNow) };
        _serviceMock.Setup(s => s.GetUserNotificationsAsync(1)).ReturnsAsync(list);

        var result = await _controller.GetMyNotifications();

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(list, ok.Value);
    }

    [Fact]
    public async Task GetNotificationById_ShouldReturnOk_WhenFound()
    {
        var notif = new NotificationDto(1, 1, "Type", "Title", "Body", false, 10, "Ticket", "Normal", DateTime.UtcNow);
        _serviceMock.Setup(s => s.GetUserNotificationsAsync(1)).ReturnsAsync(new List<NotificationDto> { notif });

        var result = await _controller.GetNotificationById(1);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(notif, ok.Value);
    }

    [Fact]
    public async Task GetNotificationById_ShouldReturnNotFound_WhenMissing()
    {
        _serviceMock.Setup(s => s.GetUserNotificationsAsync(1)).ReturnsAsync(new List<NotificationDto>());

        var result = await _controller.GetNotificationById(99);

        Assert.IsType<NotFoundResult>(result);
    }

    [Fact]
    public async Task MarkAsRead_ShouldReturnNoContent()
    {
        _serviceMock.Setup(s => s.MarkAsReadAsync(1, 1)).Returns(Task.CompletedTask);

        var result = await _controller.MarkAsRead(1);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task MarkAllAsRead_ShouldReturnNoContent()
    {
        _serviceMock.Setup(s => s.MarkAllAsReadAsync(1)).Returns(Task.CompletedTask);

        var result = await _controller.MarkAllAsRead();

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task DeleteNotification_ShouldReturnNoContent()
    {
        _serviceMock.Setup(s => s.DeleteNotificationAsync(1, 1)).Returns(Task.CompletedTask);

        var result = await _controller.DeleteNotification(1);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task DeleteAllNotifications_ShouldReturnNoContent()
    {
        _serviceMock.Setup(s => s.DeleteAllNotificationsAsync(1)).Returns(Task.CompletedTask);

        var result = await _controller.DeleteAllNotifications();

        Assert.IsType<NoContentResult>(result);
    }
}
