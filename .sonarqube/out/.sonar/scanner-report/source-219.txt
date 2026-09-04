namespace ItsTool.Application.DTOs;

public record AssignmentRuleDto(int Id, string Name, int? ProjectId, int? CategoryId, int? TicketTypeId, int? PriorityId, int? TargetGroupId, int? TargetUserId, int SortOrder, bool IsActive);

public record CreateAssignmentRuleDto(string Name, int? ProjectId, int? CategoryId, int? TicketTypeId, int? PriorityId, int? TargetGroupId, int? TargetUserId, int SortOrder, bool IsActive);

public record UpdateAssignmentRuleDto(string Name, int? ProjectId, int? CategoryId, int? TicketTypeId, int? PriorityId, int? TargetGroupId, int? TargetUserId, int SortOrder, bool IsActive);
