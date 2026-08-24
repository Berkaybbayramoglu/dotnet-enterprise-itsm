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
