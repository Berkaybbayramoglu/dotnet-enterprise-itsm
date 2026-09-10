<div align="center">

# ⚡ ITSM Tool — Enterprise IT Service Management Suite

[![.NET 8](https://img.shields.io/badge/.NET-8.0%20LTS-512BD4?style=for-the-badge&logo=dotnet&logoColor=white)](https://dotnet.microsoft.com/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-336791?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![SonarQube](https://img.shields.io/badge/SonarQube-PASSED%20(A)-4E9BCD?style=for-the-badge&logo=sonarqube&logoColor=white)](http://localhost:9000)
[![CI Pipeline](https://img.shields.io/badge/CI-GitHub%20Actions-2088FF?style=for-the-badge&logo=githubactions&logoColor=white)](.github/workflows/ci.yml)
[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?style=for-the-badge&logo=docker&logoColor=white)](docker-compose.yml)
[![Unit Tests](https://img.shields.io/badge/Unit%20Tests-358%20Passed-22C55E?style=for-the-badge&logo=checkmarx&logoColor=white)](tests/ItsTool.UnitTests)
[![Coverage](https://img.shields.io/badge/Code%20Coverage-85.34%25-success?style=for-the-badge&logo=codecov&logoColor=white)](tests/ItsTool.UnitTests)
[![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)](LICENSE)

<p align="center">
  <b>Modern, modüler, yapay zeka destekli ve kurumsal ITIL süreçleriyle tam uyumlu yeni nesil BT Hizmet Yönetimi (ITSM) Platformu.</b>
  <br />
  <i>Clean Architecture • Entity-Attribute-Value (EAV) Dinamik Formlar • AI Resolution Copilot • Gerçek Zamanlı SignalR • Dinamik SLA Motoru</i>
</p>

[Özellikler](#-öne-çıkan-özellikler) • [Mimari](#-sistem-mimarisi) • [AI / LLM Mimarisi](#-yapay-zeka-ai--llm-copilot-mimarisi) • [Test & SonarQube](#-kod-kalitesi--sonarqube) • [Kurulum](#-hızlı-kurulum) • [Demo Hesaplar](#-demo-hesaplar) • [API Dokümantasyonu](#-api-mimarisi--başlıca-endpointler)

---

</div>

## 🌟 Öne Çıkan Özellikler

| Kategori | Yetenek & Açıklama |
| :--- | :--- |
| 🤖 **AI Resolution Copilot** | Bilet geçmişi, kullanıcı yorumları ve benzer biletleri analiz ederek **otomatik çözüm önerileri**, **taslak yanıtlar**, **makale eşleştirmeleri** ve **akıllı devir (handoff)** özetleri üretir. |
| ⏱️ **Dinamik SLA Motoru** | Öncelik ve proje bazlı özelleştirilebilir ilk yanıt & çözüm süreleri; bekleme durumunda (`On Hold`) otomatik sayaç durdurma; mesai saati hesaplaması ve **ihlal öncesi proaktif eskalasyon uyarıları**. |
| 📋 **EAV Dinamik Form Motoru** | Kod değişikliği gerektirmeden proje ve kategori bazlı özel alan tanımlama (Metin, Sayı, Tarih, Açılır Liste, Çoklu Seçim). |
| 🔄 **Durum Makinesi & İş Akışları** | ITIL uyumlu Incident / Request yaşam döngüsü; admin panelinden dinamik olarak yönetilen durum geçiş kuralları (`WorkflowTransitions`). |
| 🛡️ **Gelişmiş Yetkilendirme (RBAC+)** | Rol Tabanlı Erişim Kontrolü (RBAC) üzerine inşa edilmiş, kullanıcı bazında tekil izin ekleme/çıkarma sağlayan **Claim Override** mimarisi. |
| ⚡ **Gerçek Zamanlı İletişim (SignalR)** | Bilet atamaları, durum güncellemeleri, SLA uyarıları ve `@bahsetme` bildirimleri anlık olarak tarayıcıya iletilir. |
| 📊 **Yönetici Paneli & Analitik** | KPI kartları, SLA uyum grafikleri, departman/teknisyen iş yükü ısı haritaları, filtreleme ve CSV/PDF dışa aktarma. |
| 🔍 **Bilgi Bankası (KB)** | Sıkça sorulan sorular, kategori hiyerarşisi, zengin içerikli makaleler, görüntülenme sayaçları ve onay mekanizması. |
| 🎨 **Zero-Bloat Vanilla UI** | Ağır JS framework'leri olmadan ultra hızlı çalışan, responsive, **Dark / Light tema** ve **TR / EN çoklu dil** destekli modern arayüz. |

---

## 🛠️ Detaylı Teknoloji Yığını (Tech Stack)

| Alan | Teknoloji & Kütüphane | Kullanım Amacı & Mimari Rolü |
| :--- | :--- | :--- |
| **Backend** | **.NET 8 (C# 12)** / ASP.NET Core | Yüksek performanslı, asenkron ve modüler RESTful API mimarisi |
| **Veritabanı & ORM** | **PostgreSQL 16** / **EF Core 8** (Npgsql) | İlişkisel veri saklama, Code-First migration'lar, Transaction & Interceptor desteği |
| **Gerçek Zamanlı İletişim** | **ASP.NET Core SignalR** | Bilet atama, durum değişikliği ve SLA uyarılarının istemcilere anlık push edilmesi |
| **Yapay Zeka (AI)** | **Multi-Agent AI Copilot (LLM)** | Geçmiş çözülmüş biletleri ve KB makalelerini analiz ederek çözüm önerisi ve taslak yanıt üretimi |
| **Frontend** | **Vanilla JS (ES6+ Modules)**, HTML5, CSS3 | Sıfır bağımlılık şişkinliği (zero-bloat), ultra hızlı render, Dark/Light tema ve i18n dil sözlüğü |
| **Grafik & Görselleştirme** | **Chart.js** & **Bootstrap 5 (Grid/Modal)** | Yönetici dashboard'unda KPI, SLA uyum ve bilet dağılım grafiklerinin dinamik çizimi |
| **Konteynerizasyon** | **Docker** & **Docker Compose** | Multi-stage build ile hafif üretim imajları ve tek komutla izole PostgreSQL orkestrasyonu |
| **Sürekli Entegrasyon (CI)**| **GitHub Actions** | Push ve PR'larda otomatik Ubuntu ortamı kurulumu, derleme ve test doğrulama |
| **Birim Testleri** | **xUnit**, **Moq**, **Coverlet** | 358 birim testi ve %85.34 satır kapsamı (Line Coverage) |
| **Statik Kod Analizi** | **SonarQube** | 0 Bug, 0 Güvenlik Açığı, 0 Code Smell ile tam Kalite Kapısı (Quality Gate) onayı |
| **API Dokümantasyonu** | **Swagger / OpenAPI (Swashbuckle)** | JWT Bearer kimlik doğrulaması destekli interaktif API test arayüzü |
| **Güvenlik** | **JWT & Claim Override (RBAC+)** | PBKDF2 parola tuzlama, kullanıcı bazlı tekil izin ezme, ReDoS önleyici Regex zaman aşımları |

---

## 💡 Nasıl Yapıldı? (Mimari ve Tasarım Tercihleri)

1. **Clean Architecture (Onion Mimarisi):**
   - Bağımlılıklar daima dıştan içe (Domain <- Application <- Infrastructure <- API) doğrudur.
   - `ItsTool.Domain` tamamen saf C# POCO nesneleridir, hiçbir harici veritabanı kütüphanesine bağımlı değildir. Bu sayede iş mantığı teknolojiden bağımsız kalır.
2. **EAV (Entity-Attribute-Value) Dinamik Form Motoru:**
   - Farklı projeler (örn. İK için "Çalışan Departmanı", Yazılım için "Git Commit Hash") farklı alanlar gerektirir. Veritabanında her seferinde tablo değiştirmek yerine EAV deseni uygulanarak admin panelinden anlık yeni form alanları tanımlanabilir.
3. **Dinamik Durum Makinesi (Workflow State Machine):**
   - "Açık" bileti kimler "Çözüldü" yapabilir? Bu kurallar C# koduna hardcode edilmemiştir. `WorkflowTransitions` tablosu üzerinden dinamik olarak yapılandırılır ve doğrulanır.
4. **Kesintisiz Arka Plan Görevleri (Hosted Background Services):**
   - `SlaCheckerService`: Her dakika arka planda çalışarak süresi dolmak üzere olan veya ihlal edilen biletleri tespit eder, SignalR üzerinden ilgili teknisyenlere sesli/görsel uyarı gönderir.
   - `EmailBackgroundService`: E-posta gönderimlerini ana thread'i bloke etmeden `InMemoryEmailQueue` üzerinden asenkron tüketir.
5. **Otomatik Denetim İzi (SystemAuditInterceptor):**
   - EF Core Change Tracker'a bağlanan interceptor, herhangi bir bilet veya kullanıcı güncellendiğinde hangi alanın eski değerinin ne olduğunu, yeni değerinin ne olduğunu ve işlemi kimin yaptığını `SystemAuditLogs` tablosuna yazar.

---

## 🏛️ Sistem Mimarisi

Proje, **Clean Architecture (Onion Architecture)** prensiplerine tam sadık kalınarak katmanlar arası gevşek bağlılık (loose coupling) ve yüksek test edilebilirlik hedefiyle inşa edilmiştir:

```mermaid
graph TD
    subgraph UI ["Client Layer (Vanilla SPA)"]
        HTML["Responsive HTML5 / CSS3"]
        JS["Modular Vanilla JS (API Client, UI, SignalR)"]
    end

    subgraph API ["Presentation Layer (ItsTool.API)"]
        Controllers["RESTful Controllers & Auth Filters"]
        Hubs["SignalR Notification Hub"]
        Swagger["OpenAPI / Swagger Docs"]
    end

    subgraph Core ["Application Core (ItsTool.Application & Domain)"]
        DTOs["DTOs, ViewModels & Validators"]
        Interfaces["Service & Repository Abstractions"]
        Entities["Domain POCO Entities (Auditable, SoftDelete)"]
        EAV["EAV Dynamic Field Engine"]
    end

    subgraph Infra ["Infrastructure Layer (ItsTool.Infrastructure)"]
        EF["Entity Framework Core (DbContext)"]
        Audit["SystemAuditInterceptor (Change Tracker)"]
        SlaEngine["SlaEngine (Background SLA Worker)"]
        AiCopilot["ResolutionCopilotAgent (LLM Connector)"]
        SignalR["NotificationDispatcher (Realtime Hub)"]
    end

    subgraph Data ["Data Storage & External"]
        PG[("PostgreSQL Database")]
        LLM["AI / LLM Service"]
    end

    UI --> API
    API --> Core
    API --> Infra
    Infra --> Core
    Infra --> PG
    Infra --> LLM
```

### 📁 Katman Yapısı

```
itsm-tool/
├── src/
│   ├── ItsTool.Domain/          # Saf iş modelleri, Entity'ler, EAV yapıları, Base interfaceler
│   ├── ItsTool.Application/     # İş kuralları arayüzleri, DTO'lar, servis sözleşmeleri
│   ├── ItsTool.Infrastructure/  # EF Core DbContext, PostgreSQL eşleşmeleri, SLA & AI servisleri
│   ├── ItsTool.API/             # ASP.NET Core Web API, JWT Auth, SignalR Hub, Controller'lar
│   └── ItsTool.Web/             # Vanilla JS, responsive HTML5 sayfaları ve statik varlıklar (wwwroot)
├── tests/
│   └── ItsTool.UnitTests/       # 358 birim ve entegrasyon testi, InMemory SQLite altyapısı
└── docs/                        # Mimari tasarım, ERD, gereksinim ve geliştirme notları
```

---

## 🧠 Yapay Zeka (AI / LLM) Copilot Mimarisi

ITSM Tool, destek temsilcilerinin operasyonel yükünü hafifletmek, bilet çözüm sürelerini (MTTR) minimize etmek ve yanıt kalitesini standartlaştırmak için **hibrit ve çok katmanlı bir yapay zeka mimarisine** sahiptir.

### 📐 AI Copilot Akış Şeması

```mermaid
flowchart TD
    subgraph Client ["İstemci Katmanı - Web UI"]
        Widget["AI Copilot Paneli"]
        LangSel["Dil Seçici (TR / EN)"]
        ModalSettings["Model Ayarları ve API Key"]
    end

    subgraph API ["Sunum Katmanı - ItsTool.API"]
        AiCtrl["AiController"]
        Endpoints["AI Uç Noktaları (Suggest / Draft / Summarize / Ask)"]
    end

    subgraph CoreAgents ["Ajan ve İş Mantığı - ItsTool.Infrastructure"]
        Copilot["ResolutionCopilotAgent"]
        HandoffSwarm["TicketHandoffSwarm"]
        ContextAggregator["Bağlam Toplayıcı - RAG Lite"]
    end

    subgraph DataContext ["Veri Tabanı ve Bağlam"]
        DB_Tickets[("Bilet Detayları ve Yorumlar")]
        DB_KB[("Bilgi Bankası Makaleleri")]
        DB_Custom[("EAV Dinamik Alanlar")]
    end

    subgraph ExecutionBridge ["Çalıştırma ve Karar Katmanı"]
        HealthCheck{"LLM Bağlantısı Aktif mi?"}
        LiveLLM["Canlı LLM Konnektörü - OpenAI Uyumlu"]
        HeuristicFallback["Akıllı Kural Motoru - Yerel Fallback"]
    end

    subgraph Providers ["LLM Sağlayıcıları - Yerel ve Bulut"]
        Ollama["Ollama - Llama 3 / Mistral / Qwen"]
        LMStudio["LM Studio / vLLM / Localhost"]
        OpenAI["OpenAI - GPT-4o / GPT-4o-mini"]
    end

    Widget -->|1. Kullanıcı Aksiyonu| AiCtrl
    LangSel -.->|Dil Tercihi: TR / EN| AiCtrl
    ModalSettings -.->|Model ve API Key Yapılandırması| AiCtrl
    AiCtrl --> Endpoints
    Endpoints --> Copilot
    Endpoints --> HandoffSwarm

    Copilot --> ContextAggregator
    HandoffSwarm --> ContextAggregator
    ContextAggregator <--> DB_Tickets
    ContextAggregator <--> DB_KB
    ContextAggregator <--> DB_Custom

    ContextAggregator --> HealthCheck
    HealthCheck -->|Evet - Canlı Bağlantı| LiveLLM
    HealthCheck -->|Hayır - Çevrimdışı veya Hata| HeuristicFallback

    LiveLLM --> Ollama
    LiveLLM --> LMStudio
    LiveLLM --> OpenAI

    LiveLLM -->|Sonuç: isLlm = true| Widget
    HeuristicFallback -->|Sonuç: isLlm = false / Uyarı Rozeti| Widget
```

---

### 🔑 AI Mimarimizin 6 Temel İlkesi

#### 1. 🛡️ Çift Modlu Çalışma & Kesintisiz Hizmet Garantisi (Dual-Engine Fallback)
- **Problem:** Bulut tabanlı LLM API'larında ağ kesintileri, hız kısıtlamaları (rate-limit) veya yerel modellerde bellek yetersizliği yaşandığında destek teknisyeninin ekranı donmamalıdır.
- **Çözüm:** Sistem **Sıfır Kesinti (Zero Downtime)** prensibiyle çalışır:
  - Canlı LLM bağlantısı varsa derinlemesine model çıktısı alınır (`isLlm: true`).
  - LLM erişilemezse veya kapalıysa, sistem **asla hata fırlatmaz**; anında bilet kategorisini, önceliğini, geçmiş müdahalelerini ve ilgili KB makalelerini analiz eden **yerel kural motoruna (Smart Heuristic Fallback)** devredilir (`isLlm: false`).
  - Kullanıcı arayüzünde şeffaflık sağlanarak yanıtın kural motorundan geldiği ve harici model bağlamak için ayarların kontrol edilmesi gerektiği açıkça belirtilir.

#### 2. 📚 RAG-Lite & Bağlamsal Zenginleştirme (Context Grounding)
LLM modeline sadece bilet başlığı gönderilmez. Doğruluk oranını artırmak ve halüsinasyonları önlemek için prompt context'i şu verilerle zenginleştirilir:
- **Bilet Temel Verileri:** Başlık, açıklama, kategori, öncelik, talep tipi ve durum.
- **EAV Dinamik Alanlar:** Varsa sunucu adı, etkilenen kullanıcı sayısı, hata kodları vb.
- **Zaman Çizelgesi & Yorumlar:** Son kullanıcı ile teknisyen arasındaki tüm geçmiş diyaloglar ve iç notlar (internal notes).
- **Bilgi Bankası Eşleştirmesi:** Kategori ve etiket bazlı en alakalı onaylı KB makaleleri prompt'a eklenerek modele *"Kurumsal prosedürlere sadık kalarak yanıtla"* talimatı verilir.

#### 3. 🌐 Çok Dilli Zeka & Prompt Sentezi (TR / EN)
- Arayüz üzerinden tek tıkla **🇹🇷 TR** veya **🇬🇧 EN** yanıt dili seçilebilir ve tercih `localStorage` üzerinde saklanır.
- Backend ajanları (`ResolutionCopilotAgent`, `TicketHandoffSwarm`), seçilen dile göre dinamik sistem talimatları ve kullanıcı prompt'ları oluşturur:
  - **Türkçe:** Kurumsal ve profesyonel Türkçe ITIL dili ile çözüm adımları ve müşteri bildirimleri.
  - **İngilizce:** Uluslararası IT destek standartlarına (`Best regards`, `Diagnostic steps`, `Actionable troubleshooting`) tam uyumlu İngilizce çıktılar.
  - LLM bağlı olmadığında dahi yerel motor, seçilen dilde profesyonel şablonlar üretir.

#### 4. 🔌 Evrensel Model Uyumluluğu (OpenAI-Compatible Multi-Provider)
Sistem tek bir sağlayıcıya kilitlenmez (`Vendor Lock-in` yoktur). Standart OpenAI Chat Completions REST API spesifikasyonunu destekler:
- **Yerel Modeller (Zero-Cost / Offline):** [Ollama](https://ollama.ai/) (`Llama 3`, `Mistral`, `Qwen 2.5`, `Phi-3`), [LM Studio](https://lmstudio.ai/), [vLLM](https://github.com/vllm-project/vllm).
- **Bulut Modelleri:** OpenAI (`GPT-4o`, `GPT-4o-mini`), Azure OpenAI, Anthropic Claude (uyumlu proxy'ler üzerinden).
- **Docker İçi Ağ İletişimi:** `docker-compose.yml` içerisindeki `host.docker.internal:host-gateway` köprüsü sayesinde, Docker içinde koşan ITSM Tool, host makinede çalışan yerel Ollama/LM Studio servislerine doğrudan `http://host.docker.internal:11434` üzerinden erişebilir.

#### 5. 👥 Çoklu Ajan ve Görev Ayrımı (Agentic Specialization)
- **`ResolutionCopilotAgent`:** Teşhis adımları, muhtemel kök nedenler, ilgili KB makaleleri ve son kullanıcıya iletilecek hazır e-posta/yorum taslaklarını üretir.
- **`TicketHandoffSwarm`:** Vardiya değişimlerinde veya 2. Seviye desteğe eskalasyonda biletin geçmişini, çözülemeyen darboğazları ve bir sonraki teknisyenin yapması gerekenleri özetleyen devir (handoff) notları hazırlar.

#### 6. 🎨 Sezgisel Arayüz & Güvenli Model Yönetimi
- **Göz İkonlu API Anahtarı:** Model ayarları penceresinde API anahtarı güvenle maskelenir (`type="password"`), istenildiğinde göz ikonu ile açık metne dönüştürülüp kontrol edilebilir.
- **Üst Üste Binmeyen 2 Satırlı Başlık:** Dar yan panellerde taşma ve çakışmaları önleyen modern başlık ve durum göstergesi.
- **Canlı Gecikme Testi:** Model ayarlarından tek tıkla test isteği gönderilerek milisaniye cinsinden yanıt süresi (`latency`) ve model sağlığı ölçülür.
- **Tek Tıkla Yanıta Aktarma:** Üretilen taslak tek tıkla kopyalanabilir veya doğrudan biletin yanıt kutusuna aktarılabilir.

---

## 🧪 Kod Kalitesi & SonarQube

Proje, kurumsal kodlama standartlarına ve statik kod analizi kurallarına sıkı sıkıya bağlıdır. **SonarQube Kalite Kapısı (Quality Gate)** tüm metriklerde tam başarı sağlamıştır:

<div align="center">

| Metrik | Sonuç | Durum |
| :---: | :---: | :---: |
| **Quality Gate** | **PASSED (OK)** | 🟢 Başarılı |
| **Birim Testleri** | **358 / 358 Geçti** | 🟢 %100 Başarı |
| **Satır Test Kapsamı (Line Coverage)** | **%85.34** | 🟢 Yüksek Kapsam |
| **Bugs** | **0** | 🟢 Sıfır Hata |
| **Vulnerabilities** | **0** | 🟢 Güvenli |
| **Security Hotspots** | **0** | 🟢 İncelendi |
| **Code Smells** | **0** | 🟢 Temiz Kod |
| **Kod Tekrarı (Duplications)** | **%1.2** (<%3.0 eşiği) | 🟢 Mükemmel |

</div>

### 📊 Katman Bazlı Test Kapsamı

```
+------------------------+--------+--------+--------+
| Modül                  | Satır  | Dal    | Metot  |
+------------------------+--------+--------+--------+
| ItsTool.Domain         | 93.43% | 100%   | 93.43% |
| ItsTool.Application    | 84.16% | 100%   | 82.84% |
| ItsTool.Infrastructure | 82.72% | 56.49% | 88.47% |
| ItsTool.API            | 92.12% | 68.75% | 96.62% |
+------------------------+--------+--------+--------+
| TOPLAM ORTALAMA        | 85.34% | 58.12% | 90.35% |
+------------------------+--------+--------+--------+
```

### 🔄 Sürekli Entegrasyon (CI/CD Pipeline)

GitHub Actions üzerinde koşan otomatik CI pipeline (`.github/workflows/ci.yml`), repoya yapılan her `push` ve `pull_request` işleminde:
1. **Ortam Hazırlığı:** Ubuntu üzerinde .NET 8 SDK'sını yapılandırır.
2. **Derleme:** Çözümün (`ItsTool.sln`) bağımlılıklarını geri yükler ve `Release` modda derler.
3. **Otomatik Testler:** 353 birim testini çalıştırarak kod kalitesini garanti eder.
4. **Kapsam Raporlama:** OpenCover formatında test kapsamı raporu oluşturup CI artifact olarak saklar.

---

## 🚀 Hızlı Kurulum

### 🐳 Yöntem 1: Docker ile Tek Komutla Çalıştırma (Önerilen)

Projeyi makinenize PostgreSQL veya .NET SDK kurmanıza gerek kalmadan Docker ile tek komutla başlatabilirsiniz:

```bash
# Projeyi klonlayın
git clone https://github.com/Berkaybbayramoglu/itsm-Tool.git
cd itsm-Tool

# Konteynerleri derleyin ve başlatın
docker compose up -d --build
```

> 💡 *PostgreSQL 16 ve ITSM Tool API konteynerleri otomatik ayağa kalkar, veritabanı şeması migrate edilir ve demo veriler tohumlanır.*  
> Tarayıcınızdan **`http://localhost:5246`** adresine giderek hemen giriş yapabilirsiniz.  
> Konteynerleri durdurmak için: `docker compose down`

---

### 💻 Yöntem 2: Yerel Geliştirme Ortamı (Manuel)

#### 1. Gereksinimler
- [.NET 8.0 SDK](https://dotnet.microsoft.com/download/dotnet/8.0)
- [PostgreSQL 14+](https://www.postgresql.org/download/)
- [Git](https://git-scm.com/)

### 2. Projeyi Klonlayın
```bash
git clone https://github.com/Berkaybbayramoglu/itsm-Tool.git
cd itsm-Tool
```

### 3. Veritabanı Yapılandırması
PostgreSQL sunucunuzda `itsm_tool` adında bir veritabanı oluşturun ve `src/ItsTool.API/appsettings.Development.json` dosyasındaki bağlantı dizesini düzenleyin:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Host=localhost;Port=5432;Database=itsm_tool;Username=postgres;Password=YOUR_PASSWORD"
  }
}
```

### 4. Uygulamayı Başlatın

**Terminal 1 — API Sunucusu:**
```bash
dotnet run --project src/ItsTool.API
```
> 💡 *Not: API ilk açılışta veritabanı şemasını otomatik oluşturur ve `DataSeeder` ile örnek projeleri, grupları, SLA politikalarını ve demo kullanıcıları tohumlar.*

**Terminal 2 — Web Kullanıcı Arayüzü:**
```bash
dotnet run --project src/ItsTool.Web
```

Tarayıcınızdan **`http://localhost:5246`** adresine giderek uygulamayı kullanmaya başlayabilirsiniz.

### 5. Birim Testlerini Çalıştırma
```bash
dotnet test tests/ItsTool.UnitTests/ItsTool.UnitTests.csproj /p:CollectCoverage=true
```

---

## 🔑 Demo Hesaplar

Sistem başlatıldığında hazır gelen test kullanıcıları (**Tüm şifreler:** `123456`):

| Kullanıcı Adı | Rol | Yetki & Sorumluluk Alanı |
| :--- | :--- | :--- |
| `admin` | **SuperAdmin** | Sistem geneli tam yetki; SLA, Proje, Rol, Kullanıcı ve Dinamik Form yönetimi |
| `manager` | **Manager** | Raporlama, SLA inceleme, Yönetim panelleri ve Bilgi Bankası onayları |
| `agent1` | **Agent** | Standart Destek Temsilcisi; bilet çözme, durum güncelleme, devir alma |
| `agent2` | **Agent (Override)** | Standart Temsilci + Claim Override ile verilmiş `ticket.close` yetkisi |
| `user1` | **EndUser** | Son kullanıcı; talep açma, kendi biletlerini izleme, memnuniyet anketi |

---

## 📡 API Mimarisi & Başlıca Endpoint'ler

Tüm endpoint'ler Swagger / OpenAPI UI üzerinden interaktif olarak test edilebilir (`http://localhost:5246/swagger`).

<details>
<summary><b>🔍 Başlıca REST API Endpoint Listesini Görüntüle</b></summary>

| Modül | Metot | Endpoint | Açıklama |
| :--- | :--- | :--- | :--- |
| **Auth** | `POST` | `/api/auth/login` | JWT token üretimi ve kullanıcı doğrulaması |
| **Tickets** | `GET` | `/api/ticket` | Sayfalanmış, filtrelenmiş bilet listesi |
| | `POST` | `/api/ticket` | Yeni bilet oluşturma (Dinamik alanlar dahil) |
| | `GET` | `/api/ticket/{id}` | Bilet detayları, yorumlar, ekler ve denetim izi |
| | `POST` | `/api/ticket/{id}/transition` | İzin verilen durum geçişi uygulama |
| | `POST` | `/api/ticket/{id}/assign` | Bilet teknisyen/grup atama ve devir |
| **SLA** | `GET` | `/api/sla/policies` | SLA politikaları ve hedef süreleri |
| | `PUT` | `/api/sla/policies/{id}` | Politika ve hedef süre güncelleme |
| **AI Copilot** | `POST` | `/api/ai/tickets/{id}/suggest-resolution` | AI tabanlı çözüm önerisi üretme |
| | `POST` | `/api/ai/tickets/{id}/draft-reply` | Müşteriye iletilecek taslak yanıt oluşturma |
| | `POST` | `/api/ai/tickets/{id}/summarize` | Bilet geçmişi ve yorum özetleme |
| **Dashboard** | `GET` | `/api/dashboard/overview` | KPI sayıları, SLA uyum oranları |
| | `GET` | `/api/dashboard/distributions` | Öncelik, kategori ve durum dağılımları |
| **KB** | `GET` | `/api/knowledgebase/articles` | Yayınlanmış makaleler ve arama |
| **Dynamic Forms** | `GET` | `/api/dynamicform/fields` | Dinamik alan tanımları |

</details>

---

## 🔒 Güvenlik & Standartlar

- **Yetkilendirme:** Claim tabanlı JWT Bearer Token ile güvenli kimlik doğrulama.
- **Audit Trail:** EF Core `SystemAuditInterceptor` ile tüm varlık ekleme, güncelleme ve silme işlemlerinde kullanıcı ve zaman damgalı tam denetim izi.
- **ReDoS Koruması:** Regex aramalarında ve HTML etiket temizlemelerinde katı Regex Timeout sınırları (CWE-1333 önlemi).
- **Parola Güvenliği:** PBKDF2 / ASP.NET Identity PasswordHasher ile tuzlanmış (salted) güvenli şifreleme.
- **Soft Delete:** Veri kaybını önleyen ve ilişkisel bütünlüğü koruyan `ISoftDelete` deseni.

---

## 📄 Lisans

Bu proje [MIT Lisansı](LICENSE) kapsamında lisanslanmıştır.

---

<div align="center">
  <b>Geliştirici:</b> Berkay Bayramoğlu • <a href="mailto:berkaybbayramoglu@gmail.com">berkaybbayramoglu@gmail.com</a>
  <br />
  <sub>Proje hoşunuza gittiyse sağ üst köşeden ⭐️ <b>Star</b> vermeyi unutmayın!</sub>
</div>
