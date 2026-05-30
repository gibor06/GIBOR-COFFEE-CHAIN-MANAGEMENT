using System;
using System.Collections.Generic;

namespace QuanLyChuoiCaPhe.Web.Services
{
    public static class FormatHelper
    {
        public static bool IsMeasurableUnit(string? unit)
        {
            if (string.IsNullOrWhiteSpace(unit)) return false;

            var normalized = unit.Trim().ToLowerInvariant();
            var measurableUnits = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
            {
                "kg", "g", "gram", "l", "lit", "lít", "ml"
            };

            return measurableUnits.Contains(normalized);
        }

        public static string FormatByUnit(decimal value, string? unit)
        {
            if (IsMeasurableUnit(unit))
            {
                return value.ToString("N2");
            }

            // Đơn vị đếm (cái/cây/ly/...) hiển thị số nguyên.
            var roundedInteger = Convert.ToInt32(Math.Round(value, MidpointRounding.AwayFromZero));
            return roundedInteger.ToString("N0");
        }
    }
}
