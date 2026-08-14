# Öğrenme Notları (Kalıcı Çalışma Defteri)

Bu belge, proje geliştirme süresince karşılaşılan teknik kavramları, kullanımları ve mimari kararları, staj dokümanı Madde 4.4 gereği "öğrenme odaklı" olarak kaydetmek için kullanılır.

## 1. DTO (Data Transfer Object) ve `record` Yapısı
- **Basit Açıklama:** İstemci (Front-end, mobil vb.) ile sunucu (API) arasında taşınacak veriyi paketlediğimiz kutulardır. Veritabanındaki hassas veya gereksiz kolonları dışarı sızdırmamak için kullanılır. `record`, C# 9.0 ile gelen ve oluşturulduktan sonra içeriği değiştirilemeyen (immutable) DTO'lar yazmak için harika bir yapıdır.
- **Projede Nerede:** `src/ItsTool.Application/DTOs/OrganizationDtos.cs`
  ```csharp
  // Tek satırda değişmez (immutable) bir obje oluşturuyoruz.
  public record CreateDepartmentDto(string Name, string? Description);
  ```
- **Mentor Sorarsa Cevabın:** "Veritabanı varlıklarını doğrudan API'ye açmak güvenlik zafiyeti yaratır. İhtiyacımız olan alanları filtreleyip taşımak ve veri bütünlüğünü (immutability) sağlamak için C# record yapısını DTO olarak kullandık."

## 2. Interface (Arayüz) ve Dependency Injection (DI)
- **Basit Açıklama:** Interface'ler bir sözleşmedir; "Bu sınıfın şu şu özellikleri yapabilmesi lazım" der ama nasıl yapacağını söylemez. DI (Bağımlılık Enjeksiyonu) ise sınıfların doğrudan birbirini çağırması yerine (new obj()), uygulamanın (ASP.NET Core) bu interface'e uygun sınıfı ihtiyacı olana otomatik vermesidir.
- **Projede Nerede:** `src/ItsTool.Application/Interfaces/IOrganizationService.cs` (Sözleşme) ve `src/ItsTool.Infrastructure/Services/DepartmentService.cs` (Uygulanışı).
- **Mentor Sorarsa Cevabın:** "Sınıfları birbirine sıkı sıkıya bağlamamak (Loosely Coupled) ve ileride sahte servisler (mock) ile Unit Test yazabilmek için işlemleri interface'ler üzerinden soyutladım ve .NET'in yerleşik DI mekanizmasını kullandım."

## 3. xUnit ve In-Memory Database ile Unit Testing
- **Basit Açıklama:** Yazdığımız kod parçacıklarının (fonksiyonların vb.) istenen işi doğru yapıp yapmadığını otomatik test eden sistemdir. In-Memory Database, gerçek veritabanını kirletmemek için RAM üzerinde geçici bir veritabanı açıp test bittiğinde silinmesini sağlar.
- **Projede Nerede:** `tests/ItsTool.UnitTests/Services/PermissionCalculatorTests.cs`
  ```csharp
  var options = new DbContextOptionsBuilder<ItsToolDbContext>()
      .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
      .Options;
  ```
- **Mentor Sorarsa Cevabın:** "İş kurallarımızın (yetki birleştirme, giriş onaylama) doğruluğunu kanıtlamak için xUnit testleri yazdım. Her test birbirinden bağımsız çalışabilsin diye RAM üzerinde çalışan benzersiz InMemory veritabanları kullandım."

## 4. ASP.NET Core Middleware ve [Authorize] Attribute
- **Basit Açıklama:** Middleware, API'ye gelen bir isteğin Controller'a (koda) ulaşmadan önce geçtiği güvenlik tünelleridir. `[Authorize]` attribute'u ise bu tünelden yetkisi (örneğin JWT'si) olmayanların geçmesini engelleyen bir polis noktasıdır.
- **Projede Nerede:** `src/ItsTool.API/Controllers/DepartmentsController.cs`
  ```csharp
  [ApiController]
  [Route("api/[controller]")]
  [Authorize(Policy = "RequirePermission:admin.manage")]
  public class DepartmentsController : ControllerBase
  ```
- **Mentor Sorarsa Cevabın:** "Sistemin uç noktalarını (endpoint) dış tehditlerden korumak için ASP.NET Core'un yerleşik Authorization altyapısını ve Policy-Based (Kural tabanlı) koruma mimarisini kullandık."

## 5. ProducesResponseType Annotations
- **Basit Açıklama:** API'mizi kullanan front-end geliştiricilere veya Swagger dokümantasyonuna, o endpoint'in hangi durum kodlarını (200 OK, 404 Not Found, 201 Created) ve hangi veri tiplerini döndürebileceğini önceden haber verme işlemidir. SonarQube'ün beklediği temiz kod standartlarından biridir.
- **Projede Nerede:** Tüm controller metodlarında.
  ```csharp
  [HttpGet("{id}")]
  [ProducesResponseType(typeof(DepartmentDto), StatusCodes.Status200OK)]
  [ProducesResponseType(StatusCodes.Status404NotFound)]
  public async Task<IActionResult> GetById(int id)
  ```
- **Mentor Sorarsa Cevabın:** "API tüketicilerinin (istemcilerin) beklenmedik durumlarla karşılaşmaması ve Swagger belgelerinin eksiksiz oluşması için tüm endpoint'lere Strongly-Typed (tip güvenli) dönüş anotasyonları ekledim."

## 6. GC.SuppressFinalize ve IDisposable Pattern
- **Basit Açıklama:** Uygulamada veritabanı bağlantısı veya dosya okuma gibi "unmanaged" (çöp toplayıcının otomatik silemediği) kaynaklar kullanıyorsak `IDisposable` arayüzü ile `Dispose()` metodunu yazarız. `GC.SuppressFinalize(this)` ise çöp toplayıcıya (Garbage Collector) "Ben bu nesneyi kendim temizledim, senin bir daha silmene gerek yok" diyerek performansı artırır.
- **Projede Nerede:** `tests/ItsTool.UnitTests/TestBase.cs` içinde `Dispose()` metodu.
- **Mentor Sorarsa Cevabın:** "Test sınıflarımızda InMemory veritabanı kullandığımız için bellek sızıntısını önlemek adına `IDisposable` kalıbını uyguladım ve SonarQube uyarısını çözmek için `GC.SuppressFinalize` ekleyerek Garbage Collector yükünü azalttım."

## 7. Generic Repository Pattern (Duplication Çözümü)
- **Basit Açıklama:** Her veritabanı tablosu için Ekle, Sil, Güncelle, Getir kodlarını (CRUD) tekrar tekrar yazmak yerine, bu işlemleri T tipinde (Generic) tek bir sınıfta toplayan mimari tasarım desenidir.
- **Projede Nerede:** `src/ItsTool.Application/Interfaces/IRepository.cs` ve `src/ItsTool.Infrastructure/Data/Repository.cs`
- **Mentor Sorarsa Cevabın:** "Projeye yeni modüller (Departman, Proje, Rol) eklendikçe servislerde ciddi kod tekrarı (duplication) oluştuğunu gördüm. Bunu engellemek ve kodun bakımını kolaylaştırmak için Generic Repository Pattern uygulayarak EF Core bağımlılığını tek noktaya çektim."

## 8. Testlerde Code Coverage (Kod Kapsamı) ve coverlet.msbuild
- **Basit Açıklama:** Yazılan unit testlerin gerçek kodun (production code) yüzde kaçını çalıştırdığını (kapsadığını) ölçen metrik. `coverlet` bu ölçümü yapan popüler bir .NET aracıdır.
- **Projede Nerede:** `dotnet test /p:CollectCoverage=true /p:CoverletOutputFormat=opencover` komutuyla çalışır.
- **Mentor Sorarsa Cevabın:** "Yazdığım testlerin projemizin hangi alanlarını güvene aldığını kanıtlamak ve SonarQube'e kalite raporu gönderebilmek için Coverlet kullanarak OpenCover formatında coverage raporu ürettim."

## 9. Dinamik Form Konfigürasyonu (EAV Mimarisi - Entity-Attribute-Value)
- **Basit Açıklama:** Tablolara sürekli yeni sütun (kolon) eklemek yerine, eklenecek alanları (Attribute) ve onlara girilecek değerleri (Value) satırlar halinde tutan esnek veritabanı modelidir. Müşterinin formlarını yazılımcıya ihtiyaç duymadan değiştirebilmesini sağlar.
- **Projede Nerede:** `FieldDefinition` (hangi alan?), `FieldOption` (seçenekleri neler?), `FormFieldPlacement` (hangi ekranda gözükecek?) yapıları ve `DynamicFormService`.
- **Mentor Sorarsa Cevabın:** "Müşteri özel alanlarını (custom fields) koda dokunmadan veritabanından dinamik yönetebilmek için EAV (Entity-Attribute-Value) konfigürasyon yapısını kurdum."

## 10. Workflow / State-Machine Pattern
- **Basit Açıklama:** Bir kaydın (örn. biletin) durumlarının (açık, beklemede, kapalı vs.) ve bu durumlar arası geçişlerin rastgele değil, belirli kural ve izinlere göre yapılmasını sağlayan iş akışı modelidir.
- **Projede Nerede:** `Workflow`, `WorkflowTransition` ve `WorkflowService` sınıflarında.
- **Mentor Sorarsa Cevabın:** "Biletlerin sadece izin verilen durumlara geçebilmesi için State-Machine prensibini baz alarak Workflow geçiş (transition) altyapısını tasarladım."

## 11. Soft Delete ve Bağımlılık (Cascade) Politikası
- **Basit Açıklama:** Bir veri silindiğinde onu fiziken yok etmek yerine `IsDeleted = true` yapmak. Özellikle konfigürasyon ayarlarında, bu veri başka tablolar tarafından kullanılıyorsa, "fiziksel" silme işlemi veritabanını bozabilir.
- **Projede Nerede:** `CatalogService` içerisinde `DeleteStatusAsync` metodu (aktif geçişte kullanılan statü silinemez iş kuralı).
- **Mentor Sorarsa Cevabın:** "Bir durum (status) bir workflow transition'da kullanılıyorsa veritabanı bütünlüğünü korumak adına hard-delete yapmak yerine hata fırlatıp soft-delete yaklaşımını uyguladım."

## 12. Proje Bazlı Sequence (Ticket Number)
- **Basit Açıklama:** Otomatik artan (auto-increment) primary key yerine her projenin kendi numaralandırmasını (örn. ITS-1, ITS-2, HR-1) yapması için ayrı bir tabloda (`ProjectSequence`) projeye özel sayaç tutulmasıdır.
- **Projede Nerede:** `TicketService.cs` içindeki `GenerateTicketNumberAsync` metodunda.
- **Mentor Sorarsa Cevabın:** "Müşteriler farklı projelerdeki biletlerin karışmamasını ve kendi ön ekleriyle numaralandırılmasını istedikleri için `ProjectSequence` adında ayrı bir sayaç entity'si tasarlayıp proje bazlı sequence yapısı kurdum."

## 13. Event Sourcing Temeli ve Timeline
- **Basit Açıklama:** Veritabanında sadece verinin son halini değil, verinin geçmişte uğradığı tüm değişiklikleri olay (event) bazlı kayıt altına almaktır (Audit Log).
- **Projede Nerede:** `TicketHistory`, `TicketComment`, `TicketAttachment` ve bunları birleştiren `GetTimelineAsync` metodu.
- **Mentor Sorarsa Cevabın:** "Biletlerin tarihçesini kaybetmemek ve kimin ne zaman hangi alanı değiştirdiğini (audit trail) gösterebilmek için TicketHistory tablosunu kullandım. Yorumlar, dosyalar ve geçmişi birleştirerek tek bir kronolojik Timeline endpoint'i oluşturdum."

## 14. İç (Internal) vs Dış (Public) Yorum Ayrımı
- **Basit Açıklama:** Bilette yazışılan bazı notların sadece destek ekibi tarafından görünmesi, son kullanıcıya (talep edene) gitmemesi kuralıdır.
- **Projede Nerede:** `TicketComment.IsInternal` property'si ve Controller'daki `HasClaim` bazlı filtreleme.
- **Mentor Sorarsa Cevabın:** "Ekiplerin kendi aralarında konuşabilmesi için yorumlara `IsInternal` bayrağı ekledim ve bunu okuyabilmek için token içerisindeki `ticket.comment.internal` permission claim'ini kontrol eden bir filtre mekanizması geliştirdim."

## 15. ReDoS (Regular Expression Denial of Service)
- **Basit Açıklama:** Düzenli ifadeler (Regex) çok karmaşık pattern'lerde, özellikle kullanıcıdan gelen kötü niyetli input'lar ile karşılaştığında aşırı işlemci tüketir ("Catastrophic Backtracking"). Bunu engellemek için regex match işlemine süre sınırı konur.
- **Projede Nerede:** `TicketService.cs` içindeki `ValidateRegexFormat` metodunda. `TimeSpan.FromSeconds(2)` ile timeout eklendi.
- **Mentor Sorarsa Cevabın:** "Dinamik alan konfigürasyonlarında Regex'leri admin girdiği için kontrol edemiyoruz. ReDoS saldırılarını engellemek ve işlemcinin kilitlenmesini önlemek adına 2 saniyelik timeout belirledim. Zaman aşımına uğrarsa `RegexMatchTimeoutException` fırlatıp 'geçersiz format' hatası dönüyorum."

## 16. Cognitive Complexity ve Metot Çıkarımı (Single Responsibility)
- **Basit Açıklama:** Bir metodun içerisinde çok fazla iç içe if/else, döngü veya `try-catch` olması okunabilirliği zorlaştırır (SonarQube S3776). Çözüm, farklı sorumlulukları küçük özel metotlara (helper) bölmektir.
- **Projede Nerede:** `TicketService.cs` içerisindeki `ValidateDynamicFieldsAsync` metodunu parçalayarak `ValidateRequiredField`, `ValidateRegexFormat`, `ValidateFieldOptionsAsync` metotlarına böldüm.
- **Mentor Sorarsa Cevabın:** "Dinamik alan validasyonu çok fazla sorumluluk üstlendiği için cognitive complexity 23'e çıkmıştı. Tek sorumluluk prensibini kullanarak (Single Responsibility) metotları parçalara böldüm ve complexity'i ciddi şekilde düşürdüm."

## 17. Magic String Kullanımından Kaçınmak
- **Basit Açıklama:** Kodun içinde birden fazla yerde "Ticket not found." gibi literal text (string) değerleri yazıldığında (S1192), olası değişiklikte birini gözden kaçırmak kolaydır.
- **Projede Nerede:** `TicketService.cs` içerisinde sınıfın başında `private const string TicketNotFoundMessage = "Ticket not found.";` tanımlanarak 4 yerde bu sabit kullanıldı.
- **Mentor Sorarsa Cevabın:** "Tekrarlanan magic string'leri bakım kolaylığı için `private const` sabite dönüştürdüm."

## 18. First Response vs Resolution SLA Ayrımı
- **Basit Açıklama:** ITSM dünyasında bir talebin kalitesini ölçmek için iki ana zaman hedefi vardır: Müşteriye ne kadar hızlı ilk dönüş yapıldığı (First Response) ve problemin ne kadar sürede çözüldüğü (Resolution).
- **Projede Nerede:** `TicketSla` entity'sinde `FirstResponseDueAt` ve `ResolutionDueAt` alanları olarak tutuluyor.
- **Mentor Sorarsa Cevabın:** "SLA'i sadece kapanış süresi üzerinden ölçmek yetersizdir. Müşteri, talebinin alındığını ve ilgilenildiğini bilmek ister. Bu yüzden public bir yorum atıldığında (veya statü değiştiğinde) First Response SLA'ini durduruyor, bilet tamamen kapandığında ise Resolution SLA'ini durduruyorum."

## 19. İş Saati (Business Hours) ve Tatil Matematiği
- **Basit Açıklama:** Gece 3'te açılan bir talebin SLA sayacı, sabah 9'daki mesai başlayana kadar ilerlememelidir. Sadece çalışma günlerinde ve iş saatleri içerisinde süre düşülür.
- **Projede Nerede:** `SlaEngine.cs` içindeki `CalculateDueTimeAsync` metodunda.
- **Mentor Sorarsa Cevabın:** "Bilet açıldığında hedef süreyi düz olarak eklemek yerine, takvim (BusinessHour) ve tatil (Holiday) yapılarını içeren bir döngüyle, kullanıcının belirlediği iş günlerinin içindeki saatlere yayarak gerçek hedef tarihini (Due Date) hesapladım."

## 20. SLA Pause/Resume (Duraklatma) Muhasebesi
- **Basit Açıklama:** Bir bilet müşteriden bilgi bekliyorsa (örn. "Beklemede" durumu), SLA saati durmalıdır.
- **Projede Nerede:** `Status` tablosundaki `PausesSla` flag'i ve `SlaEngine.ProcessTicketStatusChangeAsync`.
- **Mentor Sorarsa Cevabın:** "Müşteriden kaynaklanan gecikmelerin destek ekibine SLA ihlali (breach) olarak yansımaması için `PausesSla = true` olan durumlarda tarihi kaydettim (PausedAt). Bu durumdan çıkıldığında ise bekleme süresini hesaplayıp hedef tarihleri (DueAt) o kadar dakika ileri iterek adil bir SLA sayacı kurdum."

## 21. Background Job (IHostedService) ile Zamanlanmış İşlemler
- **Basit Açıklama:** Uygulama ayaktayken arka planda kendi kendine (örn. her 5 dakikada bir) tetiklenen periyodik işlemlerdir.
- **Projede Nerede:** `SlaCheckerService.cs` (BackgroundService)
- **Mentor Sorarsa Cevabın:** "SLA ihlallerini tespit edip bildirim yollamak için dışarıdan bir API isteği gelmesini bekleyemeyiz. ASP.NET Core'un kendi `IHostedService` altyapısını kullanarak arka planda periyodik (5 dk) çalışan bir checker yazdım. Bu servis DI scope'u açarak SlaEngine'i tüketiyor."

## 22. Idempotency (Bildirim Çoklamasını Engelleme)
- **Basit Açıklama:** Arka plan servislerinin veya retry mekanizmalarının aynı olay için tekrar tekrar aynı işlemi yapmasını (örn. müşteriye 5 tane "SLA doldu" maili atmasını) engellemektir.
- **Projede Nerede:** `TicketSla` tablosundaki `FirstResponseBreached`, `ResolutionWarned` vb. bayraklar.
- **Mentor Sorarsa Cevabın:** "Zamanlanmış görev her 5 dakikada bir çalışıyor. SLA bir kere patladığında (breach), o bileti tekrar yakalayıp 5 dakika sonra yeniden mail atmasın diye TicketSla üzerinde 'Uyarıldı' ve 'İhlal Edildi' flag'lerini kullandım. Böylece checker idempotent (tekrarlanabilir ama zararsız) hale geldi."

## 23. UTC Zaman Kullanımı Kararı
- **Basit Açıklama:** Veritabanına tarih/saat kaydederken sunucunun yerel saati yerine evrensel zaman (UTC) kullanılması.
- **Mentor Sorarsa Cevabın:** "Farklı coğrafyalardan, farklı zaman dilimlerinden kullanılabilme ihtimaline karşı ve sunucu timezone'unun gün ışığından yararlanma (DST) değişimlerinden etkilenmemesi için SLA hesaplamalarını tamamen `DateTime.UtcNow` ile yaptım."

## 24. Arayüz Ayrıştırma (Interface Segregation) ve Stub Service
- **Basit Açıklama:** Gerçek dış bağımlılıkları (örn. SMTP server) koda direkt yazmak yerine, test edilebilecek boş bir implementasyonla (Stub) arayüz tanımlamak.
- **Projede Nerede:** `IEmailService` ve `StubEmailService`.
- **Mentor Sorarsa Cevabın:** "Sisteme e-posta gönderimi ekleyeceğim fakat bağımlılık yaratıp testleri zorlaştırmamak adına `IEmailService` diye bir interface tasarladım. Şu anlık sadece konsola (log) yazan `StubEmailService` ile inject ettim. İleride (Faz 11) SMTP kodları sadece bu implementasyonu değiştirecek, SLA Engine hiç etkilenmeyecek."

## 25. Cognitive vs Cyclomatic Complexity ve Pure Functions
- **Basit Açıklama:** Cyclomatic complexity koddaki if/for/while gibi dallanmaların matematiksel toplamıyken; Cognitive complexity kodun bir *insan tarafından* ne kadar zor anlaşıldığını (okunabilirliğini) ölçer (iç içe if'ler, uzun döngüler puanı çok artırır).
- **Projede Nerede:** `SlaEngine.cs` refactor işleminde.
- **Mentor Sorarsa Cevabın:** "SLA hesaplama motorundaki karmaşıklığı azaltmak için kodu 'saf fonksiyonlara' (pure functions - dış dünyayı değiştirmeyen, sadece input alıp output dönen yardımcı metotlar) böldüm. Örn. `IsWorkingDay`, `ConsumeMinutesWithinDay`. Bu sayede ana fonksiyon sadece bu parçaları orkestre eden temiz bir döngüye dönüştü."

## 26. Guard Clause ve Early Return Mantığı
- **Basit Açıklama:** Şartların sağlanmadığı durumlarda kodu `if-else` bloklarıyla uzatmak yerine, metot başında hemen `return` edip çıkmaktır.
- **Projede Nerede:** `CheckFirstResponseAsync` ve `CheckResolutionAsync` metotlarında.
- **Mentor Sorarsa Cevabın:** "SLA ihlal kontrolü yaparken iç içe if'ler (arrow code) oluşuyordu. Bunun yerine 'Eğer SLA zaten karşılanmışsa hemen dön' (Early Return) diyerek ana akışı düz (flat) hale getirdim ve kodu okumayı kolaylaştırdım."

## 27. Static Metotlar ve "Pure Function" İlişkisi (Instance Data'ya Erişmeme)
- **Basit Açıklama:** Eğer bir metot sınıfın içindeki değişkenleri (`this.X`) kullanmıyorsa, o metot nesneye bağlı değildir, bağımsızdır. Bu yüzden o metodu `static` olarak işaretleyebiliriz.
- **Projede Nerede:** `SlaEngine.cs` içindeki `ApplyPause` ve `EvaluateMetric` metotlarında.
- **Mentor Sorarsa Cevabın:** "SonarQube 'bu metotlar instance dataya erişmiyor' diyerek beni uyardı. Bir metodun `static` olması onun saf bir fonksiyon (pure function) olduğunu ve sadece aldığı parametrelere göre çalıştığını gösteren iyi bir niyet belgesidir. Ayrıca sınıfın durumunu (state) değiştirmediği için thread-safe'tir ve test edilmesi çok daha kolaydır."
