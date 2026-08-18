using Microsoft.AspNetCore.Http;
using ItsTool.Application.DTOs;

namespace ItsTool.Application.Interfaces;

public interface IFileStorageService
{
    Task<string> SaveFileAsync(IFormFile file, int ticketId);
    Task DeleteFileAsync(string filePath);
}
