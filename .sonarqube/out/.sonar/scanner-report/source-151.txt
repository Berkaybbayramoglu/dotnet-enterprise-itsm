using ItsTool.Domain.Entities.Ticket;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
namespace ItsTool.Infrastructure.Data.Configurations;
public class TicketConfiguration : IEntityTypeConfiguration<Ticket> {
    public void Configure(EntityTypeBuilder<Ticket> builder) {
        builder.HasKey(t => t.Id);
        builder.Property(t => t.TicketNumber).IsRequired().HasMaxLength(50);
        builder.HasIndex(t => t.TicketNumber).IsUnique();
        builder.HasOne(t => t.RequesterUser).WithMany().HasForeignKey(t => t.RequesterUserId).OnDelete(DeleteBehavior.Restrict);
        
        builder.HasMany(t => t.Assignments)
               .WithOne(a => a.Ticket)
               .HasForeignKey(a => a.TicketId)
               .OnDelete(DeleteBehavior.Cascade);
    }
}
