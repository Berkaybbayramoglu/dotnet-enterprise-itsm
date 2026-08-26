using System.Linq.Expressions;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Common;
using Microsoft.EntityFrameworkCore;

namespace ItsTool.Infrastructure.Data;

public class Repository<T> : IRepository<T> where T : BaseEntity
{
    protected readonly ItsToolDbContext _context;
    protected readonly DbSet<T> _dbSet;

    public Repository(ItsToolDbContext context)
    {
        _context = context;
        _dbSet = context.Set<T>();
    }

    public async Task<IEnumerable<T>> GetAllAsync(Expression<Func<T, bool>>? predicate = null)
    {
        IQueryable<T> query = _dbSet.Where(e => !e.IsDeleted);
        if (predicate != null)
        {
            query = query.Where(predicate);
        }
        return await query.ToListAsync();
    }

    public async Task<T?> GetByIdAsync(int id)
    {
        return await _dbSet.FirstOrDefaultAsync(e => e.Id == id && !e.IsDeleted);
    }

    public async Task<T> AddAsync(T entity)
    {
        _dbSet.Add(entity);
        await _context.SaveChangesAsync();
        return entity;
    }

    public async Task UpdateAsync(T entity)
    {
        entity.UpdatedAt = DateTime.UtcNow;
        _dbSet.Update(entity);
        await _context.SaveChangesAsync();
    }

    public async Task DeleteAsync(int id)
    {
        var entity = await GetByIdAsync(id);
        if (entity != null)
        {
            entity.IsDeleted = true;
            entity.DeletedAt = DateTime.UtcNow;
            await _context.SaveChangesAsync();
        }
        else
        {
            throw new KeyNotFoundException($"{typeof(T).Name} not found");
        }
    }
}
