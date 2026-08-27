using ItsTool.Domain.Entities.Organization;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ItsTool.Infrastructure.Data.Configurations;

public class DepartmentConfiguration : IEntityTypeConfiguration<Department>
{
    public void Configure(EntityTypeBuilder<Department> builder)
    {
        builder.HasKey(d => d.Id);
        
        builder.HasOne(d => d.ManagerUser)
               .WithMany()
               .HasForeignKey(d => d.ManagerUserId)
               .OnDelete(DeleteBehavior.SetNull);
    }
}
