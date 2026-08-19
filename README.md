# ITSM Tool

## Proje Hakkında
Farklı iş birimlerinin IT talep ve sorunlarını yönetebileceği, çok projeli, dinamik olarak yapılandırılabilir, yetkilendirmesi esnek, gerçek ITSM süreçlerine uygun bir web uygulamasıdır.

## Kullanılan Teknolojiler
- **Backend:** .NET 8 LTS (ASP.NET Core Web API)
- **Veritabanı:** PostgreSQL
- **DB Yönetim Aracı:** DBeaver
- **ORM:** Entity Framework Core (Npgsql)
- **Frontend:** Vanilla HTML, CSS, JavaScript
- **Versiyon Kontrol:** Git & Bitbucket
- **Kod Kalite Analizi:** SonarQube

## Öne Çıkan Özellikler (MVP)
- **Dinamik Bilet Yönetimi:** Özel form alanları, projeler ve kategoriler.
- **Otomatik Atama Kuralları:** Biletleri belirli koşullara göre gruplara veya kullanıcılara atama (Aktif/Pasif Rule Toggle).
- **SLA & Webhook:** SLA süre takibi ve dış sistemlere (ör. Slack/Discord) bildirim.
- **Kanban Panosu:** Sürükle bırak ile durum değiştirme. *Not: Kapalı (Closed) talepler panoda gizlenir; Tickets ve raporlarda arşivlenerek saklanır.*
- **Audit Logging:** Hem bilet yaşam döngüsü (history) hem de sistem ayarlarının (admin/config) detaylı izlenebilirliği.

## Solution Yapısı
```text
itsm-tool/
├── src/
│   ├── ItsTool.API/             # Web API Katmanı (Endpoint'ler, Middleware)
│   ├── ItsTool.Application/     # İş Mantığı, Servisler, DTO'lar
│   ├── ItsTool.Domain/          # Domain Entity'leri (Core)
│   ├── ItsTool.Infrastructure/  # EF Core DbContext, Veri Erişimi
│   └── ItsTool.Web/             # Vanilla HTML/CSS/JS Frontend
├── tests/                       # Unit ve Integration testleri
├── docs/                        # Proje Dokümantasyonu (Agent Notları dahil)
├── README.md
├── ItsTool.sln
└── .gitignore
```

## Gereksinimler
- .NET 8 SDK
- PostgreSQL
- DBeaver
- Git
- SonarQube (İsteğe bağlı / ilerleyen aşamada)

## Kurulum Adımları
1. Repository'yi klonlayın.
2. PostgreSQL servisini başlatın.
3. API dizinindeki `appsettings.Development.json` dosyasında connection string parolasını kendinize göre düzenleyin.

## Veritabanı Oluşturma Adımları
1. DBeaver (veya pgAdmin) üzerinden PostgreSQL'e bağlanın.
2. `itsm_tool` adında boş bir veritabanı oluşturun.

## Migration Komutları
Solution dizininde (.sln dosyasının olduğu yerde) terminal açarak aşağıdaki komutları kullanabilirsiniz:

```bash
# İlk migration dosyasını oluşturmak için:
dotnet ef migrations add InitialCreate --project src/ItsTool.Infrastructure --startup-project src/ItsTool.API

# Migration'ları veritabanına uygulamak için (Şu an için çalıştırılmayacaktır):
dotnet ef database update --project src/ItsTool.Infrastructure --startup-project src/ItsTool.API
```

## Çalıştırma
**API Projesini Çalıştırmak İçin:**
```bash
dotnet run --project src/ItsTool.API
```
Health endpoint kontrolü için tarayıcıda veya Postman üzerinden: `http://localhost:5000/api/health` adresine istek atın. Status: OK dönmelidir.

**Veritabanını Seed Etmek İçin:**
Swagger (ör. `http://localhost:5000/swagger`) üzerinden veya Postman ile `POST /api/system/seed` endpoint'ini çalıştırın. Bu işlem, ilk admin kullanıcısını ve varsayılan durum/kategori gibi verileri veritabanına ekler. Veritabanı bağlantısını test etmek için `GET /api/system/db-test` endpoint'ini kullanabilirsiniz.

**Web Projesini Çalıştırmak İçin:**
```bash
dotnet run --project src/ItsTool.Web
```

## Agent Notları ve Varsayım Dosyalarının Amacı
- `docs/agent_notlari.md`: Geliştirme sürecinin aktif fazını, günlüğünü ve bir sonraki adımını tutar.
- `docs/varsayimlar.md`: Proje süresince alınan kritik mimari/tasarım kararlarını izler ve onay sürecini kaydeder.

**Bir Sonraki Adım:**
Faz 2B kapsamında, Dinamik konfigürasyon entity'lerinin (Workflow, FieldDefinition vb.) Domain katmanına eklenmesi.
