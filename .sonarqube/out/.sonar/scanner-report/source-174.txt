namespace ItsTool.Application.DTOs;

public record EmailIngestionDto(
    string MessageId,
    string From,
    string Subject,
    string Body
);
