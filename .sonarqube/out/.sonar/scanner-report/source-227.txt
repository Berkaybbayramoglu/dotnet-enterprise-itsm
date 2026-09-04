using System;

namespace ItsTool.Application.DTOs;

public record NotificationDto(int Id, int UserId, string Type, string Title, string Body, bool IsRead, int EntityId, string EntityType, string Priority, DateTime CreatedAt);
