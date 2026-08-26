using System.IO;
using System.Threading.Tasks;
using ItsTool.Application.DTOs;

namespace ItsTool.Application.Interfaces;

public interface IReportService
{
    Task<Stream> ExportTicketsToCsvAsync(TicketSearchFilterDto filter, int userId);
}
