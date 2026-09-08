using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ItsTool.Application.DTOs;
using ItsTool.Domain.Entities.Project;
using ItsTool.Domain.Entities.SLA;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Infrastructure.Services;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class SlaServiceTests : TestBase
{
    private readonly SlaService _slaService;

    public SlaServiceTests() : base()
    {
        _slaService = new SlaService(_context);
        SeedData();
    }

    private void SeedData()
    {
        _context.Projects.Add(new Project { Id = 1, Name = "Core Project", ProjectKey = "CORE", IsActive = true });
        _context.Priorities.Add(new Priority { Id = 1, Name = "Critical", SeverityLevel = 1, IsActive = true });
        _context.Priorities.Add(new Priority { Id = 2, Name = "High", SeverityLevel = 2, IsActive = true });
        _context.TicketTypes.Add(new TicketType { Id = 1, Name = "Incident", IsActive = true });
        _context.SaveChanges();
    }

    [Fact]
    public async Task CreatePolicyAsync_CreatesNewPolicyWithTargets()
    {
        var targets = new List<CreateSlaTargetDto>
        {
            new(SlaPolicyId: 0, PriorityId: 1, TicketTypeId: 1, FirstResponseMinutes: 30, ResolutionMinutes: 120)
        };

        var dto = new CreateSlaPolicyDto(
            Name: "Gold SLA",
            Description: "Gold tier response",
            ProjectId: 1,
            EscalateOnBreach: true,
            Targets: targets
        );

        var result = await _slaService.CreatePolicyAsync(dto);

        Assert.NotNull(result);
        Assert.Equal("Gold SLA", result.Name);
        Assert.True(result.IsActive);

        var created = await _context.SlaPolicies.FindAsync(result.Id);
        Assert.NotNull(created);
        Assert.Equal("Gold SLA", created.Name);

        var createdTargets = _context.SlaTargets.Where(t => t.SlaPolicyId == result.Id).ToList();
        Assert.Single(createdTargets);
        Assert.Equal(30, createdTargets[0].FirstResponseMinutes);
    }

    [Fact]
    public async Task GetPoliciesAsync_ReturnsAllActivePolicies()
    {
        var pol1 = new SlaPolicy { Name = "Global Policy", ProjectId = null, IsActive = true };
        var pol2 = new SlaPolicy { Name = "Project Policy", ProjectId = 1, IsActive = true };
        _context.SlaPolicies.AddRange(pol1, pol2);
        await _context.SaveChangesAsync();

        var policies = await _slaService.GetPoliciesAsync();
        Assert.True(policies.Count() >= 2);

        var projectOnly = await _slaService.GetPoliciesAsync(projectId: 1);
        Assert.Single(projectOnly);
        Assert.Equal("Project Policy", projectOnly.First().Name);
    }

    [Fact]
    public async Task GetPolicyByIdAsync_WhenExists_ReturnsDetailedDto()
    {
        var pol = new SlaPolicy { Name = "Detail SLA", ProjectId = 1, IsActive = true };
        _context.SlaPolicies.Add(pol);
        await _context.SaveChangesAsync();

        _context.SlaTargets.Add(new SlaTarget
        {
            SlaPolicyId = pol.Id,
            PriorityId = 1,
            TicketTypeId = 1,
            FirstResponseMinutes = 45,
            ResolutionMinutes = 180
        });
        await _context.SaveChangesAsync();

        var detail = await _slaService.GetPolicyByIdAsync(pol.Id);
        Assert.NotNull(detail);
        Assert.Equal("Detail SLA", detail.Name);
        Assert.Single(detail.Targets);
        Assert.Equal(45, detail.Targets[0].FirstResponseMinutes);
    }

    [Fact]
    public async Task UpdatePolicyAsync_UpdatesProperties()
    {
        var pol = new SlaPolicy { Name = "Old SLA Name", Description = "Old", ProjectId = null, IsActive = true };
        _context.SlaPolicies.Add(pol);
        await _context.SaveChangesAsync();

        var updateDto = new UpdateSlaPolicyDto(
            Name: "New SLA Name",
            Description: "Updated description",
            ProjectId: 1,
            EscalateOnBreach: false,
            IsActive: true
        );

        await _slaService.UpdatePolicyAsync(pol.Id, updateDto);

        var updated = await _context.SlaPolicies.FindAsync(pol.Id);
        Assert.Equal("New SLA Name", updated!.Name);
        Assert.Equal("Updated description", updated.Description);
        Assert.Equal(1, updated.ProjectId);
    }

    [Fact]
    public async Task DeletePolicyAsync_SoftDeletesPolicyAndTargets()
    {
        var pol = new SlaPolicy { Name = "To Delete", ProjectId = 1, IsActive = true };
        _context.SlaPolicies.Add(pol);
        await _context.SaveChangesAsync();

        var tgt = new SlaTarget { SlaPolicyId = pol.Id, PriorityId = 1, FirstResponseMinutes = 60, ResolutionMinutes = 120 };
        _context.SlaTargets.Add(tgt);
        await _context.SaveChangesAsync();

        await _slaService.DeletePolicyAsync(pol.Id);

        var deletedPol = await _context.SlaPolicies.FindAsync(pol.Id);
        Assert.True(deletedPol!.IsDeleted);
        Assert.False(deletedPol.IsActive);
    }

    [Fact]
    public async Task Targets_CreateUpdateBatchDelete_WorksCorrectly()
    {
        var pol = new SlaPolicy { Name = "Target Test SLA", IsActive = true };
        _context.SlaPolicies.Add(pol);
        await _context.SaveChangesAsync();

        // Create target
        var createDto = new CreateSlaTargetDto(
            SlaPolicyId: pol.Id,
            PriorityId: 1,
            TicketTypeId: 1,
            FirstResponseMinutes: 60,
            ResolutionMinutes: 240
        );
        var target = await _slaService.CreateTargetAsync(createDto);
        Assert.NotNull(target);
        Assert.Equal(60, target.FirstResponseMinutes);

        // Update target
        var updateDto = new UpdateSlaTargetDto(
            PriorityId: 1,
            TicketTypeId: 1,
            FirstResponseMinutes: 45,
            ResolutionMinutes: 180,
            IsActive: true
        );
        await _slaService.UpdateTargetAsync(target.Id, updateDto);
        var updatedTgt = await _context.SlaTargets.FindAsync(target.Id);
        Assert.Equal(45, updatedTgt!.FirstResponseMinutes);

        // Batch update
        var batchDto = new BatchUpdateSlaTargetsDto(
            Targets: new List<UpdateSlaTargetItemDto>
            {
                new(Id: target.Id, PriorityId: 1, TicketTypeId: 1, FirstResponseMinutes: 15, ResolutionMinutes: 60, IsActive: true),
                new(Id: null, PriorityId: 2, TicketTypeId: null, FirstResponseMinutes: 120, ResolutionMinutes: 480, IsActive: true)
            }
        );
        await _slaService.BatchUpdateTargetsAsync(pol.Id, batchDto);

        var targets = (await _slaService.GetTargetsAsync(pol.Id)).ToList();
        Assert.Equal(2, targets.Count);
        Assert.Contains(targets, t => t.FirstResponseMinutes == 15);
        Assert.Contains(targets, t => t.FirstResponseMinutes == 120);

        // Delete target
        await _slaService.DeleteTargetAsync(target.Id);
        var deletedTgtEntity = await _context.SlaTargets.FindAsync(target.Id);
        Assert.True(deletedTgtEntity!.IsDeleted);
    }
}
