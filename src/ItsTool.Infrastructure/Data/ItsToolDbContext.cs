using ItsTool.Domain.Entities.Organization;
using ItsTool.Domain.Entities.Auth;
using ItsTool.Domain.Entities.Project;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Domain.Entities.Workflow;
using ItsTool.Domain.Entities.Config;
using ItsTool.Domain.Entities.SLA;
using ItsTool.Domain.Entities.Notification;
using ItsTool.Domain.Entities.KnowledgeBase;
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

    // Ticket & Workflow
    public DbSet<TicketType> TicketTypes => Set<TicketType>();
    public DbSet<Category> Categories => Set<Category>();
    public DbSet<Status> Statuses => Set<Status>();
    public DbSet<Priority> Priorities => Set<Priority>();
    public DbSet<Ticket> Tickets => Set<Ticket>();
    public DbSet<TicketHistory> TicketHistories => Set<TicketHistory>();
    public DbSet<Workflow> Workflows => Set<Workflow>();
    public DbSet<WorkflowTransition> WorkflowTransitions => Set<WorkflowTransition>();
    public DbSet<TicketComment> TicketComments => Set<TicketComment>();
    public DbSet<TicketAttachment> TicketAttachments => Set<TicketAttachment>();
    public DbSet<TicketWatcher> TicketWatchers => Set<TicketWatcher>();
    public DbSet<ProjectSequence> ProjectSequences => Set<ProjectSequence>();

    // Config (EAV)
    public DbSet<FieldDefinition> FieldDefinitions => Set<FieldDefinition>();
    public DbSet<FieldOption> FieldOptions => Set<FieldOption>();
    public DbSet<FormFieldPlacement> FormFieldPlacements => Set<FormFieldPlacement>();
    public DbSet<TicketFieldValue> TicketFieldValues => Set<TicketFieldValue>();

    // SLA
    public DbSet<SlaPolicy> SlaPolicies => Set<SlaPolicy>();
    public DbSet<SlaTarget> SlaTargets => Set<SlaTarget>();
    public DbSet<BusinessHour> BusinessHours => Set<BusinessHour>();
    public DbSet<Holiday> Holidays => Set<Holiday>();

    // Notification
    public DbSet<NotificationRule> NotificationRules => Set<NotificationRule>();
    public DbSet<Notification> Notifications => Set<Notification>();

    // KnowledgeBase
    public DbSet<KnowledgeCategory> KnowledgeCategories => Set<KnowledgeCategory>();
    public DbSet<KnowledgeArticle> KnowledgeArticles => Set<KnowledgeArticle>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
        modelBuilder.ApplyConfigurationsFromAssembly(Assembly.GetExecutingAssembly());
    }
}
