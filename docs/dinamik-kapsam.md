# Dinamik Yapılandırma Kapsamı

Projenin temel amacı, koda gömülü iş kurallarını en aza indirerek "Configuration-driven" bir ITSM ortamı sunmaktır. Bu sayede yazılım geliştiricilere ihtiyaç duymadan sistem yöneticileri süreçleri yapılandırabilecektir.

## Dinamik Olacak Bileşenler (Veritabanı Yönetimli)
- **Departmanlar ve Gruplar:** Şirket organizasyon yapısının tanımlanması.
- **Kullanıcılar, Roller ve Yetkiler:** Sınırsız sayıda rol tanımı ve ince ayarlı yetki izinleri.
- **Projeler:** Farklı süreçlerin izolasyon alanları.
- **Kategoriler ve Talep Tipleri:** Incident, Service Request veya kuruma özel başka talep tipleri.
- **Durumlar (Statuses):** Açık, İşlemde, Onay Bekliyor vb. custom durumlar.
- **Workflow (Durum Geçişleri):** Hangi durumdan hangi duruma geçilebileceğinin tanımlanması (Örn: "Açık" durumundan direkt "Kapatıldı" durumuna geçilemez kuralı).
- **Öncelikler (Priorities):** İsteğe bağlı renk kodu ve ağırlığı olan öncelik tanımları.
- **Form Alanları (Custom Fields):** İlgili kategoriye veya talep tipine özel ekstra veri giriş alanları (Örn: "Sunucu talebi" için CPU/RAM alanları).
- **Atama Kuralları:** Belirli kategorilerde doğrudan belirli gruplara bilet atanması.
- **SLA Politikaları:** Yanıt ve çözüm sürelerinin, tatil günleri de hesaba katılarak dinamik tanımlanması.
- **Bildirim Kuralları:** Hangi eylemde, kime, hangi kanalla bildirim gideceğinin ayarlanması.
- **Knowledge Base Kategorileri:** Bilgi bankasının hiyerarşik yapısı.

## Dinamik Olmayacaklar (Bilinçli Kapsam Dışı)
Sistemi aşırı karmaşıklaştırmamak ve performans/güvenlik sorunlarından kaçınmak için aşağıdaki konular dinamik yapıya *dahil edilmeyecektir*:

- **Tam Page Builder:** Adminin sürükle-bırak yöntemiyle sıfırdan ekran/sayfa tasarlaması.
- **Raw Code Injection:** Admin paneli üzerinden sisteme raw HTML/CSS veya JavaScript kodu gömülmesi.
- **Sınırsız Custom Widget:** Dashboard üzerinde tamamen custom kod ile çalışan widget oluşturma yeteneği (Sistem belirli sayıda predefined widget sunar, admin bunların yerini ve konfigürasyonunu değiştirir).
- **Çok Karmaşık Low-Code Davranışları:** Gelişmiş betik dilleri ile sistemin backend iş mantığını doğrudan değiştiren aksiyonlar.

## Neden Dinamik Yapı?
Kurum içindeki farklı departmanlar (örneğin İK, IT, İdari İşler) kendi talep süreçlerini kullanmak istediklerinde her biri için kod tarafında yeni tablolar, enum'lar veya sayfalar üretmek sistemin bakımını imkansız hale getirir. Dinamik yapı, uygulamanın tek bir kod tabanıyla birçok farklı iş sürecini izole bir şekilde yürütmesine olanak tanır.
