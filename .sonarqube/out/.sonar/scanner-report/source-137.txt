namespace ItsTool.Application.Interfaces;

public interface IPermissionCalculator
{
    Task<HashSet<string>> CalculateEffectivePermissionsAsync(int userId);
}
