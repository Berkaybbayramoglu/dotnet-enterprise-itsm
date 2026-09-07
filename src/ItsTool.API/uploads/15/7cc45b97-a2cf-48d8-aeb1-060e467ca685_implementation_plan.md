# Genel Mimari Diyagramı Güncelleme Planı

## Mevcut Durum Analizi

Mevcut `Genel_Mimari.drawio` dosyası 6 sayfadan oluşmakta ve **Sayfa-1** ana sistem mimarisini içermektedir. Diğer sayfalar AI model mimarisi detaylarını (CLIP Encoder, Feature Extraction, Reduction/Merge/Regression Layers) göstermektedir.

### Sayfa-1'de Mevcut Bileşenler (Genel Mimari)

| Katman | Mevcut Modüller |
|--------|----------------|
| **Frontend Services** | Dashboard GUI, Mobile GUI, Dev Panel GUI, Kiosk GUI |
| **AI Services** | Pre-Processing Module, Training Module, AI HUB Module, Controller Module, Orchestration Core Module, Model Repository |
| **Analyze Services** | Analytics Module, Serve Module, Learning Module |
| **Core Backend Services** | Router Module, Kiosk Module, QR Module, Agent Module, User Module, Auth Module |
| **Veritabanları** | Core DB (PostgreSQL), Analytics DB (PostgreSQL) |
| **API Gateway'ler** | Frontend ↔ AI Services, AI Services ↔ Core Backend, Analyze Services ↔ Core Backend |
| **Kullanıcı Cihazları** | Mobil cihaz, Masaüstü, Android |

---

## Dokümanlarda Tanımlanan Ancak Diyagramda EKSİK Olan Bileşenler

Proje önerisi (`1501_proje_onerisi_v2.docx`) ve ek belgeler (`İzlenecek Ar-Ge Yöntemleri`, `Yenilikçi Yönler`, `Başlatılma Gerekçeleri` vb.) detaylı olarak incelendiğinde, aşağıdaki kritik bileşenlerin diyagramda **bulunmadığı** tespit edilmiştir:

### 1. Blokzincir Tabanlı Veri Değişmezliği Katmanı (Blockchain Immutability Layer)
- **Kaynak**: "Blokzincir Tabanlı Veri Değişmezliği Katmanı (Hash Üretim, Anchoring, Doğrulama Arayüzü)"
- **Açıklama**: Geri bildirim kayıtlarının silinip/değiştirilmediğinin kriptografik olarak kanıtlanması
- **Yerleşim**: Analyze Services veya Core Backend'e yakın, DB katmanına bağlı
- **Bağlantılar**: Core DB ↔ Blockchain Layer

### 2. RAG Tabanlı Karar Destek Modülü (RAG Decision Support Module)
- **Kaynak**: "RAG (Retrieval-Augmented Generation) mimarisi entegre edilecektir"
- **Açıklama**: Otel doluluk oranı gibi bağlamsal verilerle zenginleştirilen LLM, yöneticilere dinamik aksiyon önerileri sunar
- **Yerleşim**: AI Services içinde veya ayrı bir katman olarak
- **Bağlantılar**: Vector DB ↔ RAG Module ↔ Dashboard GUI

### 3. Vektör Veritabanı (Milvus/pgvector)
- **Kaynak**: "Milvus, pgvector standartlarında indekslenmesi"
- **Açıklama**: Anlamsal arama ve RAG için embedding depolama
- **Yerleşim**: Veritabanı katmanında, Core DB ve Analytics DB yanında
- **Bağlantılar**: RAG Module ↔ Vector DB, AI Services ↔ Vector DB

### 4. 32B NER Tabanlı Anonimleştirme Katmanı (NER De-identification Module)
- **Kaynak**: "32B parametreli NER modelleri ile otomatik anonimleştirme (De-identification)"
- **Açıklama**: Kişisel verilerin LLM'e gitmeden önce KVKK/GDPR uyumlu maskelenmesi
- **Yerleşim**: Pre-Processing Module'ün bir alt bileşeni veya ayrı modül olarak AI Services içinde
- **Bağlantılar**: Pre-Processing → NER Module → NLP Models

### 5. PMS Entegrasyonu (Property Management System Integration)
- **Kaynak**: "PMS (Opera/Fidelio) yazılımlarına Webhook/API üzerinden anlık 'İş Emri' iletme"
- **Açıklama**: Otellerin mevcut yönetim sistemleriyle entegrasyon
- **Yerleşim**: Core Backend Services dışında, harici sistem olarak
- **Bağlantılar**: Core Backend → Webhook/API → PMS (External)

### 6. Agentic AI Gözetim Katmanı (Agentic AI Monitoring Layer)
- **Kaynak**: "LangGraph/CrewAI tabanlı otonom ajanlar ile sürekli test edilecek"
- **Açıklama**: Mock veri gönderimi, anomali tespiti, otomatik uyarı senaryoları
- **Yerleşim**: Tüm sistemin üstünde veya yanında cross-cutting concern olarak
- **Bağlantılar**: Tüm mikroservislere bağlı

### 7. vLLM/TensorRT-LLM Inference Hızlandırma Katmanı
- **Kaynak**: "vLLM/TensorRT-LLM hızlandırma altyapısı"
- **Açıklama**: LLM çıkarımlarının düşük gecikmeli yapılması (≤4 sn)
- **Yerleşim**: AI HUB Module içinde veya yanında
- **Bağlantılar**: AI HUB ↔ vLLM Engine

### 8. VAD/DNS Ses İşleme Modülleri
- **Kaynak**: "VAD (Voice Activity Detection) ve DNS (Deep Noise Suppression)"
- **Açıklama**: Gürültülü ortamlardan gelen ses verilerinin ön işlemesi
- **Yerleşim**: Pre-Processing Module'ün alt bileşeni olarak daha detaylı gösterilmeli
- **Bağlantılar**: Kiosk/Mobile → VAD/DNS → STT

### 9. Dil Tespiti Modülü (Language Identification Module)
- **Kaynak**: "Native çok dilli (Türkçe/İngilizce) mimari"
- **Açıklama**: Gelen verinin dilinin otomatik tespiti
- **Yerleşim**: Pre-Processing Module içinde
- **Bağlantılar**: Pre-Processing → Language ID → STT/NLP

### 10. Docker/Kubernetes Altyapı Katmanı
- **Kaynak**: "Docker ve Kubernetes ile konteynerize edilmiş"
- **Açıklama**: Yatayda ölçeklenebilir bulut tabanlı mimari
- **Yerleşim**: Tüm sistemin altında altyapı katmanı olarak
- **Bağlantılar**: Tüm servisleri kapsayan container orchestration

### 11. MLOps Pipeline / Sürekli Öğrenme Döngüsü
- **Kaynak**: "MLOps pipeline'ları üzerinden modelin sürekli ve dinamik güncellenmesi"
- **Açıklama**: OAA'nın koordine ettiği model yeniden eğitim döngüsü
- **Yerleşim**: Orchestration Core Module ile Training/Learning Module arasında
- **Bağlantılar**: OAA → MLOps → Training Module → Model Repository

### 12. Webhook/Notification Sistemi
- **Kaynak**: "Webhook/API üzerinden anlık 'İş Emri' olarak iletecektir"
- **Açıklama**: Kritik durumların PMS ve harici sistemlere iletimi
- **Yerleşim**: Core Backend Services içinde
- **Bağlantılar**: Agent Module → Webhook → PMS/External

### 13. Hibrit Etiketleme Hattı (3 LLM Majority Voting)
- **Kaynak**: "Hibrit Etiketleme Hattı (3 LLM Majority Voting + Human-in-the-loop)"
- **Açıklama**: Otomatik etiketleme pipeline'ı
- **Yerleşim**: Training Module ile bağlantılı, AI Services içinde
- **Bağlantılar**: Training Module ↔ Labeling Pipeline ↔ Model Repository

### 14. Offline-First Yerel Önbellekleme Mekanizması
- **Kaynak**: "Offline-First (çevrimdışı öncelikli) mimariye sahip araçlar"
- **Açıklama**: Zayıf ağ koşullarında veri kaybını önleme
- **Yerleşim**: Frontend/Kiosk tarafında
- **Bağlantılar**: Kiosk GUI / Mobile GUI → Local Cache → API Gateway

---

## Önerilen Değişiklikler (Sayfa-1 Güncelleme)

### Eklenecek Yeni Bileşenler:

1. **Blockchain Layer** → Analyze Services katmanı içine, DB'lerin yanına
2. **RAG Module** → AI Services katmanı içine, Agent Module yanına
3. **Vector DB** → Veritabanı katmanına, Analytics DB yanına
4. **NER Anonymization Module** → AI Services içinde, Pre-Processing yanına
5. **PMS (External)** → Diyagram sağ tarafında harici sistem olarak
6. **Agentic AI Monitor** → Diyagramın üst kısmında cross-cutting olarak
7. **vLLM/TensorRT Engine** → AI HUB Module yanına
8. **VAD/DNS Sub-modules** → Pre-Processing Module detayı olarak
9. **Language ID** → Pre-Processing Module detayı olarak
10. **Docker/K8s Layer** → Diyagramın en altında altyapı katmanı
11. **MLOps Pipeline** → OAA ile Training Module arasında bağlantı
12. **Webhook/Notification** → Core Backend içinde
13. **Labeling Pipeline** → Training Module yanında
14. **Offline Cache** → Frontend cihazlarda

---

## Verification Plan

### Manual Verification
- Güncellenmiş drawio dosyasının draw.io uygulamasında açılarak görsel olarak kontrol edilmesi
- Tüm yeni bileşenlerin doğru konumlandırılıp bağlantılarının kontrol edilmesi
- Dokümanlarda tanımlanan tüm modüllerin diyagramda yer aldığının doğrulanması

> [!IMPORTANT]
> Bu plan kapsamında, mevcut diyagramın **Sayfa-1** (Genel Mimari) sayfası güncellenecektir. Diğer sayfalar (AI model detay diyagramları) değiştirilmeyecektir. Eklenen bileşenler mevcut stil ve renk şemasıyla tutarlı olacaktır.

> [!WARNING]
> Diyagramda yer alanı kısıtlı olabilir. Bazı bileşenler (VAD/DNS, Language ID gibi) mevcut Pre-Processing Module'ün alt detayları olarak eklenebilir veya ayrı bir detay sayfası olarak açılabilir. Bu konuda tercihinizi belirtir misiniz?

## Open Questions

1. **Detay seviyesi**: VAD/DNS, Language ID, NER Anonymization gibi bileşenler Pre-Processing modülünün alt detayları olarak mı gösterilsin, yoksa ana diyagramda ayrı kutular olarak mı yerleştirilsin?

2. **Docker/K8s katmanı**: Altyapı katmanı (Docker/Kubernetes) diyagramda bir çerçeve olarak mı gösterilsin, yoksa basit bir altyapı katmanı etiketi mi olsun?

3. **Harici sistemler**: PMS (Opera/Fidelio) gibi harici entegrasyonlar diyagramda nasıl gösterilsin? Ayrı bir bölge olarak mı, yoksa bağlantı oku ile mi?

4. **Yeni sayfa**: Eksik bileşenler çok fazla olduğu için yeni bir detay sayfası mı oluşturulsun, yoksa hepsi Sayfa-1'e mi sığdırılsın?
