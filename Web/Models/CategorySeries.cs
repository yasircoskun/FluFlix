using HotChocolate.Types;

namespace Models
{
    public class CategorySeries
    {
        public int SeriesID { get; set; }
        public Series Series { get; set; }
        public int CategoryID { get; set; }
        public Category Category { get; set; }
    }
}