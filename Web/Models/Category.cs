using System.Collections.Generic;

namespace Models
{
    public class Category
    {
        public int Id { get; set; }
        public string Name { get; set; }

        public virtual ICollection<CategorySeries> Serieses { get; set; }
    }
}