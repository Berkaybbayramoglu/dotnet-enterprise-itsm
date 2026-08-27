INSERT INTO "Permissions" ("Id", "Name", "Key", "IsActive", "IsDeleted", "CreatedAt")
VALUES
(19, 'Ticket Comment Internal', 'ticket.comment.internal', true, false, NOW()),
(20, 'Ticket Comment Edit', 'ticket.comment.edit', true, false, NOW()),
(21, 'Ticket Comment Reply', 'ticket.comment.reply', true, false, NOW())
ON CONFLICT ("Id") DO UPDATE SET "Name" = EXCLUDED."Name", "Key" = EXCLUDED."Key";

-- Assign to SuperAdmin Role (Id=1 usually)
INSERT INTO "RolePermissions" ("RoleId", "PermissionId", "IsActive", "IsDeleted", "CreatedAt")
VALUES
(1, 19, true, false, NOW()),
(1, 20, true, false, NOW()),
(1, 21, true, false, NOW()),
(2, 19, true, false, NOW()),
(2, 20, true, false, NOW()),
(2, 21, true, false, NOW())
ON CONFLICT DO NOTHING;
