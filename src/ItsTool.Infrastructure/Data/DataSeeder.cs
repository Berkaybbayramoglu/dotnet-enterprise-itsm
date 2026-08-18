using ItsTool.Domain.Entities.Organization;
using ItsTool.Domain.Entities.Auth;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Domain.Entities.SLA;
using BCrypt.Net;

namespace ItsTool.Infrastructure.Data;

public class DataSeeder
{
    private readonly ItsToolDbContext _context;

    public DataSeeder(ItsToolDbContext context)
    {
        _context = context;
    }

    public async Task SeedAsync()
    {
        // 1. Ticket Types
        if (!_context.TicketTypes.Any())
        {
            _context.TicketTypes.AddRange(
                new TicketType { Name = "Incident" },
                new TicketType { Name = "Service Request" }
            );
        }

        // 2. Statuses
        if (!_context.Statuses.Any())
        {
            _context.Statuses.AddRange(
                new Status { Name = "Açık", SortOrder = 1, IsSystemDefault = true },
                new Status { Name = "Devam Ediyor", SortOrder = 2 },
                new Status { Name = "Beklemede", SortOrder = 3, PausesSla = true },
                new Status { Name = "Çözüldü", SortOrder = 4, IsClosedStatus = true },
                new Status { Name = "Kapatıldı", SortOrder = 5, IsClosedStatus = true }
            );
        }

        // 3. Priorities
        if (!_context.Priorities.Any())
        {
            _context.Priorities.AddRange(
                new Priority { Name = "Kritik", Weight = 100, SeverityLevel = 1 },
                new Priority { Name = "Yüksek", Weight = 75, SeverityLevel = 2 },
                new Priority { Name = "Orta", Weight = 50, SeverityLevel = 3 },
                new Priority { Name = "Düşük", Weight = 25, SeverityLevel = 4 }
            );
        }

        // 4. Departments
        if (!_context.Departments.Any())
        {
            _context.Departments.AddRange(
                new Department { Name = "Bilgi Teknolojileri" },
                new Department { Name = "İnsan Kaynakları" }
            );
        }
        await _context.SaveChangesAsync();

        var itDept = _context.Departments.FirstOrDefault(d => d.Name == "Bilgi Teknolojileri");

        // 5. Groups
        if (!_context.Groups.Any() && itDept != null)
        {
            _context.Groups.AddRange(
                new Group { Name = "Helpdesk Ekibi", DepartmentId = itDept.Id },
                new Group { Name = "Sistem & Network Ekibi", DepartmentId = itDept.Id }
            );
            await _context.SaveChangesAsync();
        }

        // 6. Roles & Permissions
        var superAdminRole = _context.Roles.FirstOrDefault(r => r.Name == "SuperAdmin");
        if (superAdminRole == null)
        {
            superAdminRole = new Role { Name = "SuperAdmin" };
            _context.Roles.Add(superAdminRole);
            await _context.SaveChangesAsync();
        }

        if (!_context.Permissions.Any())
        {
            var permissions = ItsTool.Application.Constants.PermissionConstants.AllPermissions
                .Select(p => new Permission { Name = p, Key = p })
                .ToList();
            _context.Permissions.AddRange(permissions);
            await _context.SaveChangesAsync();
            
            foreach (var p in permissions)
            {
                _context.RolePermissions.Add(new RolePermission { RoleId = superAdminRole.Id, PermissionId = p.Id });
            }
            await _context.SaveChangesAsync();
        }

        // 7. İlk Admin Kullanıcısı
        var adminUser = _context.Users.FirstOrDefault(u => u.Username == "admin");
        if (adminUser == null && itDept != null)
        {
            adminUser = new User
            {
                Username = "admin",
                Email = "admin@itsm.local",
                FirstName = "System",
                LastName = "Admin",
                DepartmentId = itDept.Id,
                PasswordHash = BCrypt.Net.BCrypt.HashPassword("Admin123!")
            };
            _context.Users.Add(adminUser);
            await _context.SaveChangesAsync();

            // 8. Admin Kullanıcısına Rol Atama
            _context.UserRoles.Add(new UserRole
            {
                UserId = adminUser.Id,
                RoleId = superAdminRole.Id
            });
            await _context.SaveChangesAsync();
        }

        // 9. 5 Adet Default Proje (Doküman Madde 3.3)
        if (!_context.Projects.Any())
        {
            _context.Projects.AddRange(
                new ItsTool.Domain.Entities.Project.Project { Name = "IT Destek", ProjectKey = "ITS" },
                new ItsTool.Domain.Entities.Project.Project { Name = "İnsan Kaynakları", ProjectKey = "HR" },
                new ItsTool.Domain.Entities.Project.Project { Name = "Yazılım Geliştirme", ProjectKey = "DEV" },
                new ItsTool.Domain.Entities.Project.Project { Name = "DevOps & Altyapı", ProjectKey = "OPS" },
                new ItsTool.Domain.Entities.Project.Project { Name = "Güvenlik Operasyonları", ProjectKey = "SEC" }
            );
            await _context.SaveChangesAsync();
        }

        // 10. Default Categories for ITS project
        var itsProject = _context.Projects.FirstOrDefault(p => p.ProjectKey == "ITS");
        if (!_context.Categories.Any() && itsProject != null)
        {
            _context.Categories.AddRange(
                new ItsTool.Domain.Entities.Ticket.Category { Name = "Donanım Arızası", ProjectId = itsProject.Id },
                new ItsTool.Domain.Entities.Ticket.Category { Name = "Yazılım Talebi", ProjectId = itsProject.Id },
                new ItsTool.Domain.Entities.Ticket.Category { Name = "Ağ & İnternet", ProjectId = itsProject.Id }
            );
            await _context.SaveChangesAsync();
        }

        // 11. Dynamic Fields Demo
        if (!_context.FieldDefinitions.Any())
        {
            var serverNameField = new ItsTool.Domain.Entities.Config.FieldDefinition { Key = "sunucu_adi", Label = "Sunucu Adı", FieldType = ItsTool.Domain.Entities.Config.FieldType.Text };
            var impactedUsersField = new ItsTool.Domain.Entities.Config.FieldDefinition { Key = "etkilenen_kullanicilar", Label = "Etkilenen Kullanıcı Sayısı", FieldType = ItsTool.Domain.Entities.Config.FieldType.Number };
            _context.FieldDefinitions.AddRange(serverNameField, impactedUsersField);
            await _context.SaveChangesAsync();

            var hwCategory = _context.Categories.FirstOrDefault(c => c.Name == "Donanım Arızası");
            if (hwCategory != null)
            {
                _context.FormFieldPlacements.AddRange(
                    new ItsTool.Domain.Entities.Config.FormFieldPlacement { CategoryId = hwCategory.Id, FieldDefinitionId = serverNameField.Id, SortOrder = 1, IsRequired = true },
                    new ItsTool.Domain.Entities.Config.FormFieldPlacement { CategoryId = hwCategory.Id, FieldDefinitionId = impactedUsersField.Id, SortOrder = 2, IsRequired = false }
                );
                await _context.SaveChangesAsync();
            }
        }

        // 12. SLA Seed Data
        if (!_context.SlaPolicies.Any())
        {
            var policy = new SlaPolicy { Name = "Default SLA Policy", Description = "Varsayılan hizmet seviyesi sözleşmesi" };
            _context.SlaPolicies.Add(policy);
            await _context.SaveChangesAsync();

            var critical = _context.Priorities.FirstOrDefault(p => p.Name == "Kritik");
            var high = _context.Priorities.FirstOrDefault(p => p.Name == "Yüksek");
            var medium = _context.Priorities.FirstOrDefault(p => p.Name == "Orta");
            var low = _context.Priorities.FirstOrDefault(p => p.Name == "Düşük");

            if (critical != null && high != null && medium != null && low != null)
            {
                _context.SlaTargets.AddRange(
                    new SlaTarget { SlaPolicyId = policy.Id, PriorityId = critical.Id, FirstResponseMinutes = 30, ResolutionMinutes = 240 },
                    new SlaTarget { SlaPolicyId = policy.Id, PriorityId = high.Id, FirstResponseMinutes = 120, ResolutionMinutes = 1440 },
                    new SlaTarget { SlaPolicyId = policy.Id, PriorityId = medium.Id, FirstResponseMinutes = 480, ResolutionMinutes = 4320 },
                    new SlaTarget { SlaPolicyId = policy.Id, PriorityId = low.Id, FirstResponseMinutes = 1440, ResolutionMinutes = 7200 }
                );
            }

            for (int i = 1; i <= 5; i++)
            {
                _context.BusinessHours.Add(new BusinessHour
                {
                    DayOfWeek = (DayOfWeek)i,
                    StartTime = new TimeSpan(9, 0, 0),
                    EndTime = new TimeSpan(18, 0, 0),
                    IsWorkingDay = true
                });
            }
            _context.BusinessHours.Add(new BusinessHour { DayOfWeek = DayOfWeek.Saturday, IsWorkingDay = false });
            _context.BusinessHours.Add(new BusinessHour { DayOfWeek = DayOfWeek.Sunday, IsWorkingDay = false });

            await _context.SaveChangesAsync();
        }
    }
}
