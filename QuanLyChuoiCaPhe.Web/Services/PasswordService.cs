using System.Security.Cryptography;
using System.Text;
using Microsoft.AspNetCore.Identity;
using QuanLyChuoiCaPhe.Web.Models;

namespace QuanLyChuoiCaPhe.Web.Services
{
    public class PasswordService
    {
        private readonly PasswordHasher<HeThongTaiKhoan> _passwordHasher = new();

        public string HashPassword(HeThongTaiKhoan taiKhoan, string password)
        {
            return _passwordHasher.HashPassword(taiKhoan, password);
        }

        public bool VerifyPassword(HeThongTaiKhoan taiKhoan, string password, out bool needsRehash)
        {
            needsRehash = false;
            var storedHash = taiKhoan.MatKhauHash;

            if (string.IsNullOrEmpty(storedHash) || string.IsNullOrEmpty(password))
            {
                return false;
            }

            try
            {
                var identityResult = _passwordHasher.VerifyHashedPassword(taiKhoan, storedHash, password);
                if (identityResult == PasswordVerificationResult.Success)
                {
                    return true;
                }

                if (identityResult == PasswordVerificationResult.SuccessRehashNeeded)
                {
                    needsRehash = true;
                    return true;
                }
            }
            catch (FormatException)
            {
                // Legacy values are handled below.
            }

            if (VerifyLegacySha256Hex(storedHash, password) ||
                VerifyLegacySha256Base64(storedHash, password) ||
                VerifyLegacyPlainText(storedHash, password))
            {
                needsRehash = true;
                return true;
            }

            return false;
        }

        private static bool VerifyLegacyPlainText(string storedValue, string password)
        {
            return FixedTimeEquals(storedValue, password);
        }

        private static bool VerifyLegacySha256Hex(string storedValue, string password)
        {
            const string prefix = "sha256$";
            if (!storedValue.StartsWith(prefix, StringComparison.OrdinalIgnoreCase))
            {
                return false;
            }

            var expectedHex = storedValue[prefix.Length..];
            var actualHex = Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(password))).ToLowerInvariant();
            return FixedTimeEquals(expectedHex.ToLowerInvariant(), actualHex);
        }

        private static bool VerifyLegacySha256Base64(string storedValue, string password)
        {
            var actualBase64 = Convert.ToBase64String(SHA256.HashData(Encoding.UTF8.GetBytes(password)));
            return FixedTimeEquals(storedValue, actualBase64);
        }

        private static bool FixedTimeEquals(string left, string right)
        {
            var leftBytes = Encoding.UTF8.GetBytes(left);
            var rightBytes = Encoding.UTF8.GetBytes(right);
            return leftBytes.Length == rightBytes.Length &&
                   CryptographicOperations.FixedTimeEquals(leftBytes, rightBytes);
        }
    }
}
