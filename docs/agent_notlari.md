# Agent Notları

## Proje Durumu
- **Aktif Faz:** Faz 2 (Veritabanı ve Seed Data İşlemleri)
- **Aktif Görev:** Seed Data ve DB Test altyapısı tamamlandı.
- **Sonraki Aksiyon:** Faz 3 (Auth ve Esnek Yetkilendirme Altyapısı).
- **Genel Durum:** Projenin "Configuration-Driven" olmasını sağlayan temel Domain yapısı (EAV, Workflow, SLA, KB) başarıyla eklendi. İlk migration (`InitialCreate`) üretildi. Ayrıca, sisteme temel config ve admin verilerini basacak DataSeeder ve bağlantı testi için SystemController oluşturuldu.

## Tamamlananlar
- [x] Ticket, Category, Status ve Priority modellerine dinamik özellikler (Renk, varsayılan vb.) eklendi.
- [x] Workflow ve Transition (Durum Geçişi) entity'leri kuruldu.
- [x] Custom Field'lar için EAV (Entity-Attribute-Value) modelini taşıyan `FieldDefinition`, `FieldOption`, `FormFieldPlacement` ve `TicketFieldValue` entity'leri yazıldı.
- [x] SLA, Notification ve Knowledge Base entity'leri oluşturuldu.
- [x] `ItsToolDbContext` güncellendi ve Fluent API ile Composite Index, SetNull/Restrict davranışları kodlandı.
- [x] Dokümantasyonlar ve Varsayımlar güncellendi.
- [x] Migration (`InitialCreate`) üretildi.

## Devam Edenler
- [ ] Faz 3 Auth ve Token operasyonları (Bir sonraki aşama).

## Oturum Logu
### [Seed Data ve Bağlantı Testi Oturumu]
- **Yapılanlar:** `ItsTool.Infrastructure` katmanına `BCrypt.Net-Next` kütüphanesi eklendi. Temel verileri (Ticket Type, Status, Priority, Department, Group, Admin User) veritabanına ekleyecek `DataSeeder` sınıfı yazıldı. `ItsTool.API` içinde `/api/system/seed` ve `/api/system/db-test` uç noktalarını sunan `SystemController` oluşturuldu. `Program.cs` güncellendi ve bu işlemler için Dependency Injection tamamlandı. BCrypt ile admin şifresi hash'lenerek sisteme kaydedildi.
- **Kararlar:** İlk girişin sağlanabilmesi ve configuration yapısının test edilebilmesi için API tabanlı seed yaklaşımı seçildi. Veriler `Any()` kontrolleriyle ezilme riski olmadan tasarlandı.

### [SonarQube Kalite Kapısı ve Maintainability Temizliği]
- **Yapılanlar:**
  - API ve Web projelerinde `app.Run()` kullanımları, asenkron ve bloklamayan `await app.RunAsync()` ile değiştirildi.
  - `ItsTool.API` projesindeki güvensiz `AllowAnyOrigin()` kullanımı kaldırılarak, origin listesi `appsettings.json` içerisindeki `Cors:AllowedOrigins` ayarından okunacak şekilde (`WithOrigins`) yapılandırıldı. Local development için Web projesinin portları (`http://localhost:5139`, `https://localhost:7181`) eklendi.
  - `SystemController` içerisindeki uç noktalara, Swagger dokümantasyon sözleşmesine uygun şekilde `[ProducesResponseType]` (200 ve 500) annotasyonları eklendi.
  - `ItsTool.Domain`, `ItsTool.Application`, `ItsTool.Infrastructure` katmanlarında yer alan boş şablon artığı `Class1.cs` dosyaları silinerek "Code Smell" bulguları giderildi.
- **Kararlar:** 
  - SonarQube'deki hardcoded credential hatası (S2068) User Secrets kullanılarak önceden çözüldü, migration kodlarına müdahale edilmemesi (CA1861) prensibi gereği otomatik üretilen migration dosyaları analiz dışı bırakıldı. Yeni çalışma modeli olan "ÖNER - BEKLE - DOĞRULA (chat-first)" benimsendi (istisna olarak bazı düzeltmeler doğrudan yapıldı).
- **Sonraki Adım:** SonarQube baseline tamamen temiz; repository Bitbucket push'a hazır. Bir sonraki aşamada "Faz 3 — Auth ve Esnek Yetkilendirme Altyapısı" kurulacaktır.
Phase 4 Organization CRUD and Phase 3 Unit Tests completed successfully.
