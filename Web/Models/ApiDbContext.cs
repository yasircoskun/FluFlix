using Microsoft.EntityFrameworkCore;

namespace Models {
    public class ApiDbContext : DbContext
    {
        public virtual DbSet<Series> Series {get;set;}
        public virtual DbSet<Category> Category {get;set;}
        public virtual DbSet<CategorySeries> CategorySeries {get;set;}
        public virtual DbSet<Episode> Episode {get;set;}
        public virtual DbSet<Season> Season {get;set;}

        public ApiDbContext(DbContextOptions<ApiDbContext> options)
            : base(options)
        { }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<CategorySeries>().HasKey(i => new { i.SeriesID, i.CategoryID });
            
            
            modelBuilder.Entity<Season>(entity =>
            {
                entity.HasOne(d => d.Series)
                    .WithMany(p => p.Seasons)
                    .HasForeignKey(d => d.SeriesID)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_Season_Series");
            });

            modelBuilder.Entity<Episode>(entity =>
            {
                entity.HasOne(d => d.Season)
                    .WithMany(p => p.Episodes)
                    .HasForeignKey(d => d.SeasonID)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_Episode_Season");
            });
        }
    }
}
