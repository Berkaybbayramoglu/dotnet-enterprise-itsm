# ITSM Tool (Staj Projesi)

## Proje Hakkında
Farklı iş birimlerinin IT talep ve sorunlarını yönetebileceği, çok projeli, dinamik olarak yapılandırılabilir, yetkilendirmesi esnek, gerçek ITSM süreçlerine uygun bir web uygulamasıdır.

---

## 🔗 Doküman Uyumluluk Eşlemesi (Compliance Mapping)

Bu proje staj gereksinimleri doğrultusunda geliştirilmiş olup, maddelerin karşılıkları aşağıdadır:

| Doküman Maddesi | Özellik / Karşılık |
| :--- | :--- |
| **3.1** Tam Yetkili Admin Paneli | Tüm yönetim işlemleri sol menüdeki "Administration" altındaki sayfalardan (Projects, Groups, Rules, vb.) yapılabilir. |
| **3.2** Gruplar ve Yetkiler | 5 Proje, 4 Grup tohumlanmıştır (DataSeeder). `Roles` ve Claim tabanlı `Permissions` (override) ile aynı roldeki kişilere farklı yetki verilebilir. |
| **3.3** Proje Bazlı Akış | Biletler proje ve kategoriye göre dinamik form alanları (DynamicFields) ve kurallar (Rules) alır. |
| **3.4** ITSM Döngüsü | Incident/Request ayrımı; Açık, Beklemede (SLA Durdurur), Çözüldü, Kapalı durumları; Kritik'ten Düşüğe öncelikler; **Transfer** yeteneği; Dashboard raporlaması ve Bilgi Bankası (KB) aktiftir. |
| **4.1** Git & Branch | Bitbucket üzerinde barındırılmaktadır (Sık ve anlamlı commitler). |
| **4.2** SonarQube | Mimari buna uygun tasarlanmış, entegrasyon hedeflenmiştir. |
| **4.3** PostgreSQL & DBeaver | İlişkisel ve EAV karma yapısı (EF Core) PostgreSQL üzerinde kurgulanmıştır. |
| **5 (Bonus)** | SLA uyarıları, Webhook bildirimleri, In-App (SignalR) bildirim, Dashboard (Grid/Grafik/Drill-Down), Responsive UI (Mobil Uyumluluk) desteklenmektedir. Çoklu dil (TR/EN) altyapı olarak planlanmış olup MVP'de varsayılan TR kullanılmıştır (Bkz: `docs/varsayimlar.md`). |
| **6** README | Kurulum, Demo Hesaplar ve Mimari açıklamaları bu dosyada yer almaktadır. |

---

## 🛠 Kullanılan Teknolojiler
- **Backend:** .NET 8 LTS (ASP.NET Core Web API)
- **Veritabanı:** PostgreSQL (Entity Framework Core)
- **Frontend:** Vanilla HTML, CSS, JavaScript (Framework Kullanılmamıştır)
- **Versiyon Kontrol:** Git & Bitbucket

---

## 🚀 Kurulum ve Çalıştırma

### 1. Gereksinimler
- .NET 8 SDK
- PostgreSQL Server
- Git

### 2. Veritabanı Hazırlığı
PostgreSQL'de `itsm_tool` adında boş bir veritabanı oluşturun ve `src/ItsTool.API/appsettings.Development.json` dosyasındaki ConnectionString'i kendi şifrenize göre ayarlayın.

### 3. Uygulamayı Başlatma
Projenin kök dizininde bir terminal açın ve aşağıdaki komutu çalıştırarak her iki projeyi de (API ve Web) başlatın:

```bash
# API'yi başlat (Veritabanı otomatik olarak oluşturulur ve tohumlanır / AutoSeed)
dotnet run --project src/ItsTool.API

# Başka bir terminalde Web arayüzünü başlat
dotnet run --project src/ItsTool.Web
```
> **Not:** API projesi çalışırken `DataSeeder.cs` otomatik olarak 5 Proje, 4 Grup, Rol matrisleri ve örnek kullanıcıları veritabanına ekler (Development ortamı için).

---

## 🔑 Demo Hesaplar
Sistem tohumlandığında (seed) aşağıdaki kullanıcılar otomatik olarak oluşturulur. **Tüm şifreler:** `123456`

- **SuperAdmin:** `admin` (Tüm yetkiler)
- **Manager:** `manager` (Rapor, Yönetim, KB yetkileri)
- **Agent 1:** `agent1` (Standart Temsilci)
- **Agent 2:** `agent2` (Agent 1 ile aynı rol, ancak `ticket.close` yetkisi "Override" ile eklenmiş)
- **End User:** `user1` (Sadece kendi biletlerini görür, anket doldurabilir)

---

## 📸 Ekran Görüntüleri

*Not: Görseller `screenshots/` klasörüne eklenecektir.*

- **Dashboard:** `![Dashboard Placeholder](screenshots/dashboard.png)`
- **Kanban Panosu:** `![Kanban Placeholder](screenshots/kanban.png)`
- **Bilet Detayı & Transfer:** `![Ticket Detail Placeholder](screenshots/ticket_detail.png)`
- **Admin Ekranları (Projeler):** `![Admin Projects Placeholder](screenshots/admin_projects.png)`

---

## 📚 Geliştirici Belgeleri
- `docs/agent_notlari.md`: Geliştirme süreci ve faz günlüğü.
- `docs/ogrenme-notlari.md`: Teknik kararlar, responsive ve UX notları.
- `docs/varsayimlar.md`: i18n Kararı gibi mimari varsayımlar.
