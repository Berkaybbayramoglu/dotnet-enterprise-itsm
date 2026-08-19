using ItsTool.Application.DTOs;
using Microsoft.AspNetCore.Http;

namespace ItsTool.Application.Interfaces;

public interface ITicketService
{
    Task<TicketDto> CreateTicketAsync(CreateTicketDto dto);
    Task<TicketDto?> GetTicketByIdAsync(int id);
    Task UpdateTicketAsync(int id, UpdateTicketDto dto, int currentUserId);
    Task ChangeStatusAsync(int ticketId, ChangeStatusDto dto);
    Task<IEnumerable<StatusDto>> GetAllowedTransitionsAsync(int ticketId, int userId);
    Task AssignTicketAsync(int ticketId, AssignTicketDto dto);
    Task TransferTicketAsync(int ticketId, TransferTicketDto dto);
    
    Task<TicketCommentDto> AddCommentAsync(int ticketId, CreateCommentDto dto);
    Task<IEnumerable<TicketCommentDto>> GetCommentsAsync(int ticketId, bool includeInternal);
    
    Task<TicketAttachmentDto> AddAttachmentAsync(int ticketId, IFormFile file, int userId);
    Task<IEnumerable<TicketAttachmentDto>> GetAttachmentsAsync(int ticketId);
    
    Task AddWatcherAsync(int ticketId, int userId);
    Task RemoveWatcherAsync(int ticketId, int userId);
    Task<IEnumerable<TicketWatcherDto>> GetWatchersAsync(int ticketId);
    
    Task<IEnumerable<TimelineEventDto>> GetTimelineAsync(int ticketId, bool includeInternal);
    Task<PagedResult<TicketDto>> SearchTicketsAsync(TicketSearchFilterDto filter, int userId);
    Task<TicketSurveyDto> SubmitSurveyAsync(int ticketId, SubmitTicketSurveyDto dto, int userId);
}
