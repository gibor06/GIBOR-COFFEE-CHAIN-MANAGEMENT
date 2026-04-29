using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace QuanLyChuoiCaPhe.Web.Filters
{
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method, AllowMultiple = false)]
    public class RoleAuthorizeAttribute : Attribute, IAuthorizationFilter
    {
        private readonly string[] _allowedRoles;

        public RoleAuthorizeAttribute(params string[] allowedRoles)
        {
            _allowedRoles = allowedRoles;
        }

        public void OnAuthorization(AuthorizationFilterContext context)
        {
            var maTK = context.HttpContext.Session.GetString("MaTK");
            var vaiTro = context.HttpContext.Session.GetString("VaiTro");

            // Kiểm tra đăng nhập
            if (string.IsNullOrEmpty(maTK) || string.IsNullOrEmpty(vaiTro))
            {
                context.Result = new RedirectToActionResult("Login", "Account", null);
                return;
            }

            // Kiểm tra quyền
            if (_allowedRoles.Length > 0 && !_allowedRoles.Contains(vaiTro))
            {
                context.HttpContext.Session.SetString("ErrorMessage", "Bạn không có quyền truy cập chức năng này!");
                context.Result = new RedirectToActionResult("Index", "Dashboard", null);
                return;
            }
        }
    }
}
