using System.Collections.Generic;
using System.Threading.Tasks;
using ItsTool.Application.DTOs;

namespace ItsTool.Application.Interfaces;

public interface IDashboardService
{
    Task<DashboardOverviewDto> GetOverviewAsync(int userId);
    Task<DashboardDistributionsDto> GetDistributionsAsync(int userId);
    Task<IEnumerable<AgentWorkloadDto>> GetAgentWorkloadAsync(int userId);
    Task<SlaComplianceDto> GetSlaComplianceAsync(int userId);
}
