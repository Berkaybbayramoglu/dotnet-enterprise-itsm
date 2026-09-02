using System.Collections.Generic;
using System.Threading.Tasks;
using ItsTool.Application.DTOs;

namespace ItsTool.Application.Interfaces;

public interface ISlaService
{
    Task<IEnumerable<SlaPolicyDto>> GetPoliciesAsync(int? projectId = null);
    Task<SlaPolicyDto> CreatePolicyAsync(CreateSlaPolicyDto dto);
    Task UpdatePolicyAsync(int id, UpdateSlaPolicyDto dto);
    Task DeletePolicyAsync(int id);

    Task<IEnumerable<SlaTargetDto>> GetTargetsAsync(int policyId);
    Task<SlaTargetDto> CreateTargetAsync(CreateSlaTargetDto dto);
    Task UpdateTargetAsync(int id, UpdateSlaTargetDto dto);
    Task DeleteTargetAsync(int id);
}
