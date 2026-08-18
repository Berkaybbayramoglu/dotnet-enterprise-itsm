using System;
using System.Collections.Generic;

namespace ItsTool.Application.DTOs;

public class TicketSearchFilterDto
{
    public int? ProjectId { get; set; }
    public int? CategoryId { get; set; }
    public int? TypeId { get; set; }
    public int? StatusId { get; set; }
    public int? PriorityId { get; set; }
    public int? AssigneeUserId { get; set; }
    public int? RequesterUserId { get; set; }
    public DateTime? FromDate { get; set; }
    public DateTime? ToDate { get; set; }
    public string? Keyword { get; set; }
    public string? SlaStatus { get; set; } // "ontrack", "warning", "breached"
    
    public int Page { get; set; } = 1;
    public int PageSize { get; set; } = 20;
    public string? SortBy { get; set; } // e.g. "CreatedAt", "Priority", "Status"
    public bool SortDescending { get; set; } = true;
}

public class PagedResult<T>
{
    public IEnumerable<T> Items { get; set; } = new List<T>();
    public int TotalCount { get; set; }
    public int Page { get; set; }
    public int PageSize { get; set; }
    public int TotalPages => (int)Math.Ceiling(TotalCount / (double)PageSize);
}
