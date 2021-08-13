using Microsoft.EntityFrameworkCore;
using System.Linq;
using HotChocolate;
using HotChocolate.Data;
using Models;

namespace GraphQL
{
    public class Query
    {
        [UseDbContext(typeof(ApiDbContext))]
        [UseProjection]
        [UseFiltering]
        [UseSorting]
        public IQueryable<Series> GetSeries([ScopedService] ApiDbContext context)
        {
            return context.Series;
        }

        [UseDbContext(typeof(ApiDbContext))]
        [UseProjection]
        [UseFiltering]
        [UseSorting]
        public IQueryable<Category> GetCategory([ScopedService] ApiDbContext context)
        {
            return context.Category;
        }

        [UseDbContext(typeof(ApiDbContext))]
        [UseProjection]
        [UseFiltering]
        [UseSorting]
        public IQueryable<CategorySeries> GetCategorySeries([ScopedService] ApiDbContext context)
        {
            return context.CategorySeries;
        }

        [UseDbContext(typeof(ApiDbContext))]
        [UseProjection]
        [UseFiltering]
        [UseSorting]
        public IQueryable<Season> GetSeason([ScopedService] ApiDbContext context)
        {
            return context.Season;
        }

        [UseDbContext(typeof(ApiDbContext))]
        [UseProjection]
        [UseFiltering]
        [UseSorting]
        public IQueryable<Episode> GetEpisode([ScopedService] ApiDbContext context)
        {
            return context.Episode;
        }
    }

}