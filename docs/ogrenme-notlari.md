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
