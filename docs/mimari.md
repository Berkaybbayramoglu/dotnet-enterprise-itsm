# Mimari Yaklaşım

Proje, kurumsal ölçekli bir uygulamaya uygun, bakımı kolay ve test edilebilir bir yapı sunmak amacıyla **Katmanlı Mimari (Layered/Clean Architecture)** prensiplerine dayanmaktadır.

## Katmanların Sorumlulukları

1. **Domain (ItsTool.Domain):** 
   Sistemin çekirdek varlıklarını (Entities), Base interfaceleri (`IAuditable`, `ISoftDelete`) barındırır. Hiçbir dış kütüphaneye veya framework'e (EF Core dahil) bağımlılığı yoktur. Saf iş modellerini (POCO) içerdiği için tamamen state ve navigasyon özelliklerinden ibarettir.
   *EAV Tasarımı:* Custom alanlar (Özel alanlar) için EAV (Entity-Attribute-Value) modeli seçilmiştir. Bunun temel sebebi statik tablo yapısına dokunmadan limitsiz özellik tanımı yapabilmek ve ileride filtreleme/raporlama tarafını standartlaştırabilmektir.

2. **Application (ItsTool.Application):** 
   Şu an için klasörleri (DTOs, Interfaces, Services) oluşturulmuş ancak boştur. İlerleyen fazlarda iş mantığı, Mapping profilleri, Validator'ler ve servis arayüzleri burada yer alacaktır. Altyapıdan tamamen bağımsızdır.

3. **Infrastructure (ItsTool.Infrastructure):** 
   Veri erişim katmanıdır. `ItsToolDbContext` (EF Core) ve Configuration sınıflarını barındırır. Domain katmanındaki Entity'lerin PostgreSQL tablolarına nasıl eşleşeceğini yönetir. (Npgsql kullanmaktadır). Migration'lar bu katmanda yaşar.

4. **API (ItsTool.API):** 
   ASP.NET Core Web API projesidir. Şu an sadece sistemin ayakta olduğunu belirten `/api/health` endpoint'ini barındırır. İleride Controller'lar ve Auth middleware'leri buraya eklenecektir.

5. **Web/UI (ItsTool.Web):** 
   Frontend projesidir. Şu an sadece bir placeholder (`index.html`) barındırır. İstenildiği üzere SPA (React vb.) yerine vanilla HTML, CSS ve JavaScript kullanılarak inşa edilecektir.

## Veri Erişimi, İzolasyon ve Dinamik Yapı
- **Veritabanı:** PostgreSQL ve Entity Framework Core.
- **Veri İzolasyonu:** Tüm Ticket ve Config işlemleri ProjectId'ye bağlı çalışır.
- **Dinamik Yapı:** Koda sabitlenmiş enum'lar (Status, Priority) yerine Admin panelden yönetilen tablolar (TicketType, Status) kullanılmıştır. Durum geçişleri bile `WorkflowTransitions` tablosuyla veritabanı kontrollüdür.
