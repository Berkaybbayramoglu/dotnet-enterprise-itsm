using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;

namespace ItsTool.API.Security;

public class PermissionRequirement : IAuthorizationRequirement
{
    public string Permission { get; }
    public PermissionRequirement(string permission) => Permission = permission;
}

public class PermissionAuthorizationHandler : AuthorizationHandler<PermissionRequirement>
{
    protected override Task HandleRequirementAsync(AuthorizationHandlerContext context, PermissionRequirement requirement)
    {
        var isSuperAdmin = context.User.IsInRole("SuperAdmin") || 
                           context.User.HasClaim(c => (c.Type == ClaimTypes.Role || c.Type == "role" || c.Type == "http://schemas.microsoft.com/ws/2008/06/identity/claims/role") && c.Value.Equals("SuperAdmin", StringComparison.OrdinalIgnoreCase));

        var hasPermission = isSuperAdmin || context.User.HasClaim(c => 
            c.Type == "permission" && c.Value == requirement.Permission);

        if (hasPermission)
        {
            context.Succeed(requirement);
        }

        return Task.CompletedTask;
    }
}
