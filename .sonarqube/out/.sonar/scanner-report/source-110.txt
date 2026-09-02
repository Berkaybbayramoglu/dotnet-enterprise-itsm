using System.Collections.Generic;

namespace ItsTool.Application.Interfaces;

public interface IEmailTemplateService
{
    string GenerateEmailBody(string eventKey, Dictionary<string, string> templateData);
}
