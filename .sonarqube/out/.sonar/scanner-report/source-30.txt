using System;
using ItsTool.Domain.Common;

namespace ItsTool.Domain.Entities.SLA;

public class SlaPolicy : BaseEntity
{
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    public int? ProjectId { get; set; }
    public bool EscalateOnBreach { get; set; } // Phase 11: SLA Auto-Escalation
}

public class SlaTarget : BaseEntity
{
    public int SlaPolicyId { get; set; }
    public int PriorityId { get; set; }
    public int? TicketTypeId { get; set; }
    public int FirstResponseMinutes { get; set; }
    public int ResolutionMinutes { get; set; }

    public virtual SlaPolicy? SlaPolicy { get; set; }
}

public class BusinessHour : BaseEntity
{
    public DayOfWeek DayOfWeek { get; set; }
    public TimeSpan StartTime { get; set; }
    public TimeSpan EndTime { get; set; }
    public bool IsWorkingDay { get; set; }
}

public class Holiday : BaseEntity
{
    public DateTime Date { get; set; }
    public string Name { get; set; } = string.Empty;
    public bool IsRecurring { get; set; }
}
