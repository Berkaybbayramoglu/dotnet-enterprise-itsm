using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.Workflow;
using ItsTool.Infrastructure.Data;

namespace ItsTool.Infrastructure.Services;

public class WorkflowService : IWorkflowService
{
    private readonly IRepository<Workflow> _workflowRepo;
    private readonly IRepository<WorkflowTransition> _transitionRepo;

    public WorkflowService(IRepository<Workflow> workflowRepo, IRepository<WorkflowTransition> transitionRepo)
    {
        _workflowRepo = workflowRepo;
        _transitionRepo = transitionRepo;
    }

    public async Task<IEnumerable<WorkflowDto>> GetWorkflowsAsync(int? projectId = null)
    {
        var list = await _workflowRepo.GetAllAsync(w => projectId == null || w.ProjectId == projectId);
        return list.Select(w => new WorkflowDto(w.Id, w.Name, w.Description, w.ProjectId, w.IsActive));
    }

    public async Task<WorkflowDto?> GetWorkflowByIdAsync(int id)
    {
        var w = await _workflowRepo.GetByIdAsync(id);
        if (w == null) return null;
        return new WorkflowDto(w.Id, w.Name, w.Description, w.ProjectId, w.IsActive);
    }

    public async Task<WorkflowDto> CreateWorkflowAsync(CreateWorkflowDto dto)
    {
        var w = new Workflow { Name = dto.Name, Description = dto.Description, ProjectId = dto.ProjectId };
        await _workflowRepo.AddAsync(w);
        return new WorkflowDto(w.Id, w.Name, w.Description, w.ProjectId, w.IsActive);
    }

    public async Task UpdateWorkflowAsync(int id, UpdateWorkflowDto dto)
    {
        var w = await _workflowRepo.GetByIdAsync(id);
        if (w == null) throw new KeyNotFoundException("Workflow not found");
        w.Name = dto.Name; w.Description = dto.Description; w.ProjectId = dto.ProjectId; w.IsActive = dto.IsActive;
        await _workflowRepo.UpdateAsync(w);
    }

    public async Task DeleteWorkflowAsync(int id) => await _workflowRepo.DeleteAsync(id);

    public async Task<IEnumerable<WorkflowTransitionDto>> GetTransitionsByWorkflowIdAsync(int workflowId)
    {
        var list = await _transitionRepo.GetAllAsync(t => t.WorkflowId == workflowId);
        return list.Select(t => new WorkflowTransitionDto(t.Id, t.WorkflowId, t.FromStatusId, t.ToStatusId, t.TransitionName, t.RequiredPermissionKey, t.SortOrder, t.IsActive));
    }

    public async Task<WorkflowTransitionDto?> GetTransitionByIdAsync(int id)
    {
        var t = await _transitionRepo.GetByIdAsync(id);
        if (t == null) return null;
        return new WorkflowTransitionDto(t.Id, t.WorkflowId, t.FromStatusId, t.ToStatusId, t.TransitionName, t.RequiredPermissionKey, t.SortOrder, t.IsActive);
    }

    public async Task<WorkflowTransitionDto> CreateTransitionAsync(CreateWorkflowTransitionDto dto)
    {
        if (dto.FromStatusId == dto.ToStatusId) throw new InvalidOperationException("FromStatus and ToStatus cannot be the same.");
        
        var t = new WorkflowTransition
        {
            WorkflowId = dto.WorkflowId,
            FromStatusId = dto.FromStatusId,
            ToStatusId = dto.ToStatusId,
            TransitionName = dto.TransitionName,
            RequiredPermissionKey = dto.RequiredPermissionKey,
            SortOrder = dto.SortOrder
        };
        await _transitionRepo.AddAsync(t);
        return new WorkflowTransitionDto(t.Id, t.WorkflowId, t.FromStatusId, t.ToStatusId, t.TransitionName, t.RequiredPermissionKey, t.SortOrder, t.IsActive);
    }

    public async Task UpdateTransitionAsync(int id, UpdateWorkflowTransitionDto dto)
    {
        if (dto.FromStatusId == dto.ToStatusId) throw new InvalidOperationException("FromStatus and ToStatus cannot be the same.");

        var t = await _transitionRepo.GetByIdAsync(id);
        if (t == null) throw new KeyNotFoundException("Transition not found");
        
        t.FromStatusId = dto.FromStatusId;
        t.ToStatusId = dto.ToStatusId;
        t.TransitionName = dto.TransitionName;
        t.RequiredPermissionKey = dto.RequiredPermissionKey;
        t.SortOrder = dto.SortOrder;
        t.IsActive = dto.IsActive;
        await _transitionRepo.UpdateAsync(t);
    }

    public async Task DeleteTransitionAsync(int id) => await _transitionRepo.DeleteAsync(id);
}
