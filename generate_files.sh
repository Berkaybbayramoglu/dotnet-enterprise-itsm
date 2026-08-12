#!/bin/bash
mkdir -p src/ItsTool.Domain/Common src/ItsTool.Domain/Entities/Organization src/ItsTool.Domain/Entities/Auth src/ItsTool.Domain/Entities/Project src/ItsTool.Domain/Entities/Ticket
mkdir -p src/ItsTool.Application/Common src/ItsTool.Application/DTOs src/ItsTool.Application/Interfaces src/ItsTool.Application/Services src/ItsTool.Application/Validators src/ItsTool.Application/Exceptions
mkdir -p src/ItsTool.Infrastructure/Data src/ItsTool.Infrastructure/Data/Configurations
mkdir -p src/ItsTool.Web/wwwroot/css src/ItsTool.Web/wwwroot/js

# Common Interfaces
cat << 'CS' > src/ItsTool.Domain/Common/IAuditable.cs
namespace ItsTool.Domain.Common;

public interface IAuditable
{
    DateTime CreatedAt { get; set; }
    string? CreatedBy { get; set; }
    DateTime? UpdatedAt { get; set; }
    string? UpdatedBy { get; set; }
}
CS

cat << 'CS' > src/ItsTool.Domain/Common/ISoftDelete.cs
namespace ItsTool.Domain.Common;

public interface ISoftDelete
{
    bool IsDeleted { get; set; }
    DateTime? DeletedAt { get; set; }
}
CS

cat << 'CS' > src/ItsTool.Domain/Common/BaseEntity.cs
namespace ItsTool.Domain.Common;

public abstract class BaseEntity : IAuditable, ISoftDelete
{
    public int Id { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public string? CreatedBy { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public string? UpdatedBy { get; set; }
    public bool IsActive { get; set; } = true;
    public bool IsDeleted { get; set; } = false;
    public DateTime? DeletedAt { get; set; }
}
CS

# Organization Entities
cat << 'CS' > src/ItsTool.Domain/Entities/Organization/Department.cs
using ItsTool.Domain.Common;

namespace ItsTool.Domain.Entities.Organization;

/// <summary>
/// Şirket içi departmanları temsil eder (Örn: BT, İK).
/// </summary>
public class Department : BaseEntity
{
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    
    // Navigation
    public virtual ICollection<Group> Groups { get; set; } = new List<Group>();
    public virtual ICollection<User> Users { get; set; } = new List<User>();
}
CS

cat << 'CS' > src/ItsTool.Domain/Entities/Organization/Group.cs
using ItsTool.Domain.Common;

namespace ItsTool.Domain.Entities.Organization;

/// <summary>
/// Departmana bağlı alt çalışma/çözüm gruplarını temsil eder.
/// </summary>
public class Group : BaseEntity
{
    public string Name { get; set; } = string.Empty;
    public int? DepartmentId { get; set; }
    
    // Navigation
    public virtual Department? Department { get; set; }
    public virtual ICollection<GroupMember> Members { get; set; } = new List<GroupMember>();
}
CS

cat << 'CS' > src/ItsTool.Domain/Entities/Organization/User.cs
using ItsTool.Domain.Common;

namespace ItsTool.Domain.Entities.Organization;

/// <summary>
/// Sistem kullanıcılarını temsil eder.
/// </summary>
public class User : BaseEntity
{
    public string Username { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string PasswordHash { get; set; } = string.Empty;
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
    public int? DepartmentId { get; set; }

    // Navigation
    public virtual Department? Department { get; set; }
    public virtual ICollection<GroupMember> GroupMemberships { get; set; } = new List<GroupMember>();
}
CS

cat << 'CS' > src/ItsTool.Domain/Entities/Organization/GroupMember.cs
using ItsTool.Domain.Common;

namespace ItsTool.Domain.Entities.Organization;

/// <summary>
/// Kullanıcı ve Grup arasındaki çoka-çok ilişkiyi temsil eder.
/// </summary>
public class GroupMember : BaseEntity
{
    public int UserId { get; set; }
    public int GroupId { get; set; }

    // Navigation
    public virtual User? User { get; set; }
    public virtual Group? Group { get; set; }
}
CS

# Auth Entities
cat << 'CS' > src/ItsTool.Domain/Entities/Auth/Role.cs
using ItsTool.Domain.Common;

namespace ItsTool.Domain.Entities.Auth;

/// <summary>
/// Sistem rollerini temsil eder.
/// </summary>
public class Role : BaseEntity
{
    public string Name { get; set; } = string.Empty;
}
CS

cat << 'CS' > src/ItsTool.Domain/Entities/Auth/Permission.cs
using ItsTool.Domain.Common;

namespace ItsTool.Domain.Entities.Auth;

/// <summary>
/// Sistem yetkilerini temsil eder (Örn: Ticket.Create).
/// </summary>
public class Permission : BaseEntity
{
    public string Name { get; set; } = string.Empty;
    public string Key { get; set; } = string.Empty;
}
CS

cat << 'CS' > src/ItsTool.Domain/Entities/Auth/RolePermission.cs
using ItsTool.Domain.Common;

namespace ItsTool.Domain.Entities.Auth;

/// <summary>
/// Rol - Yetki eşleştirmesi.
/// </summary>
public class RolePermission : BaseEntity
{
    public int RoleId { get; set; }
    public int PermissionId { get; set; }
    
    public virtual Role? Role { get; set; }
    public virtual Permission? Permission { get; set; }
}
CS

cat << 'CS' > src/ItsTool.Domain/Entities/Auth/UserRole.cs
using ItsTool.Domain.Common;
using ItsTool.Domain.Entities.Organization;

namespace ItsTool.Domain.Entities.Auth;

/// <summary>
/// Kullanıcı - Rol eşleştirmesi.
/// </summary>
public class UserRole : BaseEntity
{
    public int UserId { get; set; }
    public int RoleId { get; set; }

    public virtual User? User { get; set; }
    public virtual Role? Role { get; set; }
}
CS

cat << 'CS' > src/ItsTool.Domain/Entities/Auth/GroupRole.cs
using ItsTool.Domain.Common;
using ItsTool.Domain.Entities.Organization;

namespace ItsTool.Domain.Entities.Auth;

/// <summary>
/// Grup - Rol eşleştirmesi.
/// </summary>
public class GroupRole : BaseEntity
{
    public int GroupId { get; set; }
    public int RoleId { get; set; }

    public virtual Group? Group { get; set; }
    public virtual Role? Role { get; set; }
}
CS

cat << 'CS' > src/ItsTool.Domain/Entities/Auth/UserPermissionOverride.cs
using ItsTool.Domain.Common;
using ItsTool.Domain.Entities.Organization;

namespace ItsTool.Domain.Entities.Auth;

/// <summary>
/// Kullanıcı bazlı özel yetki eklentilerini (veya kısıtlarını) yönetir.
/// </summary>
public class UserPermissionOverride : BaseEntity
{
    public int UserId { get; set; }
    public int PermissionId { get; set; }
    public bool IsGranted { get; set; } // true ise eklenti, false ise kısıtlama

    public virtual User? User { get; set; }
    public virtual Permission? Permission { get; set; }
}
CS

# Project Entities
cat << 'CS' > src/ItsTool.Domain/Entities/Project/Project.cs
using ItsTool.Domain.Common;

namespace ItsTool.Domain.Entities.Project;

/// <summary>
/// Sistemdeki izole çalışma alanlarını/projeleri temsil eder.
/// </summary>
public class Project : BaseEntity
{
    public string Name { get; set; } = string.Empty;
    public string ProjectKey { get; set; } = string.Empty; // Örn: IT, HR
    public string? Description { get; set; }
    public int CurrentTicketSequence { get; set; } = 0; // Bilet numarası sayacı
}
CS

cat << 'CS' > src/ItsTool.Domain/Entities/Project/ProjectMember.cs
using ItsTool.Domain.Common;
using ItsTool.Domain.Entities.Organization;

namespace ItsTool.Domain.Entities.Project;

/// <summary>
/// Projeye dahil olan kullanıcıları tutar.
/// </summary>
public class ProjectMember : BaseEntity
{
    public int ProjectId { get; set; }
    public int UserId { get; set; }
    public int? SpecificRoleId { get; set; } // Projeye özel rol ataması

    public virtual Project? Project { get; set; }
    public virtual User? User { get; set; }
}
CS

# Ticket Entities
cat << 'CS' > src/ItsTool.Domain/Entities/Ticket/TicketType.cs
using ItsTool.Domain.Common;

namespace ItsTool.Domain.Entities.Ticket;

/// <summary>
/// Ticket tipini belirler (Örn: Incident, Request). Config-driven olduğu için tablo.
/// </summary>
public class TicketType : BaseEntity
{
    public string Name { get; set; } = string.Empty;
    public int ProjectId { get; set; }
}
CS

cat << 'CS' > src/ItsTool.Domain/Entities/Ticket/Category.cs
using ItsTool.Domain.Common;

namespace ItsTool.Domain.Entities.Ticket;

/// <summary>
/// Proje altındaki talep sınıflarını temsil eder (Örn: Donanım, Yazılım).
/// </summary>
public class Category : BaseEntity
{
    public string Name { get; set; } = string.Empty;
    public int ProjectId { get; set; }
    public int? ParentCategoryId { get; set; }
}
CS

cat << 'CS' > src/ItsTool.Domain/Entities/Ticket/Status.cs
using ItsTool.Domain.Common;

namespace ItsTool.Domain.Entities.Ticket;

/// <summary>
/// Talebin anlık durumunu temsil eder (Örn: Yeni, İşlemde).
/// </summary>
public class Status : BaseEntity
{
    public string Name { get; set; } = string.Empty;
    public int ProjectId { get; set; }
    public bool IsClosedStatus { get; set; } = false; // SLA için önemli
}
CS

cat << 'CS' > src/ItsTool.Domain/Entities/Ticket/Priority.cs
using ItsTool.Domain.Common;

namespace ItsTool.Domain.Entities.Ticket;

/// <summary>
/// Talebin önceliğini temsil eder (Örn: Kritik, Düşük).
/// </summary>
public class Priority : BaseEntity
{
    public string Name { get; set; } = string.Empty;
    public int ProjectId { get; set; }
    public int Weight { get; set; } // Sıralama veya SLA hesabı için
}
CS

cat << 'CS' > src/ItsTool.Domain/Entities/Ticket/Ticket.cs
using ItsTool.Domain.Common;
using ItsTool.Domain.Entities.Organization;

namespace ItsTool.Domain.Entities.Ticket;

/// <summary>
/// Ana talep (ticket) tablosudur.
/// </summary>
public class Ticket : BaseEntity
{
    public string TicketNumber { get; set; } = string.Empty;
    public string Title { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    
    public int ProjectId { get; set; }
    public int CategoryId { get; set; }
    public int TypeId { get; set; }
    public int StatusId { get; set; }
    public int PriorityId { get; set; }
    
    public int RequesterUserId { get; set; }
    public int? AssignedUserId { get; set; }
    public int? AssignedGroupId { get; set; }

    // Navigation
    public virtual Project.Project? Project { get; set; }
    public virtual Category? Category { get; set; }
    public virtual TicketType? Type { get; set; }
    public virtual Status? Status { get; set; }
    public virtual Priority? Priority { get; set; }
    public virtual User? RequesterUser { get; set; }
    public virtual User? AssignedUser { get; set; }
    public virtual Group? AssignedGroup { get; set; }
}
CS

cat << 'CS' > src/ItsTool.Domain/Entities/Ticket/TicketHistory.cs
using ItsTool.Domain.Common;

namespace ItsTool.Domain.Entities.Ticket;

/// <summary>
/// Bilet üzerindeki değişikliklerin genel logu (audit trail).
/// </summary>
public class TicketHistory : BaseEntity
{
    public int TicketId { get; set; }
    public string FieldName { get; set; } = string.Empty; // Hangi alan değişti
    public string? OldValue { get; set; }
    public string? NewValue { get; set; }
    public string Action { get; set; } = string.Empty; // Create, Update, Assign, Transition vb.

    public virtual Ticket? Ticket { get; set; }
}
CS

# DbContext and Configurations
cat << 'CS' > src/ItsTool.Infrastructure/Data/ItsToolDbContext.cs
using ItsTool.Domain.Entities.Organization;
using ItsTool.Domain.Entities.Auth;
using ItsTool.Domain.Entities.Project;
using ItsTool.Domain.Entities.Ticket;
using Microsoft.EntityFrameworkCore;
using System.Reflection;

namespace ItsTool.Infrastructure.Data;

public class ItsToolDbContext : DbContext
{
    public ItsToolDbContext(DbContextOptions<ItsToolDbContext> options) : base(options)
    {
    }

    // Organization
    public DbSet<Department> Departments => Set<Department>();
    public DbSet<Group> Groups => Set<Group>();
    public DbSet<User> Users => Set<User>();
    public DbSet<GroupMember> GroupMembers => Set<GroupMember>();

    // Auth
    public DbSet<Role> Roles => Set<Role>();
    public DbSet<Permission> Permissions => Set<Permission>();
    public DbSet<RolePermission> RolePermissions => Set<RolePermission>();
    public DbSet<UserRole> UserRoles => Set<UserRole>();
    public DbSet<GroupRole> GroupRoles => Set<GroupRole>();
    public DbSet<UserPermissionOverride> UserPermissionOverrides => Set<UserPermissionOverride>();

    // Project
    public DbSet<Project> Projects => Set<Project>();
    public DbSet<ProjectMember> ProjectMembers => Set<ProjectMember>();

    // Ticket
    public DbSet<TicketType> TicketTypes => Set<TicketType>();
    public DbSet<Category> Categories => Set<Category>();
    public DbSet<Status> Statuses => Set<Status>();
    public DbSet<Priority> Priorities => Set<Priority>();
    public DbSet<Ticket> Tickets => Set<Ticket>();
    public DbSet<TicketHistory> TicketHistories => Set<TicketHistory>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
        // Apply all IEntityTypeConfiguration from the current assembly
        modelBuilder.ApplyConfigurationsFromAssembly(Assembly.GetExecutingAssembly());
    }
}
CS

cat << 'CS' > src/ItsTool.Infrastructure/Data/Configurations/TicketConfiguration.cs
using ItsTool.Domain.Entities.Ticket;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ItsTool.Infrastructure.Data.Configurations;

public class TicketConfiguration : IEntityTypeConfiguration<Ticket>
{
    public void Configure(EntityTypeBuilder<Ticket> builder)
    {
        builder.HasKey(t => t.Id);
        
        builder.Property(t => t.TicketNumber)
               .IsRequired()
               .HasMaxLength(50);

        builder.HasIndex(t => t.TicketNumber).IsUnique();

        // Foreign keys config as an example
        builder.HasOne(t => t.RequesterUser)
               .WithMany()
               .HasForeignKey(t => t.RequesterUserId)
               .OnDelete(DeleteBehavior.Restrict);

        builder.HasOne(t => t.AssignedUser)
               .WithMany()
               .HasForeignKey(t => t.AssignedUserId)
               .OnDelete(DeleteBehavior.SetNull);
    }
}
CS

cat << 'CS' > src/ItsTool.Infrastructure/Data/ItsToolDbContextFactory.cs
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;
using Microsoft.Extensions.Configuration;

namespace ItsTool.Infrastructure.Data;

public class ItsToolDbContextFactory : IDesignTimeDbContextFactory<ItsToolDbContext>
{
    public ItsToolDbContext CreateDbContext(string[] args)
    {
        var optionsBuilder = new DbContextOptionsBuilder<ItsToolDbContext>();
        // Design-time fake connection string. It won't apply to db without running update
        optionsBuilder.UseNpgsql("Host=localhost;Database=itsm_tool;Username=postgres;Password=fake_password");

        return new ItsToolDbContext(optionsBuilder.Options);
    }
}
CS

# API files
cat << 'CS' > src/ItsTool.API/Program.cs
var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Minimal CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", builder =>
    {
        builder.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader();
    });
});

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("AllowAll");

app.MapGet("/api/health", () =>
{
    return Results.Ok(new
    {
        status = "OK",
        service = "ItsTool.API",
        timestamp = DateTime.UtcNow
    });
});

app.Run();
CS

cat << 'JSON' > src/ItsTool.API/appsettings.json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*"
}
JSON

cat << 'JSON' > src/ItsTool.API/appsettings.Development.json
{
  "ConnectionStrings": {
    "DefaultConnection": "Host=localhost;Database=itsm_tool;Username=postgres;Password=YOUR_PASSWORD_HERE"
  }
}
JSON

# Web Placeholder files
cat << 'HTML' > src/ItsTool.Web/wwwroot/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ITSM Tool</title>
    <link rel="stylesheet" href="/css/site.css">
</head>
<body>
    <div class="container">
        <h1>ITSM Tool</h1>
        <h2>Proje başlangıç iskeleti hazır</h2>
        <p>İlerleyen fazlarda gerçek web ekranları buraya eklenecektir.</p>
    </div>
    <script src="/js/site.js"></script>
</body>
</html>
HTML

cat << 'CSS' > src/ItsTool.Web/wwwroot/css/site.css
body {
    font-family: Arial, sans-serif;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    background-color: #f4f4f9;
    margin: 0;
}
.container {
    text-align: center;
    background: white;
    padding: 2rem;
    border-radius: 8px;
    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
}
CSS

cat << 'JS' > src/ItsTool.Web/wwwroot/js/site.js
console.log("ITSM Tool frontend loaded.");
JS

cat << 'CS' > src/ItsTool.Web/Program.cs
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.UseDefaultFiles();
app.UseStaticFiles();

app.Run();
CS

bash -c "chmod +x generate_files.sh && ./generate_files.sh"
