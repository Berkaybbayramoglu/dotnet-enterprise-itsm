using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ItsTool.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddDepartmentColor : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Color",
                table: "Departments",
                type: "text",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Color",
                table: "Departments");
        }
    }
}
