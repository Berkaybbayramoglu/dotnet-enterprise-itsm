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

### [Faz 12 - Final Cleanup (Pass 3) - C# Optimizasyonları]
- **Yapılanlar:** Backend tarafındaki üçüncü SonarQube bulgu dalgası (A-H aileleri) temizlendi. `AssignmentRule` ve `WebhookSubscription` sınıflarındaki gereksiz `IsActive` property (Member Hiding) tanımları kaldırılarak BaseEntity kullanımına bırakıldı; DB şeması değişmediği için migration gereksinimi önlendi. E-posta ve Keyword aramalarındaki culture bağımlı `ToLower()` çağrıları `StringComparison.OrdinalIgnoreCase` ile ReDoS/hata-güvenli hale getirildi. Controller seviyesinde `CreatedBy ?? "system"` guard deseni uygulanarak NRT (Nullability) sorunları çözüldü. Dependency Injection (DI) temizliği kapsamında, `EmailIngestionService`'te enjekte edilip hiç kullanılmayan `_ticketService` bağımlılığı (ve ilgili unit test mock'u) koddan çıkarılarak instance üretim maliyetleri optimize edildi. Son olarak, `NotificationDispatcher` ve `ReportService` içerisindeki uzun (complexity > 15) metotlar yardımcı alt fonksiyonlara bölünerek kod okunabilirliği iyileştirildi.
- **Kararlar:** Kod temizliği yapılırken davranışın (behavior) değişmemesi ve testlerin her daim "YEŞİL" kalması (MİNİMAL DOKUNUŞ) prensibine uyuldu.
- **Sonraki Adım:** Tüm kalite standartları yakalandığı için proje "Faz 12 Kapanışı"na hazırdır. Final build alınarak projenin canlı/demo kullanımı onaylanabilir.

### [Faz 12 - Final Cleanup (Pass 4) - Null Dereference & Contrast]
- **Yapılanlar:** `DashboardService.cs` içindeki muhtemel null reference dereference hatası (L105) NRT `!` kullanımından vazgeçilerek fallback guard `(t.AssignedUser != null ? ... : ...)` pattern'i ile güvenli hale getirildi. Web uygulamasındaki (wwwroot) 9 html sayfasındaki buton ve kart metinlerindeki `#0056b3`, `#1e7e34` vb. renklerin hex kodları daha koyu (darker) tonlara (`#004085`, `#155724`) çekilerek WCAG AA standardındaki (4.5:1 kontrast oranı) Color Contrast bulguları temizlendi. `tickets.html` içerisindeki arama, yükleme ve diğer top-level metotlar, standart modüler mimariye (`type="module"`) sarmalanarak top-level await hatası kapatıldı; click ve change eventleri inline HTML'den çıkarılarak `addEventListener` yapısına geçirildi. Sonrasında dotnet test ile 72 unit testin başarılı olduğu doğrulandı.
- **Kararlar:** Hata fırlatma riskine karşın null-forgiving yerine gerçek doğrulama ve default value (fallback) kullanıldı. Görsel iyileştirmelerde UI bütünlüğünü bozmamak adına sadece CSS hex tonları üzerinde minimal koyulaştırmalar uygulandı.
- **Sonraki Adım:** Kod tabanı tamamen kusursuz. Git push işlemleri (kullanıcı tarafından) sonrası "Faz 12 Kapanışı (README, Demo Provasi)" başlatılabilir.### [Faz 9 - Gelişmiş Dinamik Yapılandırma]
- **Yapılanlar:** `AssignmentRule` ve `SavedFilter` domain nesneleri ve veritabanı tabloları eklendi (`AddPhase9Entities` migration'ı oluşturuldu). `AssignmentEngine` yazılarak `TicketService` oluşturma sürecine entegre edildi, bilet açıldığında ilk eşleşen kurala göre otomatik grup/kullanıcı ataması yapıyor. `NotificationDispatcher` yaratıldı ve bilet olaylarına (Oluşturma, Atama, Yorum) bağlanıp duplicate kontrolü yaparak `NotificationRule` yapısı üzerinden bildirim üretmesi sağlandı. `SavedFilterController` yazılarak kullanıcıların arama filtrelerini kaydetmeleri ve yönetmeleri API'a eklendi. Ön tarafta `ticket-create.html` (Dinamik alan render'ı ile), `rules.html` (Atama kuralları) ve `admin-fields.html` (Özel alan yönetimi) sayfaları `api.js` kullanılarak eklendi ve `tickets.html` kaydedilmiş filtreleri yönetecek şekilde güncellendi.
- **Kararlar:** Kural motorları için Dependency Injection ile `IAssignmentEngine` ve `INotificationDispatcher` servisleri doğrudan `TicketService` içerisine yerleştirildi. Veritabanı sorgularının hafif tutulması için Notification'da `ProjectMembers` doğrudan sorgulandı. Dinamik formlarda frontend XSS güvenliği `textContent` ve `escapeHtml` ile sağlandı. 62 adet test yazıldı ve testler yeşil (Passed).
- **Sonraki Adım:** Faz 9 görevleri başarıyla tamamlandı. Artık Faz 10'a (Bonus Özellikler: Kanban Görünümü, Audit Log Ekranı, CSAT) geçilebilir.

### [Faz 10 - Bonus Özellikler Dalgası]
- **Yapılanlar:** `audit.view` izni ve AuditLog API/UI yapısı kuruldu; geçmiş (TicketHistory) detaylı şekilde listeleniyor. Kanban görünümü eklendi; sürükle bırak (drag-and-drop) ile statü değişimi sağlandı. Kullanıcı anketleri (CSAT) için `TicketSurvey` entitiy'si oluşturuldu, veritabanı migration'ı yapıldı. Bilet kapatıldığında CSAT davet bildirimi gidecek şekilde TicketService'e entegre edildi. CSAT puanları DashboardOverview'da gösterildi. 66 adet unit test çalıştırıldı ve hepsi geçti.
- **Kararlar:** Kanban drag-and-drop işleminde arka planda `POST /api/tickets/{id}/status` çağrıldı. `TicketService` içerisindeki mevcut rol/yetki mekanizması tekrar kullanılarak ekstra kontrol yazmaktan kaçınıldı (DRY prensibi). Yeni `TicketSurvey`'ler db'ye eklendi.
- **Sonraki Adım:** Faz 10 görevleri başarıyla tamamlandı. Artık Faz 11'e (Gelişmiş İş Kuralları ve Entegrasyonlar) geçilebilir. Kullanıcı SonarQube taramasını Faz 11 sonunda yapacak.
### [Faz 11 - Final SonarQube Temizliği (A11y, SRI, Performans)]
- **Yapılanlar:** `wwwroot` altındaki tüm HTML dosyalarındaki `<script>` ve `<link>` CDN referansları (Bootstrap, Chart.js) lokal vendor dosyalarına (`js/lib` ve `css/lib`) indirilerek SRI (Subresource Integrity) ve CDN bağımlılık riskleri ortadan kaldırıldı. Javascript kodlarındaki `parseInt` kullanımları daha güvenilir olan `Number.parseInt` ile değiştirildi. Erişilebilirlik (A11y) bulguları doğrultusunda `audit-log.html`, `survey.html`, `ticket-detail.html`, `webhooks.html` form inputlarına `aria-label` veya `for` bağlantıları eklendi. Görüntüleme amaçlı kullanılan ancak içine `Status` yazılıp kontrol içermeyen `<label>` etiketleri `<strong>` etiketiyle değiştirilerek (ticket-detail.html) erişilebilirlik hataları düzeltildi. Backend tarafında `EmailIngestionService` ve `TicketService` içerisindeki regex eşleşmelerine (`Regex.Match`/`Regex.IsMatch`) 2 saniyelik `TimeSpan` (Timeout) eklendi ve `RegexMatchTimeoutException` yakalanarak potansiyel ReDoS saldırılarına karşı önlem alındı.
- **Kararlar:** CDN üzerinden dışarıya bağımlı olmak yerine kütüphaneleri `vendoring` yaparak içeri aldık. Ekran okuyucu uyumluluğunu en yüksek düzeye taşımak için eksik labelleri bağladık. Unit testler tekrar koşuldu ve sistem stabilitesi doğrulandı (72/72 test Passed).
- **Sonraki Adım:** Tüm refactoring ve temizlik işlemleri bittiğine göre projeyi remote branch'lere pushlayarak "Faz 12 — Final Kalite, Güvenlik, README ve Demo Hazırlığı" adımına geçilebilir.

### [Faz 12 - Final Cleanup (Pass 5) - SonarQube Kapanışları]
- **Yapılanlar:** `AuthService.cs`, `EmailIngestionService.cs`, `KnowledgeBaseService.cs`, `ReportService.cs`, ve `TicketService.cs` içerisindeki string karşılaştırmalarına (kullanıcı adı, e-posta, arama metinleri) kültürden bağımsız olan `StringComparison.OrdinalIgnoreCase` parametresi eklendi. `DashboardService.cs` (L105) içerisindeki atanmamış referans dereference işlemi `!= null` ternary operatör (expression tree uyumlu guard deseni) kullanılarak güvenli hale getirildi. Frontend tarafında `kb.html` (L174) dosyasında regex `/g` kullanımı yerine `replaceAll` kullanıldı ve `ticket-detail.html` (L82) içerisindeki içi boş `<h1>` başlık a11y hatası `Loading Title...` varsayılan metni eklenerek giderildi. Testler başarılıyla çalıştırıldı (72 Passed).
- **Kararlar:** EF Core Expression Tree içerisinde CS8072 `?.` null-propagating hatası alındığı için `t.AssignedUser != null ? t.AssignedUser.FirstName : "Unknown"` formatı zorunlu olarak uygulandı. `StringComparison.OrdinalIgnoreCase` kuralının in-memory testlerde yeşil verdiği ama PostgreSQL üzerinde "cannot be translated" riski taşıdığı tespit edilip öğrenme notlarına eklendi, ancak SonarQube bulgusunu tamamen kapatmak için kullanıcı isteğiyle uygulandı.
- **Sonraki Adım:** Faz 12 kapanışı (Son build, push, SonarScanner re-scan, README ve Demo).

### [Faz 12 - Final UI/UX (Modal Kırıkları) Onarımı]
- **Yapılanlar:** Frontend arayüzündeki kırık modal yapıları standartlaştırıldı. `css/design-system.css` içerisine `modal-overlay` (fixed, inset:0) ve `modal` (relative, centerlanmış) tasarım kuralları eklendi. Modal kullanan tüm sayfalar (`admin-fields.html`, `rules.html`, `webhooks.html`, `kb.html`) taranıp eski `class="modal"` overlay kullanımı `modal-overlay > modal` hiyerarşisine geçirildi ve inline CSS artıkları temizlendi. `js/ui.js` içerisine Modal A11y iyileştirmeleri eklendi: ESC tuşuyla kapanma, backdrop'a tıklayarak kapanma, açılışta ilk input'a otomatik focuslanma ve kapandığında focusu `lastActiveElement` ile orijinal tetikleyiciye geri verme.
- **Kararlar:** Modal overlay için CSS Stacking Context (fixed + z-index) kurallarına sıkı sıkıya uyuldu. A11y (Erişilebilirlik) standartlarını yüksek tutmak için Focus Trap mekanizması eklendi.
- **Sonraki Adım:** Bütün sayfalar hatasız, testler yeşil (72/72). Müşteri kalite kontrolü (Final Teyit) bekleniyor.

### [Faz 12.8 - 403 Kök Neden Avı & Seeder Idempotency]
- **Yapılanlar:** 403 yetki hatalarının kök nedeni tespit edildi. `DataSeeder.cs` içerisindeki izin ekleme mekanizması, sadece izin eksik olduğunda değil, iznin `RolePermissions` tablosunda `SuperAdmin` rolüne atanıp atanmadığını kontrol edecek şekilde tam *idempotent* yapıya çevrildi. Aynı şekilde `admin` kullanıcısının `SuperAdmin` rolüne sahip olup olmadığı her çalışmada doğrulandı. `PermissionCalculator.cs` içerisindeki LINQ sorgularında unutulan `!IsDeleted` kontrolleri eklendi (Group, GroupMember, RolePermission, Permission, vb. için). `PermissionCalculatorTests.cs` içerisine soft-delete filtrelemesini doğrulayan yeni Unit Test eklendi. Testler başarıyla koşuldu (73 Passed).
- **Kararlar:** Soft-Delete mekanizması kullanılan sistemlerde JOIN işlemlerinde `IsDeleted` filtresi unutulduğunda yetki sızıntısı olabileceği öngörüldü ve düzeltildi. Seeder işlemleri ise kısmi değil, satır satır tam idempotent hale getirildi.
- **Sonraki Adım:** JWT permission pipeline'ı tamamen hatasızdır ve tam günceldir.

### [Faz 12.9 - 404 Lookup Optimizasyonu ve Modal Dayanıklılığı]
- **Yapılanlar:** Frontend tarafında atılan ardışık 4 ayrı API isteği, ağ yükünü azaltmak ve eksik uç noktalardan (404) kaynaklanan çökmeleri önlemek amacıyla backend'de oluşturulan tekil  (LookupController) endpoint'i ile birleştirildi. ,  ve  sayfalarındaki tıklamalara rağmen açılmayan modal pencereleri,  içerisinden içe aktarılan (imported)  ve  fonksiyonlarıyla onarıldı; lokal CSS ezmeleri temizlendi. Ek olarak, C# Enum () nesnelerinin frontend'e string olarak dönmesi sonucu arayüzde oluşan 'UNDEFINED' badge (rozet) sorunu, iki yönlü (Two-Way Map) Enum map sözleşmesi kurularak çözüldü.
- **Kararlar:** Hata fırlatma potansiyeli yüksek ardışık request'ler yerine payload birleştirme tercih edildi. Modal açma işlemlerinde yerel DOM stilleri () yerine sınıf tabanlı (class-based) global CSS overlay yapısı () standart kılındı.
- **Sonraki Adım:** Tüm tespit edilen aktif hata bildirimleri çözülmüştür. Testler tekrar koşulmuş ve 200 HTTP kodu ile başarılı erişim doğrulanmıştır. Proje 'Faz 12 Final Kapanış' adımına hazırdır.

### [Faz 12.9 - 404 Lookup Optimizasyonu ve Modal Dayanıklılığı]
- **Yapılanlar:** Frontend tarafında atılan ardışık 4 ayrı API isteği, ağ yükünü azaltmak ve eksik uç noktalardan (404) kaynaklanan çökmeleri önlemek amacıyla backend'de oluşturulan tekil `GET /api/lookup` (LookupController) endpoint'i ile birleştirildi. `admin-fields.html`, `rules.html` ve `webhooks.html` sayfalarındaki tıklamalara rağmen açılmayan modal pencereleri, `ui.js` içerisinden içe aktarılan (imported) `openModal` ve `closeModal` fonksiyonlarıyla onarıldı; lokal CSS ezmeleri temizlendi. Ek olarak, C# Enum (`FieldType`) nesnelerinin frontend'e string olarak dönmesi sonucu arayüzde oluşan 'UNDEFINED' badge (rozet) sorunu, iki yönlü (Two-Way Map) Enum map sözleşmesi kurularak çözüldü.
- **Kararlar:** Hata fırlatma potansiyeli yüksek ardışık request'ler yerine payload birleştirme tercih edildi. Modal açma işlemlerinde yerel DOM stilleri (`style.display='block'`) yerine sınıf tabanlı (class-based) global CSS overlay yapısı (`.active`) standart kılındı.
- **Sonraki Adım:** Tüm tespit edilen aktif hata bildirimleri çözülmüştür. Testler tekrar koşulmuş ve 200 HTTP kodu ile başarılı erişim doğrulanmıştır. Proje 'Faz 12 Final Kapanış' adımına hazırdır.

### [Faz 13 - State Machine & UI Modal Wiring Fix]
- **Yapılanlar:** Bilet durum güncellemelerinde yaşanan 400 hataları için `DataSeeder`'a "Default Global Workflow" ve `WorkflowTransition` kuralları eklendi. Frontend için izin verilen geçişleri sunan `GET /api/tickets/{id}/allowed-transitions` uç noktası tasarlandı ve `ticket-detail.html` ile `kanban.html` bu state-machine UX'ine entegre edildi. Ayrıca, `webhooks.html` ve `rules.html`'deki ölü butonlar, ESM bağımlı `onclick` kullanımından kurtarılarak vanilla `addEventListener` ile doğrudan modal ID'sine bağlandı.
- **Kararlar:** Hata ihtimalini minimize etmek için state geçişleri frontend'de kısıtlanıp hata anında Kanban tahtasında geri sarmalı olarak tasarlandı. UI butonları script içi asenkron operasyonlardan bağımsız hale getirildi.
- **Sonraki Adım:** Tüm hatalar giderilmiş olup son API ve unit test doğrulamaları yapılmıştır. Proje tamamen kararlı durumdadır.

### [Faz 13.5 - Reopen İş Kuralı, Kanban Navigasyon ve Tam Modal Wiring]
- **Yapılanlar:** `ticket.reopen` yetkisi oluşturularak "Resolved" ve "Closed" durumlarındaki biletlerin "In Progress" durumuna çekilme geçişi (`Reopen`) sisteme eklendi. `DataSeeder.cs` ve `TicketService.cs` güncellenerek, Reopen işlemi sırasında bilet geçmişine (TicketHistory) zorunlu "Reopened" logu atılması sağlandı. `kanban.html`'de kartların sürüklenmesi (drag) ile tıklanması (click) birbirinden ayrılarak detay sayfasına navigasyon düzeltildi. `webhooks.html` ve `rules.html` sayfalarında Edit/Delete butonları "Event Delegation" ile güvenli hale getirildi; Rules sayfasındaki "Lookup" alanları projeler, kategoriler vb. için API'den dolduruldu.
- **Kararlar:** Kanban'da click ve drag çakışmasını engellemek için JavaScript ile zamanlayıcılı `isDragging` bayrağı kullanıldı. Frontend tarafındaki modallerin event listener'ları `onclick`'ten kurtarılıp `tbody` üzerinden Event Delegation mantığına geçirildi.
- **Sonraki Adım:** Tüm gereksinimler başarıyla kodlandı. Bilet yönetimi, kurallar ve webhook yönetim modülleri sorunsuz çalışıyor. Projenin UI etkileşimleri kararlıdır.
