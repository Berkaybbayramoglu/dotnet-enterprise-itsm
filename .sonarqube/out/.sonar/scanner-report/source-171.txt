using System;

namespace ItsTool.Application.DTOs;

public record AuditLogFilterDto(
    int? UserId,
    string? Action,
    string? Ticket,
    DateTime? FromDate,
    DateTime? ToDate,
    int Page = 1,
    int PageSize = 50
);

public record AuditLogItemDto(
    int Id,
    int? TicketId,
    string Action,
    string FieldName,
    string? OldValue,
    string? NewValue,
    string CreatedBy,
    DateTime CreatedAt,
    string? EntityName = null,
    string? EntityId = null
);

public record PaginatedAuditLogDto(
    System.Collections.Generic.IEnumerable<AuditLogItemDto> Items,
    int TotalCount,
    int Page,
    int PageSize
);
