namespace ItsTool.Application.DTOs;

// Workflow
public record WorkflowDto(int Id, string Name, string? Description, int? ProjectId, bool IsActive);
public record CreateWorkflowDto(string Name, string? Description, int? ProjectId);
public record UpdateWorkflowDto(string Name, string? Description, int? ProjectId, bool IsActive);

// WorkflowTransition
public record WorkflowTransitionDto(int Id, int WorkflowId, int FromStatusId, int ToStatusId, string TransitionName, string? RequiredPermissionKey, int SortOrder, bool IsActive);
public record CreateWorkflowTransitionDto(int WorkflowId, int FromStatusId, int ToStatusId, string TransitionName, string? RequiredPermissionKey, int SortOrder);
public record UpdateWorkflowTransitionDto(int FromStatusId, int ToStatusId, string TransitionName, string? RequiredPermissionKey, int SortOrder, bool IsActive);
