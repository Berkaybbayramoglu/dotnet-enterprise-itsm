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
            var result = await _service.CreateTicketAsync(dto);
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

    [HttpPut("{id}")]
    [Authorize(Policy = "RequirePermission:ticket.edit")]
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
        bool hasEditPerm = User.HasClaim(c => c.Type == "Permission" && c.Value == "ticket.comment.edit");
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
        bool hasDeletePerm = User.HasClaim(c => c.Type == "Permission" && c.Value == "ticket.comment.delete");
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
        bool hasDeletePerm = User.HasClaim(c => c.Type == "Permission" && c.Value == "ticket.comment.delete");
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
        bool hasInternalPerm = User.HasClaim(c => c.Type == "Permission" && c.Value == "ticket.comment.internal");
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

    [HttpGet("{id}/timeline")]
    [ProducesResponseType(typeof(IEnumerable<TimelineEventDto>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetTimeline(int id)
    {
        bool hasInternalPerm = User.HasClaim(c => c.Type == "Permission" && c.Value == "ticket.comment.internal") || 
                               User.HasClaim(c => c.Type == ClaimTypes.Role && c.Value == "SuperAdmin");
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
