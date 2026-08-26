namespace ItsTool.Application.DTOs;

public record SavedFilterDto(int Id, int UserId, string Name, string QueryJson);

public record CreateSavedFilterDto(string Name, string QueryJson);
