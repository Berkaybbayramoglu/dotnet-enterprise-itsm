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
