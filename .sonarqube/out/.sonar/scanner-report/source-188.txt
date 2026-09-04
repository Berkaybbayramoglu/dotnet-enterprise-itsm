using System;
using System.Threading.Tasks;
using ItsTool.API.Controllers;
using ItsTool.Domain.Entities.Organization;
using Microsoft.AspNetCore.Mvc;
using Xunit;
using ItsTool.Application.Interfaces;
using Moq;

namespace ItsTool.UnitTests.Controllers;

public class AssignmentRuleControllerTests : TestBase
{
    private readonly AssignmentRuleController _controller;
    private readonly Mock<ISystemAuditService> _mockAudit;

    public AssignmentRuleControllerTests() : base()
    {
        _mockAudit = new Mock<ISystemAuditService>();
        _controller = new AssignmentRuleController(_context, _mockAudit.Object);
    }

    [Fact]
    public async Task ToggleRule_ShouldInvertIsActiveAndLogAudit()
    {
        var rule = new AssignmentRule { Name = "ToggleTest", IsActive = true };
        _context.AssignmentRules.Add(rule);
        await _context.SaveChangesAsync();

        var result = await _controller.ToggleRule(rule.Id);
        
        Assert.IsType<NoContentResult>(result);
        Assert.False(rule.IsActive);
        
        _mockAudit.Verify(a => a.LogAuditAsync("Rule", "AssignmentRule", rule.Id.ToString(), "Toggled", "IsActive", "True", "False"), Times.Once);
    }
}
