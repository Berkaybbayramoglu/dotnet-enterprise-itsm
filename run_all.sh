#!/bin/bash
mkdir -p src/ItsTool.Domain/Common src/ItsTool.Domain/Entities/Organization src/ItsTool.Domain/Entities/Auth src/ItsTool.Domain/Entities/Project src/ItsTool.Domain/Entities/Ticket
mkdir -p src/ItsTool.Application/Common src/ItsTool.Application/DTOs src/ItsTool.Application/Interfaces src/ItsTool.Application/Services src/ItsTool.Application/Validators src/ItsTool.Application/Exceptions
mkdir -p src/ItsTool.Infrastructure/Data src/ItsTool.Infrastructure/Data/Configurations
mkdir -p src/ItsTool.Web/wwwroot/css src/ItsTool.Web/wwwroot/js

cat << 'CS' > src/ItsTool.Domain/Common/IAuditable.cs
namespace ItsTool.Domain.Common;
public interface IAuditable {
    System.DateTime CreatedAt { get; set; }
    string? CreatedBy { get; set; }
    System.DateTime? UpdatedAt { get; set; }
    string? UpdatedBy { get; set; }
}
CS

cat << 'CS' > src/ItsTool.Domain/Common/ISoftDelete.cs
namespace ItsTool.Domain.Common;
public interface ISoftDelete {
    bool IsDeleted { get; set; }
    System.DateTime? DeletedAt { get; set; }
}
CS

cat << 'CS' > src/ItsTool.Domain/Common/BaseEntity.cs
namespace ItsTool.Domain.Common;
public abstract class BaseEntity : IAuditable, ISoftDelete {
    public int Id { get; set; }
    public System.DateTime CreatedAt { get; set; } = System.DateTime.UtcNow;
    public string? CreatedBy { get; set; }
    public System.DateTime? UpdatedAt { get; set; }
    public string? UpdatedBy { get; set; }
    public bool IsActive { get; set; } = true;
    public bool IsDeleted { get; set; } = false;
    public System.DateTime? DeletedAt { get; set; }
}
CS

cat << 'CS' > src/ItsTool.Domain/Entities/Organization/Department.cs
using ItsTool.Domain.Common;
using System.Collections.Generic;
namespace ItsTool.Domain.Entities.Organization;
public class Department : BaseEntity {
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    public virtual ICollection<Group> Groups { get; set; } = new List<Group>();
    public virtual ICollection<User> Users { get; set; } = new List<User>();
}
CS

cat << 'CS' > src/ItsTool.Domain/Entities/Organization/Group.cs
using ItsTool.Domain.Common;
using System.Collections.Generic;
namespace ItsTool.Domain.Entities.Organization;
public class Group : BaseEntity {
    public string Name { get; set; } = string.Empty;
    public int? DepartmentId { get; set; }
    public virtual Department? Department { get; set; }
    public virtual ICollection<GroupMember> Members { get; set; } = new List<GroupMember>();
}
CS

cat << 'CS' > src/ItsTool.Domain/Entities/Organization/User.cs
using ItsTool.Domain.Common;
using System.Collections.Generic;
namespace ItsTool.Domain.Entities.Organization;
public class User : BaseEntity {
    public string Username { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string PasswordHash { get; set; } = string.Empty;
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
    public int? DepartmentId { get; set; }
    public virtual Department? Department { get; set; }
    public virtual ICollection<GroupMember> GroupMemberships { get; set; } = new List<GroupMember>();
}
CS

cat << 'CS' > src/ItsTool.Domain/Entities/Organization/GroupMember.cs
using ItsTool.Domain.Common;
namespace ItsTool.Domain.Entities.Organization;
public class GroupMember : BaseEntity {
    public int UserId { get; set; }
    public int GroupId { get; set; }
    public virtual User? User { get; set; }
    public virtual Group? Group { get; set; }
}
CS

cat << 'CS' > src/ItsTool.Domain/Entities/Auth/Role.cs
using ItsTool.Domain.Common;
namespace ItsTool.Domain.Entities.Auth;
public class Role : BaseEntity {
    public string Name { get; set; } = string.Empty;
}
CS

cat << 'CS' > src/ItsTool.Domain/Entities/Auth/Permission.cs
using ItsTool.Domain.Common;
namespace ItsTool.Domain.Entities.Auth;
public class Permission : BaseEntity {
    public string Name { get; set; } = string.Empty;
    public string Key { get; set; } = string.Empty;
}
CS

cat << 'CS' > src/ItsTool.Domain/Entities/Auth/RolePermission.cs
using ItsTool.Domain.Common;
namespace ItsTool.Domain.Entities.Auth;
public class RolePermission : BaseEntity {
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
public class UserRole : BaseEntity {
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
public class GroupRole : BaseEntity {
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
public class UserPermissionOverride : BaseEntity {
    public int UserId { get; set; }
    public int PermissionId { get; set; }
    public bool IsGranted { get; set; }
    public virtual User? User { get; set; }
    public virtual Permission? Permission { get; set; }
}
CS

cat << 'CS' > src/ItsTool.Domain/Entities/Project/Project.cs
using ItsTool.Domain.Common;
namespace ItsTool.Domain.Entities.Project;
public class Project : BaseEntity {
    public string Name { get; set; } = string.Empty;
    public string ProjectKey { get; set; } = string.Empty;
    public string? Description { get; set; }
    public int CurrentTicketSequence { get; set; } = 0;
}
CS

cat << 'CS' > src/ItsTool.Domain/Entities/Project/ProjectMember.cs
using ItsTool.Domain.Common;
using ItsTool.Domain.Entities.Organization;
namespace ItsTool.Domain.Entities.Project;
public class ProjectMember : BaseEntity {
    public int ProjectId { get; set; }
    public int UserId { get; set; }
    public int? SpecificRoleId { get; set; }
    public virtual Project? Project { get; set; }
    public virtual User? User { get; set; }
}
CS

cat << 'CS' > src/ItsTool.Domain/Entities/Ticket/Ticket.cs
using ItsTool.Domain.Common;
using ItsTool.Domain.Entities.Organization;
namespace ItsTool.Domain.Entities.Ticket;
public class Ticket : BaseEntity {
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
public class TicketHistory : BaseEntity {
    public int TicketId { get; set; }
    public string FieldName { get; set; } = string.Empty;
    public string? OldValue { get; set; }
    public string? NewValue { get; set; }
    public string Action { get; set; } = string.Empty;
    public virtual Ticket? Ticket { get; set; }
}
CS

cat << 'CS' > src/ItsTool.Infrastructure/Data/Configurations/TicketConfiguration.cs
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
        builder.HasOne(t => t.AssignedUser).WithMany().HasForeignKey(t => t.AssignedUserId).OnDelete(DeleteBehavior.SetNull);
    }
}
CS

