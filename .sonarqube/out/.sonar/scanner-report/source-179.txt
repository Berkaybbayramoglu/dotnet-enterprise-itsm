using System;
using System.Collections.Generic;

namespace ItsTool.Application.DTOs;

public record SlaPolicyDto(int Id, string Name, string? Description, int? ProjectId, bool IsActive);
public record CreateSlaPolicyDto(string Name, string? Description, int? ProjectId);
public record UpdateSlaPolicyDto(string Name, string? Description, int? ProjectId, bool IsActive);

public record SlaTargetDto(int Id, int SlaPolicyId, int PriorityId, int? TicketTypeId, int FirstResponseMinutes, int ResolutionMinutes, bool IsActive);
public record CreateSlaTargetDto(int SlaPolicyId, int PriorityId, int? TicketTypeId, int FirstResponseMinutes, int ResolutionMinutes);
public record UpdateSlaTargetDto(int PriorityId, int? TicketTypeId, int FirstResponseMinutes, int ResolutionMinutes, bool IsActive);
