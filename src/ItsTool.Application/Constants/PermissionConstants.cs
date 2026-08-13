namespace ItsTool.Application.Constants;

public static class PermissionConstants
{
    public const string TicketCreate = "ticket.create";
    public const string TicketView = "ticket.view";
    public const string TicketAssign = "ticket.assign";
    public const string TicketTransfer = "ticket.transfer";
    public const string TicketResolve = "ticket.resolve";
    public const string TicketClose = "ticket.close";
    public const string ReportView = "report.view";
    public const string AdminManage = "admin.manage";
    public const string ConfigManage = "config.manage";

    public static IReadOnlyList<string> AllPermissions => new[]
    {
        TicketCreate, TicketView, TicketAssign, TicketTransfer, 
        TicketResolve, TicketClose, ReportView, AdminManage, ConfigManage
    };
}
