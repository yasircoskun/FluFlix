using Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;

namespace Kolekty.Controllers
{
    public class HomeController : Controller
    {
        public HomeController()
        {

        }

        [AllowAnonymous]
        public IActionResult Index()
        {

            return View();
        }
    }
}
