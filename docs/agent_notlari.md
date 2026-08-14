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
- Faz 7 refactor sırasında SLA Engine içerisindeki saf metotlar (`ApplyPause`, `EvaluateMetric`) SonarQube uyarısıyla `static` yapıldı, pure function pratikleri uygulandı.

### [Faz 8 - Frontend A11y & Readability Fixes]
- **Yapılanlar:** `wwwroot` altındaki `tickets.html`, `dashboard.html` ve `kb.html` dosyalarında yer alan ve SonarQube tarafından Accessibility (a11y) bulgusu olarak işaretlenen hatalar giderildi. Aksiyonlar için kullanılan `<a>` etiketleri semantik `<button type="button">` elementleriyle değiştirildi. Input elemanlarına `aria-label` eklendi, `<span onclick="">` gibi klavye gezinimini (keyboard navigation) bozan elemanlar natif elementlere çevrildi. Boş kalan başlık (heading) etiketleri default "Loading..." metinleriyle dolduruldu. JS dosyasındaki `replace(/.../g, ...)` kullanımları okunabilirlik açısından `replaceAll` ile refactor edildi.
- **Kararlar:** WCAG standartlarına ve ekran okuyucu uyumluluğuna sadık kalındı. Backend kodlarına veya işlevsel akışa dokunulmadan sadece DOM ağacı onarıldı.
- **Sonraki Adım:** Faz 9 (Gelişmiş Dinamik Yapılandırma) görevlerine başlanabilir.

### [Faz 8 - Konfigürasyon Senkronizasyonu (Config Drift Fix)]
- **Yapılanlar:** `ItsToolDbContextFactory` içerisinde hardcoded olarak bulunan connection string, Single Source of Truth prensibine uyarak `ItsTool.API` projesinin `appsettings.json` dosyasından okunacak şekilde (ConfigurationBuilder ile) dinamikleştirildi. `Microsoft.Extensions.Configuration.Json` ve `EnvironmentVariables` paketleri eklendi. Frontend uygulamasındaki (`api.js`) API endpoint adresi, backend'in `launchSettings.json` içindeki `https` portuyla (7204) eşleştirildi. CORS izinlerinin zaten doğru olduğu doğrulandı.
- **Kararlar:** API ve design-time migration işlemlerinin veritabanı ayarlarını tek bir kaynaktan yönetmesi sağlandı. Manuel ortam çalıştırmalarında (dotnet run) port mismatch sorunları engellendi.
- **Sonraki Adım:** Uygulama tam entegre çalışmaktadır. Testler yeşildir. Faz 9'a hazırız.
