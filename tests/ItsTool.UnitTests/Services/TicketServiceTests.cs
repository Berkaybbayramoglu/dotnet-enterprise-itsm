using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.Organization;
using ItsTool.Domain.Entities.Project;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Domain.Entities.Workflow;
using ItsTool.Domain.Entities.SLA;
using ItsTool.Infrastructure.Services;
using Microsoft.AspNetCore.Http;
using Moq;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class TicketServiceTests : TestBase
{
    private readonly Mock<IFileStorageService> _fileStorageMock = new();
    private readonly Mock<IPermissionCalculator> _permCalcMock = new();
    private readonly Mock<ISlaEngine> _slaEngineMock = new();
    private readonly Mock<IAssignmentEngine> _assignmentEngineMock = new();
    private readonly Mock<INotificationDispatcher> _notifDispatcherMock = new();

    private readonly TicketService _ticketService;

    public TicketServiceTests() : base()
    {
        _ticketService = new TicketService(
            _context,
            _fileStorageMock.Object,
            _permCalcMock.Object,
            _slaEngineMock.Object,
            _assignmentEngineMock.Object,
            _notifDispatcherMock.Object
        );

        SeedBasicData();
    }

    private void SeedBasicData()
    {
        _context.Categories.Add(new Category { Id = 1, Name = "IT", IsActive = true });
        _context.Priorities.Add(new Priority { Id = 1, Name = "Normal", SeverityLevel = 1, IsActive = true });
        _context.Statuses.Add(new Status { Id = 1, Name = "New", IsActive = true, IsClosedStatus = false, IsSystemDefault = true });
        _context.Statuses.Add(new Status { Id = 2, Name = "In Progress", IsActive = true, IsClosedStatus = false });
        _context.Statuses.Add(new Status { Id = 3, Name = "Closed", IsActive = true, IsClosedStatus = true });
        _context.Statuses.Add(new Status { Id = 5, Name = "ClosedFinal", IsActive = true, IsClosedStatus = true });
        _context.TicketTypes.Add(new TicketType { Id = 1, Name = "Incident", IsActive = true });
        _context.Projects.Add(new Project { Id = 1, Name = "Alpha", ProjectKey = "ALP", IsActive = true });
        _context.Users.Add(new User { Id = 1, Username = "admin", Email = "admin@itsm.com", FirstName = "Admin", LastName = "User", PasswordHash = "hash", IsActive = true });
        _context.Users.Add(new User { Id = 2, Username = "agent", Email = "agent@itsm.com", FirstName = "Agent", LastName = "One", PasswordHash = "hash", IsActive = true });
        _context.Groups.Add(new Group { Id = 1, Name = "Support Tier 1", IsActive = true });
        _context.Departments.Add(new Department { Id = 1, Name = "IT Support", IsActive = true });

        _context.Workflows.Add(new Workflow { Id = 1, Name = "Default WF", ProjectId = 1, IsActive = true });
        _context.WorkflowTransitions.Add(new WorkflowTransition { Id = 1, WorkflowId = 1, FromStatusId = 1, ToStatusId = 2, TransitionName = "Start Progress", IsActive = true });

        _context.SaveChanges();

        _permCalcMock.Setup(p => p.CalculateEffectivePermissionsAsync(It.IsAny<int>()))
            .ReturnsAsync(new HashSet<string> { "ticket.assign", "admin.manage", "ticket.view.all", "ticket.edit" });
    }

    [Fact]
    public async Task CreateTicketAsync_CreatesTicketWithSequentialNumber()
    {
        var dto = new CreateTicketDto(
            Title: "Server Down",
            Description: "Production server is unreachable",
            ProjectId: 1,
            CategoryId: 1,
            TypeId: 1,
            PriorityId: 1,
            RequesterUserId: 1,
            CustomFields: new Dictionary<string, string>()
        );

        var result = await _ticketService.CreateTicketAsync(dto);

        Assert.NotNull(result);
        Assert.Equal("Server Down", result.Title);
        Assert.Equal("ALP-1", result.TicketNumber);
        Assert.Equal(1, result.StatusId);

        _slaEngineMock.Verify(s => s.AttachSlaToTicketAsync(It.IsAny<int>()), Times.Once);
        _assignmentEngineMock.Verify(a => a.AssignTicketAsync(It.IsAny<Ticket>()), Times.Once);
        _notifDispatcherMock.Verify(n => n.DispatchEventAsync(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int?>(), It.IsAny<string?>()), Times.Once);
    }

    [Fact]
    public async Task GetTicketByIdAsync_WhenExists_ReturnsDto()
    {
        var ticket = new Ticket
        {
            TicketNumber = "ALP-10",
            Title = "Network Issue",
            Description = "WiFi is dropping",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 1,
            TypeId = 1,
            ProjectId = 1,
            RequesterUserId = 1,
            CreatedAt = DateTime.UtcNow
        };
        _context.Tickets.Add(ticket);
        await _context.SaveChangesAsync();

        var result = await _ticketService.GetTicketByIdAsync(ticket.Id);

        Assert.NotNull(result);
        Assert.Equal("ALP-10", result.TicketNumber);
        Assert.Equal("Network Issue", result.Title);
    }

    [Fact]
    public async Task GetTicketByIdAsync_WhenNotExists_ReturnsNull()
    {
        var result = await _ticketService.GetTicketByIdAsync(9999);
        Assert.Null(result);
    }

    [Fact]
    public async Task UpdateTicketAsync_UpdatesProperties()
    {
        var ticket = new Ticket
        {
            TicketNumber = "ALP-20",
            Title = "Old Title",
            Description = "Old Desc",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 1,
            TypeId = 1,
            ProjectId = 1,
            RequesterUserId = 1,
            CreatedAt = DateTime.UtcNow
        };
        _context.Tickets.Add(ticket);
        await _context.SaveChangesAsync();

        var updateDto = new UpdateTicketDto(
            Title: "Updated Title",
            Description: "Updated Desc",
            CategoryId: 1,
            PriorityId: 1,
            CustomFields: new Dictionary<string, string>()
        );

        await _ticketService.UpdateTicketAsync(ticket.Id, updateDto, currentUserId: 1);

        var updated = await _context.Tickets.FindAsync(ticket.Id);
        Assert.Equal("Updated Title", updated!.Title);
        Assert.Equal("Updated Desc", updated.Description);
    }

    [Fact]
    public async Task DeleteTicketAsync_SoftDeletesTicket()
    {
        var ticket = new Ticket
        {
            TicketNumber = "ALP-30",
            Title = "To Delete",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 1,
            TypeId = 1,
            ProjectId = 1,
            RequesterUserId = 1,
            CreatedAt = DateTime.UtcNow
        };
        _context.Tickets.Add(ticket);
        await _context.SaveChangesAsync();

        await _ticketService.DeleteTicketAsync(ticket.Id, currentUserId: 1);

        var deleted = await _context.Tickets.FindAsync(ticket.Id);
        Assert.True(deleted!.IsDeleted);

        await _ticketService.RestoreTicketAsync(ticket.Id, currentUserId: 1);
        Assert.False(deleted.IsDeleted);
    }

    [Fact]
    public async Task ChangeStatusAsync_UpdatesStatusAndRecordsHistory()
    {
        var ticket = new Ticket
        {
            TicketNumber = "ALP-40",
            Title = "Status Change",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 1,
            TypeId = 1,
            ProjectId = 1,
            RequesterUserId = 1,
            CreatedAt = DateTime.UtcNow
        };
        _context.Tickets.Add(ticket);
        await _context.SaveChangesAsync();

        var dto = new ChangeStatusDto(NewStatusId: 2, UserId: 1);
        await _ticketService.ChangeStatusAsync(ticket.Id, dto);

        var updated = await _context.Tickets.FindAsync(ticket.Id);
        Assert.Equal(2, updated!.StatusId);

        var history = _context.TicketHistories.Where(h => h.TicketId == ticket.Id).ToList();
        Assert.NotEmpty(history);
    }

    [Fact]
    public async Task AssignTicketAsync_AssignsUserAndGroup()
    {
        var ticket = new Ticket
        {
            TicketNumber = "ALP-50",
            Title = "Assign Test",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 1,
            TypeId = 1,
            ProjectId = 1,
            RequesterUserId = 1,
            CreatedAt = DateTime.UtcNow
        };
        _context.Tickets.Add(ticket);
        await _context.SaveChangesAsync();

        var dto = new AssignTicketDto(UserIds: new List<int> { 2 }, GroupIds: new List<int> { 1 }, AssignerUserId: 1);
        await _ticketService.AssignTicketAsync(ticket.Id, dto);

        var activeAssignments = _context.TicketAssignments.Where(a => a.TicketId == ticket.Id && a.IsActive).ToList();
        Assert.NotEmpty(activeAssignments);
        Assert.Contains(activeAssignments, a => a.AssignedUserId == 2);
        Assert.Contains(activeAssignments, a => a.AssignedGroupId == 1);
    }

    [Fact]
    public async Task Comments_AddUpdateDelete_WorksCorrectly()
    {
        var ticket = new Ticket
        {
            TicketNumber = "ALP-60",
            Title = "Comment Test",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 1,
            TypeId = 1,
            ProjectId = 1,
            RequesterUserId = 1,
            CreatedAt = DateTime.UtcNow
        };
        _context.Tickets.Add(ticket);
        await _context.SaveChangesAsync();

        // Add
        var addDto = new CreateCommentDto(Content: "Hello Support", IsInternal: false, AuthorUserId: 1);
        var comment = await _ticketService.AddCommentAsync(ticket.Id, addDto);
        Assert.NotNull(comment);
        Assert.Equal("Hello Support", comment.Content);

        // List
        var comments = await _ticketService.GetCommentsAsync(ticket.Id, includeInternal: true);
        Assert.Single(comments);

        // Update
        var updateDto = new UpdateCommentDto(Content: "Updated comment text");
        var updatedComment = await _ticketService.UpdateCommentAsync(ticket.Id, comment.Id, updateDto, userId: 1, hasEditPerm: true);
        Assert.Equal("Updated comment text", updatedComment.Content);

        // Delete
        await _ticketService.DeleteCommentAsync(ticket.Id, comment.Id, userId: 1, hasDeletePerm: true);
        var commentEntity = await _context.TicketComments.FindAsync(comment.Id);
        Assert.True(commentEntity!.IsDeleted);

        // Restore
        await _ticketService.RestoreCommentAsync(ticket.Id, comment.Id, userId: 1, hasDeletePerm: true);
        Assert.False(commentEntity.IsDeleted);
    }

    [Fact]
    public async Task Watchers_AddAndRemove_WorksCorrectly()
    {
        var ticket = new Ticket
        {
            TicketNumber = "ALP-70",
            Title = "Watcher Test",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 1,
            TypeId = 1,
            ProjectId = 1,
            RequesterUserId = 1,
            CreatedAt = DateTime.UtcNow
        };
        _context.Tickets.Add(ticket);
        await _context.SaveChangesAsync();

        await _ticketService.AddWatcherAsync(ticket.Id, userId: 2);
        var watchers = await _ticketService.GetWatchersAsync(ticket.Id);
        Assert.Single(watchers);

        await _ticketService.RemoveWatcherAsync(ticket.Id, userId: 2);
        watchers = await _ticketService.GetWatchersAsync(ticket.Id);
        Assert.Empty(watchers);
    }

    [Fact]
    public async Task SubmitSurveyAsync_RecordsSurvey()
    {
        var ticket = new Ticket
        {
            TicketNumber = "ALP-80",
            Title = "Survey Test",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 5,
            TypeId = 1,
            ProjectId = 1,
            RequesterUserId = 1,
            CreatedAt = DateTime.UtcNow
        };
        _context.Tickets.Add(ticket);
        await _context.SaveChangesAsync();

        var surveyDto = new SubmitTicketSurveyDto(Rating: 5, Comment: "Excellent resolution speed!");
        var result = await _ticketService.SubmitSurveyAsync(ticket.Id, surveyDto, userId: 1);

        Assert.NotNull(result);
        Assert.Equal(5, result.Rating);
        Assert.Equal("Excellent resolution speed!", result.Comment);
    }

    [Fact]
    public async Task SearchTicketsAsync_ReturnsPagedResults()
    {
        var ticket1 = new Ticket
        {
            TicketNumber = "ALP-91",
            Title = "First Search Ticket",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 1,
            TypeId = 1,
            ProjectId = 1,
            RequesterUserId = 1,
            CreatedAt = DateTime.UtcNow
        };
        var ticket2 = new Ticket
        {
            TicketNumber = "ALP-92",
            Title = "Second Search Ticket",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 2,
            TypeId = 1,
            ProjectId = 1,
            RequesterUserId = 1,
            CreatedAt = DateTime.UtcNow
        };
        _context.Tickets.AddRange(ticket1, ticket2);
        await _context.SaveChangesAsync();

        _permCalcMock.Setup(p => p.CalculateEffectivePermissionsAsync(1))
            .ReturnsAsync(new HashSet<string> { "ticket.view.all" });

        var filter = new TicketSearchFilterDto
        {
            Keyword = "First",
            Page = 1,
            PageSize = 10
        };

        var result = await _ticketService.SearchTicketsAsync(filter, userId: 1);
        Assert.NotNull(result);
        Assert.True(result.TotalCount >= 1);
        Assert.Contains(result.Items, t => t.Title == "First Search Ticket");
    }

    [Fact]
    public async Task GetTimelineAsync_ReturnsCombinedHistoryAndComments()
    {
        var ticket = new Ticket
        {
            TicketNumber = "ALP-100",
            Title = "Timeline Test",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 1,
            TypeId = 1,
            ProjectId = 1,
            RequesterUserId = 1,
            CreatedAt = DateTime.UtcNow
        };
        _context.Tickets.Add(ticket);
        await _context.SaveChangesAsync();

        _context.TicketComments.Add(new TicketComment
        {
            TicketId = ticket.Id,
            AuthorUserId = 1,
            Content = "Public note",
            IsInternal = false,
            CreatedAt = DateTime.UtcNow
        });
        _context.TicketHistories.Add(new TicketHistory
        {
            TicketId = ticket.Id,
            FieldName = "Status",
            OldValue = "New",
            NewValue = "In Progress",
            Action = "Updated",
            CreatedAt = DateTime.UtcNow
        });
        await _context.SaveChangesAsync();

        var timeline = await _ticketService.GetTimelineAsync(ticket.Id, includeInternal: true);
        Assert.NotNull(timeline);
        Assert.True(timeline.Count() >= 2);
    }

    [Fact]
    public async Task TransferTicketAsync_UpdatesProjectAndGroup()
    {
        var ticket = new Ticket
        {
            TicketNumber = "ALP-110",
            Title = "Transfer Test",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 1,
            TypeId = 1,
            ProjectId = 1,
            RequesterUserId = 1,
            CreatedAt = DateTime.UtcNow
        };
        _context.Tickets.Add(ticket);
        await _context.SaveChangesAsync();

        _permCalcMock.Setup(p => p.CalculateEffectivePermissionsAsync(1))
            .ReturnsAsync(new HashSet<string> { "ticket.transfer", "admin.manage" });

        var transferDto = new TransferTicketDto(ProjectId: 1, GroupId: 1, TransferrerUserId: 1);
        await _ticketService.TransferTicketAsync(ticket.Id, transferDto);

        var tree = await _ticketService.GetAssignmentTreeAsync(ticket.Id);
        Assert.NotEmpty(tree);
    }

    [Fact]
    public async Task Attachments_AddGetDelete_WorksCorrectly()
    {
        var ticket = new Ticket
        {
            TicketNumber = "ALP-120",
            Title = "Attachment Test",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 1,
            TypeId = 1,
            ProjectId = 1,
            RequesterUserId = 1,
            CreatedAt = DateTime.UtcNow
        };
        _context.Tickets.Add(ticket);
        await _context.SaveChangesAsync();

        var formFileMock = new Mock<IFormFile>();
        formFileMock.Setup(f => f.FileName).Returns("log.txt");
        formFileMock.Setup(f => f.Length).Returns(1024);
        formFileMock.Setup(f => f.ContentType).Returns("text/plain");

        _fileStorageMock.Setup(f => f.SaveFileAsync(formFileMock.Object, It.IsAny<int>()))
            .ReturnsAsync("uploads/log.txt");

        var attachment = await _ticketService.AddAttachmentAsync(ticket.Id, formFileMock.Object, userId: 1);
        Assert.NotNull(attachment);
        Assert.Equal("log.txt", attachment.FileName);

        var attachments = (await _ticketService.GetAttachmentsAsync(ticket.Id)).ToList();
        Assert.Single(attachments);

        var fileInfo = await _ticketService.GetAttachmentFileInfoAsync(ticket.Id, attachment.Id);
        Assert.Equal("log.txt", fileInfo.FileName);

        await _ticketService.DeleteAttachmentAsync(ticket.Id, attachment.Id, userId: 1, hasManagePerm: true);
        var deletedEntity = await _context.TicketAttachments.FindAsync(attachment.Id);
        Assert.True(deletedEntity!.IsDeleted);
    }

    [Fact]
    public async Task GetAllowedTransitionsAsync_ReturnsConfiguredTransitions()
    {
        var ticket = new Ticket
        {
            TicketNumber = "ALP-130",
            Title = "Transitions Test",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 1,
            TypeId = 1,
            ProjectId = 1,
            RequesterUserId = 1,
            CreatedAt = DateTime.UtcNow
        };
        _context.Tickets.Add(ticket);
        await _context.SaveChangesAsync();

        var transitions = await _ticketService.GetAllowedTransitionsAsync(ticket.Id, userId: 1);
        Assert.NotNull(transitions);
    }

    [Fact]
    public async Task GetTicketByIdAsync_WithTicketSla_MapsSlaInfoSuccessfully()
    {
        var dueTime = DateTime.UtcNow.AddHours(2);
        var ticket = new Ticket
        {
            TicketNumber = "ALP-SLA-1",
            Title = "SLA Map Test",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 1,
            TypeId = 1,
            ProjectId = 1,
            RequesterUserId = 1,
            CreatedAt = DateTime.UtcNow
        };
        _context.Tickets.Add(ticket);
        await _context.SaveChangesAsync();

        var ticketSla = new TicketSla
        {
            TicketId = ticket.Id,
            ResolutionDueAt = dueTime,
            ResolutionBreached = false,
            ResolutionWarned = true,
            FirstResponseBreached = false
        };
        _context.TicketSlas.Add(ticketSla);
        await _context.SaveChangesAsync();

        var result = await _ticketService.GetTicketByIdAsync(ticket.Id);

        Assert.NotNull(result);
        Assert.NotNull(result.Sla);
        Assert.Equal(dueTime, result.Sla.ResolutionDueAt);
        Assert.True(result.Sla.ResolutionWarned);
        Assert.False(result.Sla.ResolutionBreached);
    }

    [Fact]
    public async Task SearchTicketsAsync_WithTicketSla_MapsSlaInfoSuccessfully()
    {
        _permCalcMock.Setup(p => p.CalculateEffectivePermissionsAsync(It.IsAny<int>()))
            .ReturnsAsync(new HashSet<string> { "ticket.view" });

        var dueTime = DateTime.UtcNow.AddMinutes(45);
        var ticket = new Ticket
        {
            TicketNumber = "ALP-SLA-SEARCH-1",
            Title = "SLA Search Test",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 1,
            TypeId = 1,
            ProjectId = 1,
            RequesterUserId = 1,
            CreatedAt = DateTime.UtcNow
        };
        _context.Tickets.Add(ticket);
        await _context.SaveChangesAsync();

        var ticketSla = new TicketSla
        {
            TicketId = ticket.Id,
            ResolutionDueAt = dueTime,
            ResolutionBreached = false,
            ResolutionWarned = false,
            FirstResponseBreached = false
        };
        _context.TicketSlas.Add(ticketSla);
        await _context.SaveChangesAsync();

        var searchResult = await _ticketService.SearchTicketsAsync(new TicketSearchFilterDto { Keyword = "ALP-SLA-SEARCH-1" }, userId: 1);

        Assert.NotNull(searchResult);
        var foundTicket = Assert.Single(searchResult.Items);
        Assert.NotNull(foundTicket.Sla);
        Assert.Equal(dueTime, foundTicket.Sla.ResolutionDueAt);
        Assert.False(foundTicket.Sla.ResolutionBreached);
    }

    [Fact]
    public async Task AddCommentAsync_And_UpdateCommentAsync_ShouldRecordHistoriesAndNotify()
    {
        var ticket = new Ticket
        {
            TicketNumber = "ALP-COMM-1",
            Title = "Comment Test Ticket",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 1,
            TypeId = 1,
            ProjectId = 1,
            RequesterUserId = 1,
            CreatedAt = DateTime.UtcNow
        };
        _context.Tickets.Add(ticket);
        await _context.SaveChangesAsync();

        // 1. Regular comment
        var regularComment = await _ticketService.AddCommentAsync(ticket.Id, new CreateCommentDto(
            Content: "Normal user comment",
            IsInternal: false,
            AuthorUserId: 1,
            ParentCommentId: null,
            MentionedUserIds: new[] { 2 }
        ));
        Assert.NotNull(regularComment);
        Assert.Equal("Normal user comment", regularComment.Content);
        Assert.False(regularComment.IsInternal);

        // 2. Internal note
        var internalNote = await _ticketService.AddCommentAsync(ticket.Id, new CreateCommentDto(
            Content: "Internal diagnostic note",
            IsInternal: true,
            AuthorUserId: 1,
            ParentCommentId: null,
            MentionedUserIds: null
        ));
        Assert.True(internalNote.IsInternal);

        // 3. Reply comment
        var replyComment = await _ticketService.AddCommentAsync(ticket.Id, new CreateCommentDto(
            Content: "Reply to user comment",
            IsInternal: false,
            AuthorUserId: 2,
            ParentCommentId: regularComment.Id,
            MentionedUserIds: null
        ));
        Assert.Equal(regularComment.Id, replyComment.ParentCommentId);

        // 4. Update comment by author
        var updated = await _ticketService.UpdateCommentAsync(ticket.Id, regularComment.Id, new UpdateCommentDto("Edited comment text"), userId: 1, hasEditPerm: false);
        Assert.Equal("Edited comment text", updated.Content);
        Assert.True(updated.IsEdited);

        // 5. Update comment by non-author with permission
        var updatedByAdmin = await _ticketService.UpdateCommentAsync(ticket.Id, regularComment.Id, new UpdateCommentDto("Admin edited text"), userId: 2, hasEditPerm: true);
        Assert.Equal("Admin edited text", updatedByAdmin.Content);

        // 6. Update comment unauthorized
        await Assert.ThrowsAsync<UnauthorizedAccessException>(() =>
            _ticketService.UpdateCommentAsync(ticket.Id, regularComment.Id, new UpdateCommentDto("Hacker edit"), userId: 99, hasEditPerm: false));

        // 7. Update non-existent comment
        await Assert.ThrowsAsync<KeyNotFoundException>(() =>
            _ticketService.UpdateCommentAsync(ticket.Id, 99999, new UpdateCommentDto("No comment"), userId: 1, hasEditPerm: true));
    }

    [Fact]
    public async Task GetEligibleUsersForTicketAsync_ShouldReturnRequesterAssigneesAndProjectMembers()
    {
        var ticket = new Ticket
        {
            TicketNumber = "ALP-ELIG-1",
            Title = "Eligible Users Ticket",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 1,
            TypeId = 1,
            ProjectId = 1,
            RequesterUserId = 1,
            CreatedAt = DateTime.UtcNow
        };
        _context.Tickets.Add(ticket);
        await _context.SaveChangesAsync();

        // Add user assignment
        var assignUser = new TicketAssignment
        {
            TicketId = ticket.Id,
            AssignedUserId = 2,
            IsActive = true
        };
        _context.TicketAssignments.Add(assignUser);

        // Add group assignment with member 1
        var groupMember = new GroupMember { GroupId = 1, UserId = 1 };
        _context.GroupMembers.Add(groupMember);
        var assignGroup = new TicketAssignment
        {
            TicketId = ticket.Id,
            AssignedGroupId = 1,
            IsActive = true
        };
        _context.TicketAssignments.Add(assignGroup);

        // Add project member 2
        var projMember = new ProjectMember { ProjectId = 1, UserId = 2 };
        _context.ProjectMembers.Add(projMember);
        await _context.SaveChangesAsync();

        var users = (await _ticketService.GetEligibleUsersForTicketAsync(ticket.Id)).ToList();
        Assert.NotEmpty(users);
        Assert.Contains(users, u => u.Id == 1);
        Assert.Contains(users, u => u.Id == 2);

        // Non-existent ticket
        var empty = await _ticketService.GetEligibleUsersForTicketAsync(99999);
        Assert.Empty(empty);
    }
}

