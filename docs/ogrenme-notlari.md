# Öğrenme Notları

## Inline Edit vs Modal Edit Tercihi
Ticket Detail sayfasında modal üzerinden düzenleme yapmak yerine yerinde (in-place) düzenleme yapmayı tercih etmenin hem kullanıcı deneyimi hem de performans açısından farklı sonuçları oldu:
- **Artılar (Inline Edit):** Kullanıcının bağlamdan (context) kopmasını engeller. Mevcut değerler hemen orada düzenlenebilir, özellikle uzun metinleri (description) okurken hemen yanında düzenleme başlatmak ekran okuma alışkanlığına daha uygundur.
- **Eksiler (Inline Edit):** Geliştirme (DOM manipulation) kısmı biraz daha karmaşıktır. Mevcut salt okunur elementleri (div, span) anlık olarak input/textarea'ya dönüştürüp, geri alındığında orjinal halini sorunsuz render etmek defensive bir JavaScript mimarisi gerektirir. Modal yaklaşımı DOM'u çok daha statik ve güvenli tutar.

## Alan Bazlı Audit ve No-Op Kirliliği
Update işlemlerinde tüm değerleri alıp direkt veritabanına kaydetmek (ve hepsine "Updated" logu basmak) Audit Log tablosunda büyük bir kirliliğe ("no-op pollution") sebep olur.
- Sadece gerçekten değişen alanları tespit etmek (`oldValue != newValue`) ve sadece bu alanlar için `TicketHistory` oluşturmak kritik bir business logic kuralıdır.
- `TicketService.cs` içerisindeki `CheckDiff` metodu tam olarak bu no-op kirliliğini önlemiş, geçmişe yönelik okumalarda yalnızca "gerçekten yapılan" değişiklikleri görünür kılmıştır.

## Dinamik Alanlar ve Validasyon
Dinamik olarak formlara sonradan eklenen alanların (Regex, Required flag'leri) backend üzerinde `ValidateDynamicFieldsAsync` içerisinde kontrol edilmesi, sistemin veri bütünlüğünü sağlar. Edit ekranında da frontend seviyesinde bu kuralların (required attribute vb.) input'lara bağlanması UX'i iyileştirir ve 400 Bad Request fırlatma ihtimalini minimize eder.

## Shared Component Extraction (DRY) & Event Delegation
UI modallarını tekil sayfalarda (örn. `kanban.html` içinde statik olarak) tutmak yerine `ui.js` gibi merkezi ve paylaşılan scriptler içerisinden dinamik DOM enjeksiyonu ile yönetmek ciddi kod tasarrufu ve bakım kolaylığı sağlar (DRY prensibi). Özellikle `dashboard.html`'deki liste elemanlarında ve `kanban.html`'deki kartlarda aynı preview modalı (Ticket Preview) başarılı bir şekilde kullanıldı.
Ayrıca, `tickets.html` üzerindeki chip'lerde click eventlerini teker teker bağlamak yerine kapsayıcı `.btn-group` üzerine bağlayıp (Event Delegation), accessibility standartlarına uygun şekilde `aria-pressed` özniteliklerini güncelledik. `Closed` durumu UI tarafında kırılgan string karşılaştırması yerine daha güvenli olan `isClosedStatus` bayrağı ile sağlandı.

## KB Görünürlük Matrisi ve İçerik Yaşam Döngüsü (Authoring)
Bilgi Bankası (Knowledge Base) modülünde dokümanların statüsü ve görünürlüğü ayrı kavramlardır:
- **Statü (Status):** Draft (Taslak) veya Published (Yayınlanmış). Sadece "Published" olanlar genel kullanıcılara (end-user) listelenir. "Draft" statüsündekiler sadece `kb.manage` yetkisine sahip kullanıcılar tarafından (Authoring UI üzerinden) görülebilir ve düzenlenebilir.
- **Görünürlük (Visibility):** Internal (Sadece dahili personel görebilir) veya Public (Herkes görebilir).
Bu ayrım sayesinde, bir makale hem "Published" hem de "Internal" olabilir. Bu durumda dış müşteriler göremezken, iç ekipler makaleye erişebilir. API tarafında kullanıcının yetkisine göre bu filtrelerin sunucuda (backend) işletilmesi (filtering at source) güvenlik açısından kritiktir.

## Drill-Down Dashboard Deseni ve Erişilebilirlik (a11y)
Dashboard KPI kartlarının statik rakamlar yerine dinamik, etkileşimli nesnelere dönüştürülmesi (Drill-Down), kullanıcıların ilgilendikleri veri kümesinin detayına saniyeler içinde inebilmesini sağlar. 
Bunu yaparken **Erişilebilirlik (Accessibility - a11y)** göz ardı edilmemelidir. Salt `<div>` olan bir karta tıklama eventi (`onclick`) vermek yeterli değildir. Ekran okuyucuların ve klavye kullanıcılarının (tab navigasyonu) bu elementi bir buton olarak algılayabilmesi için:
- `role="button"` ve `tabindex="0"` özniteliklerinin eklenmesi gerekir.
- Sadece `onclick` değil, aynı zamanda `onkeydown` event'i ile "Enter" veya "Space" tuşlarına basıldığında (event.key === 'Enter' || event.key === ' ') aynı aksiyonun tetiklenmesi garanti altına alınmalıdır.
Bu desen, hem şık (hover effect) hem de engelsiz bir Dashboard sunar.

## 10. Compliance Audit ve Responsive UI (Staj Dokümanı Uyumluluğu)
- **Compliance Audit Yöntemi:** Projenin staj gereksinimlerine (PDF) göre tam uyumluluğunun denetimi için tüm özellikler (CRUD sayfaları, Seed Data, Transfer özellikleri vb.) maddeler halinde denetlenmiş, `varsayimlar.md` gibi açıklama dokümanları eklenerek boşluklar kapatılmıştır.
- **Responsive (Mobil) Stratejisi:** Medya sorguları (`@media`) kullanılarak, ekran boyutu 768px altına düştüğünde sidebar gizlenmiş (overlay ile açılır hale getirilmiş), tablo verileri yatay kaydırma (overflow-x) ile taşınmış ve modal ile form yapıları esnek (grid 1fr) hale getirilmiştir. Bu yapı `ui.js` içerisinde bir Hamburger menü dinleyicisi ile tamamlanmıştır.
- **i18n Karar Çerçevesi:** Çoklu dil (İngilizce/Türkçe) desteği MVC yapısında MVP'ye entegre etmek yerine, varsayılan bir "TR" dil altyapısıyla çalışması sağlanmış ve `varsayimlar.md` dosyasında bir mimari kısıtlılık / roadmap hedefi olarak izah edilmiştir.

## 11. Undo (Geri Al) Pattern & Viewport Scroll (v15)
- **Undo Pattern:** Silme (Delete) gibi yıkıcı (destructive) işlemler veya Publish/Status gibi hızlı durum değiştiren aksiyonlarda, doğrudan "Emin misiniz?" pop-up'ı çıkartmak yerine **Optimistic UI & Undo Toast** pattern'i tercih edildi. Kullanıcı eylemi yapar, arayüzde işlem yapılmış gibi davranılır (veya silme işlemi arka planda 6 saniye bekletilir). Kullanıcı 6 saniye içerisinde "Geri Al" (Undo) butonuna basarsa işlem iptal edilir veya tersine (revert) API çağrısı ile düzeltilir. Bu UX açısından sürtünmeyi (friction) azaltır.
- **Soft vs Hard Delete:** Veritabanındaki `IsDeleted` bayrağı ile kayıtların "Soft Delete" yapılması, Undo pattern gibi yapıları desteklediği ve Audit (Denetim) süreçlerinde veri bütünlüğünü koruduğu için ITSM gibi projelerde kritik bir kalıptır.
- **Viewport-Contained Scroll (Kanban):** Kanban panosunda tüm sayfanın yatay ve dikey kayması yerine, ana sayfa (layout) sabit tutularak (`height: calc(100vh - 150px); overflow-y: hidden; overflow-x: auto;`) sadece kolonların ve kolon içi item'ların (`flex: 1; overflow-y: auto;`) kendi içinde scroll olması sağlandı. Bu sayede topbar menüsü her zaman erişilebilir kalır ve UI bir "app" hissiyatı verir.

## 12. Kişisel Tercihler (LocalStorage) ve RBAC Şeffaflığı (v16)
- **Kişisel UI Tercihleri:** Kanban kolon sırası gibi her kullanıcının kendine özel yapmak istediği basit durumlar için backend'de tablo (örn. `UserPreferences`) oluşturmak yerine `localStorage` kullanımı seçilmiştir. Anahtar olarak `kanban.colorder.{userId}` kullanılarak, aynı bilgisayarı kullanan farklı hesapların (agent1 vs user1) ayarlarının birbirine karışması engellenmiştir. Server side yerine Client side saklama kararı, DB I/O yükünü düşüren bir Trade-off'tur.
- **İki Eksenli DnD Yönetimi:** Kanban tahtasında hem kolonlar kendi içinde (Sıralama), hem de kartlar kolonlar arası (Status Update) hareket ettiği için HTML5 Drag & Drop event'leri `dataTransfer.setData("type", "column")` gibi yöntemlerle izole edilmiştir. Bilet sürüklemelerinde hedef kolon, `ev.dataTransfer.getData("type")` kontrolü ile kolon başlığının bırakma eventini yoksaymaktadır.
- **RBAC Şeffaflığı:** Kullanıcının (Örn: Agent) kendi "efektif" yetkilerini şeffaf olarak görmesi (Sağ üst avatar Modal'ı) güven artırıcı bir UX'tir. Rol, Grup ve Override üzerinden hesaplanan birleşik yetkiler (Permissions) UI'da sergilenerek, ITSM sistemindeki olası bir "Yetkim Yok" hatasının (403) teşhis edilmesi son kullanıcıya bırakılmıştır. Override edilen yetkilere de UI tarafında (API'den eklenen `.overrides` payload'ı ile) "override" rozeti yerleştirilmiştir.

## 13. "Kodda Var" vs "Runtime'da Var" (Curl Kanıt Kültürü) ve Arayüz Bildirimi (v18)
- **Runtime (Çalışma Zamanı) Gerçeği:** Bir Controller veya DTO dosyasının projede ("kodda") bulunması, o uç noktanın (endpoint) çalıştığı anlamına gelmez. Route atamaları (`[Route("api/[controller]")]`), dependency injection eksiklikleri veya method imzalarındaki uyumsuzluklar (örn. `CategoriesController`'ın `Catalog` içine gömülmüş olup `api/categories` route'una yanıt vermemesi), sadece **çalışma anında** (runtime) bir API çağrısı (curl) yapıldığında ortaya çıkar. Gerçek kanıt, yazılmış kod değil, `200 OK` dönen curl veya test çıktısıdır.
- **Event Delegation Gücü:** HTML içerisine `onclick="..."` yazmak yerine (inline handlers), global düzeyde (document) tek bir dinleyici (`addEventListener`) koyarak olayları yakalamak (Event Delegation) ve `data-action="..."` kullanmak; hem kod tekrarını azaltır hem de dinamik oluşturulan DOM elemanlarına anında etki eder.
- **Drag State (Affordance) Görselliği:** Native HTML5 Drag & Drop yapısında, sürüklenen elemanın veya hedef (drop) bölgesinin görsel olarak değişmesi (örneğin `.dragging` ile saydamlaşması veya `.drag-over` ile etrafının vurgulanması), kullanıcının "Neyi sürüklüyorum?" ve "Nereye bırakabilirim?" sorularını anlık olarak cevaplar. Bu görsel geri bildirim (feedback) UX açısından temel bir affordance (kullanım ipucu) ilkesidir.

## 14. Son Faz (Final Cleanup) ve Performans/Erişilebilirlik Temelleri
- **Sync-over-Async Antipattern'i:** EF Core sorgularında (özellikle Seeder gibi başlangıç yapılarında) `Any()`, `FirstOrDefault()` veya `ToList()` gibi senkron metotların çağrılması, o metodun asenkron yapısını (async/await) bloke eder (thread starvation). Alt katmandaki veritabanı isteği ağ üzerinden (I/O) gelirken, C# thread'i kilitlenir. Bunun yerine `AnyAsync()`, `FirstOrDefaultAsync()` kullanılması Thread Pool'daki iş parçacıklarının serbest kalmasını ve yüksek eşzamanlılığı (concurrency) sağlar. LINQ-to-Objects (bellekteki `List<T>`) üzerinde `ToList()` kullanılması ise I/O içermediği için meşrudur.
- **Type Coercion ve Number Constructor:** JavaScript'te yalın `isNaN("abc")` true dönerken, aslında tip dönüşümü (type coercion) yaparak arka planda işler. Oysa `Number.isNaN("abc")` false döner (çünkü string'tir, NaN değildir). Strict (katı) kontrol için `Number.isNaN()` ve `Number.parseInt()` modern JS standartlarıdır. Bu durum "Beklenmeyen NaN" hatalarını önler.
- **CSS var() Fallback ve Sözdizimi:** CSS Custom Properties (`--degisken`) tanımlı olduklarında yalın kullanılamazlar. Mutlaka `var(--degisken)` fonksiyonuna sarılmaları gerekir. Eğer `calc()` gibi matematiksel işlemler (örn. negatife çevirme: `calc(var(--sidebar-width) * -1)`) yapılacaksa doğru sentaks hayati önem taşır; çıplak `-var(...)` geçersizdir.
- **A11y (Erişilebilirlik) İyileştirmeleri:** Sadece bir etikete (label) metin yazmak yetmez. Ekran okuyucuların (screen readers) o metni yanındaki form elementiyle ilişkilendirmesi için `<label for="inputId">` kullanılması veya input'un içine `aria-label="Metin"` eklenmesi zorunludur. Bu hem kullanıcı deneyimini hem de WCAG uygunluğunu artırır.

### Öğrenme Notu - Complexity & Sweep (FAZ 8)
- **Complexity Bölme (Early Return, Helper):** Büyük metotlardaki cyclomatic complexity'i kırmak için conditional logic'leri (`foreach` içerisindeki uzun atamalar, `if-else` condition'lar) private helper metotlara çıkararak parçaladık (`DataSeeder.cs`, `TicketService.cs`).
- **Dataset API:** `getAttribute('data-*')` kullanımlarını `dataset.*` şeklinde yeniden düzenledik (ör. `dataset.statusName`). Bu standart, camelCase mapping ile daha güvenli DOM erişimi sağlar.
- **Top-Level Await (v11.5 Deseni):** ES Modules ( `<script type="module">`) içinde top-level await yapabilmek, "unhandled promise rejection" kaynaklı kırılganlıkları engellemek için async metot başlatımlarını `await` ile bağladık (`loadDashboard`, `loadFields` vb.).
- **Ders (Tekrar Eden Bulgu):** Eğer aynı bulgu (empty-catch, boş-heading) projenin birkaç yerinde tekrar ediyorsa, sweep'i (taramayı) satır bazlı değil *repo-geneli* yapmalıyız. Tekrar eden bulgu = sweep eksik.

### Öğrenme Notu - One-Off Script Politikası ve Son Sweep (FAZ 9)
- **One-off Script Politikası:** Toplu düzeltmeler (bulk-fix) için yazılan geçici Python veya JS betiklerinin repo içerisinde tutulmaması kritik bir kuraldır. Geçmişte bu tarz `fix_*.py` scriptleri SonarQube bulgularına ve gereksiz kod kirliliğine neden oldu. Bu betikler artık ya `/tmp` gibi repo dışı bir alanda çalıştırılmalı ya da çalıştırıldıktan hemen sonra (ör. `&& rm script.py`) silinmelidir.
- **Empty Catch Disiplini:** Arayüz (UI) katmanında ve `wwwroot` altındaki tüm API isteklerinde oluşabilecek hataların yutulmasını (swallow) önlemek için tüm boş `catch(e) {}` bloklarına `console.error(e)` eklendi.
- **DataSeeder Constants:** `StatusConstants` ve geçiş isimleri (TransitionName) gibi "magic string" (sihirli metin) değerlerinin merkezileştirilmesi SOLID prensiplerine tam uyum sağlar.

### Öğrenme Notu - Final Sweep ve Modül Yapısı (FAZ 10)
- **Top-Level Await (v11.5 Deseni):** Sayfa yüklenme anında çağrılan `init()`, `loadLookups()` gibi asenkron metotların yutulmasını (swallow) önlemek için tüm ana `<script>` etiketleri `<script type="module">` yapısına geçirildi ve fonksiyon çağrıları `await` ile önceliklendirildi.
- **Test Null-Safety Deseni:** `Assert.NotNull(x);` kullanımından sonra C# 8+ compiler'ının nullable uyarısı vermemesi için değişkenler `x!.Property` şeklinde null-forgiving (bang) operatörü ile çağrıldı. Bu, test kodlarında "Zaten NotNull ile guardladım, buraya geldiyse null değildir" anlamına gelir.
- **UI Complexity ve A11y:**
  - `projects.html` içerisinde üç defa tekrar eden statü-renk eşleştirme ternarileri (içiçe geçmiş - nested ternary) `getProjectStatusColor` adlı bir yardımcı metoda çıkarılarak karmaşıklık düşürüldü.
  - A11y (Erişilebilirlik) standartları gereği filtre butonlarını gruplayan `role="group"` div'leri, anlamsal (semantic) HTML etiketi olan `<fieldset>` ve `<legend>` yapısına dönüştürüldü.

### Öğrenme Notu - Void vs Return Sözleşmesi ve Son Sweep (FAZ 11 Kapanış)
- **Void vs Return Sözleşmesi:** `buildEditDynamicFields` gibi HTML string'i üreten yardımcı (helper) metodlar, kendi içinde `container.innerHTML = ...` gibi DOM manipülasyonu yapmamalıdır. Ürettikleri string değerini `return html;` ile geri dönmeli ve çağrı yapılan noktada (caller tarafında) bu değer DOM'a aktarılmalıdır. Bu kural çiğnendiğinde, atama yapılan değişkene `undefined` döner ve `innerHTML = undefined` hatasına sebep olur.
- **Top-Level Await Kapanışı:** Son kalan `kb.html` ve `kb-article.html` sayfaları da `<script type="module">` ve top-level `await` yapısına geçirilerek projede sıfır hataya ulaşıldı.

### Öğrenme Notu - Config-Driven Factory & Controller Base Patterns (FAZ 12)
- **Duplication (Kopya Kod) Tespiti ve Çözümü:** Hem C# hem de JS tarafındaki %37'lere varan kopyalamalar, mimari kalıplar (design patterns) ile aşılır.
- **Frontend DRY - Config-Driven CRUD Factory:** 5 ayrı HTML sayfasındaki 300+ satırlık birbirinin aynısı olan AJAX (GET/POST/DELETE/PUT) ve DOM/Modal (Create/Edit) döngüleri, konfigürasyon objesi (columns, endpoints, tableBodyId vs) alan tek bir JS factory (`crud-page.js`) metoduna (`initCrudPage`) devredilerek %60'a varan kod silinmesi sağlanmıştır. 
- **Backend DRY - Generic Controller Base:** Aynı (try-catch, audit, mapping, result types) döngüsüne sahip `Categories`, `Groups`, `Projects` ve `Roles` controller'ları için ortak bir abstract base sınıf (`CrudControllerBase<TDto, TCreateDto, TUpdateDto>`) yazılarak API yapısı DRY prensibine uygun hale getirilmiştir. Bu yapı hem okunabilirliği artırır hem de SonarQube'un *Code Duplication* metriğinde ciddi bir düşüş (%8 altına) sağlar.

### Öğrenme Notu - Skeleton-Level DRY ve Generic Kısıtlamaları (FAZ 13)
- **Markup Duplication:** Frontend'deki DRY yaklaşımı yalnızca mantık (JS) ile sınırlı kalmamalıdır. Birbirine benzeyen CRUD sayfalarındaki tablo (HTML `<table>`), eylem çubukları (Toolbar), ve modal iskeleti (Modal overlay) tamamen aynı kalıptan çıkıyorsa, bunları da JS Factory içerisinden string/template literal olarak render etmek (Skeleton-Level DRY) HTML sayfalarının satır sayılarını %60-70 oranında düşürür. (Ortalama sayfa başı <80 satır elde edildi).
- **Generic Parametre Sınırları (SonarQube ≤2 Kuralı):** `CrudControllerBase<TEntity, TDto, TCreateDto, TUpdateDto>` gibi çok fazla generic tip alan sınıflar okunabilirliği ve bakımı zorlaştırır. Bunun yerine, Controller'ı sadece okuma (GET) metodlarına ve ortak Delete işlemlerine indirgeyip (örn: `CrudControllerBase<TDto>`), Create/Update operasyonlarını concrete sınıflara bırakmak (veya tek bir Request DTO ile sınırlamak) parametre sayısını kurallara uygun hale getirirken mimari esneklik sağlar.

### Öğrenme Notu - Güvenlik ve Kod Temizliği (FAZ 14 Kapanış)
- **ReDoS (Regular Expression Denial of Service) Koruması:** Kullanıcı girdisi üzerinden beslenen Regular Expression (Regex) işlemlerinde daima bir *Timeout* tanımlanmalıdır. `TimeSpan.FromSeconds(2)` gibi makul bir kısıt vererek `RegexMatchTimeoutException` yakalamak, olası ReDoS (düzenli ifade ile servis dışı bırakma) saldırılarını veya işlemciyi kitleyecek döngüleri engeller.
- **Ternary Karmaşıklığı:** Javascript kodunda üçlü operatörlerin (ternary `? :`) veya elvis operatörlerinin (`?.`, `??`) çoklu/iç içe (nested) kullanılması, SonarQube gibi statik analiz araçlarında Cognitive Complexity puanını ciddi şekilde artırır. Olabildiğince düz, okuması kolay mantıksal kontroller kullanılmalıdır.

### Öğrenme Notu - JS Factory Complexity Management (FAZ 16 Kapanış)
- **Early-Return ve Parçalama:** Config-driven (konfigürasyona dayalı) çalışan factory metodları doğası gereği DOM manipülasyonu, API istekleri ve Validasyon işlerini aynı anda yapar. Bu durum "Cognitive Complexity" değerini inanılmaz derecede hızla şişirir (15 limitini aşar). Çözüm olarak form toplama (`getFormData`), modal içi doldurma (`populateForm`) ve HTML oluşturma (`buildCellHtml`) gibi saf işlevler bağımsız yardımcı metodlara çekilmeli ve ana flow içerisinde yalnızca bunlar çağrılmalıdır.
- **Empty-Catch Anti-Pattern:** Javascript asenkron operasyonlarında (örn. API hataları) catch bloğunun içinin boş bırakılması hata analizini imkansızlaştırır. Minimum standart olarak `console.error(err)` ve kullanıcıya UI bazlı geri bildirim (Toast/Alert) sunulmalıdır.

### Öğrenme Notu - Yapısal DRY ve "İkiz Sayfa" Tuzağı (FAZ 17 Kapanış)
- **Shell Enjeksiyonu (Structural DRY):** Modern web uygulamalarında `sidebar` ve `topbar` gibi yapısal (structural) HTML bloklarının her sayfada kopyalanması, bakım maliyetini ve SonarQube Duplication metriklerini patlatır. Bunları tek bir `layout.js` (veya server-side partial) üzerinden enjekte etmek, HTML dosyalarını sadece içerdikleri "iş mantığına" (main content) odaklayarak sayfa satır sayılarını devasa oranda düşürür.
- **İkiz Sayfalar (Twin Pages) Tuzağı:** "Departmanlar", "Gruplar", "Projeler" gibi sayfalar aslında veri yapısı dışında birbiriyle BİREBİR aynı olan ikiz sayfalardır. Bunları ayrı HTML dosyaları olarak tutmak ciddi bir mimari hatadır (Anti-Pattern). Bunları silip tek bir `admin-crud.html?type=X` yapısına geçmek ve bir `config registry` (`admin-configs.js`) üzerinden kolon ve form tanımlarını beslemek, duplication'ı tam anlamıyla sıfırlar ve uygulamanın genişletilebilirliğini artırır.

### Öğrenme Notu - EF Core Translation Hataları (Postgres)
- **StringComparison.OrdinalIgnoreCase:** Entity Framework Core (özellikle PostgreSQL provider'ı olan Npgsql), LINQ sorguları içerisinde yer alan `string.Equals(val1, val2, StringComparison.OrdinalIgnoreCase)` yapısını SQL'e çeviremez (Translation Error). Bunun yerine, `.ToLower() == .ToLower()` veya Npgsql'in `EF.Functions.ILike` operatörü kullanılmalıdır. Aksi halde kod derlenir ancak çalışma zamanında (Runtime) 500 Internal Server Error (InvalidOperationException) fırlatır.
