using System;
using System.Collections.Generic;

namespace ItsTool.Application.DTOs;

public record SlaPolicyDto(int Id, string Name, string? Description, int? ProjectId, bool EscalateOnBreach, bool IsActive);
public record CreateSlaPolicyDto(string Name, string? Description, int? ProjectId, bool EscalateOnBreach = false, List<CreateSlaTargetDto>? Targets = null);
public record UpdateSlaPolicyDto(string Name, string? Description, int? ProjectId, bool EscalateOnBreach, bool IsActive);

public record SlaTargetDto(int Id, int SlaPolicyId, int PriorityId, int? TicketTypeId, int FirstResponseMinutes, int ResolutionMinutes, bool IsActive);
public record CreateSlaTargetDto(int SlaPolicyId, int PriorityId, int? TicketTypeId, int FirstResponseMinutes, int ResolutionMinutes);
public record UpdateSlaTargetDto(int PriorityId, int? TicketTypeId, int FirstResponseMinutes, int ResolutionMinutes, bool IsActive);

public record SlaTargetItemDto(
    int Id,
    int SlaPolicyId,
    int PriorityId,
    string PriorityName,
    string PriorityColor,
    int PrioritySeverityLevel,
    int? TicketTypeId,
    string? TicketTypeName,
    int FirstResponseMinutes,
    int ResolutionMinutes,
    bool IsActive
);

public record SlaPolicyDetailDto(
    int Id,
    string Name,
    string? Description,
    int? ProjectId,
    string? ProjectName,
    bool EscalateOnBreach,
    bool IsActive,
    List<SlaTargetItemDto> Targets
);

public record UpdateSlaTargetItemDto(
    int? Id,
    int PriorityId,
    int? TicketTypeId,
    int FirstResponseMinutes,
    int ResolutionMinutes,
    bool IsActive
);

public record BatchUpdateSlaTargetsDto(
    List<UpdateSlaTargetItemDto> Targets
);
