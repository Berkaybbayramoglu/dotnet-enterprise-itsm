using ItsTool.Application.DTOs;
using ItsTool.Domain.Entities.Workflow;
using ItsTool.Infrastructure.Data;
using ItsTool.Infrastructure.Services;
using Microsoft.EntityFrameworkCore;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class WorkflowServiceTests : TestBase
{
    private readonly Repository<Workflow> _workflowRepo;
    private readonly Repository<WorkflowTransition> _transitionRepo;
    private readonly WorkflowService _service;

    public WorkflowServiceTests() : base()
    {
        _workflowRepo = new Repository<Workflow>(_context);
        _transitionRepo = new Repository<WorkflowTransition>(_context);
        _service = new WorkflowService(_workflowRepo, _transitionRepo);
    }

    [Fact]
    public async Task CreateWorkflowAsync_ShouldCreateWorkflow()
    {
        var dto = new CreateWorkflowDto("Main", "Desc", null);
        var result = await _service.CreateWorkflowAsync(dto);

        Assert.NotNull(result);
        Assert.Equal("Main", result.Name);
    }

    [Fact]
    public async Task CreateTransitionAsync_ShouldThrowIfFromEqualsTo()
    {
        var dto = new CreateWorkflowTransitionDto(1, 1, 1, "t", null, 1);
        await Assert.ThrowsAsync<InvalidOperationException>(() => _service.CreateTransitionAsync(dto));
    }

    [Fact]
    public async Task UpdateTransitionAsync_ShouldThrowIfFromEqualsTo()
    {
        var t = new WorkflowTransition { WorkflowId = 1, FromStatusId = 1, ToStatusId = 2, TransitionName = "t" };
        _context.WorkflowTransitions.Add(t);
        await _context.SaveChangesAsync();

        var dto = new UpdateWorkflowTransitionDto(3, 3, "t2", null, 2, true);
        await Assert.ThrowsAsync<InvalidOperationException>(() => _service.UpdateTransitionAsync(t.Id, dto));
    }
}
