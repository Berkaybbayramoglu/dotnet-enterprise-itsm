using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.SLA;
using ItsTool.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;
using System;

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

    public async Task<IEnumerable<SlaPolicyDto>> GetPoliciesAsync(int? projectId = null)
    {
        var list = await _context.SlaPolicies
            .Where(p => !p.IsDeleted && (projectId == null || p.ProjectId == projectId))
            .ToListAsync();
        
        return list.Select(p => new SlaPolicyDto(p.Id, p.Name, p.Description, p.ProjectId, p.IsActive));
    }

    public async Task<SlaPolicyDto> CreatePolicyAsync(CreateSlaPolicyDto dto)
    {
        var policy = new SlaPolicy
        {
            Name = dto.Name,
            Description = dto.Description,
            ProjectId = dto.ProjectId
        };
        _context.SlaPolicies.Add(policy);
        await _context.SaveChangesAsync();
        return new SlaPolicyDto(policy.Id, policy.Name, policy.Description, policy.ProjectId, policy.IsActive);
    }

    public async Task UpdatePolicyAsync(int id, UpdateSlaPolicyDto dto)
    {
        var policy = await _context.SlaPolicies.FirstOrDefaultAsync(p => p.Id == id && !p.IsDeleted);
        if (policy == null) throw new KeyNotFoundException(PolicyNotFound);

        policy.Name = dto.Name;
        policy.Description = dto.Description;
        policy.ProjectId = dto.ProjectId;
        policy.IsActive = dto.IsActive;
        await _context.SaveChangesAsync();
    }

    public async Task DeletePolicyAsync(int id)
    {
        var policy = await _context.SlaPolicies.FirstOrDefaultAsync(p => p.Id == id && !p.IsDeleted);
        if (policy != null)
        {
            policy.IsDeleted = true;
            policy.IsActive = false;
            await _context.SaveChangesAsync();
        }
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
            ResolutionMinutes = dto.ResolutionMinutes
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
