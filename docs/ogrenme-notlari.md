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
