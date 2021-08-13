using Microsoft.EntityFrameworkCore.Migrations;

namespace FluFlix.Migrations
{
    public partial class posterURL : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "posterURL",
                table: "Series",
                type: "nvarchar(max)",
                nullable: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "posterURL",
                table: "Series");
        }
    }
}
