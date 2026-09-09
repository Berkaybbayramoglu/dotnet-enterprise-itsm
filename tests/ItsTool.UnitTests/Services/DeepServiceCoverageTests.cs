using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.Auth;
using ItsTool.Domain.Entities.KnowledgeBase;
using ItsTool.Domain.Entities.Notification;
using ItsTool.Domain.Entities.Organization;
using ItsTool.Domain.Entities.Project;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Infrastructure.Data;
using ItsTool.Infrastructure.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Moq;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class DeepServiceCoverageTests
{
    private static ItsToolDbContext CreateDbContext(string dbName)
    {
        var options = new DbContextOptionsBuilder<ItsToolDbContext>()
            .UseInMemoryDatabase(databaseName: dbName)
            .Options;
        return new ItsToolDbContext(options);
    }

    [Fact]
    public async Task AuthService_LoginAndGetMe_ShouldHandleAllScenarios()
    {
        var db = CreateDbContext("AuthServiceDeepDb");
        var hash = BCrypt.Net.BCrypt.HashPassword("CorrectPassword123!");
        var user = new User { Id = 1, Username = "johndoe", Email = "john@example.com", PasswordHash = hash, IsActive = true, ProfilePhoto = "photo.png" };
        var role = new Role { Id = 1, Name = "Agent", IsActive = true };
        db.Users.Add(user);
        db.Roles.Add(role);
        db.UserRoles.Add(new UserRole { UserId = 1, RoleId = 1, Role = role });
        db.Groups.Add(new Group { Id = 10, Name = "Tier 1", IsActive = true });
        db.GroupMembers.Add(new GroupMember { UserId = 1, GroupId = 10 });
        var perm = new Permission { Id = 5, Key = "ticket.close", Name = "Close", Description = "Close ticket" };
        db.Permissions.Add(perm);
        db.UserPermissionOverrides.Add(new UserPermissionOverride { UserId = 1, PermissionId = 5, IsGranted = true, Permission = perm });
        db.KnowledgeArticles.Add(new KnowledgeArticle { Id = 1, Title = "Doc", Content = "Body", AuthorUserId = 1 });
        await db.SaveChangesAsync();

        var tokenServiceMock = new Mock<ITokenService>();
        tokenServiceMock.Setup(t => t.GenerateToken(1, "johndoe", It.IsAny<IEnumerable<string>>(), It.IsAny<IEnumerable<string>>()))
            .Returns("fake-jwt-token");

        var permCalcMock = new Mock<IPermissionCalculator>();
        permCalcMock.Setup(p => p.CalculateEffectivePermissionsAsync(1))
            .ReturnsAsync(new HashSet<string> { "ticket.view", "ticket.close" });

        var config = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?> { { "Jwt:ExpiryMinutes", "60" } }).Build();

        var authService = new AuthService(db, tokenServiceMock.Object, permCalcMock.Object, config);

        // 1. Success login
        var loginResp = await authService.LoginAsync(new LoginRequestDto("johndoe", "CorrectPassword123!"));
        Assert.Equal("fake-jwt-token", loginResp.Token);
        Assert.Equal("johndoe", loginResp.Username);

        // 2. Wrong password
        await Assert.ThrowsAsync<UnauthorizedAccessException>(() => authService.LoginAsync(new LoginRequestDto("johndoe", "WrongPass")));

        // 3. User not found
        await Assert.ThrowsAsync<UnauthorizedAccessException>(() => authService.LoginAsync(new LoginRequestDto("nobody", "Pass")));

        // 4. GetMe success
        var me = await authService.GetMeAsync(1);
        Assert.Equal("johndoe", me.Username);
        Assert.Single(me.Groups);
        Assert.Single(me.Roles);
        Assert.Single(me.Overrides);
        Assert.Equal(1, me.KbArticleCount);

        // 5. GetMe missing user
        await Assert.ThrowsAsync<UnauthorizedAccessException>(() => authService.GetMeAsync(999));
    }

    [Fact]
    public async Task DepartmentService_AllMethods_ShouldFunctionProperly()
    {
        var db = CreateDbContext("DeptServiceDeepDb");
        var repo = new Repository<Department>(db);
        var service = new DepartmentService(repo);

        // Create
        var created = await service.CreateAsync(new CreateDepartmentDto("Support", "Customer support", "#FF0000"));
        Assert.Equal("Support", created.Name);

        // GetAll
        var all = await service.GetAllAsync();
        Assert.Single(all);

        // GetById
        var getDept = await service.GetByIdAsync(created.Id);
        Assert.NotNull(getDept);
        Assert.Null(await service.GetByIdAsync(999));

        // Update
        await service.UpdateAsync(created.Id, new UpdateDepartmentDto("Support Tier 1", "Updated desc", true, "#00FF00"));
        var updated = await service.GetByIdAsync(created.Id);
        Assert.Equal("Support Tier 1", updated!.Name);

        await Assert.ThrowsAsync<KeyNotFoundException>(() => service.UpdateAsync(999, new UpdateDepartmentDto("N", "D", true, "#fff")));

        // Delete
        await service.DeleteAsync(created.Id);
        Assert.Null(await service.GetByIdAsync(created.Id));
    }

    [Fact]
    public async Task ProjectService_MemberManagement_ShouldAddAndRemoveMembers()
    {
        var db = CreateDbContext("ProjectServiceDeepDb");
        var repo = new Repository<Project>(db);
        var service = new ProjectService(repo, db);

        var project = await service.CreateAsync(new CreateProjectDto("Billing System", "BILL", "Billing app"));
        Assert.Equal("BILL", project.ProjectKey);

        // Add Member
        await service.AddMemberAsync(project.Id, 10);
        Assert.True(await db.ProjectMembers.AnyAsync(pm => pm.ProjectId == project.Id && pm.UserId == 10));

        // Add duplicate member (noop)
        await service.AddMemberAsync(project.Id, 10);
        Assert.Equal(1, await db.ProjectMembers.CountAsync(pm => pm.ProjectId == project.Id && pm.UserId == 10));

        // Remove Member
        await service.RemoveMemberAsync(project.Id, 10);
        Assert.False(await db.ProjectMembers.AnyAsync(pm => pm.ProjectId == project.Id && pm.UserId == 10));

        // Update with status
        await service.UpdateAsync(project.Id, new UpdateProjectDto("Billing Sys 2", "BILL2", "Desc", "Inactive"));
        var updated = await service.GetByIdAsync(project.Id);
        Assert.Equal("Inactive", updated!.Status);

        // Delete
        await service.DeleteAsync(project.Id);
        Assert.Null(await service.GetByIdAsync(project.Id));
    }

    [Fact]
    public async Task NotificationService_MarkAsReadAndDelete_ShouldUpdateCorrectly()
    {
        var db = CreateDbContext("NotificationServiceDeepDb");
        db.Notifications.Add(new Notification { Id = 1, UserId = 5, Title = "N1", Body = "B1", IsRead = false, Priority = "Normal", CreatedAt = DateTime.UtcNow });
        db.Notifications.Add(new Notification { Id = 2, UserId = 5, Title = "N2", Body = "B2", IsRead = false, Priority = "High", CreatedAt = DateTime.UtcNow });
        await db.SaveChangesAsync();

        var service = new NotificationService(db);

        // Get user notifications
        var list = (await service.GetUserNotificationsAsync(5)).ToList();
        Assert.Equal(2, list.Count);

        // Mark one as read
        await service.MarkAsReadAsync(1, 5);
        var notif1 = await db.Notifications.FindAsync(1);
        Assert.True(notif1!.IsRead);

        // Mark all as read
        await service.MarkAllAsReadAsync(5);
        var notif2 = await db.Notifications.FindAsync(2);
        Assert.True(notif2!.IsRead);

        // Delete one
        await service.DeleteNotificationAsync(1, 5);
        Assert.True((await db.Notifications.FindAsync(1))!.IsDeleted);

        // Delete all
        await service.DeleteAllNotificationsAsync(5);
        Assert.True((await db.Notifications.FindAsync(2))!.IsDeleted);
    }

    [Fact]
    public async Task UserService_DeactivateAndGroupMemberships_ShouldHandleAuditAndAssignments()
    {
        var db = CreateDbContext("UserServiceDeepDb");
        var user = new User { Id = 10, Username = "agent_bob", Email = "bob@test.com", PasswordHash = "h", IsActive = true, ProfilePhoto = "old.jpg" };
        db.Users.Add(user);
        db.Groups.Add(new Group { Id = 1, Name = "ServiceDesk", IsActive = true });
        db.Groups.Add(new Group { Id = 2, Name = "NetworkTeam", IsActive = true });
        user.GroupMemberships.Add(new GroupMember { UserId = 10, GroupId = 1 });

        var openStatus = new Status { Id = 1, Name = "Open", IsClosedStatus = false };
        db.Statuses.Add(openStatus);
        var ticket = new Ticket { Id = 20, Title = "Bug", StatusId = 1, Status = openStatus };
        db.Tickets.Add(ticket);
        db.TicketAssignments.Add(new TicketAssignment { TicketId = 20, AssignedUserId = 10, IsActive = true, Ticket = ticket });
        await db.SaveChangesAsync();

        var httpContext = new DefaultHttpContext();
        httpContext.User = new ClaimsPrincipal(new ClaimsIdentity(new[] { new Claim(ClaimTypes.NameIdentifier, "1") }));
        var accessorMock = new Mock<IHttpContextAccessor>();
        accessorMock.Setup(a => a.HttpContext).Returns(httpContext);

        var repo = new Repository<User>(db);
        var service = new UserService(repo, db, accessorMock.Object);

        // Update user: change profile photo, update group membership (remove 1, add 2), and deactivate user
        var updateDto = new UpdateUserDto(
            Email: "bob.new@test.com",
            FirstName: "Bob",
            LastName: "Smith",
            IsActive: false, // deactivate
            DepartmentId: null,
            ProfilePhoto: "new.jpg",
            GroupIds: new[] { 2 }
        );

        await service.UpdateAsync(10, updateDto);

        // Verify deactivation unassigned open ticket
        var assignment = await db.TicketAssignments.FirstAsync(a => a.TicketId == 20 && a.AssignedUserId == 10);
        Assert.False(assignment.IsActive);
        Assert.True(await db.TicketHistories.AnyAsync(h => h.TicketId == 20 && h.Action == "Unassigned"));

        // Verify profile photo and group membership audit logs
        Assert.True(await db.SystemAuditLogs.AnyAsync(l => l.EntityId == "10" && l.Action == "ProfilePhotoUpdated"));
        Assert.True(await db.SystemAuditLogs.AnyAsync(l => l.EntityId == "10" && l.FieldName == "GroupMemberships"));

        // Roles & Permissions overrides
        var role = new Role { Id = 3, Name = "Manager" };
        db.Roles.Add(role);
        await db.SaveChangesAsync();

        await service.AssignRoleAsync(10, 3);
        Assert.True(await db.UserRoles.AnyAsync(ur => ur.UserId == 10 && ur.RoleId == 3));

        await service.RevokeRoleAsync(10, 3);
        Assert.False(await db.UserRoles.AnyAsync(ur => ur.UserId == 10 && ur.RoleId == 3));

        // Add permission override (new then update)
        await service.AddPermissionOverrideAsync(10, 5, true);
        Assert.True(await db.UserPermissionOverrides.AnyAsync(po => po.UserId == 10 && po.PermissionId == 5 && po.IsGranted));

        await service.AddPermissionOverrideAsync(10, 5, false);
        Assert.False((await db.UserPermissionOverrides.FirstAsync(po => po.UserId == 10 && po.PermissionId == 5)).IsGranted);
    }

    [Fact]
    public async Task KnowledgeBaseService_SearchApproveRejectAndVote_ShouldExecute()
    {
        var db = CreateDbContext("KbServiceDeepDb");
        var cat = new KnowledgeCategory { Id = 1, Name = "IT Hardware" };
        db.KnowledgeCategories.Add(cat);

        var article = new KnowledgeArticle
        {
            Id = 1,
            Title = "How to configure VPN",
            Content = "Step 1: open client. Step 2: enter credentials.",
            CategoryId = 1,
            Category = cat,
            Status = ArticleStatus.PendingReview,
            Visibility = ArticleVisibility.Public,
            AuthorUserId = 3,
            CreatedAt = DateTime.UtcNow
        };
        db.KnowledgeArticles.Add(article);
        await db.SaveChangesAsync();

        var permCalcMock = new Mock<IPermissionCalculator>();
        permCalcMock.Setup(p => p.CalculateEffectivePermissionsAsync(1)).ReturnsAsync(new HashSet<string> { "kb.manage" });
        permCalcMock.Setup(p => p.CalculateEffectivePermissionsAsync(2)).ReturnsAsync(new HashSet<string>());

        var signalRPusherMock = new Mock<ISignalRPusher>();
        signalRPusherMock.Setup(s => s.PushNotificationAsync(It.IsAny<int>(), It.IsAny<object>())).Returns(Task.CompletedTask);

        var service = new KnowledgeBaseService(db, permCalcMock.Object, signalRPusherMock.Object);

        // 1. Regular user search (doesn't see pending review of other user)
        var unapprovedSearchResult = await service.SearchArticlesAsync(2, "VPN", null);
        Assert.Empty(unapprovedSearchResult);

        // 2. Admin search (sees pending review)
        var adminSearchResult = await service.SearchArticlesAsync(1, "VPN", null);
        Assert.Single(adminSearchResult);

        // 3. Regular user GetArticle returns null for pending review
        var nullArticle = await service.GetArticleAsync(1, 2);
        Assert.Null(nullArticle);

        // 4. Review article - publish it
        await service.ReviewArticleAsync(1, new ReviewKbArticleDto(ArticleStatus.Published, "Looks great!"), 1);
        var publishedArticle = await service.GetArticleAsync(1, 2);
        Assert.NotNull(publishedArticle);
        Assert.Equal(1, publishedArticle.ViewCount); // increments view count
        Assert.Equal(ArticleStatus.Published, publishedArticle.Status);

        // 5. Review article - request revision
        await service.ReviewArticleAsync(1, new ReviewKbArticleDto(ArticleStatus.NeedsRevision, "Please add diagrams"), 1);
        var revisionArticle = await db.KnowledgeArticles.FindAsync(1);
        Assert.Equal(ArticleStatus.NeedsRevision, revisionArticle!.Status);

        // 6. Categories CRUD
        var newCat = await service.CreateCategoryAsync(new CreateKbCategoryDto("Security", null));
        Assert.Equal("Security", newCat.Name);
        await service.UpdateCategoryAsync(newCat.Id, new CreateKbCategoryDto("InfoSec", null));
        var catList = await service.GetCategoriesAsync();
        Assert.Contains(catList, c => c.Name == "InfoSec");
        await service.DeleteCategoryAsync(newCat.Id);

        // 7. Delete article
        await service.DeleteArticleAsync(1, 1);
        var deleted = await db.KnowledgeArticles.FindAsync(1);
        Assert.True(deleted!.IsDeleted);
    }
}
