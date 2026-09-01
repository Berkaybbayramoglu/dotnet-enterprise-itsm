using ItsTool.Application.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;

namespace ItsTool.Infrastructure.Services;

public class LocalFileStorageService : IFileStorageService
{
    private readonly string _basePath;

    public LocalFileStorageService(IConfiguration configuration)
    {
        _basePath = configuration["FileStorage:BasePath"] ?? "uploads";
        if (!Directory.Exists(_basePath))
        {
            Directory.CreateDirectory(_basePath);
        }
    }

    public async Task<string> SaveFileAsync(IFormFile file, int ticketId)
    {
        var allowedExtensions = new[] { ".jpg", ".jpeg", ".png", ".gif", ".webp", ".pdf", ".docx", ".xlsx", ".doc", ".xls", ".txt", ".md", ".csv", ".json", ".xml", ".zip", ".log", ".tex", ".svg", ".rar", ".7z", ".tar.gz", ".tar", ".sql" };
        var ext = Path.GetExtension(file.FileName).ToLowerInvariant();
        
        if (!allowedExtensions.Contains(ext))
            throw new InvalidOperationException($"File type '{ext}' not allowed.");

        if (file.Length > 10 * 1024 * 1024) // 10 MB
            throw new InvalidOperationException("File size exceeds 10MB limit.");

        var ticketFolder = Path.Combine(_basePath, ticketId.ToString());
        if (!Directory.Exists(ticketFolder))
            Directory.CreateDirectory(ticketFolder);

        var fileName = $"{Guid.NewGuid()}_{file.FileName}";
        var filePath = Path.Combine(ticketFolder, fileName);

        using (var stream = new FileStream(filePath, FileMode.Create))
        {
            await file.CopyToAsync(stream);
        }

        return filePath;
    }

    public Task DeleteFileAsync(string filePath)
    {
        if (File.Exists(filePath))
            File.Delete(filePath);
        return Task.CompletedTask;
    }
}
