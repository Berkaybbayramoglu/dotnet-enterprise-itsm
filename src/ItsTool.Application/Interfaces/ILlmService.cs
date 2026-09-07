using System.Threading.Tasks;

namespace ItsTool.Application.Interfaces;

public interface ILlmService
{
    Task<string> GetCompletionAsync(string systemPrompt, string userMessage);
    Task<bool> IsAvailableAsync();
    string GetModelName();
    string GetEndpoint();
}
