namespace QuanLyChuoiCaPhe.Web.Services
{
    public static class CodeGenerator
    {
        public static string GenerateNext(string prefix, int numericWidth, IEnumerable<string?> existingCodes)
        {
            var maxNumber = 0;

            foreach (var existingCode in existingCodes)
            {
                var code = existingCode?.Trim();
                if (string.IsNullOrEmpty(code) || !code.StartsWith(prefix, StringComparison.OrdinalIgnoreCase))
                {
                    continue;
                }

                var numberPart = code[prefix.Length..];
                if (int.TryParse(numberPart, out var number) && number > maxNumber)
                {
                    maxNumber = number;
                }
            }

            var nextNumber = maxNumber + 1;
            var maxAllowed = (int)Math.Pow(10, numericWidth) - 1;
            if (nextNumber > maxAllowed)
            {
                throw new InvalidOperationException($"Không thể sinh mã {prefix}: đã vượt quá {numericWidth} chữ số.");
            }

            return $"{prefix}{nextNumber.ToString($"D{numericWidth}")}";
        }
    }
}
