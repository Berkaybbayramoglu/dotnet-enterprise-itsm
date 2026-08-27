using ItsTool.Domain.Entities.Organization;
using ItsTool.Domain.Entities.Auth;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Domain.Entities.SLA;
using Microsoft.EntityFrameworkCore;
using BCrypt.Net;
using ItsTool.Application.Constants;
namespace ItsTool.Infrastructure.Data;

public static class StatusConstants
{
    public const string Open = "Açık";
    public const string InProgress = "Devam Ediyor";
    public const string OnHold = "Beklemede";
    public const string Resolved = "Çözüldü";
    public const string Closed = "Kapatıldı";
}

public static class TransitionConstants
{
    public const string StartProgress = "Start Progress";
    public const string PutOnHold = "Put on Hold";
    public const string Resolve = "Resolve";
    public const string MoveToOpen = "Move to Open";
    public const string ResumeProgress = "Resume Progress";
    public const string ReopenToOpen = "Reopen to Open";
    public const string ReopenToProgress = "Reopen to Progress";
    public const string ReopenToPending = "Reopen to Pending";
    public const string ReopenToResolved = "Reopen to Resolved";
}


public class DataSeeder
{
    private static readonly string[] ManagerPermissions = new[] { "report.view", "audit.view", "ticket.view", "ticket.assign", "ticket.transfer", "kb.manage" };
    private static readonly string[] AgentPermissions = new[] { "ticket.view", PermissionConstants.TicketEdit, PermissionConstants.TicketResolve, "ticket.comment", "ticket.assign", "ticket.transfer", "kb.view" };
    private static readonly string[] EndUserPermissions = new[] { "ticket.create", "ticket.view", "survey.submit", "kb.view" };

    private readonly ItsToolDbContext _context;

    public DataSeeder(ItsToolDbContext context)
    {
        _context = context;
    }

    public async Task SeedAsync()
    {        await SeedTicketTypesAsync();
        await SeedStatusesAsync();
        await SeedPrioritiesAsync();
        await SeedDepartmentsAndGroupsAsync();
        await SeedRolesAndPermissionsAsync();
        await SeedUsersAsync();
        await SeedProjectsAndCategoriesAsync();
        await SeedDynamicFieldsAsync();
        await SeedSlaPoliciesAsync();
        await SeedWorkflowTransitionsAsync();
        await SeedKnowledgeBaseAsync();

    }

    private async Task SeedTicketTypesAsync()
    {
        // Ticket Types
        if (!await _context.TicketTypes.AnyAsync())
        {
            _context.TicketTypes.AddRange(
                new TicketType { Name = "Incident" },
                new TicketType { Name = "Service Request" }
            );
        }
    }

    private async Task SeedStatusesAsync()
    {
        // Statuses
        if (!await _context.Statuses.AnyAsync())
        {
            _context.Statuses.AddRange(
                new Status { Name = StatusConstants.Open, SortOrder = 1, IsSystemDefault = true },
                new Status { Name = StatusConstants.InProgress, SortOrder = 2 },
                new Status { Name = StatusConstants.OnHold, SortOrder = 3, PausesSla = true },
                new Status { Name = StatusConstants.Resolved, SortOrder = 4, IsClosedStatus = true },
                new Status { Name = StatusConstants.Closed, SortOrder = 5, IsClosedStatus = true }
            );
        }
    }

    private async Task SeedPrioritiesAsync()
    {
        // Priorities
        if (!await _context.Priorities.AnyAsync())
        {
            _context.Priorities.AddRange(
                new Priority { Name = "Kritik", Weight = 100, SeverityLevel = 1 },
                new Priority { Name = "Yüksek", Weight = 75, SeverityLevel = 2 },
                new Priority { Name = "Orta", Weight = 50, SeverityLevel = 3 },
                new Priority { Name = "Düşük", Weight = 25, SeverityLevel = 4 }
            );
        }
    }

    private async Task SeedDepartmentsAndGroupsAsync()
    {
        // Departments
        if (!await _context.Departments.AnyAsync())
        {
            _context.Departments.AddRange(
                new Department { Name = "Bilgi Teknolojileri" },
                new Department { Name = "İnsan Kaynakları" }
            );
        }
        await _context.SaveChangesAsync();

        var itDept = await _context.Departments.FirstOrDefaultAsync(d => d.Name == "Bilgi Teknolojileri");
        // Groups
        if (!await _context.Groups.AnyAsync() && itDept != null)
        {
            _context.Groups.AddRange(
                new Group { Name = "Helpdesk Ekibi", DepartmentId = itDept.Id },
                new Group { Name = "Sistem & Network Ekibi", DepartmentId = itDept.Id },
                new Group { Name = "Yazılım Destek Ekibi", DepartmentId = itDept.Id },
                new Group { Name = "Güvenlik Ekibi", DepartmentId = itDept.Id }
            );
            await _context.SaveChangesAsync();
        }
    }

    private async Task SeedRolesAndPermissionsAsync()
    {
        // Roles & Permissions Setup
        var allPermissions = ItsTool.Application.Constants.PermissionConstants.AllPermissions;
        var existingPermissions = await _context.Permissions.ToListAsync();
        
        var missingPermissions = allPermissions.Where(pKey => !existingPermissions.Any(p => p.Key == pKey)).Select(pKey => new Permission { Name = pKey, Key = pKey, Description = "Sistem tarafından otomatik oluşturuldu." }).ToList();
        if (missingPermissions.Count > 0)
        {
            _context.Permissions.AddRange(missingPermissions);
            existingPermissions.AddRange(missingPermissions);
        }
        await _context.SaveChangesAsync();
        
        // Add default descriptions to permissions if missing
        var permDescriptions = new Dictionary<string, string>
        {
            { "ticket.create", "Yeni bilet oluşturma yetkisi sağlar." },
            { "ticket.view", "Tüm biletleri veya yetkili olunan biletleri görüntüleme yetkisi sağlar." },
            { "ticket.edit", "Bilet detaylarını düzenleme yetkisi sağlar." },
            { "ticket.assign", "Biletleri kişilere veya gruplara atama yetkisi sağlar." },
            { "ticket.transfer", "Biletleri farklı projelere veya departmanlara transfer etme yetkisi sağlar." },
            { "ticket.resolve", "Biletleri çözüldü olarak işaretleme yetkisi sağlar." },
            { "ticket.close", "Çözülmüş biletleri tamamen kapatma yetkisi sağlar." },
            { "ticket.reopen", "Kapanmış biletleri yeniden açma yetkisi sağlar." },
            { "ticket.comment", "Biletlere yorum ekleme yetkisi sağlar." },
            { "ticket.comment.internal", "Biletlere sadece personelin görebileceği iç not (internal note) ekleme yetkisi sağlar." },
            { "ticket.comment.edit", "Biletlerdeki yorumları düzenleme yetkisi sağlar." },
            { "ticket.comment.reply", "Biletlerdeki yorumlara cevap verme yetkisi sağlar." },
            { "ticket.comment.delete", "Biletlerdeki yorumları silme yetkisi sağlar." },
            { "report.view", "Sistem raporlarını ve analitikleri görüntüleme yetkisi sağlar." },
            { "admin.manage", "Sistem genelinde tam yetkili (SuperAdmin) yönetici hakları sağlar." },
            { "config.manage", "Sistem yapılandırmalarını, kuralları ve webhook'ları yönetme yetkisi sağlar." },
            { "sla.manage", "SLA (Hizmet Seviyesi) politikalarını yönetme yetkisi sağlar." },
            { "audit.view", "Sistem denetim kayıtlarını (Audit Logs) görüntüleme yetkisi sağlar." },
            { "kb.manage", "Bilgi bankası makalelerini oluşturma ve düzenleme yetkisi sağlar." },
            { "kb.view", "Bilgi bankası makalelerini okuma yetkisi sağlar." },
            { "survey.submit", "Müşteri memnuniyet anketlerini doldurma yetkisi sağlar." },
            { "user.manage", "Kullanıcıları ve rolleri yönetme yetkisi sağlar." }
        };
        
        foreach (var ep in existingPermissions)
        {
            if (string.IsNullOrEmpty(ep.Description) && permDescriptions.ContainsKey(ep.Key))
            {
                ep.Description = permDescriptions[ep.Key];
            }
        }
        await _context.SaveChangesAsync();

        var rolesToSeed = new Dictionary<string, string[]>
        {
            { "SuperAdmin", allPermissions.ToArray() },
            { "Manager", ManagerPermissions },
            { "Agent", AgentPermissions },
            { "EndUser", EndUserPermissions }
        };

        var existingRoles = await _context.Roles.Include(r => r.RolePermissions).ToListAsync();

        foreach (var kvp in rolesToSeed)
        {
            var role = existingRoles.FirstOrDefault(r => r.Name == kvp.Key);
            if (role == null)
            {
                role = new Role { Name = kvp.Key };
                _context.Roles.Add(role);
                existingRoles.Add(role);
                await _context.SaveChangesAsync(); // save to get Id
            }

            foreach (var permKey in kvp.Value)
            {
                var perm = existingPermissions.FirstOrDefault(p => p.Key == permKey);
                if (perm != null && !role.RolePermissions.Any(rp => rp.PermissionId == perm.Id))
                {
                    _context.RolePermissions.Add(new RolePermission { RoleId = role.Id, PermissionId = perm.Id });
                }
            }
        }
        await _context.SaveChangesAsync();
    }

    private async Task SeedUsersAsync()
    {
        var itDept = await _context.Departments.FirstOrDefaultAsync(d => d.Name == "Bilgi Teknolojileri");
        var existingRoles = await _context.Roles.ToListAsync();
        var existingPermissions = await _context.Permissions.ToListAsync();
        // Users
        var usersToSeed = new List<(string Username, string Password, string Role, string FirstName, string LastName)>
        {
            ("admin", "Admin123!", "SuperAdmin", "System", "Admin"),
            ("manager", "Manager123!", "Manager", "IT", "Manager"),
            ("agent1", "Agent123!", "Agent", "Helpdesk", "Agent 1"),
            ("agent2", "Agent123!", "Agent", "Helpdesk", "Agent 2"),
            ("user1", "User123!", "EndUser", "End", "User")
        };

        var existingUsers = await _context.Users.Include(u => u.UserRoles).Include(u => u.PermissionOverrides).ToListAsync();

        foreach (var u in usersToSeed)
        {
            await CreateOrUpdateUserAsync(u, existingUsers, itDept, existingRoles, existingPermissions);
        }
        await _context.SaveChangesAsync();
    }

    private async Task SeedProjectsAndCategoriesAsync()
    {
        // 5 Adet Default Proje (Doküman Madde 3.3)
        if (!await _context.Projects.AnyAsync())
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
        // Default Categories for ITS project
        var itsProject = await _context.Projects.FirstOrDefaultAsync(p => p.ProjectKey == "ITS");
        if (!await _context.Categories.AnyAsync() && itsProject != null)
        {
            _context.Categories.AddRange(
                new ItsTool.Domain.Entities.Ticket.Category { Name = "Donanım Arızası", ProjectId = itsProject.Id },
                new ItsTool.Domain.Entities.Ticket.Category { Name = "Yazılım Talebi", ProjectId = itsProject.Id },
                new ItsTool.Domain.Entities.Ticket.Category { Name = "Ağ & İnternet", ProjectId = itsProject.Id }
            );
            await _context.SaveChangesAsync();
        }
    }

    private async Task SeedDynamicFieldsAsync()
    {
        // Dynamic Fields Demo
        if (!await _context.FieldDefinitions.AnyAsync())
        {
            var serverNameField = new ItsTool.Domain.Entities.Config.FieldDefinition { Key = "sunucu_adi", Label = "Sunucu Adı", FieldType = ItsTool.Domain.Entities.Config.FieldType.Text };
            var impactedUsersField = new ItsTool.Domain.Entities.Config.FieldDefinition { Key = "etkilenen_kullanicilar", Label = "Etkilenen Kullanıcı Sayısı", FieldType = ItsTool.Domain.Entities.Config.FieldType.Number };
            _context.FieldDefinitions.AddRange(serverNameField, impactedUsersField);
            await _context.SaveChangesAsync();

            var hwCategory = await _context.Categories.FirstOrDefaultAsync(c => c.Name == "Donanım Arızası");
            if (hwCategory != null)
            {
                _context.FormFieldPlacements.AddRange(
                    new ItsTool.Domain.Entities.Config.FormFieldPlacement { CategoryId = hwCategory.Id, FieldDefinitionId = serverNameField.Id, SortOrder = 1, IsRequired = true },
                    new ItsTool.Domain.Entities.Config.FormFieldPlacement { CategoryId = hwCategory.Id, FieldDefinitionId = impactedUsersField.Id, SortOrder = 2, IsRequired = false }
                );
                await _context.SaveChangesAsync();
            }
        }
    }

    private async Task SeedSlaPoliciesAsync()
    {
        // SLA Seed Data
        if (!await _context.SlaPolicies.AnyAsync())
        {
            var policy = new SlaPolicy { Name = "Default SLA Policy", Description = "Varsayılan hizmet seviyesi sözleşmesi" };
            _context.SlaPolicies.Add(policy);
            await _context.SaveChangesAsync();

            var critical = await _context.Priorities.FirstOrDefaultAsync(p => p.Name == "Kritik");
            var high = await _context.Priorities.FirstOrDefaultAsync(p => p.Name == "Yüksek");
            var medium = await _context.Priorities.FirstOrDefaultAsync(p => p.Name == "Orta");
            var low = await _context.Priorities.FirstOrDefaultAsync(p => p.Name == "Düşük");

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

    private async Task SeedWorkflowTransitionsAsync()
    {
        var defaultWorkflow = await GetOrCreateDefaultWorkflowAsync();
        
        var openStatus = await _context.Statuses.FirstOrDefaultAsync(s => s.Name == StatusConstants.Open);
        var inProgressStatus = await _context.Statuses.FirstOrDefaultAsync(s => s.Name == StatusConstants.InProgress);
        var onHoldStatus = await _context.Statuses.FirstOrDefaultAsync(s => s.Name == StatusConstants.OnHold);
        var resolvedStatus = await _context.Statuses.FirstOrDefaultAsync(s => s.Name == StatusConstants.Resolved);
        var closedStatus = await _context.Statuses.FirstOrDefaultAsync(s => s.Name == StatusConstants.Closed);

        if (openStatus != null && inProgressStatus != null && onHoldStatus != null && resolvedStatus != null && closedStatus != null)
        {
            var desiredTransitions = BuildDesiredTransitions(defaultWorkflow.Id, openStatus.Id, inProgressStatus.Id, onHoldStatus.Id, resolvedStatus.Id, closedStatus.Id);

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

        await UpdateLegacyTransitionsAsync(resolvedStatus?.Id, closedStatus?.Id, inProgressStatus?.Id);
    }

    private async Task UpdateLegacyTransitionsAsync(int? resolvedStatusId, int? closedStatusId, int? inProgressStatusId)
    {
        var existingTransitions = await _context.WorkflowTransitions.Where(wt => string.IsNullOrEmpty(wt.TransitionName)).ToListAsync();
        if (existingTransitions.Count == 0) return;

        foreach (var et in existingTransitions)
        {
            if ((et.FromStatusId == resolvedStatusId || et.FromStatusId == closedStatusId) && et.ToStatusId == inProgressStatusId)
            {
                et.TransitionName = "Reopen";
                et.RequiredPermissionKey = PermissionConstants.TicketReopen;
            }
            else
            {
                et.TransitionName = "Default";
            }
        }
        await _context.SaveChangesAsync();
    }

    private async Task SeedKnowledgeBaseAsync()
    {
        // Knowledge Base Categories & Articles
        if (!await _context.KnowledgeCategories.AnyAsync())
        {
            _context.KnowledgeCategories.AddRange(
                new ItsTool.Domain.Entities.KnowledgeBase.KnowledgeCategory { Name = "Rehberler" },
                new ItsTool.Domain.Entities.KnowledgeBase.KnowledgeCategory { Name = "Prosedürler" },
                new ItsTool.Domain.Entities.KnowledgeBase.KnowledgeCategory { Name = "Sistem & Altyapı" }
            );
            await _context.SaveChangesAsync();
        }

        if (!await _context.KnowledgeArticles.AnyAsync())
        {
            var rehberlerCat = await _context.KnowledgeCategories.FirstOrDefaultAsync(c => c.Name == "Rehberler");
            var prosedurlerCat = await _context.KnowledgeCategories.FirstOrDefaultAsync(c => c.Name == "Prosedürler");
            var sistemCat = await _context.KnowledgeCategories.FirstOrDefaultAsync(c => c.Name == "Sistem & Altyapı");

            var adminAuthor = await _context.Users.FirstOrDefaultAsync(u => u.Username == "admin");
            
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


    private async Task CreateOrUpdateUserAsync(
        (string Username, string Password, string Role, string FirstName, string LastName) u,
        List<ItsTool.Domain.Entities.Organization.User> existingUsers, 
        ItsTool.Domain.Entities.Organization.Department? itDept,
        List<ItsTool.Domain.Entities.Auth.Role> existingRoles, 
        List<ItsTool.Domain.Entities.Auth.Permission> existingPermissions)
    {
        var user = existingUsers.FirstOrDefault(x => x.Username == u.Username);
        if (user == null && itDept != null)
        {
            user = new ItsTool.Domain.Entities.Organization.User
            {
                Username = u.Username,
                Email = $"{u.Username}@itsm.local",
                FirstName = u.FirstName,
                LastName = u.LastName,
                DepartmentId = itDept.Id,
                PasswordHash = BCrypt.Net.BCrypt.HashPassword(u.Password)
            };
            _context.Users.Add(user);
            existingUsers.Add(user);
            await _context.SaveChangesAsync(); // get Id
        }
        else if (user != null)
        {
            // Force reset password hash for demo accounts to ensure they match *123!
            user.PasswordHash = BCrypt.Net.BCrypt.HashPassword(u.Password);
            _context.Users.Update(user);
            await _context.SaveChangesAsync();
        }

        if (user != null)
        {
            var role = existingRoles.First(r => r.Name == u.Role);
            if (!user.UserRoles.Any(ur => ur.RoleId == role.Id))
            {
                _context.UserRoles.Add(new ItsTool.Domain.Entities.Auth.UserRole { UserId = user.Id, RoleId = role.Id });
            }

            if (u.Username == "agent2")
            {
                var closePerm = existingPermissions.First(p => p.Key == PermissionConstants.TicketClose);
                if (!user.PermissionOverrides.Any(po => po.PermissionId == closePerm.Id))
                {
                    _context.UserPermissionOverrides.Add(new ItsTool.Domain.Entities.Auth.UserPermissionOverride
                    {
                        UserId = user.Id,
                        PermissionId = closePerm.Id,
                        IsGranted = true
                    });
                }
            }
        }
    }



    private static List<ItsTool.Domain.Entities.Workflow.WorkflowTransition> BuildDesiredTransitions(int workflowId, int openId, int inProgressId, int onHoldId, int resolvedId, int closedId)
    {
        return new List<ItsTool.Domain.Entities.Workflow.WorkflowTransition>
        {
            new() { WorkflowId = workflowId, FromStatusId = openId, ToStatusId = inProgressId, IsActive = true, TransitionName = TransitionConstants.StartProgress },
            new() { WorkflowId = workflowId, FromStatusId = openId, ToStatusId = onHoldId, IsActive = true, TransitionName = TransitionConstants.PutOnHold },
            new() { WorkflowId = workflowId, FromStatusId = openId, ToStatusId = resolvedId, IsActive = true, TransitionName = TransitionConstants.Resolve, RequiredPermissionKey = PermissionConstants.TicketResolve },
            new() { WorkflowId = workflowId, FromStatusId = openId, ToStatusId = closedId, IsActive = true, TransitionName = StatusConstants.Closed, RequiredPermissionKey = PermissionConstants.TicketClose },
            new() { WorkflowId = workflowId, FromStatusId = inProgressId, ToStatusId = openId, IsActive = true, TransitionName = TransitionConstants.MoveToOpen },
            new() { WorkflowId = workflowId, FromStatusId = inProgressId, ToStatusId = onHoldId, IsActive = true, TransitionName = TransitionConstants.PutOnHold },
            new() { WorkflowId = workflowId, FromStatusId = inProgressId, ToStatusId = resolvedId, IsActive = true, TransitionName = TransitionConstants.Resolve, RequiredPermissionKey = PermissionConstants.TicketResolve },
            new() { WorkflowId = workflowId, FromStatusId = inProgressId, ToStatusId = closedId, IsActive = true, TransitionName = StatusConstants.Closed, RequiredPermissionKey = PermissionConstants.TicketClose },
            new() { WorkflowId = workflowId, FromStatusId = onHoldId, ToStatusId = openId, IsActive = true, TransitionName = TransitionConstants.MoveToOpen },
            new() { WorkflowId = workflowId, FromStatusId = onHoldId, ToStatusId = inProgressId, IsActive = true, TransitionName = TransitionConstants.ResumeProgress },
            new() { WorkflowId = workflowId, FromStatusId = onHoldId, ToStatusId = resolvedId, IsActive = true, TransitionName = TransitionConstants.Resolve, RequiredPermissionKey = PermissionConstants.TicketResolve },
            new() { WorkflowId = workflowId, FromStatusId = onHoldId, ToStatusId = closedId, IsActive = true, TransitionName = StatusConstants.Closed, RequiredPermissionKey = PermissionConstants.TicketClose },
            new() { WorkflowId = workflowId, FromStatusId = resolvedId, ToStatusId = openId, IsActive = true, TransitionName = TransitionConstants.ReopenToOpen, RequiredPermissionKey = PermissionConstants.TicketReopen },
            new() { WorkflowId = workflowId, FromStatusId = resolvedId, ToStatusId = inProgressId, IsActive = true, TransitionName = TransitionConstants.ReopenToProgress, RequiredPermissionKey = PermissionConstants.TicketReopen },
            new() { WorkflowId = workflowId, FromStatusId = resolvedId, ToStatusId = onHoldId, IsActive = true, TransitionName = TransitionConstants.ReopenToPending, RequiredPermissionKey = PermissionConstants.TicketReopen },
            new() { WorkflowId = workflowId, FromStatusId = resolvedId, ToStatusId = closedId, IsActive = true, TransitionName = StatusConstants.Closed, RequiredPermissionKey = PermissionConstants.TicketClose },
            new() { WorkflowId = workflowId, FromStatusId = closedId, ToStatusId = openId, IsActive = true, TransitionName = TransitionConstants.ReopenToOpen, RequiredPermissionKey = PermissionConstants.TicketReopen },
            new() { WorkflowId = workflowId, FromStatusId = closedId, ToStatusId = inProgressId, IsActive = true, TransitionName = TransitionConstants.ReopenToProgress, RequiredPermissionKey = PermissionConstants.TicketReopen },
            new() { WorkflowId = workflowId, FromStatusId = closedId, ToStatusId = onHoldId, IsActive = true, TransitionName = TransitionConstants.ReopenToPending, RequiredPermissionKey = PermissionConstants.TicketReopen },
            new() { WorkflowId = workflowId, FromStatusId = closedId, ToStatusId = resolvedId, IsActive = true, TransitionName = TransitionConstants.ReopenToResolved, RequiredPermissionKey = PermissionConstants.TicketReopen }
        };
    }

    private async Task<ItsTool.Domain.Entities.Workflow.Workflow> GetOrCreateDefaultWorkflowAsync()
    {
        var wf = await _context.Workflows.FirstOrDefaultAsync(w => w.Name == "Default Global Workflow");
        if (wf == null)
        {
            wf = new ItsTool.Domain.Entities.Workflow.Workflow 
            { 
                Name = "Default Global Workflow", 
                Description = "Sistem varsayılan iş akışı", 
                IsActive = true 
            };
            _context.Workflows.Add(wf);
            await _context.SaveChangesAsync();
        }
        return wf;
    }
}