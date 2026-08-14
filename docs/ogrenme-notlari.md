# ITSM Projesi Öğrenme ve Geliştirme Notları

## Faz 8: Dashboard, Raporlama, Arama & Filtreleme, Knowledge Base
**Kavram:** Entity Framework Core In-Memory Testleri ve `IQueryable` Davranış Farklılıkları
**Basit Açıklama:** Unit testlerde kullanılan In-Memory provider, SQL'e dönüştürülen LINQ sorgularını (örneğin `.ToLower().Contains()`) client-side (bellekte) çalıştırır. Eğer veritabanında "required" (zorunlu) ilişkiler tanımlandıysa (örneğin foreign key olan bir alan nullable değilse), EF Core bu ilişkiyi `INNER JOIN` olarak algılar. Test verisi oluştururken ilişkili entity'leri (Category, Type, Priority) DB'ye eklemezseniz, In-Memory testlerde dahi `Include` veya Navigation Property sorguları (INNER JOIN nedeniyle) ana kaydı getirmez ve testler gizlice başarısız olur.
**Projede Nerede:** `ReportServiceTests.cs` (ExportTicketsToCsvAsync) ve `TicketService.cs` (SearchTicketsAsync)
**Mentor Sorarsa Cevabın:** "Raporlama servislerini test ederken In-Memory veritabanının required (zorunlu) foreign key'ler için INNER JOIN mantığında çalıştığını fark ettim. Test ortamında Ticket oluştururken Category, Type, Priority gibi zorunlu ilişkili tabloları mock olarak doldurmadığımız için `Include` yapıldığında kayıtlar eşleşmiyor ve filtreye takılıyordu. Test verilerini (Category, Type, vb.) context'e ekleyerek bu sorunu çözdüm ve `NullReferenceException`'ları engelledim. Ayrıca frontend tarafında API entegrasyonu için Fetch API kullanarak `api.js` wrapper class'ı oluşturdum."

