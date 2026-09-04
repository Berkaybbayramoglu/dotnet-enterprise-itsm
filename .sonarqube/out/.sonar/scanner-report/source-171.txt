using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.KnowledgeBase;
using ItsTool.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace ItsTool.Infrastructure.Services;

public class KnowledgeBaseService : IKnowledgeBaseService
{
    private const string KbManagePermission = "kb.manage";
    private readonly ItsToolDbContext _context;
    private readonly IPermissionCalculator _permissionCalculator;
    private readonly ISignalRPusher _signalRPusher;

    public KnowledgeBaseService(ItsToolDbContext context, IPermissionCalculator permissionCalculator, ISignalRPusher signalRPusher)
    {
        _context = context;
        _permissionCalculator = permissionCalculator;
        _signalRPusher = signalRPusher;
    }

    public async Task<IEnumerable<KbCategoryDto>> GetCategoriesAsync()
    {
        var list = await _context.KnowledgeCategories.Where(c => !c.IsDeleted).ToListAsync();
        return list.Select(c => new KbCategoryDto(c.Id, c.Name, c.ParentId));
    }

    public async Task<KbCategoryDto> CreateCategoryAsync(CreateKbCategoryDto dto)
    {
        var cat = new KnowledgeCategory { Name = dto.Name, ParentId = dto.ParentId };
        _context.KnowledgeCategories.Add(cat);
        await _context.SaveChangesAsync();
        return new KbCategoryDto(cat.Id, cat.Name, cat.ParentId);
    }

    public async Task UpdateCategoryAsync(int id, CreateKbCategoryDto dto)
    {
        var cat = await _context.KnowledgeCategories.FirstOrDefaultAsync(c => c.Id == id && !c.IsDeleted);
        if (cat == null) throw new KeyNotFoundException("Category not found.");
        cat.Name = dto.Name;
        cat.ParentId = dto.ParentId;
        await _context.SaveChangesAsync();
    }

    public async Task DeleteCategoryAsync(int id)
    {
        var cat = await _context.KnowledgeCategories.FirstOrDefaultAsync(c => c.Id == id && !c.IsDeleted);
        if (cat != null)
        {
            cat.IsDeleted = true;
            await _context.SaveChangesAsync();
        }
    }

    public async Task<IEnumerable<KbArticleSummaryDto>> SearchArticlesAsync(int userId, string? keyword, int? categoryId)
    {
        var perms = await _permissionCalculator.CalculateEffectivePermissionsAsync(userId);
        bool canManageKb = perms.Contains(KbManagePermission);
        bool isStaff = perms.Contains("ticket.manage") || perms.Contains("ticket.assign") || perms.Contains("ticket.edit"); // Determine internal visibility

        var query = _context.KnowledgeArticles
            .Where(a => !a.IsDeleted);

        if (!canManageKb)
        {
            query = query.Where(a => a.Status == ArticleStatus.Published || a.AuthorUserId == userId);
        }

        if (!isStaff && !canManageKb)
        {
            // If the user is not staff, they can only see Public articles, EXCEPT if they authored it themselves
            query = query.Where(a => a.Visibility == ArticleVisibility.Public || a.AuthorUserId == userId);
        }

        if (categoryId.HasValue)
        {
            query = query.Where(a => a.CategoryId == categoryId.Value);
        }

        if (!string.IsNullOrWhiteSpace(keyword))
        {
            var kw = keyword;
            query = query.Where(a => a.Title.Contains(kw, StringComparison.OrdinalIgnoreCase) || a.Content.Contains(kw, StringComparison.OrdinalIgnoreCase));
        }

        var joinedQuery = from a in query
                          join u in _context.Users on a.AuthorUserId equals u.Id into uGroup
                          from u in uGroup.DefaultIfEmpty()
                          join d in _context.Departments on u.DepartmentId equals d.Id into dGroup
                          from d in dGroup.DefaultIfEmpty()
                          select new { Article = a, User = u, Department = d };

        var list = await joinedQuery.OrderByDescending(x => x.Article.CreatedAt).ToListAsync();
        
        return list.Select(x => new KbArticleSummaryDto(
            x.Article.Id, 
            x.Article.CategoryId, 
            x.Article.Title, 
            x.Article.AuthorUserId, 
            x.User != null ? (x.User.FirstName + " " + x.User.LastName).Trim() : null,
            x.Department != null ? x.Department.Name : null,
            x.Article.Status, 
            x.Article.Visibility, 
            x.Article.ViewCount, 
            x.Article.CreatedAt, 
            x.Article.ManagerFeedback));
    }

    public async Task<KbArticleDto?> GetArticleAsync(int id, int userId)
    {
        var perms = await _permissionCalculator.CalculateEffectivePermissionsAsync(userId);
        bool canManageKb = perms.Contains(KbManagePermission);
        bool isStaff = perms.Contains("ticket.manage") || perms.Contains("ticket.assign") || perms.Contains("ticket.edit");

        var joined = await (from a in _context.KnowledgeArticles
                            where a.Id == id && !a.IsDeleted
                            join u in _context.Users on a.AuthorUserId equals u.Id into uGroup
                            from u in uGroup.DefaultIfEmpty()
                            join d in _context.Departments on u.DepartmentId equals d.Id into dGroup
                            from d in dGroup.DefaultIfEmpty()
                            select new { Article = a, User = u, Department = d }).FirstOrDefaultAsync();
                            
        if (joined == null) return null;
        var article = joined.Article;

        // Visibility checks
        if (!canManageKb && article.AuthorUserId != userId && article.Status != ArticleStatus.Published) return null;
        if (article.Visibility == ArticleVisibility.Internal && !isStaff && !canManageKb && article.AuthorUserId != userId) return null;

        // Increment ViewCount if published
        if (article.Status == ArticleStatus.Published)
        {
            article.ViewCount++;
            await _context.SaveChangesAsync();
        }

        return new KbArticleDto(
            article.Id, 
            article.CategoryId, 
            article.Title, 
            article.Content, 
            article.AuthorUserId, 
            joined.User != null ? (joined.User.FirstName + " " + joined.User.LastName).Trim() : null,
            joined.Department != null ? joined.Department.Name : null,
            article.Status, 
            article.Visibility, 
            article.ViewCount, 
            article.CreatedAt, 
            article.ManagerFeedback);
    }

    public async Task<KbArticleDto> CreateArticleAsync(CreateKbArticleDto dto, int authorId)
    {
        var perms = await _permissionCalculator.CalculateEffectivePermissionsAsync(authorId);
        bool canManageKb = perms.Contains(KbManagePermission);

        var status = dto.Status;
        if (!canManageKb)
        {
            status = ArticleStatus.PendingReview;
        }

        var article = new KnowledgeArticle
        {
            CategoryId = dto.CategoryId,
            Title = dto.Title,
            Content = dto.Content,
            Status = status,
            Visibility = dto.Visibility,
            AuthorUserId = authorId
        };
        _context.KnowledgeArticles.Add(article);
        await _context.SaveChangesAsync();

        if (status == ArticleStatus.PendingReview)
        {
            await NotifyManagersOfSuggestionAsync(article.Id, article.Title);
        }

        return new KbArticleDto(article.Id, article.CategoryId, article.Title, article.Content, article.AuthorUserId, null, null, article.Status, article.Visibility, article.ViewCount, article.CreatedAt, article.ManagerFeedback);
    }

    private async Task NotifyManagersOfSuggestionAsync(int articleId, string title)
    {
        // Find users with kb.manage permission
        // Option 1: SuperAdmins
        var superAdminRoleId = await _context.Roles.Where(r => r.Name == "SuperAdmin" && !r.IsDeleted).Select(r => r.Id).FirstOrDefaultAsync();
        
        // Option 2: Roles with kb.manage
        var kbManagePermId = await _context.Permissions.Where(p => p.Name == KbManagePermission).Select(p => p.Id).FirstOrDefaultAsync();
        
        var kbManageRoleIds = await _context.RolePermissions
            .Where(rp => rp.PermissionId == kbManagePermId && !rp.IsDeleted)
            .Select(rp => rp.RoleId)
            .ToListAsync();
            
        var targetRoleIds = kbManageRoleIds.ToList();
        if (superAdminRoleId > 0) targetRoleIds.Add(superAdminRoleId);

        var article = await _context.KnowledgeArticles.FirstOrDefaultAsync(a => a.Id == articleId);
        var authorUserId = article?.AuthorUserId ?? 0;

        var managerUserIds = await _context.UserRoles
            .Where(ur => targetRoleIds.Contains(ur.RoleId) && !ur.IsDeleted && ur.UserId != authorUserId)
            .Select(ur => ur.UserId)
            .Distinct()
            .ToListAsync();

        var notifications = managerUserIds.Select(userId => new ItsTool.Domain.Entities.Notification.Notification
        {
            UserId = userId,
            Type = "kb.suggested",
            Title = "New Knowledge Base Suggestion",
            Body = $"A new article '{title}' requires your review.",
            EntityType = "KnowledgeArticle",
            EntityId = articleId,
            Priority = "Normal",
            IsRead = false,
            CreatedAt = DateTime.UtcNow
        }).ToList();

        _context.Notifications.AddRange(notifications);
        await _context.SaveChangesAsync();

        foreach (var userId in managerUserIds)
        {
            await _signalRPusher.PushNotificationAsync(userId, new
            {
                type = "kb.suggested",
                title = "New Knowledge Base Suggestion",
                body = $"A new article '{title}' requires your review.",
                entityId = articleId,
                priority = "Normal",
                createdAt = DateTime.UtcNow
            });
        }
    }

    public async Task UpdateArticleAsync(int id, UpdateKbArticleDto dto, int currentUserId)
    {
        var perms = await _permissionCalculator.CalculateEffectivePermissionsAsync(currentUserId);
        bool canManageKb = perms.Contains(KbManagePermission);

        var article = await _context.KnowledgeArticles.FirstOrDefaultAsync(a => a.Id == id && !a.IsDeleted);
        if (article == null) throw new KeyNotFoundException("Article not found.");

        if (!canManageKb && article.AuthorUserId != currentUserId)
        {
            throw new UnauthorizedAccessException("You do not have permission to edit this article.");
        }

        if (!canManageKb)
        {
            if (dto.Status == ArticleStatus.Draft)
            {
                article.Status = ArticleStatus.Draft;
            }
            else
            {
                // If author is editing and not saving as draft, force status back to PendingReview
                if (article.Status == ArticleStatus.NeedsRevision)
                {
                    await NotifyManagersOfSuggestionAsync(article.Id, dto.Title);
                }
                article.Status = ArticleStatus.PendingReview;
            }
        }
        else
        {
            article.Status = dto.Status;
        }

        article.CategoryId = dto.CategoryId;
        article.Title = dto.Title;
        article.Content = dto.Content;
        article.Visibility = dto.Visibility;
        await _context.SaveChangesAsync();
    }

    public async Task ReviewArticleAsync(int id, ReviewKbArticleDto dto, int reviewerId)
    {
        var perms = await _permissionCalculator.CalculateEffectivePermissionsAsync(reviewerId);
        if (!perms.Contains(KbManagePermission)) throw new UnauthorizedAccessException("Only KB managers can review articles.");

        var article = await _context.KnowledgeArticles.FirstOrDefaultAsync(a => a.Id == id && !a.IsDeleted);
        if (article == null) throw new KeyNotFoundException("Article not found.");

        var reviewer = await _context.Users.FirstOrDefaultAsync(u => u.Id == reviewerId);
        var reviewerName = reviewer != null ? $"{reviewer.FirstName} {reviewer.LastName}".Trim() : "Yönetici";

        article.Status = dto.Status;
        if (!string.IsNullOrWhiteSpace(dto.Feedback))
        {
            article.ManagerFeedback = $"[Tarih: {DateTime.Now:dd.MM.yyyy HH:mm} - İnceleyen: {reviewerName}]\n{dto.Feedback}";
        }
        else
        {
            article.ManagerFeedback = null;
        }

        await _context.SaveChangesAsync();

        // Notify author
        string actionText;
        if (dto.Status == ArticleStatus.NeedsRevision)
            actionText = "marked for revision";
        else if (dto.Status == ArticleStatus.Rejected)
            actionText = "rejected";
        else
            actionText = "published";

        var notif = new ItsTool.Domain.Entities.Notification.Notification
        {
            UserId = article.AuthorUserId,
            Type = "kb.reviewed",
            Title = "Article Reviewed",
            Body = $"Your article '{article.Title}' has been {actionText}.",
            EntityType = "KnowledgeArticle",
            EntityId = article.Id,
            Priority = dto.Status == ArticleStatus.Published ? "Low" : "Normal",
            IsRead = false,
            CreatedAt = DateTime.UtcNow
        };
        _context.Notifications.Add(notif);
        await _context.SaveChangesAsync();

        await _signalRPusher.PushNotificationAsync(article.AuthorUserId, new
        {
            type = "kb.reviewed",
            title = notif.Title,
            body = notif.Body,
            entityId = article.Id,
            priority = notif.Priority,
            createdAt = notif.CreatedAt
        });
    }

    public async Task DeleteArticleAsync(int id, int currentUserId)
    {
        var perms = await _permissionCalculator.CalculateEffectivePermissionsAsync(currentUserId);
        bool canManageKb = perms.Contains(KbManagePermission);

        var article = await _context.KnowledgeArticles.FirstOrDefaultAsync(a => a.Id == id && !a.IsDeleted);
        if (article != null)
        {
            if (!canManageKb && article.AuthorUserId != currentUserId)
            {
                throw new UnauthorizedAccessException("You do not have permission to delete this article.");
            }

            article.IsDeleted = true;
            await _context.SaveChangesAsync();
        }
    }
}
