using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Domain.Entities.Project;
using ItsTool.Domain.Entities.Workflow;
using ItsTool.Domain.Entities.Config;
using ItsTool.Infrastructure.Services;
using Microsoft.EntityFrameworkCore;
using Moq;
using Xunit;
using Microsoft.AspNetCore.Http;

namespace ItsTool.UnitTests.Services;

public class TicketServiceTests : TestBase
{
    private readonly TicketService _service;
    private readonly Mock<IFileStorageService> _fileStorageMock;
    private readonly Mock<IPermissionCalculator> _permissionMock;
    private readonly Mock<ISlaEngine> _slaEngineMock;

    private readonly Mock<IAssignmentEngine> _assignmentEngineMock;
    private readonly Mock<INotificationDispatcher> _notificationDispatcherMock;

    public TicketServiceTests() : base()
    {
        _fileStorageMock = new Mock<IFileStorageService>();
        _permissionMock = new Mock<IPermissionCalculator>();
        _slaEngineMock = new Mock<ISlaEngine>();
        _assignmentEngineMock = new Mock<IAssignmentEngine>();
        _notificationDispatcherMock = new Mock<INotificationDispatcher>();

        _service = new TicketService(_context, _fileStorageMock.Object, _permissionMock.Object, _slaEngineMock.Object, _assignmentEngineMock.Object, _notificationDispatcherMock.Object);
    }

    [Fact]
    public async Task CreateTicketAsync_ShouldGenerateSequenceNumber()
    {
        var p = new Project { Name = "Test", ProjectKey = "TEST" };
        _context.Projects.Add(p);
        
        var s = new Status { Name = "Open", IsSystemDefault = true };
        _context.Statuses.Add(s);
        await _context.SaveChangesAsync();

        var dto = new CreateTicketDto("T", "D", p.Id, 1, 1, 1, 1, new Dictionary<string, string>());
        var result = await _service.CreateTicketAsync(dto);

        Assert.Equal("TEST-1", result.TicketNumber);
        
        var result2 = await _service.CreateTicketAsync(dto);
        Assert.Equal("TEST-2", result2.TicketNumber);
    }

    [Fact]
    public async Task ChangeStatusAsync_ShouldThrowIfTransitionNotAllowed()
    {
        var t = new Ticket { TicketNumber = "1", Title = "1", ProjectId = 1, StatusId = 1 };
        _context.Tickets.Add(t);
        var wf = new Workflow { Name = "W", ProjectId = 1 };
        _context.Workflows.Add(wf);
        await _context.SaveChangesAsync();

        // No transition defined
        await Assert.ThrowsAsync<InvalidOperationException>(() => _service.ChangeStatusAsync(t.Id, new ChangeStatusDto(2, 1)));
    }

    [Fact]
    public async Task ChangeStatusAsync_ShouldThrowIfMissingPermission()
    {
        var t = new Ticket { TicketNumber = "1", Title = "1", ProjectId = 1, StatusId = 1 };
        _context.Tickets.Add(t);
        var wf = new Workflow { Name = "W", ProjectId = 1 };
        _context.Workflows.Add(wf);
        
        var wt = new WorkflowTransition { WorkflowId = 1, FromStatusId = 1, ToStatusId = 2, TransitionName = "x", RequiredPermissionKey = "ticket.resolve", IsActive = true };
        _context.WorkflowTransitions.Add(wt);
        await _context.SaveChangesAsync();

        _permissionMock.Setup(p => p.CalculateEffectivePermissionsAsync(1)).ReturnsAsync(new HashSet<string> { "ticket.view" });

        await Assert.ThrowsAsync<UnauthorizedAccessException>(() => _service.ChangeStatusAsync(t.Id, new ChangeStatusDto(2, 1)));
    }

    [Fact]
    public async Task ValidateDynamicFields_ShouldThrowIfRequiredMissing()
    {
        var p = new Project { Name = "P", ProjectKey = "P" };
        _context.Projects.Add(p);
        var def = new FieldDefinition { Key = "k1", Label = "L1" };
        _context.FieldDefinitions.Add(def);
        await _context.SaveChangesAsync();

        var place = new FormFieldPlacement { FieldDefinitionId = def.Id, ProjectId = p.Id, CategoryId = 1, TicketTypeId = 1, IsRequired = true, IsActive = true };
        _context.FormFieldPlacements.Add(place);
        await _context.SaveChangesAsync();

        var dto = new CreateTicketDto("T", "D", p.Id, 1, 1, 1, 1, new Dictionary<string, string>());
        
        await Assert.ThrowsAsync<InvalidOperationException>(() => _service.CreateTicketAsync(dto));
    }

    [Fact]
    public async Task AddCommentAsync_InternalCommentsShouldBeFiltered()
    {
        var t = new Ticket { TicketNumber = "1" };
        _context.Tickets.Add(t);
        await _context.SaveChangesAsync();

        await _service.AddCommentAsync(t.Id, new CreateCommentDto("public", false, 1));
        await _service.AddCommentAsync(t.Id, new CreateCommentDto("internal", true, 1));

        var publicOnly = await _service.GetCommentsAsync(t.Id, false);
        Assert.Single(publicOnly);
        Assert.Equal("public", publicOnly.First().Content);

        var all = await _service.GetCommentsAsync(t.Id, true);
        Assert.Equal(2, all.Count());
    }

    [Fact]
    public async Task AssignTicketAsync_ShouldAddHistory()
    {
        var t = new Ticket { TicketNumber = "1" };
        _context.Tickets.Add(t);
        await _context.SaveChangesAsync();

        _permissionMock.Setup(p => p.CalculateEffectivePermissionsAsync(1)).ReturnsAsync(new HashSet<string> { "ticket.assign" });

        await _service.AssignTicketAsync(t.Id, new AssignTicketDto(new List<int> { 2 }, new List<int>(), 1, 1));

        var history = await _context.TicketHistories.FirstOrDefaultAsync(h => h.TicketId == t.Id && h.Action == "Assigned");
        Assert.NotNull(history);
        Assert.Equal("Users:2,Groups:", history.NewValue);
    }

    [Fact]
    public async Task SubmitSurveyAsync_ShouldOnlyAllowRequester()
    {
        var t = new Ticket { TicketNumber = "1", RequesterUserId = 10, StatusId = 5 }; // Closed
        _context.Tickets.Add(t);
        await _context.SaveChangesAsync();

        var dto = new SubmitTicketSurveyDto(5, "Good");
        // UserId 11 is not requester
        await Assert.ThrowsAsync<UnauthorizedAccessException>(() => _service.SubmitSurveyAsync(t.Id, dto, 11));
    }

    [Fact]
    public async Task SubmitSurveyAsync_ShouldPreventDuplicates()
    {
        var t = new Ticket { TicketNumber = "1", RequesterUserId = 10, StatusId = 5 }; // Closed
        _context.Tickets.Add(t);
        _context.TicketSurveys.Add(new TicketSurvey { TicketId = 1, Rating = 4 });
        await _context.SaveChangesAsync();

        var dto = new SubmitTicketSurveyDto(5, "Good");
        await Assert.ThrowsAsync<InvalidOperationException>(() => _service.SubmitSurveyAsync(t.Id, dto, 10));
    }
}
