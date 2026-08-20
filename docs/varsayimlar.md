# Varsayımlar

| ID | Tarih | Kategori | Varsayım | Gerekçe | Etki | Risk | Durum | Not |
|---|---|---|---|---|---|---|---|---|
| 001 | 11.08.2026 | İsimlendirme | Solution adının `ItsTool` olarak belirlenmesi. | Kısa, akılda kalıcı. | Düşük | Düşük | Onay Bekliyor | - |
| 002 | Backend | Mimari | Web API ve .NET katmanlı mimari kullanılması. | ITSM gereksinimlerini en iyi karşılayan endüstri standardı. | Yüksek | Orta | Açık | - |
| 003 | Veritabanı | Teknoloji | ORM olarak Entity Framework Core (PostgreSQL - Npgsql) seçilmesi. | .NET ekosisteminde PostgreSQL ile en uyumlu ORM'dir. | Yüksek | Düşük | Onay Bekliyor | - |
| 004 | Frontend | Teknoloji | SPA yerine saf Vanilla HTML, CSS, JS ve AJAX kullanılması. | Mimaride sadelik. | Çok Yüksek | Orta | Açık | - |
| 005 | Güvenlik | Kimlik Doğr. | Kimlik doğrulama için JWT (JSON Web Token) kullanılması. | API'nin stateless yapısını korumak. | Yüksek | Düşük | Açık | - |
| 006 | Mimari | Veri Yönetimi | Soft Delete yapısı (IsDeleted) ve temel Audit alanlarının (CreatedBy vb.) BaseEntity'de standart olması. | ITSM sistemlerinde veri izlenebilirliği. | Orta | Düşük | Onay Bekliyor | - |
| 007 | Ticket | İş Kuralları | Ticket numaralarının `{ProjectKey}-{Sequence}` (Örn: HELP-1001) formatında otomatik üretilmesi. | ITSM standardı. | Orta | Düşük | Onay Bekliyor | - |
| 008 | Organizasyon | Model | Departman ve Group'un ayrı tablolar olması. | İş birimi ile destek grubu ayrımı. | Orta | Düşük | Açık | - |
| 009 | Gelişmiş Özell.| Veri Saklama | Custom Field verilerinin MVP'de EAV (TicketFieldValues) olarak tutulması, JSONB'nin sadece metadata veya destekleyici olarak kullanılması. | JSONB tek depolama alanı yapıldığında sorgu zorlukları oluşmaması. | Yüksek | Orta | Kabul Edildi / Uygulandı | Faz 2B'de Domain eklendi. |
| 010 | Kurulum | İlk Veri | İlk migration ile DB'ye varsayılan bir "Super Admin" Seed edilmesi. | Sisteme ilk login ihtiyacı. | Düşük | Düşük | Açık | - |
| 011 | Geliştirme | Kapsam Dışı | Özellik bazında gerçek zamanlı Chat ve E-posta alma MVP kapsamında değil. | Çekirdeğe odaklanma. | Orta | Düşük | Açık | - |
| 012 | 11.08.2026 | Yol Haritası | Geliştirmenin 13 (Faz 0-12) ardışık faz olarak uygulanması. | Yönetilebilirlik. | Yüksek | Düşük | Açık | - |
| 013 | Geliştirme | Kapsam | Dinamik yapılandırmanın kontrollü tutulması; "Page Builder" yapılmaması. | Güvenlik açıkları. | Çok Yüksek | Yüksek | Kabul Edildi | MVP Ana Kuralı |
| 014 | Geliştirme | Öncelik | Bonus özelliklere geçilmeden temel MVP çekirdeğinin mutlaka tamamlanması. | Risk yönetimi. | Yüksek | Düşük | Kabul Edildi | - |
| 015 | Mimari | Ek Geliştirme| Bonus özelliklerin, çekirdek mimariyi bozmadan ayrı branchlerde eklenmesi. | Clean Architecture uyumu. | Orta | Düşük | Açık | - |
| 016 | Ortam | Framework | .NET versiyonu olarak .NET 8 LTS kullanılması. | Uzun vadeli destek ve modern özellikler. | Yüksek | Düşük | Onay Bekliyor | - |
| 017 | Veritabanı | İsimlendirme| Veritabanı adının `itsm_tool` olması. | Anlaşılırlık. | Düşük | Düşük | Onay Bekliyor | - |
| 018 | Veritabanı | Güvenlik | DB parolalarının repository'e eklenmemesi (appsettings'de placeholder). | Güvenlik ihlalini önlemek. | Yüksek | Düşük | Onay Bekliyor | - |
| 019 | Veritabanı | Migration | Migration dosyalarının (`Migrations/` klasöründeki .cs dosyaları) version control'de tutulması. | EF Core migration mimarisinin temel mantığıdır. | Yüksek | Düşük | Açık | Faz 2B eklendi |
| 024 | Kurulum | Seed Data | Sisteme ilk giriş için admin/Admin123! kullanıcısı ve temel ITSM config verileri API endpoint'i üzerinden seed edilecektir. | Login sisteminin test edilmesi ve temel ayarların yapılması. | Yüksek | Düşük | Kabul Edildi | API endpoint ile yapıldı. |
\n## Faz 4 Sonrası Quality Gate ve Coverage Kararı\nCoverage koşulu bilinçli olarak (şimdilik) kaldırıldı/indirildi; Faz 12'de (sistem ve entegrasyon testleri eklendiğinde) %80 koşulu geri eklenecektir.

## Audit Log Kapsamı (Faz 15/17 Kararı)
Sistemde loglama işlemleri aşağıdaki kapsama alınmıştır. İlke: "herkesin yaptığı her şey iz bırakır".
- **Ticket**: created/status/assign/reopen/UPDATED (alan bazlı old→new olarak loglanır, değişiklik olmayan alanlar loglanmaz) (`TicketHistory` tablosu).
- **Config**: rules/fields/workflows/sla/webhooks CRUD işlemleri ve toggle (Active/Inactive) hareketleri (`SystemAuditLog` tablosu).
- **User/Auth**: user/role/permission değişiklikleri; auth login başarılı/başarısız denemeleri.
- **Kapsam Dışı**: Read/Get (okuma) işlemleri loglanmaz. Bunun sebebi performans yükünü azaltmak ve sadece davranış değişikliği yaratan "State Mutation" (Durum değişimi) olaylarına odaklanmaktır.

## Status Semantiği (Faz 16 Kararı)
Sistemdeki statü geçişleri ve anlamları şu şekilde netleştirilmiştir:
- **Resolved (Çözüldü)**: Çözüm uygulandı, kullanıcının onayı veya geri bildirimi bekleniyor. Bilet hala "aktif" kabul edilir.
- **Closed (Kapalı)**: Bilet kesin olarak tamamlandı. Panodan (Kanban) gizlenir ancak silinmez. ITSM standartları ve audit bütünlüğü gereği biletler sadece "soft-archive" (Closed) durumuna çekilir, veri kaybı yaşanmaması için tamamen silinmez. Raporlarda ve ana listede görüntülenmeye devam eder.
