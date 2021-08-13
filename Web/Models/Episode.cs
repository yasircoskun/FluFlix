namespace Models
{
    public class Episode
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int Order { get; set; }
        public string StreamLink { get; set; }
        public string Resource { get; set; }
        public int SeasonID { get; set; }
        public Season Season { get; set; }
    }
}