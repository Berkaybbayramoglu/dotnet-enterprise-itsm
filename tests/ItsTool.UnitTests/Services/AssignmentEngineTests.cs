using System.Threading.Tasks;
using ItsTool.Domain.Entities.Organization;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Infrastructure.Services;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class AssignmentEngineTests : TestBase
{
    private readonly AssignmentEngine _engine;

    public AssignmentEngineTests() : base()
    {
        _engine = new AssignmentEngine(_context);
    }

    [Fact]
    public async Task AssignTicketAsync_ShouldAssign_WhenRuleMatches()
    {
        var rule1 = new AssignmentRule { Name = "R1", SortOrder = 10, ProjectId = 1, TargetUserId = 99, IsActive = true };
        _context.AssignmentRules.Add(rule1);
        await _context.SaveChangesAsync();

        var ticket = new Ticket { ProjectId = 1, CategoryId = 2 };
        
        await _engine.AssignTicketAsync(ticket);
        
        Assert.Equal(99, ticket.Assignments.FirstOrDefault()?.AssignedUserId);
    }

    [Fact]
    public async Task AssignTicketAsync_ShouldSkipInactiveRules()
    {
        var rule1 = new AssignmentRule { Name = "R1", SortOrder = 10, ProjectId = 1, TargetUserId = 99, IsActive = false };
        _context.AssignmentRules.Add(rule1);
        await _context.SaveChangesAsync();

        var ticket = new Ticket { ProjectId = 1 };
        
        await _engine.AssignTicketAsync(ticket);
        
        Assert.Null(ticket.Assignments.FirstOrDefault()?.AssignedUserId); // Remained unassigned
    }

    [Fact]
    public async Task AssignTicketAsync_ShouldPickFirstMatchBySortOrder()
    {
        var rule1 = new AssignmentRule { Name = "R1", SortOrder = 20, ProjectId = 1, TargetUserId = 99, IsActive = true };
        var rule2 = new AssignmentRule { Name = "R2", SortOrder = 10, ProjectId = 1, TargetUserId = 88, IsActive = true };
        _context.AssignmentRules.AddRange(rule1, rule2);
        await _context.SaveChangesAsync();

        var ticket = new Ticket { ProjectId = 1 };
        
        await _engine.AssignTicketAsync(ticket);
        
        Assert.Equal(88, ticket.Assignments.FirstOrDefault()?.AssignedUserId); // 10 comes before 20
    }
}
