using System.Collections.Generic;
using System.Linq;
using HotChocolate;
using HotChocolate.Types;

namespace Models
{
    public class Series
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string About { get; set; }
        public string posterURL { get; set; }

        public virtual ICollection<CategorySeries> Categories { get; set; }
        public virtual ICollection<Season> Seasons { get; set; }
    }



}