using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace ItsTool.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class MultiAssignTree : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Tickets_Groups_AssignedGroupId",
                table: "Tickets");

            migrationBuilder.DropForeignKey(
                name: "FK_Tickets_Users_AssignedUserId",
                table: "Tickets");

            migrationBuilder.DropIndex(
                name: "IX_Tickets_AssignedGroupId",
                table: "Tickets");

            migrationBuilder.DropIndex(
                name: "IX_Tickets_AssignedUserId",
                table: "Tickets");

            migrationBuilder.DropColumn(
                name: "AssignedGroupId",
                table: "Tickets");

            migrationBuilder.DropColumn(
                name: "AssignedUserId",
                table: "Tickets");

            migrationBuilder.AddColumn<int>(
                name: "ManagerUserId",
                table: "Departments",
                type: "integer",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "TicketAssignments",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    TicketId = table.Column<int>(type: "integer", nullable: false),
                    AssignedUserId = table.Column<int>(type: "integer", nullable: true),
                    AssignedGroupId = table.Column<int>(type: "integer", nullable: true),
                    ParentAssignmentId = table.Column<int>(type: "integer", nullable: true),
                    AssignedByUserId = table.Column<int>(type: "integer", nullable: false),
                    IsActive = table.Column<bool>(type: "boolean", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    CreatedBy = table.Column<string>(type: "text", nullable: true),
                    UpdatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    UpdatedBy = table.Column<string>(type: "text", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    DeletedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_TicketAssignments", x => x.Id);
                    table.ForeignKey(
                        name: "FK_TicketAssignments_Groups_AssignedGroupId",
                        column: x => x.AssignedGroupId,
                        principalTable: "Groups",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_TicketAssignments_TicketAssignments_ParentAssignmentId",
                        column: x => x.ParentAssignmentId,
                        principalTable: "TicketAssignments",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_TicketAssignments_Tickets_TicketId",
                        column: x => x.TicketId,
                        principalTable: "Tickets",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_TicketAssignments_Users_AssignedByUserId",
                        column: x => x.AssignedByUserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_TicketAssignments_Users_AssignedUserId",
                        column: x => x.AssignedUserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Departments_ManagerUserId",
                table: "Departments",
                column: "ManagerUserId");

            migrationBuilder.CreateIndex(
                name: "IX_TicketAssignments_AssignedByUserId",
                table: "TicketAssignments",
                column: "AssignedByUserId");

            migrationBuilder.CreateIndex(
                name: "IX_TicketAssignments_AssignedGroupId",
                table: "TicketAssignments",
                column: "AssignedGroupId");

            migrationBuilder.CreateIndex(
                name: "IX_TicketAssignments_AssignedUserId",
                table: "TicketAssignments",
                column: "AssignedUserId");

            migrationBuilder.CreateIndex(
                name: "IX_TicketAssignments_ParentAssignmentId",
                table: "TicketAssignments",
                column: "ParentAssignmentId");

            migrationBuilder.CreateIndex(
                name: "IX_TicketAssignments_TicketId",
                table: "TicketAssignments",
                column: "TicketId");

            migrationBuilder.AddForeignKey(
                name: "FK_Departments_Users_ManagerUserId",
                table: "Departments",
                column: "ManagerUserId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Departments_Users_ManagerUserId",
                table: "Departments");

            migrationBuilder.DropTable(
                name: "TicketAssignments");

            migrationBuilder.DropIndex(
                name: "IX_Departments_ManagerUserId",
                table: "Departments");

            migrationBuilder.DropColumn(
                name: "ManagerUserId",
                table: "Departments");

            migrationBuilder.AddColumn<int>(
                name: "AssignedGroupId",
                table: "Tickets",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "AssignedUserId",
                table: "Tickets",
                type: "integer",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Tickets_AssignedGroupId",
                table: "Tickets",
                column: "AssignedGroupId");

            migrationBuilder.CreateIndex(
                name: "IX_Tickets_AssignedUserId",
                table: "Tickets",
                column: "AssignedUserId");

            migrationBuilder.AddForeignKey(
                name: "FK_Tickets_Groups_AssignedGroupId",
                table: "Tickets",
                column: "AssignedGroupId",
                principalTable: "Groups",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Tickets_Users_AssignedUserId",
                table: "Tickets",
                column: "AssignedUserId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);
        }
    }
}
