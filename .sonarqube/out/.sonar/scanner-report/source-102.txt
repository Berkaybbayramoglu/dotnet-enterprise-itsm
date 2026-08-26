using ItsTool.Domain.Entities.Workflow;
using ItsTool.Domain.Entities.Config;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ItsTool.Infrastructure.Data.Configurations;

public class CustomFieldConfiguration : IEntityTypeConfiguration<FieldDefinition>
{
    public void Configure(EntityTypeBuilder<FieldDefinition> builder)
    {
        builder.HasIndex(f => f.Key).IsUnique();
    }
}

public class TicketFieldValueConfiguration : IEntityTypeConfiguration<TicketFieldValue>
{
    public void Configure(EntityTypeBuilder<TicketFieldValue> builder)
    {
        builder.HasIndex(tfv => new { tfv.TicketId, tfv.FieldDefinitionId }).IsUnique();
        
        builder.HasOne(tfv => tfv.Ticket)
               .WithMany()
               .HasForeignKey(tfv => tfv.TicketId)
               .OnDelete(DeleteBehavior.Cascade);
               
        builder.HasOne(tfv => tfv.FieldDefinition)
               .WithMany()
               .HasForeignKey(tfv => tfv.FieldDefinitionId)
               .OnDelete(DeleteBehavior.Restrict);
    }
}

public class WorkflowTransitionConfiguration : IEntityTypeConfiguration<WorkflowTransition>
{
    public void Configure(EntityTypeBuilder<WorkflowTransition> builder)
    {
        builder.HasOne(wt => wt.FromStatus)
               .WithMany()
               .HasForeignKey(wt => wt.FromStatusId)
               .OnDelete(DeleteBehavior.Restrict);

        builder.HasOne(wt => wt.ToStatus)
               .WithMany()
               .HasForeignKey(wt => wt.ToStatusId)
               .OnDelete(DeleteBehavior.Restrict);
    }
}
