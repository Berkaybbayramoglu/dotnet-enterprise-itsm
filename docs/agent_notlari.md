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

### [Faz 8 - Static Files & Frontend Routing Fix]
- **Yapılanlar:** `ItsTool.Web/Program.cs` içerisindeki "Hello World" minimal API mapping'i kaldırıldı. Yerine `app.UseDefaultFiles()` (kök dizini index.html'e yönlendirir) ve `app.UseStaticFiles()` (wwwroot içeriklerini sunar) middleware'leri eklendi. `wwwroot/index.html` dosyası oluşturuldu ve localStorage içindeki JWT token'a bakarak `/login.html` veya `/dashboard.html`'e yönlendirme yapan basit bir mekanizma eklendi. Frontend API base URL'i API'nin HTTP portu olan `5246`'ya hizalandı (gerekirse HTTPS portuna geri alınabilir, CORS uyumlu).
- **Kararlar:** Middleware pipeline sıralaması (pipeline ordering) gözetilerek `UseDefaultFiles` metodu `UseStaticFiles` metodundan önce çağrıldı; bu sayede "/" adresine yapılan isteklerin başarıyla index.html üzerinden sunulması sağlandı.
- **Sonraki Adım:** Uygulamanın frontend ve backend bağlantısı yerel portlar üzerinden tam sağlandı. Faz 9 işlemlerine geçilebilir.

### [Faz 8 - HTML5 Validation & Login Sözleşmesi Fix]
- **Yapılanlar:** Frontend'deki katı `type="email"` doğrulaması `type="text"` olarak değiştirilerek Username (örn: admin) girişlerine izin verildi ve `autocomplete="username"` eklendi. Backend `AuthService.LoginAsync` içerisinde sadece `Username` bazlı yapılan sorgu, `(Username == input OR Email == input)` şeklinde (case-insensitive) genişletilerek hem e-posta hem de kullanıcı adıyla giriş yapma imkanı sağlandı. `api.js` içerisindeki payload parametresi `email`'den `username`'e dönüştürülerek backend `LoginRequestDto` modeliyle tam uyumlu hale getirildi. Bu akışı doğrulayan yeni bir Unit Test yazıldı.
- **Kararlar:** HTML5'in client-side validation özelliklerinin, esnek backend tasarımlarını engellememesi adına doğru input type (text) seçildi; erişilebilirliği korumak için gerekli yapılandırmalar (label ve autocomplete) eklendi.
- **Sonraki Adım:** Login mekanizması esnetildi ve hatasız çalışıyor. Faz 9 görevlerine başlanabilir.

### [Faz 8 - Dashboard Frontend-Backend Veri Kontratı Fix]
- **Yapılanlar:** `dashboard.html` içerisindeki KPI kartlarında verilerin "undefined" olarak gözükmesi (özellikle `slaBreachedCount`, `slaRiskCount` ve `unassignedCount` isimleri yüzünden) sorunu giderildi. Backend tarafında tanımlı `DashboardOverviewDto` içindeki property'lerin JSON çıktısındaki camelCase isimleri baz alınarak (örn. `slaBreachedTickets`) JS kısmı güncellendi. JavaScript'teki template literal'lara nullish coalescing operator `(deger ?? 0)` ile defensive rendering eklendi, böylece değerlerin eksik gelme durumunda "undefined" veya "null" basılması engellendi.
- **Kararlar:** API'nin geriye döndürdüğü DTO modeli "Single Source of Truth" kabul edildi ve frontend kodu bu kontrata hizalandı. Unit testlere de `GetOverviewAsync` metodu üzerinden bilet olmadığında 0 döndüğünü teyit eden bir test (`GetOverviewAsync_ShouldReturnZeros_WhenNoTickets`) eklendi. Tüm testlerin "YEŞİL" statüsü doğrulandı.
### [Faz 9 - Gelişmiş Dinamik Yapılandırma]
- **Yapılanlar:** `AssignmentRule` ve `SavedFilter` domain nesneleri ve veritabanı tabloları eklendi (`AddPhase9Entities` migration'ı oluşturuldu). `AssignmentEngine` yazılarak `TicketService` oluşturma sürecine entegre edildi, bilet açıldığında ilk eşleşen kurala göre otomatik grup/kullanıcı ataması yapıyor. `NotificationDispatcher` yaratıldı ve bilet olaylarına (Oluşturma, Atama, Yorum) bağlanıp duplicate kontrolü yaparak `NotificationRule` yapısı üzerinden bildirim üretmesi sağlandı. `SavedFilterController` yazılarak kullanıcıların arama filtrelerini kaydetmeleri ve yönetmeleri API'a eklendi. Ön tarafta `ticket-create.html` (Dinamik alan render'ı ile), `rules.html` (Atama kuralları) ve `admin-fields.html` (Özel alan yönetimi) sayfaları `api.js` kullanılarak eklendi ve `tickets.html` kaydedilmiş filtreleri yönetecek şekilde güncellendi.
- **Kararlar:** Kural motorları için Dependency Injection ile `IAssignmentEngine` ve `INotificationDispatcher` servisleri doğrudan `TicketService` içerisine yerleştirildi. Veritabanı sorgularının hafif tutulması için Notification'da `ProjectMembers` doğrudan sorgulandı. Dinamik formlarda frontend XSS güvenliği `textContent` ve `escapeHtml` ile sağlandı. 62 adet test yazıldı ve testler yeşil (Passed).
- **Sonraki Adım:** Faz 9 görevleri başarıyla tamamlandı. Artık Faz 10'a (Bonus Özellikler: Kanban Görünümü, Audit Log Ekranı, CSAT) geçilebilir.

### [Faz 10 - Bonus Özellikler Dalgası]
- **Yapılanlar:** `audit.view` izni ve AuditLog API/UI yapısı kuruldu; geçmiş (TicketHistory) detaylı şekilde listeleniyor. Kanban görünümü eklendi; sürükle bırak (drag-and-drop) ile statü değişimi sağlandı. Kullanıcı anketleri (CSAT) için `TicketSurvey` entitiy'si oluşturuldu, veritabanı migration'ı yapıldı. Bilet kapatıldığında CSAT davet bildirimi gidecek şekilde TicketService'e entegre edildi. CSAT puanları DashboardOverview'da gösterildi. 66 adet unit test çalıştırıldı ve hepsi geçti.
- **Kararlar:** Kanban drag-and-drop işleminde arka planda `POST /api/tickets/{id}/status` çağrıldı. `TicketService` içerisindeki mevcut rol/yetki mekanizması tekrar kullanılarak ekstra kontrol yazmaktan kaçınıldı (DRY prensibi). Yeni `TicketSurvey`'ler db'ye eklendi.
- **Sonraki Adım:** Faz 10 görevleri başarıyla tamamlandı. Artık Faz 11'e (Gelişmiş İş Kuralları ve Entegrasyonlar) geçilebilir. Kullanıcı SonarQube taramasını Faz 11 sonunda yapacak.
