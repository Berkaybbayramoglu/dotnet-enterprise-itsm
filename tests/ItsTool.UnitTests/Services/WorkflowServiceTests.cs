using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ItsTool.Application.DTOs;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Domain.Entities.Workflow;
using ItsTool.Infrastructure.Data;
using ItsTool.Infrastructure.Services;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class WorkflowServiceTests : TestBase
{
    private readonly WorkflowService _workflowService;

    public WorkflowServiceTests() : base()
    {
        var wfRepo = new Repository<Workflow>(_context);
        var trRepo = new Repository<WorkflowTransition>(_context);
        _workflowService = new WorkflowService(wfRepo, trRepo);
        SeedData();
    }

    private void SeedData()
    {
        _context.Statuses.Add(new Status { Id = 1, Name = "Open", IsActive = true });
        _context.Statuses.Add(new Status { Id = 2, Name = "Resolved", IsActive = true });
        _context.SaveChanges();
    }

    [Fact]
    public async Task Workflows_Crud_WorksCorrectly()
    {
        var createDto = new CreateWorkflowDto("Incident Workflow", "Standard workflow for incidents", 1);
        var created = await _workflowService.CreateWorkflowAsync(createDto);

        Assert.NotNull(created);
        Assert.Equal("Incident Workflow", created.Name);

        var byId = await _workflowService.GetWorkflowByIdAsync(created.Id);
        Assert.NotNull(byId);
        Assert.Equal("Incident Workflow", byId.Name);

        var updateDto = new UpdateWorkflowDto("Incident Workflow Revised", "Updated", 1, true);
        await _workflowService.UpdateWorkflowAsync(created.Id, updateDto);

        var updated = await _workflowService.GetWorkflowByIdAsync(created.Id);
        Assert.Equal("Incident Workflow Revised", updated!.Name);

        await _workflowService.DeleteWorkflowAsync(created.Id);
        var deleted = await _context.Workflows.FindAsync(created.Id);
        Assert.True(deleted!.IsDeleted);
    }

    [Fact]
    public async Task Transitions_Crud_WorksCorrectly()
    {
        var wf = new Workflow { Name = "Main WF", IsActive = true };
        _context.Workflows.Add(wf);
        await _context.SaveChangesAsync();

        var createDto = new CreateWorkflowTransitionDto(wf.Id, 1, 2, "Resolve Ticket", null, 1);
        var created = await _workflowService.CreateTransitionAsync(createDto);

        Assert.NotNull(created);
        Assert.Equal("Resolve Ticket", created.TransitionName);

        var transitions = (await _workflowService.GetTransitionsByWorkflowIdAsync(wf.Id)).ToList();
        Assert.Single(transitions);

        var updateDto = new UpdateWorkflowTransitionDto(1, 2, "Resolve Ticket Now", null, 2, true);
        await _workflowService.UpdateTransitionAsync(created.Id, updateDto);

        var updatedEntity = await _context.WorkflowTransitions.FindAsync(created.Id);
        Assert.Equal("Resolve Ticket Now", updatedEntity!.TransitionName);

        await _workflowService.DeleteTransitionAsync(created.Id);
        var deletedEntity = await _context.WorkflowTransitions.FindAsync(created.Id);
        Assert.True(deletedEntity!.IsDeleted);
    }
}
