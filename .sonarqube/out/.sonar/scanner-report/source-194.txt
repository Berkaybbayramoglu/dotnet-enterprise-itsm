using System.Collections.Generic;
using System.Threading.Tasks;
using ItsTool.Application.DTOs;

namespace ItsTool.Application.Interfaces;

public interface IKnowledgeBaseService
{
    Task<IEnumerable<KbCategoryDto>> GetCategoriesAsync();
    Task<KbCategoryDto> CreateCategoryAsync(CreateKbCategoryDto dto);
    Task UpdateCategoryAsync(int id, CreateKbCategoryDto dto);
    Task DeleteCategoryAsync(int id);

    Task<IEnumerable<KbArticleSummaryDto>> SearchArticlesAsync(int userId, string? keyword, int? categoryId);
    Task<KbArticleDto?> GetArticleAsync(int id, int userId);
    Task<KbArticleDto> CreateArticleAsync(CreateKbArticleDto dto, int authorId);
    Task UpdateArticleAsync(int id, UpdateKbArticleDto dto);
    Task DeleteArticleAsync(int id);
}
