using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace ItsTool.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class TicketController : ControllerBase
{
    private const string PermissionClaim = "permission";
    private const string RoleSuperAdmin = "SuperAdmin";
    private const string RoleManager = "Manager";
    private readonly ITicketService _service;

    public TicketController(ITicketService service)
    {
        _service = service;
    }

    private int GetCurrentUserId()
    {
        var idClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        return int.TryParse(idClaim, out var id) ? id : 0;
    }

    [HttpPost]
    [Authorize(Policy = "RequirePermission:ticket.create")]
    [ProducesResponseType(typeof(TicketDto), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> CreateTicket([FromBody] CreateTicketDto dto)
    {
        try
        {
            var forcedDto = dto with { RequesterUserId = GetCurrentUserId() };
            var result = await _service.CreateTicketAsync(forcedDto);
            return CreatedAtAction(nameof(GetTicket), new { id = result.Id }, result);
        }
        catch (InvalidOperationException ex) { return BadRequest(new { error = ex.Message }); }
    }

    [HttpGet("{id}")]
    [Authorize(Policy = "RequirePermission:ticket.view")]
    [ProducesResponseType(typeof(TicketDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetTicket(int id)
    {
        var t = await _service.GetTicketByIdAsync(id);
        if (t == null) return NotFound();
        return Ok(t);
    }

    [HttpGet("{id}/eligible-users")]
    [ProducesResponseType(typeof(IEnumerable<UserDto>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetEligibleUsers(int id)
    {
        var users = await _service.GetEligibleUsersForTicketAsync(id);
        return Ok(users);
    }

    private static readonly HashSet<string> AllowedDeleteRoles = new(StringComparer.OrdinalIgnoreCase) { RoleSuperAdmin, RoleManager };
    private static readonly HashSet<string> AllowedDeletePermissions = new() { "ticket.manage", "ticket.assign", "ticket.delete", "ticket.edit" };

    private bool HasTicketDeletePermission()
    {
        if (User.IsInRole(RoleSuperAdmin) || User.IsInRole(RoleManager)) return true;
        return User.Claims.Any(c => 
            (c.Type == ClaimTypes.Role && AllowedDeleteRoles.Contains(c.Value)) ||
            (c.Type == PermissionClaim && AllowedDeletePermissions.Contains(c.Value)));
    }

    [HttpDelete("{id}")]
    [Authorize]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    public async Task<IActionResult> DeleteTicket(int id)
    {
        if (!HasTicketDeletePermission()) return Forbid();

        try
        {
            await _service.DeleteTicketAsync(id, GetCurrentUserId());
            return NoContent();
        }
        catch (System.Collections.Generic.KeyNotFoundException) { return NotFound(); }
    }

    [HttpPost("{id}/restore")]
    [Authorize]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    public async Task<IActionResult> RestoreTicket(int id)
    {
        if (!HasTicketDeletePermission()) return Forbid();

        try
        {
            await _service.RestoreTicketAsync(id, GetCurrentUserId());
            return NoContent();
        }
        catch (System.Collections.Generic.KeyNotFoundException) { return NotFound(); }
    }

    [HttpPut("{id}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> UpdateTicket(int id, [FromBody] UpdateTicketDto dto)
    {
        try
        {
            await _service.UpdateTicketAsync(id, dto, GetCurrentUserId());
            return NoContent();
        }
        catch (KeyNotFoundException) { return NotFound(); }
        catch (InvalidOperationException ex) { return BadRequest(new { error = ex.Message }); }
    }

    [HttpGet("{id}/allowed-transitions")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetAllowedTransitions(int id)
    {
        try
        {
            var transitions = await _service.GetAllowedTransitionsAsync(id, GetCurrentUserId());
            return Ok(transitions);
        }
        catch (KeyNotFoundException)
        {
            return NotFound();
        }
    }

    [HttpPost("{id}/status")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<IActionResult> ChangeStatus(int id, [FromBody] int newStatusId)
    {
        try
        {
            var dto = new ChangeStatusDto(newStatusId, GetCurrentUserId());
            await _service.ChangeStatusAsync(id, dto);
            return NoContent();
        }
        catch (KeyNotFoundException) { return NotFound(); }
        catch (InvalidOperationException ex) { return BadRequest(new { error = ex.Message }); }
        catch (UnauthorizedAccessException ex) { return Unauthorized(new { error = ex.Message }); }
    }

    public record AssignTicketRequest(List<int> UserIds, List<int> GroupIds, int? ParentAssignmentId = null);

    [HttpPost("{id}/assign")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> AssignTicket(int id, [FromBody] AssignTicketRequest req)
    {
        try
        {
            var dto = new AssignTicketDto(req.UserIds ?? new List<int>(), req.GroupIds ?? new List<int>(), GetCurrentUserId(), req.ParentAssignmentId);
            await _service.AssignTicketAsync(id, dto);
            return NoContent();
        }
        catch (KeyNotFoundException) { return NotFound(); }
        catch (UnauthorizedAccessException ex) { return Unauthorized(new { error = ex.Message }); }
    }

    [HttpGet("{id}/assignments/tree")]
    [ProducesResponseType(typeof(IEnumerable<TicketAssigneeDto>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetAssignmentTree(int id)
    {
        try
        {
            var tree = await _service.GetAssignmentTreeAsync(id);
            return Ok(tree);
        }
        catch (KeyNotFoundException) { return NotFound(); }
    }

    [HttpPost("{id}/transfer")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> TransferTicket(int id, [FromBody] TransferTicketDto dto)
    {
        try
        {
            var transferDto = new TransferTicketDto(dto.ProjectId, dto.GroupId, GetCurrentUserId());
            await _service.TransferTicketAsync(id, transferDto);
            return NoContent();
        }
        catch (KeyNotFoundException) { return NotFound(); }
        catch (UnauthorizedAccessException ex) { return Unauthorized(new { error = ex.Message }); }
    }

    [HttpPost("{id}/comments")]
    [ProducesResponseType(typeof(TicketCommentDto), StatusCodes.Status201Created)]
    public async Task<IActionResult> AddComment(int id, [FromBody] CreateCommentDto dto)
    {
        var createDto = new CreateCommentDto(dto.Content, dto.IsInternal, GetCurrentUserId(), dto.ParentCommentId, dto.MentionedUserIds);
        var result = await _service.AddCommentAsync(id, createDto);
        return Ok(result);
    }

    [HttpPut("{id}/comments/{commentId}")]
    [ProducesResponseType(typeof(TicketCommentDto), StatusCodes.Status200OK)]
    public async Task<IActionResult> UpdateComment(int id, int commentId, [FromBody] UpdateCommentDto dto)
    {
        bool hasEditPerm = User.HasClaim(c => c.Type == PermissionClaim && c.Value == "ticket.comment.edit");
        try
        {
            var result = await _service.UpdateCommentAsync(id, commentId, dto, GetCurrentUserId(), hasEditPerm);
            return Ok(result);
        }
        catch (KeyNotFoundException) { return NotFound(); }
        catch (UnauthorizedAccessException ex) { return Unauthorized(new { error = ex.Message }); }
    }

    [HttpDelete("{id}/comments/{commentId}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> DeleteComment(int id, int commentId)
    {
        bool hasDeletePerm = User.HasClaim(c => c.Type == PermissionClaim && c.Value == "ticket.comment.delete");
        try
        {
            await _service.DeleteCommentAsync(id, commentId, GetCurrentUserId(), hasDeletePerm);
            return NoContent();
        }
        catch (KeyNotFoundException) { return NotFound(); }
        catch (UnauthorizedAccessException ex) { return Unauthorized(new { error = ex.Message }); }
    }

    [HttpPost("{id}/comments/{commentId}/restore")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> RestoreComment(int id, int commentId)
    {
        bool hasDeletePerm = User.HasClaim(c => c.Type == PermissionClaim && c.Value == "ticket.comment.delete");
        try
        {
            await _service.RestoreCommentAsync(id, commentId, GetCurrentUserId(), hasDeletePerm);
            return NoContent();
        }
        catch (KeyNotFoundException) { return NotFound(); }
        catch (UnauthorizedAccessException ex) { return Unauthorized(new { error = ex.Message }); }
    }

    [HttpGet("{id}/comments")]
    [ProducesResponseType(typeof(IEnumerable<TicketCommentDto>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetComments(int id)
    {
        bool hasInternalPerm = User.HasClaim(c => c.Type == PermissionClaim && c.Value == "ticket.comment.internal");
        var result = await _service.GetCommentsAsync(id, hasInternalPerm);
        return Ok(result);
    }

    [HttpPost("{id}/attachments")]
    [ProducesResponseType(typeof(TicketAttachmentDto), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> AddAttachment(int id, IFormFile file)
    {
        try
        {
            var result = await _service.AddAttachmentAsync(id, file, GetCurrentUserId());
            return Ok(result);
        }
        catch (InvalidOperationException ex) { return BadRequest(new { error = ex.Message }); }
    }

    [HttpGet("{id}/attachments")]
    [ProducesResponseType(typeof(IEnumerable<TicketAttachmentDto>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetAttachments(int id)
    {
        return Ok(await _service.GetAttachmentsAsync(id));
    }

    [AllowAnonymous]
    [HttpGet("{id}/attachments/{attachmentId}/download")]
    public async Task<IActionResult> DownloadAttachment(int id, int attachmentId)
    {
        try
        {
            var (filePath, contentType, fileName) = await _service.GetAttachmentFileInfoAsync(id, attachmentId);
            if (!System.IO.File.Exists(filePath))
                return NotFound();
                
            return PhysicalFile(System.IO.Path.GetFullPath(filePath), contentType, fileName);
        }
        catch (KeyNotFoundException)
        {
            return NotFound();
        }
    }

    [HttpDelete("{id}/attachments/{attachmentId}")]
    public async Task<IActionResult> DeleteAttachment(int id, int attachmentId)
    {
        bool hasManage = User.HasClaim(c => c.Type == PermissionClaim && c.Value == "ticket.manage") || 
                         User.HasClaim(c => c.Type == ClaimTypes.Role && c.Value == RoleSuperAdmin);
        try
        {
            await _service.DeleteAttachmentAsync(id, attachmentId, GetCurrentUserId(), hasManage);
            return NoContent();
        }
        catch (UnauthorizedAccessException ex)
        {
            return StatusCode(403, new { error = ex.Message });
        }
        catch (KeyNotFoundException ex)
        {
            return StatusCode(404, new { error = ex.Message });
        }
    }

    [HttpGet("{id}/timeline")]
    [ProducesResponseType(typeof(IEnumerable<TimelineEventDto>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetTimeline(int id)
    {
        bool hasInternalPerm = User.HasClaim(c => c.Type == PermissionClaim && c.Value == "ticket.comment.internal") || 
                               User.HasClaim(c => c.Type == ClaimTypes.Role && c.Value == RoleSuperAdmin);
        return Ok(await _service.GetTimelineAsync(id, hasInternalPerm));
    }

    [HttpGet("search")]
    public async Task<IActionResult> Search([FromQuery] TicketSearchFilterDto filter)
    {
        var result = await _service.SearchTicketsAsync(filter, GetCurrentUserId());
        return Ok(result);
    }

    [HttpPost("{id}/survey")]
    [ProducesResponseType(typeof(TicketSurveyDto), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> SubmitSurvey(int id, [FromBody] SubmitTicketSurveyDto dto)
    {
        try
        {
            var result = await _service.SubmitSurveyAsync(id, dto, GetCurrentUserId());
            return CreatedAtAction(nameof(GetTicket), new { id = result.TicketId }, result);
        }
        catch (InvalidOperationException ex) { return BadRequest(new { error = ex.Message }); }
        catch (UnauthorizedAccessException ex) { return Unauthorized(new { error = ex.Message }); }
        catch (KeyNotFoundException) { return NotFound(); }
    }
}
