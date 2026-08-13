# Faz Planı ve Yaklaşımı

Geliştirme süreci, büyük ve karmaşık yapıyı yönetilebilir ve test edilebilir küçük parçalara bölmek için aşağıdaki fazlara ayrılmıştır. Bu belge projenin ana yol haritasıdır.

## FAZ 0 — Hazırlık, Ortam Kurulumu ve Araştırma
**Amaç:** Projeye başlamadan önce teknik ortamı hazırlamak ve ITSM domain’ini anlamak.
**Kapsam:** .NET, PostgreSQL, DBeaver, Git/Bitbucket, SonarQube hazırlığı, ITSM araçlarının (ServiceNow, Jira vb.) ve dinamik ITSM konfigürasyon yaklaşımının araştırılması, repository iskeleti ve temel dokümantasyon.
**Çıktılar:** Boş ama çalışan proje iskeleti, README.md, `docs/` klasörü (`agent_notlari.md`, `varsayimlar.md` dahil), araştırma notları, branch/commit stratejisi.
**Kabul Kriterleri:** Repository yapısı oluşmuş, temel dokümanlar yazılmış, geliştirme ortamı tanımlanmış, faz planı oluşturulmuş, agent notları ve varsayımlar kaydedilmiş olmalıdır.
**Dikkat Edilecekler:** Daha baştan büyük kod yazılmamalı, dokümantasyon sağlam başlatılmalı ve varsayımlar mutlaka kaydedilmelidir.

## FAZ 1 — Kapsam, Dinamik Model ve Mimari Tasarım
**Amaç:** Kod yazmadan önce sistemin dinamik yapısını netleştirmek.
**Kapsam:** Gereksinim analizi, dinamik kapsamın belirlenmesi, organizasyon modeli, yetki modeli, proje modeli, workflow modeli, form alanı stratejisi, ekran haritası ve üst seviye ERD tasarımı.
**Çıktılar:** Güncellenmiş `gereksinim.md`, `mimari.md`, `dinamik-kapsam.md`, `faz-plani.md`, `erd-taslak.md`, `git-stratejisi.md`, `varsayimlar.md`.
**Kabul Kriterleri:** Dinamik olacak/olmayacak yapılar netleştirilmiş, aynı gruptaki kişilere farklı yetki tasarımı yapılmış, en az 5 proje, Incident/Service Request süreçleri ve workflow tanımlanmış olmalıdır.
**Dikkat Edilecekler:** "Her şey dinamik olsun" denilerek kapsam şişirilmemeli, yetki modeli sadece grup bazlı bırakılmamalı, proje bazlı veri izolasyonu baştan tasarlanmalıdır.

## FAZ 2 — PostgreSQL Veritabanı Tasarımı
**Amaç:** Dinamik yapıyı taşıyabilecek sağlam bir veritabanı modeli kurmak.
**Kapsam:** Organizasyon, yetki, proje, konfigürasyon, dinamik form, ticket, SLA, bildirim, Knowledge Base ve audit tablolarının tasarımı ve seed data tasarımı.
**Çıktılar:** Güncellenmiş `erd-taslak.md`, migration planı, seed data planı, DBeaver’da yönetilebilir tablo yapısı.
**Kabul Kriterleri:** Doğru foreign key ilişkileri, esnek yetki modeli, izole edilebilir projeler, audit alanları, config tablolarında aktif/pasif yaklaşımı ve en az 5 projenin seed edilebilmesi.
**Dikkat Edilecekler:** Config kayıtları silinmek yerine pasife alınabilmeli, ticket numarası formatı tasarlanmalı, JSONB/EAV kararı gerekçelendirilmeli ve temel audit kolonları (CreatedAt vb.) unutulmamalıdır.

## FAZ 3 — Auth ve Esnek Yetkilendirme
**Amaç:** Sistemin güvenlik temelini kurmak.
**Kapsam:** Login, logout, password hashing, session/token yönetimi, roller, yetkiler, grup bazlı yetkiler, kullanıcı bazlı yetki override ve proje bazlı yetki kontrolü.
**Çıktılar:** Auth altyapısı, yetki kontrol mekanizması, login audit taslağı ve permission modeli.
**Kabul Kriterleri:** Yetkisiz işlem engeli, aynı gruptaki kullanıcılarda farklı yetki desteği, tam yetkili admin hesabı, backend seviyesinde yetki denetimi ve şifre hash'leme.
**Dikkat Edilecekler:** Yetki kontrolü yalnızca frontend'de kalmamalı, proje bazlı erişim unutulmamalı ve permission cache invalidate senaryoları düşünülmelidir.

## FAZ 4 — Admin Paneli ve Organizasyon Yapısı
**Amaç:** Tam yetkili Admin paneli şartını karşılamak ve dinamik organizasyon yapısını kurmak.
**Kapsam:** Departman, grup, kullanıcı, rol/yetki, proje ve proje üye yönetimi ile en az 5 projenin oluşturulması.
**Çıktılar:** Admin paneli, ilgili CRUD işlemleri ve proje/üye yönetimi arayüzleri/servisleri.
**Kabul Kriterleri:** Admin departman, grup, proje ekleyebilmeli; kullanıcıları gruplara atayabilmeli; yetkileri ayrıştırabilmeli ve projeleri bağımsız yönetebilmelidir.
**Dikkat Edilecekler:** Admin paneli gerçek CRUD işlemleri yapmalı, config değişiklikleri audit log'a düşmeli ve silme yerine pasife alma kuralı işletilmelidir.

## FAZ 5 — Dinamik ITSM Katalog ve Workflow Yapılandırması
**Amaç:** ITSM konfigürasyon katmanını kurmak.
**Kapsam:** Talep tipleri, kategoriler, durumlar, öncelikler, workflow tanımları, transition kuralları ve temel form tanımları.
**Çıktılar:** İlgili ayarlar için CRUD işlemleri ve workflow transition yönetimi.
**Kabul Kriterleri:** Admin yeni kategori ekleyebilmeli, proje bazlı workflow tanımlayabilmeli, durum geçişleri konfigüre edilebilmeli ve yetkisiz geçişler engellenebilmelidir.
**Dikkat Edilecekler:** Geçişler herkese açık olmamalı, kullanılan durum silinmemeli, workflow değişiklikleri audit log'a düşmeli ve "Beklemede" durumunun SLA etkisi planlanmalıdır.

## FAZ 6 — Dinamik Ticket Çekirdeği
**Amaç:** Dinamik konfigürasyonla çalışan ticket temelini üretmek.
**Kapsam:** Ticket oluşturma, listeleme, detay görüntüleme, dinamik form render, status transition, ticket history ve numara üretimi.
**Çıktılar:** Dinamik ticket formları, liste/detay ekranları, geçmiş (history) yönetimi ve proje bazlı izolasyon.
**Kabul Kriterleri:** Incident/Service Request oluşturulabilmeli, kategori/projeye göre form dinamik değişmeli, proje bazlı izole çalışmalı, numara benzersiz olmalı ve history oluşmalıdır.
**Dikkat Edilecekler:** Form render aşamasında XSS koruması ve backend validation zorunludur; soft delete tercih edilmeli ve eski ticket/eski config ilişkisi kopmamalıdır.

## FAZ 7 — Atama, Transfer, Yorum, Dosya ve Timeline
**Amaç:** Ticket’ı gerçek ITSM operasyon akışına uygun hale getirmek.
**Kapsam:** Atama (grup/kullanıcı), transfer, internal note, public reply, dosya ekleme, timeline ve watcher listesi.
**Çıktılar:** Atama arayüzü, transfer akışı, yorum paneli, attachment yönetimi, timeline ve watcher işlemleri.
**Kabul Kriterleri:** Yalnızca yetkililer atama yapabilmeli, transfer kayıtları tutulmalı, internal/public note ayrımı çalışmalı, dosya yükleme güvenli olmalı ve timeline kronolojik sıralanmalıdır.
**Dikkat Edilecekler:** Dosyalar web root'ta açıkta kalmamalı, MIME type/extension kontrolü yapılmalı ve internal comment'in müşteriye sızması engellenmelidir.

## FAZ 8 — SLA, İş Takvimi ve Bildirimler
**Amaç:** SLA ve bildirim mekanizmasını kurmak.
**Kapsam:** SLA politikaları (First Response, Resolution), mesai saatleri, tatiller, duraklatma (pause/resume), uyarılar, in-app ve email bildirimleri, bildirim kuralları.
**Çıktılar:** SLA politikası/takvim config sayfaları, hesaplama motoru, bildirim servisi ve in-app merkezi.
**Kabul Kriterleri:** SLA'ler tatil/mesai gözetilerek doğru hesaplanmalı, ihlal uyarıları çalışmalı, doğru kişiye bildirim gitmeli ve mükerrer bildirim engellenmelidir.
**Dikkat Edilecekler:** Timezone net olmalı, background job mimarisi doğru kurulmalı ve SLA sonuçları raporlara kaynak olacak şekilde veritabanında tutulmalıdır.

## FAZ 9 — Dashboard, Raporlama, Arama ve Knowledge Base
**Amaç:** Sistemin yönetilebilirlik ve görünürlük katmanını güçlendirmek.
**Kapsam:** Dashboard, grafikler, gelişmiş arama/filtreleme, report export ve rol bazlı Knowledge Base modülü (kategori ve makaleler).
**Çıktılar:** Dashboard arayüzleri, raporlama motoru, arama sistemi ve Knowledge Base yönetimi.
**Kabul Kriterleri:** Dashboard verileri gerçek olmalı, filtreleme çalışmalı, KB rol tabanlı görünmeli ve arama performansı tatmin edici olmalıdır.
**Dikkat Edilecekler:** Dashboard SQL sorguları optimize edilmeli, KB'de internal/public ayrımı netleşmeli ve kategoriler dinamik yönetilebilmelidir.

## FAZ 10 — Gelişmiş Dinamik Yapılandırma
**Amaç:** Projeyi farklılaştıran dinamik yapılandırma katmanını olgunlaştırmak.
**Kapsam:** Custom fields, form layout, validation engine, assignment/notification rule engines, kaydedilmiş filtreler, multi-language vb.
**Çıktılar:** İlgili rule engine'lerin ve yapılandırma ekranlarının geliştirilmesi.
**Kabul Kriterleri:** Admin kod değişikliği olmadan ticket formu/alanları düzenleyebilmeli, validasyon ve otomatik kurallar sorunsuz çalışmalıdır.
**Dikkat Edilecekler:** Admin raw code girememeli, alan tipleri kısıtlı (whitelist) olmalı ve cache invalidation titizlikle yönetilmelidir.

## FAZ 11 — Bonus / Advanced ITSM Özellikleri
**Amaç:** Dokümandaki bonus maddelerini tamamlamak ve projeyi daha güçlü hale getirmek.
**Kapsam:** E-posta entegrasyonu, dosya, audit log vb. zorunlu bonusların olgunlaşması. (İsteğe bağlı Problem/Change mgmt, CSAT, Kanban, Webhooks vb.)
**Çıktılar:** Bonus özelliklerin ana akışı bozmadan entegre edilmesi.
**Kabul Kriterleri:** Tüm bonuslar (özellikle audit, responsive, çoklu dil, atama otomasyonu) ana MVP çekirdeğini bozmadan stabil çalışmalıdır.
**Dikkat Edilecekler:** Karmaşık özellikler MVP'yi riske etmemeli, her bonus feature branch ile yapılmalıdır.

## FAZ 12 — Kalite, Test, Güvenlik, README ve Demo
**Amaç:** Projeyi sunulabilir, savunulabilir ve sürdürülebilir hale getirmek.
**Kapsam:** SonarQube incelemesi/temizliği, birim/entegrasyon testleri, güvenlik/performans kontrolleri, final README ve demo hazırlığı.
**Çıktılar:** Temiz SonarQube raporu, test senaryoları, güvenlik onaylı sürüm, demo akışı ve final agent notları.
**Kabul Kriterleri:** Kritik bug/yetki açığı olmamalı, README ile uygulama ayağa kalkabilmeli ve demo uçtan uca çalışmalıdır.
**Dikkat Edilecekler:** Bu aşamada büyük kod/feature eklenmemeli, stabilizasyona ve açıklanabilirliğe odaklanılmalıdır.
- Coverage koşulu bilinçli kaldırıldı/indirildi; Faz 12'de test olgunlaşınca geri eklenecek.
