using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ItsTool.Domain.Entities.Config;
using ItsTool.Infrastructure.Data;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ItsTool.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize(Policy = "RequirePermission:config.manage")]
public class WebhookController : ControllerBase
{
    private readonly ItsToolDbContext _context;

    public WebhookController(ItsToolDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<IActionResult> GetWebhooks()
    {
        var subs = await _context.WebhookSubscriptions.Where(w => !w.IsDeleted).ToListAsync();
        return Ok(subs);
    }

    [HttpPost]
    public async Task<IActionResult> CreateWebhook([FromBody] WebhookSubscription sub)
    {
        _context.WebhookSubscriptions.Add(sub);
        await _context.SaveChangesAsync();
        return Ok(sub);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateWebhook(int id, [FromBody] WebhookSubscription sub)
    {
        var existing = await _context.WebhookSubscriptions.FindAsync(id);
        if (existing == null) return NotFound();

        existing.Url = sub.Url;
        existing.EventsCsv = sub.EventsCsv;
        existing.Secret = sub.Secret;
        existing.IsActive = sub.IsActive;

        await _context.SaveChangesAsync();
        return Ok(existing);
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteWebhook(int id)
    {
        var existing = await _context.WebhookSubscriptions.FindAsync(id);
        if (existing == null) return NotFound();

        existing.IsDeleted = true;
        await _context.SaveChangesAsync();
        return NoContent();
    }

    [HttpPut("{id}/toggle")]
    public async Task<IActionResult> ToggleWebhook(int id)
    {
        var existing = await _context.WebhookSubscriptions.FindAsync(id);
        if (existing == null || existing.IsDeleted) return NotFound();

        existing.IsActive = !existing.IsActive;
        await _context.SaveChangesAsync();
        return NoContent();
    }
}
