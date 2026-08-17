using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace ItsTool.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddPhase9Entities : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "AssignmentRules",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Name = table.Column<string>(type: "text", nullable: false),
                    ProjectId = table.Column<int>(type: "integer", nullable: true),
                    CategoryId = table.Column<int>(type: "integer", nullable: true),
                    TicketTypeId = table.Column<int>(type: "integer", nullable: true),
                    PriorityId = table.Column<int>(type: "integer", nullable: true),
                    TargetGroupId = table.Column<int>(type: "integer", nullable: true),
                    TargetUserId = table.Column<int>(type: "integer", nullable: true),
                    SortOrder = table.Column<int>(type: "integer", nullable: false),
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
                    table.PrimaryKey("PK_AssignmentRules", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AssignmentRules_Categories_CategoryId",
                        column: x => x.CategoryId,
                        principalTable: "Categories",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_AssignmentRules_Groups_TargetGroupId",
                        column: x => x.TargetGroupId,
                        principalTable: "Groups",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_AssignmentRules_Priorities_PriorityId",
                        column: x => x.PriorityId,
                        principalTable: "Priorities",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_AssignmentRules_Projects_ProjectId",
                        column: x => x.ProjectId,
                        principalTable: "Projects",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_AssignmentRules_TicketTypes_TicketTypeId",
                        column: x => x.TicketTypeId,
                        principalTable: "TicketTypes",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_AssignmentRules_Users_TargetUserId",
                        column: x => x.TargetUserId,
                        principalTable: "Users",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "SavedFilters",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    UserId = table.Column<int>(type: "integer", nullable: false),
                    Name = table.Column<string>(type: "text", nullable: false),
                    QueryJson = table.Column<string>(type: "text", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    CreatedBy = table.Column<string>(type: "text", nullable: true),
                    UpdatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    UpdatedBy = table.Column<string>(type: "text", nullable: true),
                    IsActive = table.Column<bool>(type: "boolean", nullable: false),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    DeletedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_SavedFilters", x => x.Id);
                    table.ForeignKey(
                        name: "FK_SavedFilters_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_AssignmentRules_CategoryId",
                table: "AssignmentRules",
                column: "CategoryId");

            migrationBuilder.CreateIndex(
                name: "IX_AssignmentRules_PriorityId",
                table: "AssignmentRules",
                column: "PriorityId");

            migrationBuilder.CreateIndex(
                name: "IX_AssignmentRules_ProjectId",
                table: "AssignmentRules",
                column: "ProjectId");

            migrationBuilder.CreateIndex(
                name: "IX_AssignmentRules_TargetGroupId",
                table: "AssignmentRules",
                column: "TargetGroupId");

            migrationBuilder.CreateIndex(
                name: "IX_AssignmentRules_TargetUserId",
                table: "AssignmentRules",
                column: "TargetUserId");

            migrationBuilder.CreateIndex(
                name: "IX_AssignmentRules_TicketTypeId",
                table: "AssignmentRules",
                column: "TicketTypeId");

            migrationBuilder.CreateIndex(
                name: "IX_SavedFilters_UserId",
                table: "SavedFilters",
                column: "UserId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AssignmentRules");

            migrationBuilder.DropTable(
                name: "SavedFilters");
        }
    }
}
