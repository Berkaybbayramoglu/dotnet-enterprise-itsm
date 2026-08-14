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
    private readonly ItsToolDbContext _context;
    private readonly IPermissionCalculator _permissionCalculator;

    public KnowledgeBaseService(ItsToolDbContext context, IPermissionCalculator permissionCalculator)
    {
        _context = context;
        _permissionCalculator = permissionCalculator;
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
        bool canManageKb = perms.Contains("kb.manage");
        bool isStaff = perms.Contains("ticket.manage") || perms.Contains("ticket.assign"); // Determine internal visibility

        var query = _context.KnowledgeArticles
            .Where(a => !a.IsDeleted);

        if (!canManageKb)
        {
            query = query.Where(a => a.Status == ArticleStatus.Published);
        }

        if (!isStaff && !canManageKb)
        {
            query = query.Where(a => a.Visibility == ArticleVisibility.Public);
        }

        if (categoryId.HasValue)
        {
            query = query.Where(a => a.CategoryId == categoryId.Value);
        }

        if (!string.IsNullOrWhiteSpace(keyword))
        {
            var kw = keyword.ToLower();
            query = query.Where(a => a.Title.ToLower().Contains(kw) || a.Content.ToLower().Contains(kw));
        }

        var list = await query.OrderByDescending(a => a.CreatedAt).ToListAsync();
        
        return list.Select(a => new KbArticleSummaryDto(a.Id, a.CategoryId, a.Title, a.AuthorUserId, a.Status, a.Visibility, a.ViewCount, a.CreatedAt));
    }

    public async Task<KbArticleDto?> GetArticleAsync(int id, int userId)
    {
        var perms = await _permissionCalculator.CalculateEffectivePermissionsAsync(userId);
        bool canManageKb = perms.Contains("kb.manage");
        bool isStaff = perms.Contains("ticket.manage") || perms.Contains("ticket.assign");

        var article = await _context.KnowledgeArticles.FirstOrDefaultAsync(a => a.Id == id && !a.IsDeleted);
        if (article == null) return null;

        // Visibility checks
        if (article.Status == ArticleStatus.Draft && !canManageKb) return null;
        if (article.Visibility == ArticleVisibility.Internal && !isStaff && !canManageKb) return null;

        // Increment ViewCount if published
        if (article.Status == ArticleStatus.Published)
        {
            article.ViewCount++;
            await _context.SaveChangesAsync();
        }

        return new KbArticleDto(article.Id, article.CategoryId, article.Title, article.Content, article.AuthorUserId, article.Status, article.Visibility, article.ViewCount, article.CreatedAt);
    }

    public async Task<KbArticleDto> CreateArticleAsync(CreateKbArticleDto dto, int authorId)
    {
        var article = new KnowledgeArticle
        {
            CategoryId = dto.CategoryId,
            Title = dto.Title,
            Content = dto.Content,
            Status = dto.Status,
            Visibility = dto.Visibility,
            AuthorUserId = authorId
        };
        _context.KnowledgeArticles.Add(article);
        await _context.SaveChangesAsync();

        return new KbArticleDto(article.Id, article.CategoryId, article.Title, article.Content, article.AuthorUserId, article.Status, article.Visibility, article.ViewCount, article.CreatedAt);
    }

    public async Task UpdateArticleAsync(int id, UpdateKbArticleDto dto)
    {
        var article = await _context.KnowledgeArticles.FirstOrDefaultAsync(a => a.Id == id && !a.IsDeleted);
        if (article == null) throw new KeyNotFoundException("Article not found.");

        article.CategoryId = dto.CategoryId;
        article.Title = dto.Title;
        article.Content = dto.Content;
        article.Status = dto.Status;
        article.Visibility = dto.Visibility;
        await _context.SaveChangesAsync();
    }

    public async Task DeleteArticleAsync(int id)
    {
        var article = await _context.KnowledgeArticles.FirstOrDefaultAsync(a => a.Id == id && !a.IsDeleted);
        if (article != null)
        {
            article.IsDeleted = true;
            await _context.SaveChangesAsync();
        }
    }
}
