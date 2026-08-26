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
