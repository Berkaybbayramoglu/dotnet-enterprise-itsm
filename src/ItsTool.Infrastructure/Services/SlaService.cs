using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.SLA;
using ItsTool.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace ItsTool.Infrastructure.Services;

public class SlaService : ISlaService
{
    private readonly ItsToolDbContext _context;
    private const string PolicyNotFound = "SLA Policy not found.";
    private const string TargetNotFound = "SLA Target not found.";

    public SlaService(ItsToolDbContext context)
    {
        _context = context;
    }

    public async Task<IEnumerable<SlaPolicyDetailDto>> GetPoliciesAsync(int? projectId = null)
    {
        var policies = await _context.SlaPolicies
            .Where(p => !p.IsDeleted && (projectId == null || p.ProjectId == projectId))
            .OrderBy(p => p.ProjectId.HasValue) // Global (null) first
            .ThenBy(p => p.Name)
            .ToListAsync();

        var policyIds = policies.Select(p => p.Id).ToList();

        var targets = await _context.SlaTargets
            .Where(t => !t.IsDeleted && policyIds.Contains(t.SlaPolicyId))
            .ToListAsync();

        var projects = await _context.Projects
            .Where(pr => !pr.IsDeleted)
            .ToDictionaryAsync(pr => pr.Id, pr => pr.Name);

        var priorities = await _context.Priorities
            .ToDictionaryAsync(pr => pr.Id);

        var ticketTypes = await _context.TicketTypes
            .ToDictionaryAsync(tt => tt.Id, tt => tt.Name);

        var result = new List<SlaPolicyDetailDto>();

        foreach (var policy in policies)
        {
            string? projectName = policy.ProjectId.HasValue && projects.TryGetValue(policy.ProjectId.Value, out var pName) 
                ? pName 
                : null;

            var policyTargets = targets
                .Where(t => t.SlaPolicyId == policy.Id)
                .Select(t =>
                {
                    priorities.TryGetValue(t.PriorityId, out var prio);
                    string? typeName = t.TicketTypeId.HasValue && ticketTypes.TryGetValue(t.TicketTypeId.Value, out var ttName)
                        ? ttName
                        : null;

                    return new SlaTargetItemDto(
                        t.Id,
                        t.SlaPolicyId,
                        t.PriorityId,
                        prio?.Name ?? $"Öncelik #{t.PriorityId}",
                        prio?.ColorHex ?? "#8c8c8c",
                        prio?.SeverityLevel ?? 99,
                        t.TicketTypeId,
                        typeName,
                        t.FirstResponseMinutes,
                        t.ResolutionMinutes,
                        t.IsActive
                    );
                })
                .OrderBy(t => t.PrioritySeverityLevel)
                .ToList();

            result.Add(new SlaPolicyDetailDto(
                policy.Id,
                policy.Name,
                policy.Description,
                policy.ProjectId,
                projectName,
                policy.EscalateOnBreach,
                policy.IsActive,
                policyTargets
            ));
        }

        return result;
    }

    public async Task<SlaPolicyDetailDto?> GetPolicyByIdAsync(int id)
    {
        var policies = await GetPoliciesAsync();
        return policies.FirstOrDefault(p => p.Id == id);
    }

    public async Task<SlaPolicyDto> CreatePolicyAsync(CreateSlaPolicyDto dto)
    {
        var policy = new SlaPolicy
        {
            Name = dto.Name,
            Description = dto.Description,
            ProjectId = dto.ProjectId,
            EscalateOnBreach = dto.EscalateOnBreach,
            IsActive = true
        };
        _context.SlaPolicies.Add(policy);
        await _context.SaveChangesAsync();

        if (dto.Targets != null && dto.Targets.Count > 0)
        {
            foreach (var t in dto.Targets)
            {
                _context.SlaTargets.Add(new SlaTarget
                {
                    SlaPolicyId = policy.Id,
                    PriorityId = t.PriorityId,
                    TicketTypeId = t.TicketTypeId,
                    FirstResponseMinutes = t.FirstResponseMinutes,
                    ResolutionMinutes = t.ResolutionMinutes,
                    IsActive = true
                });
            }
            await _context.SaveChangesAsync();
        }
        else
        {
            // Seed default targets for this policy from priorities
            var priorities = await _context.Priorities.ToListAsync();
            foreach (var prio in priorities)
            {
                int firstResponse = prio.SeverityLevel switch
                {
                    1 => 30,    // Critical
                    2 => 120,   // High
                    3 => 480,   // Medium
                    _ => 1440   // Low
                };
                int resolution = prio.SeverityLevel switch
                {
                    1 => 240,   // 4h
                    2 => 1440,  // 24h
                    3 => 4320,  // 3d
                    _ => 7200   // 5d
                };

                _context.SlaTargets.Add(new SlaTarget
                {
                    SlaPolicyId = policy.Id,
                    PriorityId = prio.Id,
                    FirstResponseMinutes = firstResponse,
                    ResolutionMinutes = resolution,
                    IsActive = true
                });
            }
            await _context.SaveChangesAsync();
        }

        return new SlaPolicyDto(policy.Id, policy.Name, policy.Description, policy.ProjectId, policy.EscalateOnBreach, policy.IsActive);
    }

    public async Task UpdatePolicyAsync(int id, UpdateSlaPolicyDto dto)
    {
        var policy = await _context.SlaPolicies.FirstOrDefaultAsync(p => p.Id == id && !p.IsDeleted);
        if (policy == null) throw new KeyNotFoundException(PolicyNotFound);

        policy.Name = dto.Name;
        policy.Description = dto.Description;
        policy.ProjectId = dto.ProjectId;
        policy.EscalateOnBreach = dto.EscalateOnBreach;
        policy.IsActive = dto.IsActive;
        await _context.SaveChangesAsync();
    }

    public async Task DeletePolicyAsync(int id)
    {
        var policy = await _context.SlaPolicies.FirstOrDefaultAsync(p => p.Id == id && !p.IsDeleted);
        if (policy != null)
        {
            // Prevent deleting the global default policy
            if (policy.ProjectId == null)
            {
                throw new InvalidOperationException("Genel Sistem SLA Politikası silinemez.");
            }

            policy.IsDeleted = true;
            policy.IsActive = false;
            await _context.SaveChangesAsync();
        }
    }

    public async Task RestorePolicyAsync(int id)
    {
        var policy = await _context.SlaPolicies.FirstOrDefaultAsync(p => p.Id == id);
        if (policy == null) throw new KeyNotFoundException(PolicyNotFound);

        policy.IsDeleted = false;
        policy.IsActive = true;

        var targets = await _context.SlaTargets.Where(t => t.SlaPolicyId == id).ToListAsync();
        foreach (var t in targets)
        {
            t.IsDeleted = false;
            t.IsActive = true;
        }

        await _context.SaveChangesAsync();
    }

    public async Task<IEnumerable<SlaPolicyDetailDto>> GetDeletedPoliciesAsync()
    {
        var policies = await _context.SlaPolicies
            .Where(p => p.IsDeleted)
            .OrderByDescending(p => p.UpdatedAt ?? p.CreatedAt)
            .ToListAsync();

        var policyIds = policies.Select(p => p.Id).ToList();

        var targets = await _context.SlaTargets
            .Where(t => policyIds.Contains(t.SlaPolicyId))
            .ToListAsync();

        var projects = await _context.Projects
            .ToDictionaryAsync(pr => pr.Id, pr => pr.Name);

        var priorities = await _context.Priorities
            .ToDictionaryAsync(pr => pr.Id);

        var ticketTypes = await _context.TicketTypes
            .ToDictionaryAsync(tt => tt.Id, tt => tt.Name);

        var result = new List<SlaPolicyDetailDto>();

        foreach (var policy in policies)
        {
            string? projectName = policy.ProjectId.HasValue && projects.TryGetValue(policy.ProjectId.Value, out var pName) 
                ? pName 
                : null;

            var policyTargets = targets
                .Where(t => t.SlaPolicyId == policy.Id)
                .Select(t =>
                {
                    priorities.TryGetValue(t.PriorityId, out var prio);
                    string? typeName = t.TicketTypeId.HasValue && ticketTypes.TryGetValue(t.TicketTypeId.Value, out var ttName)
                        ? ttName
                        : null;

                    return new SlaTargetItemDto(
                        t.Id,
                        t.SlaPolicyId,
                        t.PriorityId,
                        prio?.Name ?? $"Öncelik #{t.PriorityId}",
                        prio?.ColorHex ?? "#8c8c8c",
                        prio?.SeverityLevel ?? 99,
                        t.TicketTypeId,
                        typeName,
                        t.FirstResponseMinutes,
                        t.ResolutionMinutes,
                        t.IsActive
                    );
                })
                .OrderBy(t => t.PrioritySeverityLevel)
                .ToList();

            result.Add(new SlaPolicyDetailDto(
                policy.Id,
                policy.Name,
                policy.Description,
                policy.ProjectId,
                projectName,
                policy.EscalateOnBreach,
                policy.IsActive,
                policyTargets
            ));
        }

        return result;
    }

    public async Task<IEnumerable<SlaTargetDto>> GetTargetsAsync(int policyId)
    {
        var list = await _context.SlaTargets
            .Where(t => t.SlaPolicyId == policyId && !t.IsDeleted)
            .ToListAsync();
        
        return list.Select(t => new SlaTargetDto(t.Id, t.SlaPolicyId, t.PriorityId, t.TicketTypeId, t.FirstResponseMinutes, t.ResolutionMinutes, t.IsActive));
    }

    public async Task<SlaTargetDto> CreateTargetAsync(CreateSlaTargetDto dto)
    {
        var target = new SlaTarget
        {
            SlaPolicyId = dto.SlaPolicyId,
            PriorityId = dto.PriorityId,
            TicketTypeId = dto.TicketTypeId,
            FirstResponseMinutes = dto.FirstResponseMinutes,
            ResolutionMinutes = dto.ResolutionMinutes,
            IsActive = true
        };
        _context.SlaTargets.Add(target);
        await _context.SaveChangesAsync();
        return new SlaTargetDto(target.Id, target.SlaPolicyId, target.PriorityId, target.TicketTypeId, target.FirstResponseMinutes, target.ResolutionMinutes, target.IsActive);
    }

    public async Task UpdateTargetAsync(int id, UpdateSlaTargetDto dto)
    {
        var target = await _context.SlaTargets.FirstOrDefaultAsync(t => t.Id == id && !t.IsDeleted);
        if (target == null) throw new KeyNotFoundException(TargetNotFound);

        target.PriorityId = dto.PriorityId;
        target.TicketTypeId = dto.TicketTypeId;
        target.FirstResponseMinutes = dto.FirstResponseMinutes;
        target.ResolutionMinutes = dto.ResolutionMinutes;
        target.IsActive = dto.IsActive;
        await _context.SaveChangesAsync();
    }

    public async Task BatchUpdateTargetsAsync(int policyId, BatchUpdateSlaTargetsDto dto)
    {
        var policy = await _context.SlaPolicies.FirstOrDefaultAsync(p => p.Id == policyId && !p.IsDeleted);
        if (policy == null) throw new KeyNotFoundException(PolicyNotFound);

        var existingTargets = await _context.SlaTargets
            .Where(t => t.SlaPolicyId == policyId && !t.IsDeleted)
            .ToListAsync();

        foreach (var item in dto.Targets)
        {
            SlaTarget? target = null;
            if (item.Id.HasValue && item.Id.Value > 0)
            {
                target = existingTargets.FirstOrDefault(t => t.Id == item.Id.Value);
            }

            target ??= existingTargets.FirstOrDefault(t => t.PriorityId == item.PriorityId && t.TicketTypeId == item.TicketTypeId);

            if (target != null)
            {
                target.PriorityId = item.PriorityId;
                target.TicketTypeId = item.TicketTypeId;
                target.FirstResponseMinutes = item.FirstResponseMinutes;
                target.ResolutionMinutes = item.ResolutionMinutes;
                target.IsActive = item.IsActive;
            }
            else
            {
                _context.SlaTargets.Add(new SlaTarget
                {
                    SlaPolicyId = policyId,
                    PriorityId = item.PriorityId,
                    TicketTypeId = item.TicketTypeId,
                    FirstResponseMinutes = item.FirstResponseMinutes,
                    ResolutionMinutes = item.ResolutionMinutes,
                    IsActive = item.IsActive
                });
            }
        }

        await _context.SaveChangesAsync();
    }

    public async Task DeleteTargetAsync(int id)
    {
        var target = await _context.SlaTargets.FirstOrDefaultAsync(t => t.Id == id && !t.IsDeleted);
        if (target != null)
        {
            target.IsDeleted = true;
            target.IsActive = false;
            await _context.SaveChangesAsync();
        }
    }
}
