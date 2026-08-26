using System.Linq;
using System.Threading.Tasks;
using ItsTool.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;
using Xunit;

namespace ItsTool.UnitTests.Data;

public class DataSeederTests : TestBase
{
    [Fact]
    public async Task SeedAsync_ShouldUpsertFullReopenMatrix_WhenCalledMultipleTimes()
    {
        var seeder = new DataSeeder(_context);
        // First run
        await seeder.SeedAsync();

        var workflow = await _context.Workflows.FirstOrDefaultAsync(w => w.Name == "Default Global Workflow");
        Assert.NotNull(workflow);

        var closedStatus = await _context.Statuses.FirstOrDefaultAsync(s => s.Name == "Kapatıldı");
        var resolvedStatus = await _context.Statuses.FirstOrDefaultAsync(s => s.Name == "Çözüldü");
        var inProgressStatus = await _context.Statuses.FirstOrDefaultAsync(s => s.Name == "Devam Ediyor");

        Assert.NotNull(closedStatus);
        Assert.NotNull(resolvedStatus);
        Assert.NotNull(inProgressStatus);

        // Verify reopened transitions exist
        var closedToProgress = await _context.WorkflowTransitions
            .AnyAsync(wt => wt.WorkflowId == workflow!.Id && wt.FromStatusId == closedStatus!.Id && wt.ToStatusId == inProgressStatus!.Id);
        
        var resolvedToProgress = await _context.WorkflowTransitions
            .AnyAsync(wt => wt.WorkflowId == workflow!.Id && wt.FromStatusId == resolvedStatus!.Id && wt.ToStatusId == inProgressStatus!.Id);

        Assert.True(closedToProgress, "Closed -> In Progress transition missing");
        Assert.True(resolvedToProgress, "Resolved -> In Progress transition missing");

        // Delete one to simulate drift/modification
        var transitionToRemove = await _context.WorkflowTransitions
            .FirstAsync(wt => wt.FromStatusId == closedStatus!.Id && wt.ToStatusId == inProgressStatus!.Id);
        _context.WorkflowTransitions.Remove(transitionToRemove);
        await _context.SaveChangesAsync();

        // Second run - should upsert the missing one
        await seeder.SeedAsync();

        var missingTransitionIsBack = await _context.WorkflowTransitions
            .AnyAsync(wt => wt.WorkflowId == workflow!.Id && wt.FromStatusId == closedStatus!.Id && wt.ToStatusId == inProgressStatus!.Id);

        Assert.True(missingTransitionIsBack, "Seeder failed to UPSERT the missing Reopen transition.");
    }
}
