using System.Collections.Generic;
using System.Threading.Tasks;
using ItsTool.Application.DTOs;

namespace ItsTool.Application.Interfaces;

public interface ISlaService
{
    Task<IEnumerable<SlaPolicyDetailDto>> GetPoliciesAsync(int? projectId = null);
    Task<SlaPolicyDetailDto?> GetPolicyByIdAsync(int id);
    Task<SlaPolicyDto> CreatePolicyAsync(CreateSlaPolicyDto dto);
    Task UpdatePolicyAsync(int id, UpdateSlaPolicyDto dto);
    Task DeletePolicyAsync(int id);
    Task RestorePolicyAsync(int id);
    Task<IEnumerable<SlaPolicyDetailDto>> GetDeletedPoliciesAsync();

    Task<IEnumerable<SlaTargetDto>> GetTargetsAsync(int policyId);
    Task<SlaTargetDto> CreateTargetAsync(CreateSlaTargetDto dto);
    Task UpdateTargetAsync(int id, UpdateSlaTargetDto dto);
    Task BatchUpdateTargetsAsync(int policyId, BatchUpdateSlaTargetsDto dto);
    Task DeleteTargetAsync(int id);
}
