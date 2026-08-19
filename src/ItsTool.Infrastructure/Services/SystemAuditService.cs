using System;
using System.Threading.Tasks;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities;
using ItsTool.Infrastructure.Data;
using Microsoft.AspNetCore.Http;
using System.Security.Claims;

namespace ItsTool.Infrastructure.Services;

public class SystemAuditService : ISystemAuditService
{
    private readonly ItsToolDbContext _context;
    private readonly IHttpContextAccessor _httpContextAccessor;

    public SystemAuditService(ItsToolDbContext context, IHttpContextAccessor httpContextAccessor)
    {
        _context = context;
        _httpContextAccessor = httpContextAccessor;
    }

    public async Task LogAuditAsync(string entityName, string entityId, string action, string? fieldName = null, string? oldValue = null, string? newValue = null)
    {
        var userIdStr = _httpContextAccessor.HttpContext?.User?.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? "system";
        
        var log = new SystemAuditLog
        {
            EntityName = entityName,
            EntityId = entityId,
            Action = action,
            FieldName = fieldName,
            OldValue = oldValue,
            NewValue = newValue,
            CreatedBy = userIdStr,
            CreatedAt = DateTime.UtcNow
        };

        _context.SystemAuditLogs.Add(log);
        await _context.SaveChangesAsync();
    }
}
