using ItsTool.Application.Interfaces;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using System.Linq;

namespace ItsTool.API.Controllers;
[ApiController]
[Route("api/[controller]")]
public class TestController : ControllerBase {
    private readonly IRoleService _roleService;
    public TestController(IRoleService roleService) { _roleService = roleService; }
    
    [HttpGet("roles")]
    [AllowAnonymous]
    public async Task<IActionResult> GetRoles() { 
        var roles = await _roleService.GetAllAsync();
        var str = string.Join("\n", roles.Select(r => $"{r.Name}: {string.Join(",", r.Permissions ?? System.Array.Empty<string>())}"));
        return Ok(str);
    }
}
