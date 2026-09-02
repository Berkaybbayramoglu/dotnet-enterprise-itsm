using ItsTool.Domain.Common;

namespace ItsTool.Domain.Entities.Config;

public enum FieldType { Text, Number, Date, Dropdown, MultiSelect }

public class FieldDefinition : BaseEntity
{
    public string Key { get; set; } = string.Empty;
    public string Label { get; set; } = string.Empty;
    public FieldType FieldType { get; set; }
    public string? ValidationRegex { get; set; }
}

public class FieldOption : BaseEntity
{
    public int FieldDefinitionId { get; set; }
    public string Value { get; set; } = string.Empty;
    public string Label { get; set; } = string.Empty;
    public int SortOrder { get; set; }

    public virtual FieldDefinition? FieldDefinition { get; set; }
}

public class FormFieldPlacement : BaseEntity
{
    public int? ProjectId { get; set; }
    public int? CategoryId { get; set; }
    public int? TicketTypeId { get; set; }
    public int FieldDefinitionId { get; set; }
    public int SortOrder { get; set; }
    public bool IsRequired { get; set; }

    public virtual FieldDefinition? FieldDefinition { get; set; }
}

public class TicketFieldValue : BaseEntity
{
    public int TicketId { get; set; }
    public int FieldDefinitionId { get; set; }
    public string ValueString { get; set; } = string.Empty;
    public string? ValueText { get; set; }

    public virtual Ticket.Ticket? Ticket { get; set; }
    public virtual FieldDefinition? FieldDefinition { get; set; }
}
