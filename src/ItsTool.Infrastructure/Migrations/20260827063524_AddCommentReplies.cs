using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ItsTool.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddCommentReplies : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "IsEdited",
                table: "TicketComments",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<int>(
                name: "ParentCommentId",
                table: "TicketComments",
                type: "integer",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_TicketComments_ParentCommentId",
                table: "TicketComments",
                column: "ParentCommentId");

            migrationBuilder.AddForeignKey(
                name: "FK_TicketComments_TicketComments_ParentCommentId",
                table: "TicketComments",
                column: "ParentCommentId",
                principalTable: "TicketComments",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_TicketComments_TicketComments_ParentCommentId",
                table: "TicketComments");

            migrationBuilder.DropIndex(
                name: "IX_TicketComments_ParentCommentId",
                table: "TicketComments");

            migrationBuilder.DropColumn(
                name: "IsEdited",
                table: "TicketComments");

            migrationBuilder.DropColumn(
                name: "ParentCommentId",
                table: "TicketComments");
        }
    }
}
