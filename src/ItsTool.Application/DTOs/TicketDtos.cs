namespace ItsTool.Application.DTOs;

public record TicketDto(int Id, string TicketNumber, string Title, string Description, int ProjectId, int CategoryId, int TypeId, int StatusId, int PriorityId, int RequesterUserId, int? AssignedUserId, int? AssignedGroupId, Dictionary<string, string>? CustomFields = null);
public record CreateTicketDto(string Title, string Description, int ProjectId, int CategoryId, int TypeId, int PriorityId, int RequesterUserId, Dictionary<string, string> CustomFields);
public record UpdateTicketDto(string Title, string Description, int CategoryId, int PriorityId, Dictionary<string, string> CustomFields);

public record TicketHistoryDto(int Id, int TicketId, string FieldName, string? OldValue, string? NewValue, string Action, DateTime CreatedAt);
public record TicketCommentDto(int Id, int TicketId, int AuthorUserId, string Content, bool IsInternal, DateTime CreatedAt, int? ParentCommentId = null, bool IsEdited = false);
public record CreateCommentDto(string Content, bool IsInternal, int AuthorUserId, int? ParentCommentId = null);
public record UpdateCommentDto(string Content);

public record TicketAttachmentDto(int Id, int TicketId, string FileName, string FilePath, long FileSize, string ContentType, int UploadedByUserId, DateTime CreatedAt);

public record TicketWatcherDto(int TicketId, int UserId);

public record TimelineEventDto(string EventType, DateTime Timestamp, object Data); // e.g. EventType: "Comment", "History", "Attachment"

public record AssignTicketDto(int UserId, int AssignerUserId);
public record TransferTicketDto(int? ProjectId, int? GroupId, int TransferrerUserId);
public record ChangeStatusDto(int NewStatusId, int UserId);
