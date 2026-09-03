using Microsoft.AspNetCore.Mvc;

namespace ItsTool.API.Controllers;

public abstract class CrudControllerBase<TDto> : ControllerBase where TDto : class
{
    protected abstract Task<IEnumerable<TDto>> GetAllEntitiesAsync();
    protected abstract Task<TDto?> GetEntityByIdAsync(int id);
    protected abstract Task DeleteEntityAsync(int id);

    [HttpGet]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public async Task<IActionResult> GetAll()
    {
        return Ok(await GetAllEntitiesAsync());
    }

    [HttpGet("{id}")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetById(int id)
    {
        var entity = await GetEntityByIdAsync(id);
        if (entity == null) return NotFound();
        return Ok(entity);
    }

    [HttpDelete("{id}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Delete(int id)
    {
        try
        {
            await DeleteEntityAsync(id);
            return NoContent();
        }
        catch (KeyNotFoundException)
        {
            return NotFound();
        }
    }
}
