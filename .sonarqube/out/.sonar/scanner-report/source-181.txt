using System;

namespace ItsTool.Application.DTOs;

public record TicketSurveyDto(
    int Id,
    int TicketId,
    int Rating,
    string? Comment,
    DateTime SubmittedAt
);

public record SubmitTicketSurveyDto(
    int Rating,
    string? Comment
);
