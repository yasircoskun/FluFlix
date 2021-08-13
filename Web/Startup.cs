using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using GraphQL;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Models;

namespace FluFlix
{
    public class Startup
    {
        private readonly IWebHostEnvironment _env;
        public Startup(IConfiguration configuration, IWebHostEnvironment env)
        {
            Configuration = configuration;
            _env = env;
        }

        public IConfiguration Configuration { get; }
        // This method gets called by the runtime. Use this method to add services to the container.
        // For more information on how to configure your application, visit https://go.microsoft.com/fwlink/?LinkID=398940
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddMvc();

            /* appsettings.json dosyasından ConnectionString okur ve bunu kullanarak SQLServer bağlantısı sağlar.
             * Standart AddDbContext'ten farklı olarak AddPooledDbContextFactory kullanarak paralel 
             * işlem yapabilme yeteneği edindik. Bu şu anlama gelir birden fazla context nesnesi aynı anda yaşam döngüsünde yer edinebilir.
             * GraphQL'in tek sorgu ile birden fazla varlığın bilgisini alabilme avantajından faydalanabilmemiz için gerekli.
             * bkz: https://dev.to/moe23/net-5-api-with-graphql-step-by-step-2b20
             */
            var ConnectionString = Configuration.GetConnectionString("ConnectionString");
            services.AddPooledDbContextFactory<ApiDbContext>(options => {options.UseSqlServer(ConnectionString);});
        
            
            services.AddGraphQLServer()
                .AddQueryType<Query>()
                .AddMutationType<Mutation>()
                .AddProjections()
                .AddSorting()
                .AddFiltering()
                .ModifyRequestOptions(opt => opt.IncludeExceptionDetails = _env.IsDevelopment()); //GraphQL için Query sınıfını tanıttık ve Development ortamında detaylı hata mesajı vermesini sağladık

        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseStaticFiles();

            app.UseRouting();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapGraphQL();
                endpoints.MapControllerRoute("default", "{controller=Home}/{action=Index}");
            });
        }
    }
}
