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
    public const string ReportView = "report.view";
    public const string AdminManage = "admin.manage";
    public const string ConfigManage = "config.manage";
    public const string SlaManage = "sla.manage";
    public const string AuditView = "audit.view";

    public static IReadOnlyList<string> AllPermissions => new[]
    {
        TicketCreate, TicketView, TicketEdit, TicketAssign, TicketTransfer, 
        TicketResolve, TicketClose, TicketReopen, TicketCommentInternal, ReportView, AdminManage, ConfigManage, SlaManage, AuditView
    };
}
