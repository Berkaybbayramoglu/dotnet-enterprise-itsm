using System;
using System.Collections.Generic;

namespace ItsTool.Application.DTOs;

public record DashboardOverviewDto(int OpenTickets, int CriticalTickets, int SlaBreachedTickets, int SlaRiskTickets, int UnassignedTickets, double CsatAverage);

public record TicketDistributionDto(string Key, int Count);

public record DashboardDistributionsDto(
    IEnumerable<TicketDistributionDto> ByStatus,
    IEnumerable<TicketDistributionDto> ByPriority,
    IEnumerable<TicketDistributionDto> ByProject,
    IEnumerable<TicketDistributionDto> ByCategory
);

public record AgentWorkloadDto(int UserId, string UserName, int OpenTicketCount);
public record DepartmentWorkloadDto(int DepartmentId, string DepartmentName, int OpenTicketCount, IEnumerable<AgentWorkloadDto> Members);

public record SlaComplianceDto(
    double FirstResponseComplianceRate,
    double ResolutionComplianceRate,
    double AverageResolutionTimeMinutes
);
