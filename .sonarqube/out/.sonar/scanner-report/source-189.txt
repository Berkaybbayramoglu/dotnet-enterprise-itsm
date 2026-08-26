using System.Threading.Tasks;
using ItsTool.Application.DTOs;

namespace ItsTool.Application.Interfaces;

public interface IEmailIngestionService
{
    Task ProcessIncomingEmailAsync(EmailIngestionDto dto);
}
