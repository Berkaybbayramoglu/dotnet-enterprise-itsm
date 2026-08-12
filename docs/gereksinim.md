# Proje Gereksinimleri

Bu doküman, projede beklenen temel ITSM özelliklerini ve opsiyonel bonusları tanımlar.

## Zorunlu Gereksinimler

1. **Tam Yetkili Admin Paneli:** Sistemin tamamının (projeler, kullanıcılar, workflow) yönetilebildiği bir arayüz.
2. **Gruplar:** Farklı iş birimlerini (Yazılım, Sistem, Destek, vb.) temsil eden gruplar.
3. **Yetkilendirme ve Kullanıcılar:** 
   - Her grubun kullanıcıları olmalı.
   - Her kullanıcının farklı yetkileri olabilmeli.
   - Aynı gruptaki iki kişi tamamen farklı yetkilere sahip olabilmeli (örn: Biri sadece ticket açar, diğeri atama yapar).
4. **Çoklu Proje Desteği (En az 5 proje):**
   - Her projenin kendine ait talep akışı, kategorileri ve atama kuralları olmalı.
   - Projeler birbirinden tamamen bağımsız yönetilebilmeli.
5. **ITSM Süreçleri:**
   - Incident Management (Olay Yönetimi)
   - Service Request Management (Hizmet Talep Yönetimi)
6. **Talep Yönetimi ve Yaşam Döngüsü:**
   - Talep Durumları (Açık, Devam Ediyor, Beklemede, Çözüldü, Kapatıldı vb.)
   - Talep Önceliklendirme (Kritik, Yüksek, Orta, Düşük)
   - Talep Atama ve Transfer mekanizması.
7. **SLA (Service Level Agreement) Takibi:** Süreç hedeflerinin belirlenip aşım durumlarının izlenmesi.
8. **Dashboard / Raporlama:** Taleplerin durumlarını ve sistemdeki yoğunluğu gösteren özet paneller.
9. **Bildirim Mekanizması:** Sistem içi bildirimler.
10. **Knowledge Base (Bilgi Bankası):** Kullanıcıların kendi sorunlarını çözmesine yardımcı olacak makale altyapısı.
11. **Geliştirme Disiplini:**
    - Git & Bitbucket kullanımı (küçük, anlamlı, sık commitler).
    - SonarQube ile kod kalite takibi (code smell ve güvenlik).
    - PostgreSQL ve DBeaver kullanımı.
12. **AI Kullanımı ve Açıklanabilirlik:** AI tarafından yazılan tüm kod, alınan tüm kararlar açıklanabilir olmalı ve takım tarafından sahiplenilmelidir.

## Opsiyonel / Bonus Özellikler

- E-posta entegrasyonu (Talep oluşturulduğunda/güncellendiğinde bildirim)
- Dosya ekleme (Ekran görüntüsü vb. attachment)
- Grafiksel dashboard (Talep istatistiklerini görselleştirme)
- Arama & Filtreleme (Gelişmiş sorgulama)
- Audit Log (Kim, ne zaman, ne yaptı - değişiklik tarihçesi)
- Talep üzerine yorum/mesajlaşma (Talep detayında iletişim akışı)
- Responsive tasarım (Mobil uyumlu arayüz)
- Otomatik atama kuralları (Kategoriye göre belirlenen ekibe/kişiye atama)
- SLA ihlal uyarıları (Süre aşımına yaklaşınca veya geçildiğinde uyarı mekanizması)
- Çoklu dil desteği (Türkçe / İngilizce)
