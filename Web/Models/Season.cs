using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace Models
{
    public class Season
    {
        [Key]
        public int Id { get; set; }
        public int Order { get; set; }
        public int SeriesID { get; set; }
        public Series Series { get; set; }

        public virtual ICollection<Episode> Episodes { get; set; }
    }
}