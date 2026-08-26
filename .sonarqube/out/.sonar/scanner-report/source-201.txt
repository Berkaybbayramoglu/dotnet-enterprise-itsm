using System.Threading.Tasks;

namespace ItsTool.Application.Interfaces;

public interface ISystemAuditService
{
    Task LogAuditAsync(string entityName, string entityId, string action, string? fieldName = null, string? oldValue = null, string? newValue = null);
}
