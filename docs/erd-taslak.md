# Üst Seviye PostgreSQL ERD Taslağı

Aşağıda ITSM Tool'un ana veri tabloları ve birbirleri arasındaki mantıksal ilişkiler özetlenmiştir.

## Organizasyon
*(Faz 2A kapsamında kodlandı)*
- **Departments:** Şirket içi departmanlar.
- **Groups:** Departmana bağlı çalışma grupları.
- **Users:** Sistem kullanıcıları.
- **GroupMembers:** Hangi kullanıcının hangi gruba dahil olduğu.

## Yetki ve Roller
*(Faz 2A kapsamında kodlandı)*
- **Roles:** Sistemdeki rol isimleri (Admin, Agent vb.).
- **Permissions:** Sistemdeki detaylı yetki listesi.
- **RolePermissions:** Rol - Yetki eşleşmesi.
- **UserRoles:** Kullanıcı - Rol eşleşmesi.
- **GroupRoles:** Grup - Rol eşleşmesi.
- **UserPermissionOverrides:** Kullanıcıya özel izin eklentisi veya kısıtlaması.
- **ProjectUserPermissions:** *(Planlandı)* Belirli bir projede kullanıcının/grubun yetkileri.

## Proje ve Konfigürasyon
*(Faz 2B kapsamında kodlandı)*
- **Projects:** Sistemdeki bağımsız çalışma alanları (ProjectKey içerir).
- **ProjectMembers:** Projeye dahil olan kullanıcılar.
- **Categories:** Proje altındaki talep sınıfları.
- **TicketTypes:** Incident, Request gibi kayıt türleri.
- **Statuses:** Talebin konumu (Açık, Kapalı).
- **Priorities:** Talebin aciliyeti.
- **Workflows & WorkflowTransitions:** Durum geçiş kuralları (Kim hangi durumdan hangisine geçebilir).
- **FieldDefinitions & FieldOptions:** Dinamik form alan tanımları (EAV - Entity-Attribute-Value modeli için Attribute tanımı).
- **FormFieldPlacements:** Hangi alının hangi form/projede çıkacağını belirler.

## Ticket (Talep) Çekirdeği
*(Faz 2B kapsamında kodlandı)*
- **Tickets:** Ana talep tablosu (Proje, kategori, durum, atama FK'ları).
- **TicketHistory:** Bilet üzerindeki değişikliklerin audit logu.
- **TicketFieldValues:** Dinamik alan verileri (EAV yapısındaki Value tablosu. TicketId ve FieldDefinitionId composite unique key'dir).

*(Planlandı)*
- **TicketComments:** Taleplere girilen yorumlar.
- **TicketAttachments:** Talebe veya yoruma bağlı dosyalar.
- **TicketTransfers / TicketAssignments:** Atama tarihçesi.

## SLA (Hizmet Seviyesi)
*(Faz 2B kapsamında kodlandı)*
- **SlaPolicies:** Proje/Öncelik bazlı hedef süreler (Name, Description vb).
- **SlaTargets:** First Response, Resolution hedefleri.
- **BusinessHours / Holidays:** Tatil günleri ve mesai takvimleri.

## Bildirim
*(Faz 2B kapsamında kodlandı)*
- **Notifications:** Uygulama içi veya e-posta bildirimleri.
- **NotificationRules:** Bildirim kuralları (Örn: "ticket.created" -> "Admin").

## Knowledge Base (Bilgi Bankası)
*(Faz 2B kapsamında kodlandı)*
- **KnowledgeCategories:** KB makale hiyerarşisi.
- **KnowledgeArticles:** Makaleler.

## EAV ve Workflow Mimarisi Notu:
EAV (Entity-Attribute-Value) modeli `TicketFieldValues` üzerinden kurgulanmış olup, her ticket için ilgili custom alan değeri burada esnek olarak saklanır. Arama/filtreleme hızını korumak için metadata olarak veritabanında indexli JSONB desteği ileride entegre edilecektir. Workflow sistemi ise durumlar arası geçişte yetki ve kısıtlamaları doğrudan `WorkflowTransitions` tablosu ile yönetmektedir.
