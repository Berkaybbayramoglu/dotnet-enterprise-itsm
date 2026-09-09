using System;
using System.Collections.Generic;
using System.Security.Claims;
using System.Threading.Tasks;
using ItsTool.API.Controllers;
using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities;
using ItsTool.Domain.Entities.Config;
using ItsTool.Domain.Entities.Organization;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Domain.Entities.Workflow;
using ItsTool.Infrastructure.Data;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Moq;
using Xunit;

namespace ItsTool.UnitTests.Controllers;

public class ExtraControllersCoverageTests
{
    private static ItsToolDbContext CreateDbContext(string dbName)
    {
        var options = new DbContextOptionsBuilder<ItsToolDbContext>()
            .UseInMemoryDatabase(databaseName: dbName)
            .Options;
        return new ItsToolDbContext(options);
    }

    private static ControllerContext CreateControllerContextWithUser(int userId)
    {
        var claims = new[] { new Claim(ClaimTypes.NameIdentifier, userId.ToString()) };
        var identity = new ClaimsIdentity(claims, "TestAuth");
        return new ControllerContext
        {
            HttpContext = new DefaultHttpContext { User = new ClaimsPrincipal(identity) }
        };
    }

    [Fact]
    public async Task SystemController_SeedDatabase_ShouldHandleAlreadySeededAndNewSeed()
    {
        var db = CreateDbContext("SystemControllerDb1");
        db.Users.Add(new User { Id = 1, Username = "admin", Email = "a@a.com", PasswordHash = "hash" });
        await db.SaveChangesAsync();

        var controller = new SystemController(new DataSeeder(db), db);

        var result = await controller.SeedDatabase();
        var okResult = Assert.IsType<OkObjectResult>(result);
        var response = Assert.IsType<SystemController.SystemResponse>(okResult.Value);
        Assert.Contains("already seeded", response.Message);

        var dbEmpty = CreateDbContext("SystemControllerDbEmpty");
        var controllerEmpty = new SystemController(new DataSeeder(dbEmpty), dbEmpty);

        var freshResult = await controllerEmpty.SeedDatabase();
        var freshOk = Assert.IsType<OkObjectResult>(freshResult);
        var freshResp = Assert.IsType<SystemController.SystemResponse>(freshOk.Value);
        Assert.Contains("applied successfully", freshResp.Message);
    }

    [Fact]
    public void SystemController_TestDatabaseConnection_ShouldReturnOk()
    {
        var db = CreateDbContext("SystemControllerDbConn");
        db.Users.Add(new User { Id = 1, Username = "u1", Email = "u1@t.com", PasswordHash = "p" });
        db.SaveChanges();

        var controller = new SystemController(new DataSeeder(db), db);

        var result = controller.TestDatabaseConnection();
        var okResult = Assert.IsType<OkObjectResult>(result);
        var response = Assert.IsType<SystemController.SystemResponse>(okResult.Value);
        Assert.Contains("Connection OK", response.Message);
    }

    [Fact]
    public async Task SystemController_IngestEmail_ShouldCallService()
    {
        var db = CreateDbContext("SystemControllerDbIngest");
        var controller = new SystemController(new DataSeeder(db), db);

        var emailServiceMock = new Mock<IEmailIngestionService>();
        emailServiceMock.Setup(e => e.ProcessIncomingEmailAsync(It.IsAny<EmailIngestionDto>()))
            .Returns(Task.CompletedTask);

        var dto = new EmailIngestionDto("msg-123", "test@user.com", "Issue", "Broken");
        var result = await controller.IngestEmail(emailServiceMock.Object, dto);

        var okResult = Assert.IsType<OkObjectResult>(result);
        emailServiceMock.Verify(e => e.ProcessIncomingEmailAsync(dto), Times.Once);
    }

    [Fact]
    public async Task TestController_GetRoles_ShouldFormatRoleList()
    {
        var roleServiceMock = new Mock<IRoleService>();
        roleServiceMock.Setup(r => r.GetAllAsync()).ReturnsAsync(new List<RoleDto>
        {
            new(1, "Admin", "Admin desc", true, new[] { "all.manage", "ticket.view" })
        });

        var controller = new TestController(roleServiceMock.Object);
        var result = await controller.GetRoles();

        var okResult = Assert.IsType<OkObjectResult>(result);
        var content = Assert.IsType<string>(okResult.Value);
        Assert.Contains("Admin: all.manage,ticket.view", content);
    }

    [Fact]
    public async Task AssignmentRuleController_Crud_ShouldFunctionCorrectly()
    {
        var db = CreateDbContext("AssignmentRuleControllerDb");
        var auditMock = new Mock<ISystemAuditService>();
        var controller = new AssignmentRuleController(db, auditMock.Object);

        // 1. Create
        var createDto = new CreateAssignmentRuleDto("Rule 1", 1, null, null, null, 2, null, 1, true);
        var createResult = await controller.CreateRule(createDto);
        var createdAction = Assert.IsType<CreatedAtActionResult>(createResult);
        var createdDto = Assert.IsType<AssignmentRuleDto>(createdAction.Value);
        Assert.Equal("Rule 1", createdDto.Name);

        // 2. Get All
        var getAllResult = await controller.GetRules();
        var okAll = Assert.IsType<OkObjectResult>(getAllResult);
        var list = Assert.IsAssignableFrom<IEnumerable<AssignmentRuleDto>>(okAll.Value);
        Assert.Single(list);

        // 3. Get By Id
        var getByIdResult = await controller.GetRuleById(createdDto.Id);
        var okById = Assert.IsType<OkObjectResult>(getByIdResult);
        Assert.Equal(createdDto.Id, ((AssignmentRuleDto)okById.Value!).Id);

        var notFoundGet = await controller.GetRuleById(999);
        Assert.IsType<NotFoundResult>(notFoundGet);

        // 4. Update
        var updateDto = new UpdateAssignmentRuleDto("Rule 1 Updated", 1, null, null, null, 2, null, 2, true);
        var updateResult = await controller.UpdateRule(createdDto.Id, updateDto);
        Assert.IsType<NoContentResult>(updateResult);

        var notFoundUpdate = await controller.UpdateRule(999, updateDto);
        Assert.IsType<NotFoundResult>(notFoundUpdate);

        // 5. Delete
        var deleteResult = await controller.DeleteRule(createdDto.Id);
        Assert.IsType<NoContentResult>(deleteResult);

        var notFoundDelete = await controller.DeleteRule(999);
        Assert.IsType<NotFoundResult>(notFoundDelete);
    }

    [Fact]
    public async Task SavedFilterController_Crud_ShouldFunctionCorrectly()
    {
        var db = CreateDbContext("SavedFilterControllerDb");
        var controller = new SavedFilterController(db)
        {
            ControllerContext = CreateControllerContextWithUser(42)
        };

        // 1. Create
        var createDto = new CreateSavedFilterDto("My Filter", "{\"status\": 1}");
        var createResult = await controller.CreateFilter(createDto);
        var createdAction = Assert.IsType<CreatedAtActionResult>(createResult);
        var createdDto = Assert.IsType<SavedFilterDto>(createdAction.Value);
        Assert.Equal("My Filter", createdDto.Name);
        Assert.Equal(42, createdDto.UserId);

        // 2. Get My Filters
        var getAllResult = await controller.GetMyFilters();
        var okAll = Assert.IsType<OkObjectResult>(getAllResult);
        var list = Assert.IsAssignableFrom<IEnumerable<SavedFilterDto>>(okAll.Value);
        Assert.Single(list);

        // 3. Get By Id
        var getByIdResult = await controller.GetFilterById(createdDto.Id);
        var okById = Assert.IsType<OkObjectResult>(getByIdResult);
        Assert.Equal(createdDto.Id, ((SavedFilterDto)okById.Value!).Id);

        var notFoundGet = await controller.GetFilterById(999);
        Assert.IsType<NotFoundResult>(notFoundGet);

        // 4. Delete
        var deleteResult = await controller.DeleteFilter(createdDto.Id);
        Assert.IsType<NoContentResult>(deleteResult);

        var notFoundDelete = await controller.DeleteFilter(999);
        Assert.IsType<NotFoundResult>(notFoundDelete);
    }

    [Fact]
    public async Task WorkflowController_AdditionalScenarios_ShouldHandleErrors()
    {
        var serviceMock = new Mock<IWorkflowService>();
        serviceMock.Setup(s => s.GetWorkflowsAsync(null)).ReturnsAsync(new List<WorkflowDto>());
        serviceMock.Setup(s => s.UpdateWorkflowAsync(99, It.IsAny<UpdateWorkflowDto>())).ThrowsAsync(new KeyNotFoundException());
        serviceMock.Setup(s => s.CreateTransitionAsync(It.IsAny<CreateWorkflowTransitionDto>()))
            .ThrowsAsync(new InvalidOperationException("Invalid transition"));
        serviceMock.Setup(s => s.UpdateTransitionAsync(99, It.IsAny<UpdateWorkflowTransitionDto>()))
            .ThrowsAsync(new KeyNotFoundException());
        serviceMock.Setup(s => s.UpdateTransitionAsync(1, It.IsAny<UpdateWorkflowTransitionDto>()))
            .ThrowsAsync(new InvalidOperationException("Duplicate transition"));

        var controller = new WorkflowController(serviceMock.Object);

        // Get missing workflow by id
        var missingWf = await controller.GetWorkflowById(99);
        Assert.IsType<NotFoundResult>(missingWf);

        // Update missing workflow
        var updateMissing = await controller.UpdateWorkflow(99, new UpdateWorkflowDto("Wf", null, null, true));
        Assert.IsType<NotFoundResult>(updateMissing);

        // Create invalid transition
        var invalidCreate = await controller.CreateTransition(new CreateWorkflowTransitionDto(1, 1, 2, "Submit", null, 1));
        Assert.IsType<BadRequestObjectResult>(invalidCreate);

        // Update missing transition
        var notFoundTransition = await controller.UpdateTransition(99, new UpdateWorkflowTransitionDto(1, 2, "Submit", null, 1, true));
        Assert.IsType<NotFoundResult>(notFoundTransition);

        // Update transition invalid op
        var badReqTransition = await controller.UpdateTransition(1, new UpdateWorkflowTransitionDto(1, 2, "Submit", null, 1, true));
        Assert.IsType<BadRequestObjectResult>(badReqTransition);

        // Delete transition
        var deleteResult = await controller.DeleteTransition(5);
        Assert.IsType<NoContentResult>(deleteResult);
    }

    [Fact]
    public async Task AuditLogController_ShouldFilterTicketAndSystemLogs()
    {
        var db = CreateDbContext("AuditLogControllerDb");
        db.TicketHistories.Add(new TicketHistory { Id = 1, TicketId = 12, Action = "Create", CreatedBy = "10", CreatedAt = DateTime.UtcNow });
        db.SystemAuditLogs.Add(new SystemAuditLog { Id = 1, EntityType = "User", EntityId = "5", Action = "Create", CreatedBy = "10", CreatedAt = DateTime.UtcNow });
        await db.SaveChangesAsync();

        var controller = new AuditLogController(db);

        // Filter by ITS-12
        var filterWithPrefix = new AuditLogFilterDto(Ticket: "ITS-12", Action: "Create", UserId: 10, FromDate: null, ToDate: null, Page: 1, PageSize: 10);
        var resultPrefix = await controller.GetAuditLogs(filterWithPrefix);
        var okPrefix = Assert.IsType<OkObjectResult>(resultPrefix);
        var dtoPrefix = Assert.IsType<PaginatedAuditLogDto>(okPrefix.Value);
        Assert.Single(dtoPrefix.Items);

        // Filter by plain number 12
        var filterPlain = new AuditLogFilterDto(Ticket: "12", Action: null, UserId: null, FromDate: null, ToDate: null, Page: 1, PageSize: 10);
        var resultPlain = await controller.GetAuditLogs(filterPlain);
        var okPlain = Assert.IsType<OkObjectResult>(resultPlain);
        var dtoPlain = Assert.IsType<PaginatedAuditLogDto>(okPlain.Value);
        Assert.Single(dtoPlain.Items);
    }
}
