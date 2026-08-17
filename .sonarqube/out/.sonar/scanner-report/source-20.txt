using ItsTool.Domain.Common;

namespace ItsTool.Domain.Entities.KnowledgeBase;

public class KnowledgeCategory : BaseEntity
{
    public string Name { get; set; } = string.Empty;
    public int? ParentId { get; set; }
    public virtual KnowledgeCategory? Parent { get; set; }
}

public enum ArticleStatus { Draft, Published }
public enum ArticleVisibility { Internal, Public }

public class KnowledgeArticle : BaseEntity
{
    public int CategoryId { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Content { get; set; } = string.Empty;
    public int AuthorUserId { get; set; }
    public ArticleStatus Status { get; set; }
    public ArticleVisibility Visibility { get; set; }
    public int ViewCount { get; set; }

    public virtual KnowledgeCategory? Category { get; set; }
}
