using ItsTool.Application.DTOs;

namespace ItsTool.Application.Interfaces;

public interface IWorkflowService
{
    // Workflow
    Task<IEnumerable<WorkflowDto>> GetWorkflowsAsync(int? projectId = null);
    Task<WorkflowDto?> GetWorkflowByIdAsync(int id);
    Task<WorkflowDto> CreateWorkflowAsync(CreateWorkflowDto dto);
    Task UpdateWorkflowAsync(int id, UpdateWorkflowDto dto);
    Task DeleteWorkflowAsync(int id);

    // WorkflowTransition
    Task<IEnumerable<WorkflowTransitionDto>> GetTransitionsByWorkflowIdAsync(int workflowId);
    Task<WorkflowTransitionDto?> GetTransitionByIdAsync(int id);
    Task<WorkflowTransitionDto> CreateTransitionAsync(CreateWorkflowTransitionDto dto);
    Task UpdateTransitionAsync(int id, UpdateWorkflowTransitionDto dto);
    Task DeleteTransitionAsync(int id);
}
