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
        if (_context.TicketTypes.Any() || _context.Users.Any())
        {
            return; // Veritabanında veri varsa seed atlama
        }

        // 1. Ticket Types
        var incident = new TicketType { Name = "Incident" };
        var serviceRequest = new TicketType { Name = "Service Request" };
        _context.TicketTypes.AddRange(incident, serviceRequest);

        // 2. Statuses
        var open = new Status { Name = "Açık", SortOrder = 1, IsSystemDefault = true };
        var inProgress = new Status { Name = "Devam Ediyor", SortOrder = 2 };
        var pending = new Status { Name = "Beklemede", SortOrder = 3, PausesSla = true };
        var resolved = new Status { Name = "Çözüldü", SortOrder = 4, IsClosedStatus = true };
        var closed = new Status { Name = "Kapatıldı", SortOrder = 5, IsClosedStatus = true };
        _context.Statuses.AddRange(open, inProgress, pending, resolved, closed);

        // 3. Priorities
        var critical = new Priority { Name = "Kritik", Weight = 100, SeverityLevel = 1 };
        var high = new Priority { Name = "Yüksek", Weight = 75, SeverityLevel = 2 };
        var medium = new Priority { Name = "Orta", Weight = 50, SeverityLevel = 3 };
        var low = new Priority { Name = "Düşük", Weight = 25, SeverityLevel = 4 };
        _context.Priorities.AddRange(critical, high, medium, low);

        // 4. Departments
        var itDept = new Department { Name = "Bilgi Teknolojileri" };
        var hrDept = new Department { Name = "İnsan Kaynakları" };
        _context.Departments.AddRange(itDept, hrDept);

        // 5. Groups
        var helpdesk = new Group { Name = "Helpdesk Ekibi", Department = itDept };
        var sysNetwork = new Group { Name = "Sistem & Network Ekibi", Department = itDept };
        _context.Groups.AddRange(helpdesk, sysNetwork);

        // 6. Roles & Permissions
        var superAdminRole = new Role { Name = "SuperAdmin" };
        _context.Roles.Add(superAdminRole);
        
        if (!_context.Permissions.Any())
        {
            var permissions = ItsTool.Application.Constants.PermissionConstants.AllPermissions
                .Select(p => new Permission { Name = p, Key = p })
                .ToList();
            _context.Permissions.AddRange(permissions);

            // İlişkileri kurmak için SaveChanges yapıp Id'leri almalıyız
            await _context.SaveChangesAsync();
            
            foreach (var p in permissions)
            {
                _context.RolePermissions.Add(new RolePermission { RoleId = superAdminRole.Id, PermissionId = p.Id });
            }
        }

        // 7. İlk Admin Kullanıcısı
        var adminUser = new User
        {
            Username = "admin",
            Email = "admin@itsm.local",
            FirstName = "System",
            LastName = "Admin",
            Department = itDept,
            PasswordHash = BCrypt.Net.BCrypt.HashPassword("Admin123!")
        };
        _context.Users.Add(adminUser);

        // Değişiklikleri kaydet ki Id'ler üretilsin
        await _context.SaveChangesAsync();

        // 8. Admin Kullanıcısına Rol Atama
        _context.UserRoles.Add(new UserRole
        {
            UserId = adminUser.Id,
            RoleId = superAdminRole.Id
        });

        // 9. 5 Adet Default Proje (Doküman Madde 3.3)
        var p1 = new ItsTool.Domain.Entities.Project.Project { Name = "IT Destek", ProjectKey = "ITS" };
        var p2 = new ItsTool.Domain.Entities.Project.Project { Name = "İnsan Kaynakları", ProjectKey = "HR" };
        var p3 = new ItsTool.Domain.Entities.Project.Project { Name = "Yazılım Geliştirme", ProjectKey = "DEV" };
        var p4 = new ItsTool.Domain.Entities.Project.Project { Name = "DevOps & Altyapı", ProjectKey = "OPS" };
        var p5 = new ItsTool.Domain.Entities.Project.Project { Name = "Güvenlik Operasyonları", ProjectKey = "SEC" };
        _context.Projects.AddRange(p1, p2, p3, p4, p5);

        // 10. SLA Seed Data
        var policy = new SlaPolicy { Name = "Default SLA Policy", Description = "Varsayılan hizmet seviyesi sözleşmesi" };
        _context.SlaPolicies.Add(policy);
        
        await _context.SaveChangesAsync();

        _context.SlaTargets.AddRange(
            new SlaTarget { SlaPolicyId = policy.Id, PriorityId = critical.Id, FirstResponseMinutes = 30, ResolutionMinutes = 240 },
            new SlaTarget { SlaPolicyId = policy.Id, PriorityId = high.Id, FirstResponseMinutes = 120, ResolutionMinutes = 1440 },
            new SlaTarget { SlaPolicyId = policy.Id, PriorityId = medium.Id, FirstResponseMinutes = 480, ResolutionMinutes = 4320 },
            new SlaTarget { SlaPolicyId = policy.Id, PriorityId = low.Id, FirstResponseMinutes = 1440, ResolutionMinutes = 7200 }
        );

        for (int i = 1; i <= 5; i++) // Pzt(1) - Cum(5)
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
