using ItsTool.Domain.Entities.Ticket;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ItsTool.Infrastructure.Data.Configurations;

public class TicketAssignmentConfiguration : IEntityTypeConfiguration<TicketAssignment>
{
    public void Configure(EntityTypeBuilder<TicketAssignment> builder)
    {
        builder.HasKey(a => a.Id);
        
        builder.HasOne(a => a.AssignedUser)
               .WithMany()
               .HasForeignKey(a => a.AssignedUserId)
               .OnDelete(DeleteBehavior.Restrict);

        builder.HasOne(a => a.AssignedGroup)
               .WithMany()
               .HasForeignKey(a => a.AssignedGroupId)
               .OnDelete(DeleteBehavior.Restrict);

        builder.HasOne(a => a.AssignedByUser)
               .WithMany()
               .HasForeignKey(a => a.AssignedByUserId)
               .OnDelete(DeleteBehavior.Restrict);

        builder.HasOne(a => a.ParentAssignment)
               .WithMany()
               .HasForeignKey(a => a.ParentAssignmentId)
               .OnDelete(DeleteBehavior.Restrict);
    }
}
