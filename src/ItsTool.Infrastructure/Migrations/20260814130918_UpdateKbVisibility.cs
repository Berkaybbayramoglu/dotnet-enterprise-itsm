using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ItsTool.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class UpdateKbVisibility : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_TicketSlas_TicketId",
                table: "TicketSlas");

            migrationBuilder.AddColumn<int>(
                name: "Visibility",
                table: "KnowledgeArticles",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateIndex(
                name: "IX_TicketSlas_TicketId",
                table: "TicketSlas",
                column: "TicketId",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_TicketSlas_TicketId",
                table: "TicketSlas");

            migrationBuilder.DropColumn(
                name: "Visibility",
                table: "KnowledgeArticles");

            migrationBuilder.CreateIndex(
                name: "IX_TicketSlas_TicketId",
                table: "TicketSlas",
                column: "TicketId");
        }
    }
}
