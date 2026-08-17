using System;

namespace ItsTool.Application.DTOs;

public record NotificationDto(int Id, int UserId, string Title, string Message, bool IsRead, int? RelatedEntityId, string? RelatedEntityType, DateTime CreatedAt);
