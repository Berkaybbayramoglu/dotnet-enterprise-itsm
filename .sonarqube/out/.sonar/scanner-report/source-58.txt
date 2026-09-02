using System.Threading.Tasks;
using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ItsTool.API.Controllers;

[ApiController]
[Route("api/kb")]
[Authorize]
public class KnowledgeBaseController : ControllerBase
{
    private readonly IKnowledgeBaseService _kbService;

    public KnowledgeBaseController(IKnowledgeBaseService kbService)
    {
        _kbService = kbService;
    }

    private int GetCurrentUserId()
    {
        var claim = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier) ?? User.FindFirst("UserId");
        return claim != null && int.TryParse(claim.Value, out int id) ? id : 0;
    }

    [HttpGet("categories")]
    public async Task<IActionResult> GetCategories()
    {
        var result = await _kbService.GetCategoriesAsync();
        return Ok(result);
    }

    [HttpPost("categories")]
    [Authorize(Policy = "RequireKbManage")]
    public async Task<IActionResult> CreateCategory(CreateKbCategoryDto dto)
    {
        var result = await _kbService.CreateCategoryAsync(dto);
        return Ok(result);
    }

    [HttpPut("categories/{id}")]
    [Authorize(Policy = "RequireKbManage")]
    public async Task<IActionResult> UpdateCategory(int id, CreateKbCategoryDto dto)
    {
        await _kbService.UpdateCategoryAsync(id, dto);
        return NoContent();
    }

    [HttpDelete("categories/{id}")]
    [Authorize(Policy = "RequireKbManage")]
    public async Task<IActionResult> DeleteCategory(int id)
    {
        await _kbService.DeleteCategoryAsync(id);
        return NoContent();
    }

    [HttpGet("articles")]
    public async Task<IActionResult> SearchArticles([FromQuery] string? search, [FromQuery] int? category)
    {
        var result = await _kbService.SearchArticlesAsync(GetCurrentUserId(), search, category);
        return Ok(result);
    }

    [HttpGet("articles/{id}")]
    public async Task<IActionResult> GetArticle(int id)
    {
        var result = await _kbService.GetArticleAsync(id, GetCurrentUserId());
        if (result == null) return NotFound();
        return Ok(result);
    }

    [HttpPost("articles")]
    public async Task<IActionResult> CreateArticle(CreateKbArticleDto dto)
    {
        var result = await _kbService.CreateArticleAsync(dto, GetCurrentUserId());
        return Ok(result);
    }

    [HttpPut("articles/{id}")]
    public async Task<IActionResult> UpdateArticle(int id, UpdateKbArticleDto dto)
    {
        await _kbService.UpdateArticleAsync(id, dto, GetCurrentUserId());
        return NoContent();
    }

    [HttpPost("articles/{id}/review")]
    [Authorize(Policy = "RequireKbManage")]
    public async Task<IActionResult> ReviewArticle(int id, ReviewKbArticleDto dto)
    {
        await _kbService.ReviewArticleAsync(id, dto, GetCurrentUserId());
        return NoContent();
    }

    [HttpDelete("articles/{id}")]
    public async Task<IActionResult> DeleteArticle(int id)
    {
        await _kbService.DeleteArticleAsync(id, GetCurrentUserId());
        return NoContent();
    }
}
