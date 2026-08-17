using System;
using ItsTool.Domain.Entities.KnowledgeBase;

namespace ItsTool.Application.DTOs;

public record KbCategoryDto(int Id, string Name, int? ParentId);
public record CreateKbCategoryDto(string Name, int? ParentId);

public record KbArticleDto(int Id, int CategoryId, string Title, string Content, int AuthorUserId, ArticleStatus Status, ArticleVisibility Visibility, int ViewCount, DateTime CreatedAt);
public record KbArticleSummaryDto(int Id, int CategoryId, string Title, int AuthorUserId, ArticleStatus Status, ArticleVisibility Visibility, int ViewCount, DateTime CreatedAt);

public record CreateKbArticleDto(int CategoryId, string Title, string Content, ArticleStatus Status, ArticleVisibility Visibility);
public record UpdateKbArticleDto(int CategoryId, string Title, string Content, ArticleStatus Status, ArticleVisibility Visibility);
