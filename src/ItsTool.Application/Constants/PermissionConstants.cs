namespace ItsTool.Application.Constants;

public static class PermissionConstants
{
    public const string TicketCreate = "ticket.create";
    public const string TicketView = "ticket.view";
    public const string TicketEdit = "ticket.edit";
    public const string TicketAssign = "ticket.assign";
    public const string TicketTransfer = "ticket.transfer";
    public const string TicketResolve = "ticket.resolve";
    public const string TicketClose = "ticket.close";
    public const string TicketReopen = "ticket.reopen";
    public const string TicketCommentInternal = "ticket.comment.internal";
    public const string TicketCommentEdit = "ticket.comment.edit";
    public const string TicketCommentReply = "ticket.comment.reply";
    public const string ReportView = "report.view";
    public const string AdminManage = "admin.manage";
    public const string ConfigManage = "config.manage";
    public const string SlaManage = "sla.manage";
    public const string AuditView = "audit.view";

    public const string KbManage = "kb.manage";
    public const string KbView = "kb.view";
    public const string SurveySubmit = "survey.submit";
    public const string TicketComment = "ticket.comment";

    public static IReadOnlyList<string> AllPermissions => new[]
    {
        TicketCreate, TicketView, TicketEdit, TicketAssign, TicketTransfer, 
        TicketResolve, TicketClose, TicketReopen, TicketCommentInternal, TicketCommentEdit, TicketCommentReply, ReportView, AdminManage, ConfigManage, SlaManage, AuditView,
        KbManage, KbView, SurveySubmit, TicketComment
    };
}
