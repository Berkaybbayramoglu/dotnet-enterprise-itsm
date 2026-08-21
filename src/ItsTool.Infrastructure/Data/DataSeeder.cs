using ItsTool.Domain.Entities.Organization;
using ItsTool.Domain.Entities.Auth;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Domain.Entities.SLA;
using Microsoft.EntityFrameworkCore;
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

        var allPermissions = ItsTool.Application.Constants.PermissionConstants.AllPermissions;
        var existingPermissions = _context.Permissions.ToList();
        var superAdminRolePermissions = _context.RolePermissions.Where(rp => rp.RoleId == superAdminRole.Id).ToList();

        foreach (var pKey in allPermissions)
        {
            var dbPermission = existingPermissions.FirstOrDefault(p => p.Key == pKey);
            if (dbPermission == null)
            {
                dbPermission = new Permission { Name = pKey, Key = pKey };
                _context.Permissions.Add(dbPermission);
                existingPermissions.Add(dbPermission);
            }

            if (!superAdminRolePermissions.Any(rp => rp.PermissionId == dbPermission.Id && rp.RoleId == superAdminRole.Id))
            {
                var rolePerm = new RolePermission { RoleId = superAdminRole.Id, Permission = dbPermission };
                _context.RolePermissions.Add(rolePerm);
                superAdminRolePermissions.Add(rolePerm);
            }
        }
        await _context.SaveChangesAsync();

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
        }

        // 8. Admin Kullanıcısına Rol Atama (Idempotent)
        if (adminUser != null && superAdminRole != null)
        {
            var adminHasSuperRole = _context.UserRoles.Any(ur => ur.UserId == adminUser.Id && ur.RoleId == superAdminRole.Id);
            if (!adminHasSuperRole)
            {
                _context.UserRoles.Add(new UserRole
                {
                    UserId = adminUser.Id,
                    RoleId = superAdminRole.Id
                });
                await _context.SaveChangesAsync();
            }
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
        // 13. Default Workflow & Transitions
        var defaultWorkflow = await _context.Workflows.FirstOrDefaultAsync(w => w.Name == "Default Global Workflow");
        if (defaultWorkflow == null)
        {
            defaultWorkflow = new ItsTool.Domain.Entities.Workflow.Workflow 
            { 
                Name = "Default Global Workflow", 
                Description = "Sistem varsayılan iş akışı", 
                IsActive = true 
            };
            _context.Workflows.Add(defaultWorkflow);
            await _context.SaveChangesAsync();
        }

            var openStatus = _context.Statuses.FirstOrDefault(s => s.Name == "Açık");
            var inProgressStatus = _context.Statuses.FirstOrDefault(s => s.Name == "Devam Ediyor");
            var onHoldStatus = _context.Statuses.FirstOrDefault(s => s.Name == "Beklemede");
            var resolvedStatus = _context.Statuses.FirstOrDefault(s => s.Name == "Çözüldü");
            var closedStatus = _context.Statuses.FirstOrDefault(s => s.Name == "Kapatıldı");

        if (openStatus != null && inProgressStatus != null && onHoldStatus != null && resolvedStatus != null && closedStatus != null)
        {
            var desiredTransitions = new List<ItsTool.Domain.Entities.Workflow.WorkflowTransition>
            {
                // Open -> {InProgress,Pending,Resolved,Closed}
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = openStatus.Id, ToStatusId = inProgressStatus.Id, IsActive = true, TransitionName = "Start Progress" },
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = openStatus.Id, ToStatusId = onHoldStatus.Id, IsActive = true, TransitionName = "Put on Hold" },
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = openStatus.Id, ToStatusId = resolvedStatus.Id, IsActive = true, TransitionName = "Resolve", RequiredPermissionKey = "ticket.resolve" },
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = openStatus.Id, ToStatusId = closedStatus.Id, IsActive = true, TransitionName = "Close", RequiredPermissionKey = "ticket.close" },

                // In Progress -> {Open,Pending,Resolved,Closed}
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = inProgressStatus.Id, ToStatusId = openStatus.Id, IsActive = true, TransitionName = "Move to Open" },
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = inProgressStatus.Id, ToStatusId = onHoldStatus.Id, IsActive = true, TransitionName = "Put on Hold" },
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = inProgressStatus.Id, ToStatusId = resolvedStatus.Id, IsActive = true, TransitionName = "Resolve", RequiredPermissionKey = "ticket.resolve" },
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = inProgressStatus.Id, ToStatusId = closedStatus.Id, IsActive = true, TransitionName = "Close", RequiredPermissionKey = "ticket.close" },

                // Pending (On Hold) -> {Open,InProgress,Resolved,Closed}
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = onHoldStatus.Id, ToStatusId = openStatus.Id, IsActive = true, TransitionName = "Move to Open" },
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = onHoldStatus.Id, ToStatusId = inProgressStatus.Id, IsActive = true, TransitionName = "Resume Progress" },
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = onHoldStatus.Id, ToStatusId = resolvedStatus.Id, IsActive = true, TransitionName = "Resolve", RequiredPermissionKey = "ticket.resolve" },
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = onHoldStatus.Id, ToStatusId = closedStatus.Id, IsActive = true, TransitionName = "Close", RequiredPermissionKey = "ticket.close" },

                // Resolved -> {Open,InProgress,Pending,Closed}
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = resolvedStatus.Id, ToStatusId = openStatus.Id, IsActive = true, TransitionName = "Reopen to Open", RequiredPermissionKey = "ticket.reopen" },
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = resolvedStatus.Id, ToStatusId = inProgressStatus.Id, IsActive = true, TransitionName = "Reopen to Progress", RequiredPermissionKey = "ticket.reopen" },
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = resolvedStatus.Id, ToStatusId = onHoldStatus.Id, IsActive = true, TransitionName = "Reopen to Pending", RequiredPermissionKey = "ticket.reopen" },
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = resolvedStatus.Id, ToStatusId = closedStatus.Id, IsActive = true, TransitionName = "Close", RequiredPermissionKey = "ticket.close" },

                // Closed -> {Open,InProgress,Pending,Resolved}
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = closedStatus.Id, ToStatusId = openStatus.Id, IsActive = true, TransitionName = "Reopen to Open", RequiredPermissionKey = "ticket.reopen" },
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = closedStatus.Id, ToStatusId = inProgressStatus.Id, IsActive = true, TransitionName = "Reopen to Progress", RequiredPermissionKey = "ticket.reopen" },
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = closedStatus.Id, ToStatusId = onHoldStatus.Id, IsActive = true, TransitionName = "Reopen to Pending", RequiredPermissionKey = "ticket.reopen" },
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = closedStatus.Id, ToStatusId = resolvedStatus.Id, IsActive = true, TransitionName = "Reopen to Resolved", RequiredPermissionKey = "ticket.reopen" }
            };

            var currentTransitions = await _context.WorkflowTransitions
                .Where(wt => wt.WorkflowId == defaultWorkflow.Id)
                .ToListAsync();

            foreach (var dt in desiredTransitions)
            {
                var exists = currentTransitions.Any(wt => wt.FromStatusId == dt.FromStatusId && wt.ToStatusId == dt.ToStatusId);
                if (!exists)
                {
                    _context.WorkflowTransitions.Add(dt);
                }
            }
            await _context.SaveChangesAsync();
        }

        var existingTransitions = _context.WorkflowTransitions.Where(wt => string.IsNullOrEmpty(wt.TransitionName)).ToList();
        if (existingTransitions.Any())
        {

            foreach (var et in existingTransitions)
            {
                if ((et.FromStatusId == resolvedStatus?.Id || et.FromStatusId == closedStatus?.Id) && et.ToStatusId == inProgressStatus?.Id)
                {
                    et.TransitionName = "Reopen";
                    et.RequiredPermissionKey = "ticket.reopen";
                }
                else
                {
                    et.TransitionName = "Default";
                }
            }
            await _context.SaveChangesAsync();
        }

        // 14. Knowledge Base Categories & Articles
        if (!_context.KnowledgeCategories.Any())
        {
            _context.KnowledgeCategories.AddRange(
                new ItsTool.Domain.Entities.KnowledgeBase.KnowledgeCategory { Name = "Rehberler" },
                new ItsTool.Domain.Entities.KnowledgeBase.KnowledgeCategory { Name = "Prosedürler" },
                new ItsTool.Domain.Entities.KnowledgeBase.KnowledgeCategory { Name = "Sistem & Altyapı" }
            );
            await _context.SaveChangesAsync();
        }

        if (!_context.KnowledgeArticles.Any())
        {
            var rehberlerCat = _context.KnowledgeCategories.FirstOrDefault(c => c.Name == "Rehberler");
            var prosedurlerCat = _context.KnowledgeCategories.FirstOrDefault(c => c.Name == "Prosedürler");
            var sistemCat = _context.KnowledgeCategories.FirstOrDefault(c => c.Name == "Sistem & Altyapı");

            var adminAuthor = _context.Users.FirstOrDefault(u => u.Username == "admin");
            
            if (adminAuthor != null && rehberlerCat != null && prosedurlerCat != null && sistemCat != null)
            {
                _context.KnowledgeArticles.AddRange(
                    new ItsTool.Domain.Entities.KnowledgeBase.KnowledgeArticle
                    {
                        Title = "VPN Bağlantı Rehberi",
                        Content = "Şirket ağına uzaktan erişim sağlamak için VPN bağlantısının nasıl kurulacağını adım adım anlatan rehber.\n\n1. Cisco AnyConnect uygulamasını açın.\n2. Sunucu adresi olarak vpn.sirket.com girin.\n3. Kullanıcı adı ve şifrenizle giriş yapın.\n4. MFA (Çok Faktörlü Doğrulama) kodunu girin.",
                        CategoryId = rehberlerCat.Id,
                        AuthorUserId = adminAuthor.Id,
                        Visibility = ItsTool.Domain.Entities.KnowledgeBase.ArticleVisibility.Public,
                        Status = ItsTool.Domain.Entities.KnowledgeBase.ArticleStatus.Published,
                        ViewCount = 12
                    },
                    new ItsTool.Domain.Entities.KnowledgeBase.KnowledgeArticle
                    {
                        Title = "Parola Sıfırlama Prosedürü",
                        Content = "Hesap parolanızı unuttuysanız veya süresi dolduysa izlemeniz gereken adımlar.\n\nEğer bilgisayarınızda oturum açabiliyorsanız, Ctrl+Alt+Del yaparak 'Parola Değiştir' seçeneğini kullanın. Oturum açamıyorsanız Self-Service Portal üzerinden telefon numaranıza gelecek SMS ile sıfırlama yapabilirsiniz.",
                        CategoryId = prosedurlerCat.Id,
                        AuthorUserId = adminAuthor.Id,
                        Visibility = ItsTool.Domain.Entities.KnowledgeBase.ArticleVisibility.Public,
                        Status = ItsTool.Domain.Entities.KnowledgeBase.ArticleStatus.Published,
                        ViewCount = 8
                    },
                    new ItsTool.Domain.Entities.KnowledgeBase.KnowledgeArticle
                    {
                        Title = "Sunucu Bakım Kontrol Listesi",
                        Content = "DİKKAT: Bu doküman sadece IT personeli içindir.\n\nAylık sunucu bakımlarında kontrol edilmesi gereken metrikler:\n- CPU ve RAM kullanım trendleri\n- Disk doluluk oranları (>%80 ise uyarı)\n- Güvenlik yamalarının (patch) durumu\n- Backup operasyonlarının son durumu (Success/Failure logları)",
                        CategoryId = sistemCat.Id,
                        AuthorUserId = adminAuthor.Id,
                        Visibility = ItsTool.Domain.Entities.KnowledgeBase.ArticleVisibility.Internal,
                        Status = ItsTool.Domain.Entities.KnowledgeBase.ArticleStatus.Published,
                        ViewCount = 3
                    },
                    new ItsTool.Domain.Entities.KnowledgeBase.KnowledgeArticle
                    {
                        Title = "Taslak: Yeni Personel Onboarding",
                        Content = "Yeni personellerin ilk günlerinde IT tarafından sağlanacak donanım ve yazılım erişimlerinin taslağıdır. Henüz tamamlanmamıştır.",
                        CategoryId = rehberlerCat.Id,
                        AuthorUserId = adminAuthor.Id,
                        Visibility = ItsTool.Domain.Entities.KnowledgeBase.ArticleVisibility.Internal,
                        Status = ItsTool.Domain.Entities.KnowledgeBase.ArticleStatus.Draft,
                        ViewCount = 0
                    }
                );
                await _context.SaveChangesAsync();
            }
        }
    }
}
