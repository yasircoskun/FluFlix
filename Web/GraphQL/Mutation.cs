using Microsoft.EntityFrameworkCore;
using System.Linq;
using HotChocolate;
using HotChocolate.Data;
using Models;
using System.Threading.Tasks;
using System.Collections.Generic;

namespace GraphQL
{

    public class Mutation
    {
        public record AddSeriesPayload(Series series);
        public record AddSeriesInput(string name, string about, string posterURL, List<int> categories);
        public record UpdateSeriesInput(int id, string name, string about);

        [UseDbContext(typeof(ApiDbContext))]
        public async Task<AddSeriesPayload> AddSeriesAsync(AddSeriesInput input, [ScopedService] ApiDbContext context)
        {
            if(input.categories != null || input.categories.Count != 0){
                var series = new Series
                {
                    Name = input.name,
                    About = input.about,
                    posterURL = input.posterURL,
                };

                context.Series.Add(series);
                await context.SaveChangesAsync();
                
                foreach (var categoryId in input.categories)
                {
                    var category = context.Category.Find(categoryId);

                    var seriesID = series.Id;
                    var categorySeries = new CategorySeries
                    {
                        CategoryID = category.Id,
                        SeriesID = seriesID
                    };
                    context.CategorySeries.Add(categorySeries);
                    await context.SaveChangesAsync();
                }
                return new AddSeriesPayload(series);
            }else{
                var series = new Series
                {
                    Name = input.name,
                    About = input.about,
                    posterURL = input.posterURL
                };

                context.Series.Add(series);
                await context.SaveChangesAsync();
                return new AddSeriesPayload(series);
            }
            

        }

        [UseDbContext(typeof(ApiDbContext))]
        public async Task<AddSeriesPayload> DelSeriesAsync(int id, [ScopedService] ApiDbContext context)
        {
            var series = context.Series.Find(id);
            context.Series.Remove(series);
            await context.SaveChangesAsync();

            return new AddSeriesPayload(series);
        }

        [UseDbContext(typeof(ApiDbContext))]
        public async Task<AddSeriesPayload> UpdateSeriesAsync(UpdateSeriesInput input, [ScopedService] ApiDbContext context)
        {
            var series = context.Series.Find(input.id);
            series.Name = input.name;
            series.About = input.about;
            await context.SaveChangesAsync();

            return new AddSeriesPayload(series);
        }
    }

}