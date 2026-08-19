using System.Collections.Generic;
using System.Linq;
using ItsTool.Application.Interfaces;
using System.Threading.Tasks;
using ItsTool.Application.DTOs;
using ItsTool.Domain.Entities.Organization;
using ItsTool.Infrastructure.Data;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ItsTool.API.Controllers;

[ApiController]
[Route("api/rules/assignment")]
[Authorize(Policy = "RequirePermission:config.manage")]
public class AssignmentRuleController : ControllerBase
{
    private readonly ItsToolDbContext _context;
    private readonly ISystemAuditService _auditService;

    public AssignmentRuleController(ItsToolDbContext context, ISystemAuditService auditService)
    {
        _context = context;
        _auditService = auditService;
    }

    [HttpGet]
    [ProducesResponseType(typeof(IEnumerable<AssignmentRuleDto>), 200)]
    public async Task<IActionResult> GetRules()
    {
        var rules = await _context.AssignmentRules
            .Where(r => !r.IsDeleted)
            .OrderBy(r => r.SortOrder)
            .ToListAsync();
            
        var dtos = rules.Select(r => new AssignmentRuleDto(
            r.Id, r.Name, r.ProjectId, r.CategoryId, r.TicketTypeId, r.PriorityId, r.TargetGroupId, r.TargetUserId, r.SortOrder, r.IsActive));
            
        return Ok(dtos);
    }

    [HttpPost]
    [ProducesResponseType(typeof(AssignmentRuleDto), 201)]
    public async Task<IActionResult> CreateRule([FromBody] CreateAssignmentRuleDto dto)
    {
        var rule = new AssignmentRule
        {
            Name = dto.Name,
            ProjectId = dto.ProjectId,
            CategoryId = dto.CategoryId,
            TicketTypeId = dto.TicketTypeId,
            PriorityId = dto.PriorityId,
            TargetGroupId = dto.TargetGroupId,
            TargetUserId = dto.TargetUserId,
            SortOrder = dto.SortOrder,
            IsActive = dto.IsActive
        };
        
        _context.AssignmentRules.Add(rule);
        await _context.SaveChangesAsync();
        
        await _auditService.LogAuditAsync("AssignmentRule", rule.Id.ToString(), "Created", "Rule", null, rule.Name);

        var responseDto = new AssignmentRuleDto(
            rule.Id, rule.Name, rule.ProjectId, rule.CategoryId, rule.TicketTypeId, rule.PriorityId, rule.TargetGroupId, rule.TargetUserId, rule.SortOrder, rule.IsActive);
            
        return CreatedAtAction(nameof(GetRules), new { id = rule.Id }, responseDto);
    }

    [HttpPut("{id}")]
    [ProducesResponseType(204)]
    public async Task<IActionResult> UpdateRule(int id, [FromBody] UpdateAssignmentRuleDto dto)
    {
        var rule = await _context.AssignmentRules.FirstOrDefaultAsync(r => r.Id == id && !r.IsDeleted);
        if (rule == null) return NotFound();
        
        rule.Name = dto.Name;
        rule.ProjectId = dto.ProjectId;
        rule.CategoryId = dto.CategoryId;
        rule.TicketTypeId = dto.TicketTypeId;
        rule.PriorityId = dto.PriorityId;
        rule.TargetGroupId = dto.TargetGroupId;
        rule.TargetUserId = dto.TargetUserId;
        rule.SortOrder = dto.SortOrder;
        rule.IsActive = dto.IsActive;
        
        await _context.SaveChangesAsync();
        await _auditService.LogAuditAsync("AssignmentRule", rule.Id.ToString(), "Updated", "Rule", null, rule.Name);
        return NoContent();
    }

    [HttpDelete("{id}")]
    [ProducesResponseType(204)]
    public async Task<IActionResult> DeleteRule(int id)
    {
        var rule = await _context.AssignmentRules.FirstOrDefaultAsync(r => r.Id == id && !r.IsDeleted);
        if (rule == null) return NotFound();
        
        rule.IsDeleted = true;
        await _context.SaveChangesAsync();
        await _auditService.LogAuditAsync("AssignmentRule", rule.Id.ToString(), "Deleted", "Rule", rule.Name, null);
        return NoContent();
    }
}
