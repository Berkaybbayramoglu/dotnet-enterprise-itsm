# Detaylı Proje Planı
## Kuantum Manyetometreler için Pekiştirmeli Öğrenme ile Gürbüz ve Yorumlanabilir Kontrol Protokolü Keşfi

**Kısa ad:** QSenseBench
**Hedefler:** TÜBİTAK 2209 kabulü · Bitirme projesi · Uluslararası konferans/dergi yayını
**Süre:** 12 ay

---

## 0. Bir Paragrafta Proje

Kuantum manyetometreler, dünyanın en hassas manyetik alan ölçerleridir — GPS'in çalışmadığı yerlerde navigasyon, yeraltı görüntüleme ve biyomedikal görüntülemede kullanılırlar. Bu sensörlerin hassasiyeti, içindeki kuantum sisteme uygulanan **kontrol darbe dizilerine** bağlıdır. Literatürde pekiştirmeli öğrenme (RL) ile bu darbeleri optimize eden çalışmalar var, ancak neredeyse hepsi **ideal simülasyonda eğitilip ideal simülasyonda test ediliyor** ve ortaya **cihaza gömülemeyecek kadar büyük kara kutular** çıkarıyor. Biz bu iki boşluğu kapatıyoruz: (1) gerçekçi cihaz sapmalarını içeren açık kaynak bir kıyaslama ortamı kuruyoruz, (2) RL'in bulduğu protokolü okunabilir ve gömülü donanımda çalışabilir bir formüle damıtıyoruz.

---

## 1. Neden Temayı Bu Şekilde Daralttık?

Önceki değerlendirmede "quantum many-body control + tensor network + RL" fikri incelenmişti. O fikir bilimsel olarak sağlam ama **1 yıllık bir lisans projesi için kontrolden çıkma riski çok yüksek**. Nedenleri:

| Sorun | Sonuç |
|---|---|
| Tensor network (MPS/TEBD) matematiği ağır | Fizik öğrenmeye 6 ay gider, proje yapmaya vakit kalmaz |
| Simülasyon pahalı | Her deney saatler sürer, iterasyon yavaşlar |
| Ölçülebilir "başarı" tanımı bulanık | Jüriye "ne başardınız" sorusuna net cevap veremezsiniz |
| Sanayi karşılığı dolaylı | 2209-B ve CV tarafı zayıf kalır |

Bu plan **aynı temanın** (RL + spin sistemleri + kuantum kontrol) çok daha tutarlı bir dilimini alıyor:

| Avantaj | Nasıl |
|---|---|
| Hilbert uzayı küçük (2×2 ile 8×8 arası) | Dizüstü bilgisayarda saniyeler içinde çalışır, GPU şart değil |
| Fizik yükü tek bölümlük | Bloch küresi, Rabi, Ramsey, T1/T2 — 3-4 haftada öğrenilir |
| Kütüphane fiziği hallediyor | QuTiP kullanılır, elle denklem türetilmez |
| Özgün katkının tamamı yazılım/ML mühendisliği | Sizin güçlü olduğunuz alanda kalıyorsunuz |
| Metrik net ve sayısal | Hassasiyet (η, T/√Hz) ve fidelity — jüriye tablo gösterirsiniz |
| Sanayi karşılığı doğrudan | Aşağıda Bölüm 11'de kanıtlarıyla var |

**Önemli:** Many-body tarafı kaybolmuyor. Projenin son iş paketi (WP7), sistemi etkileşen NV spin topluluklarına genişletmek — ki bu **gerçek bir many-body problemidir**. Yani ana omurga güvenli, uzatma hedefi iddialı.

---

## 2. Kuantum Terimleri Sözlüğü (Fizik Bilmeyene)

Planın geri kalanını okurken lazım olacak her terim burada:

**Spin.** Elektronun veya çekirdeğin sahip olduğu, küçük bir pusula iğnesi gibi davranan özellik. Manyetik alan içinde bu iğne döner. Manyetometrenin çalışma prensibi tam olarak budur: iğnenin ne kadar döndüğüne bakarak alanı ölçersiniz.

**Kübit / iki seviyeli sistem.** En basit kuantum sistemi: iki durumu olan (0 ve 1 gibi) ama bu ikisinin karışımında da bulunabilen bir sistem. Bir spin, iyi bir kübittir.

**Bloch küresi.** Tek bir kübitin durumunu bir kürenin yüzeyindeki nokta olarak gösteren görselleştirme. Kuzey kutbu "0", güney kutbu "1", aradaki her nokta bir karışım. Kontrol uyguladığınızda bu nokta küre üzerinde hareket eder. **Projenin görsel demosu tam olarak budur** — ekranda dönen bir ok göreceksiniz.

**NV merkezi (Nitrogen-Vacancy center).** Elmasın kristal yapısındaki bir kusur. Bir azot atomu + yanında bir boşluk. Bu kusur, oda sıcaklığında çalışan mükemmel bir spin sensörü gibi davranır. Ticari kuantum manyetometrelerin çoğu buna dayanır. Elmas gerekmez — biz sadece simüle edeceğiz.

**Darbe (pulse) / kontrol darbesi.** Spine uygulanan kısa mikrodalga sinyali. Bloch küresindeki oku belirli bir açıyla döndürür. Ajanın seçtiği "aksiyon" budur.

**Ramsey dizisi.** Klasik ölçüm protokolü: bir darbe uygula → bekle → ikinci darbe uygula → ölç. Bekleme sırasında manyetik alan oku döndürür, bu dönüş miktarından alanı hesaplarsınız. Bizim baseline'ımız.

**CPMG / XY8.** Ramsey'in geliştirilmiş halleri. Arada ekstra darbeler atarak gürültünün etkisini bastırırlar ("dinamik ayrıştırma"). Onlarca yıllık, elle tasarlanmış, çok iyi protokoller. **Yenmesi gereken rakipler bunlar.**

**T2\* (dekoherans süresi).** Kuantum bilgisinin bozulmadan kalabildiği süre. Çevre gürültüsü yüzünden ok yavaş yavaş rastgeleleşir. Ne kadar uzunsa o kadar iyi ölçüm. Cihazdan cihaza, hatta günden güne değişir — projenin can alıcı noktası bu.

**Detuning (ayar kayması).** Uyguladığınız mikrodalga frekansı ile spinin gerçek frekansı arasındaki fark. Pratikte asla tam sıfır olmaz. Kalibrasyon hatası.

**Fidelity (sadakat).** Ulaştığınız durumun hedef duruma ne kadar benzediği. 0 ile 1 arası. 1 = mükemmel.

**Hassasiyet (sensitivity, η).** Manyetometrenin gerçek performans ölçüsü: birim zamanda ölçebildiğiniz en küçük manyetik alan. Birimi T/√Hz. **Küçük olması iyidir.** Fizikçilerin ve sanayinin gerçekten baktığı sayı budur — ve literatürdeki RL çalışmalarının çoğu bunu değil, fidelity'yi raporluyor. Bu bizim eleştirimizin bir parçası.

**Lindblad ana denklemi.** Çevresiyle etkileşen (yani gürültülü, gerçekçi) bir kuantum sisteminin zamanla nasıl değiştiğini veren denklem. QuTiP bunu sizin için çözer, `mesolve()` fonksiyonu.

**GRAPE / CRAB.** Kuantum kontrolde standart optimizasyon algoritmaları. Gradyan tabanlı. Verilen tek bir durum için çok iyi darbe bulurlar, ama koşullar değişince yeniden çalıştırmak gerekir. Ana rakiplerimiz.

**Domain randomization (alan rastgeleleştirme).** Robotikten gelen bir teknik: ajanı eğitirken simülasyonun parametrelerini her bölümde rastgele değiştirirsiniz. Böylece ajan tek bir ideal duruma değil, bir dağılıma karşı sağlamlaşır. **Projenin teknik kalbi bu.**

**Sembolik regresyon.** Bir veri kümesine uyan matematiksel *formülü* bulan yöntem (sinir ağı değil, gerçek denklem). PySR kütüphanesi bunu yapar. Kara kutuyu okunabilir hale getirmek için kullanacağız.

---

## 3. Literatür: Prestijli İşler ve Ne Yaptılar

Bu bölüm proje önerinizin "literatür özeti" kısmının iskeletidir. Her birini okumanız gerekmiyor; ilk üçünü okuyun, gerisini atıf verin.

### 3.1 Temel taşlar (mutlaka okuyun)

**Bukov ve ark., "Reinforcement Learning in Different Phases of Quantum Control", Phys. Rev. X 8, 031086 (2018).**
Alanı başlatan iş. RL'in kuantum kontrol problemini çözebildiğini gösterdi ve kontrol probleminin "kolay/zor/imkânsız" fazları olduğunu ortaya koydu. Sizin problem zorluğu tartışmanızın referansı.

**Cooke & Czischek, "Reinforcement Learning for Optimal Control of Spin Magnetometers", Phys. Rev. A 112, 062603 (2025).**
**Bu makale sizin başlangıç noktanız.** Spin tabanlı bir manyetometreyi SAC algoritmasıyla kontrol ediyor, dekoherans varlığında. Projenin ilk iş paketi bu makalenin sonucunu yeniden üretmek olacak. Çok yeni olması avantaj: "bu çalışmanın açık bıraktığı sorular" demek için mükemmel.

**Metz & Bukov, "Self-correcting quantum many-body control using reinforcement learning with tensor networks", Nature Machine Intelligence 5, 780 (2023).**
Önceki değerlendirmede konuşulan iş. Tensor network + RL'in zirvesi. Siz bunu yapmayacaksınız ama **atıf vermeniz ve "neden farklı bir yol seçtik" demeniz** proje önerinizin olgunluğunu gösterir.

### 3.2 Yakın rakipler / boşluğu tanımlayanlar

**Fentaw ve ark., "Adaptive RL for Robust Open Quantum System Control: A Multi-Task Framework", arXiv:2605.26925 (Mayıs 2026).**
51 farklı Hamiltonian üzerinde çok-görevli SAC eğitiyor, görülmemiş Hamiltonian'lara genelleme test ediyor. **Size en yakın iş.** Ama: kapı/durum-transferi odaklı, algılama değil; hassasiyet metriği yok; yorumlanabilirlik yok; açık benchmark yok. Boşluğunuzu tam olarak burada tanımlarsınız.

**"Reinforcement Learning for Quantum Control under Physical Constraints", ICML 2025 (PMLR 267).**
Fiziksel kısıtlar altında RL. Darbelerin pürüzsüz ve deneysel olarak uygulanabilir olmasını zorluyor. Sizin "gerçekçilik kısıtları" tasarımınızın referansı. ICML'de yayınlanmış olması, bu alanın üst düzey ML konferanslarında kabul gördüğünün kanıtı.

**Jauch ve ark. (Robert Bosch GmbH + Ulm Üniversitesi), "Quantum magnetometry enhanced by machine learning", Quantum Sci. Technol. 11, 015055 (2026)** ve **"Adaptive and Robust Control of Diamond Quantum Sensors via Meta-Learning", Adv. Quantum Technol. (2026).**
**Bunlar altın değerinde.** Bir sanayi devi (Bosch) NV manyetometre darbe optimizasyonuna ML uyguluyor ve transfer edilebilirlik/gürbüzlük problemini açıkça "çözülmemiş" diye işaret ediyor. Proje önerinizde "bu problemin sanayi tarafından da öncelikli görüldüğü" iddianızın kanıtı.

**Belliardo, Zoratti, Giovannetti, "Model-aware RL in Bayesian quantum metrology", Phys. Rev. A 109, 062609 (2024).**
Kuantum metrolojide RL'in ciddi referansı. Adaptif ölçüm stratejileri.

**AutoQSense (Liu & Wang, USTC, Ağustos 2026).**
Kuantum sensör devrelerini RL ile otomatik tasarlıyor, Fisher bilgisi tabanlı ödül. Dolanıklık kapısı sayısını %30 azaltmış. Çok yeni — alanın canlı olduğunun göstergesi.

### 3.3 Yöntemsel referanslar (yorumlanabilirlik tarafı)

**Bastani ve ark., "Verifiable RL via Policy Extraction" (VIPER), NeurIPS 2018.** Sinir ağı politikasını karar ağacına damıtma. Klasik.
**Acero & Li, "Distilling RL Policies for Interpretable Robot Locomotion", RLC 2024 Workshop.** Robot yürüyüşünü sembolik formüle damıtma. Sizin yöntem şablonunuz.
**SPID / GM-DAGGER (OpenReview, 2025).** Damıtmada "sadakat" (fidelity to original policy) kavramını getiriyor — sadece performans değil, davranış benzerliği de ölçülmeli. Bu ayrımı kullanmanız işinizi olgunlaştırır.
**Cranmer, PySR (2023).** Sembolik regresyon kütüphanesi. Doğrudan kullanacaksınız.

### 3.4 Benchmark literatürü (özgünlük iddianızın dayanağı)

RL topluluğunda alan-özel kıyaslama ortamları saygın bir katkı türüdür ve hepsi iyi yerlerde yayınlanmıştır:

- **safe-control-gym** (robotik, güvenli kontrol)
- **controlgym** (endüstriyel kontrol + PDE, Mitsubishi Electric Research Labs ortak)
- **PC-Gym** (kimyasal proses kontrolü, Imperial College)
- **GreenLight-Gym** (sera kontrolü, Wageningen)
- **OPS** (optik kontrol)
- **qgym** (TU Delft) — **dikkat:** bu var ama kuantum *derleme* için (devre haritalama, yönlendirme, zamanlama). Kontrol/algılama için değil.

**Kuantum algılama kontrolü için, gerçekçi cihaz sapmalarını parametrize eden standart bir açık kıyaslama ortamı yok.** Boşluk burada.

> **Uyarı:** Bu özgünlük iddiasını başvuru yazarken tekrar doğrulayın. Literatür hızlı hareket ediyor. Google Scholar'da `"quantum sensing" "reinforcement learning" benchmark environment` ve GitHub'da `quantum control gymnasium` araması yapın. Eğer benzeri çıkarsa panik yapmayın — o zaman katkınızı "gürbüzlük eksenine odaklanan ilk ortam" diye konumlandırırsınız.

---

## 4. Jüriyi Etkileyen Şey Nedir? (Açık Konuşalım)

TÜBİTAK 2209 hakemleri, ekşisözlük'teki bir hakem yorumuna göre her projeye 4-5 saat ayırıyor ve **başvurulardaki uydurma kaynaklardan şikâyetçi**. Bu bize üç şey söylüyor:

**Jüriyi etkileyen:**

1. **"Bunu bir yılda gerçekten yapabilirler mi?" sorusuna net evet.** Yapılabilirlik, özgünlükten daha çok proje öldürür. Elinizde çalışan bir ön-sonuç varsa (ilk 2 ayda üretilebilir), bu tek başına kabul şansını ciddi artırır.
2. **Ölçülebilir başarı kriteri.** "Daha iyi sonuçlar elde etmeyi hedefliyoruz" ölür. "XY8 dizisine göre ±%20 T2\* sapmasında hassasiyette %15 iyileşme hedefliyoruz" yaşar.
3. **Somut, doğrulanabilir çıktı.** Açık kaynak repo + veri + reprodüksiyon talimatı. Hakem tıklayıp bakabilir.
4. **Gerçek atıflar.** Her atıfı kontrol edin. DOI'siz kaynak koymayın. Yapay zekâ ile yazdıysanız her cümleyi doğrulayın — hakemler bunu yakalıyor ve çok sert cezalandırıyor.
5. **Dürüst risk bölümü.** "Riskimiz yok" demek amatörlüktür. "Şu riskler var, B planımız şu" demek olgunluktur.

**Jüriyi soğutan:**

- "Yeni bir RL algoritması geliştireceğiz" — 1 yılda olmaz, hakem bunu bilir.
- "Devrim yaratacak" tonu.
- Fizik/matematik derinliği olmayan ekibin ağır fizik projesi vaat etmesi.
- Sadece uygulama: "PPO'yu X problemine uyguladık."

**Bu planın bunlara cevabı:** Katkı iddiası mütevazı ama net (bir benchmark + bir ampirik çalışma + bir damıtma hattı). Hiçbiri "yeni algoritma" iddiası içermiyor. Hepsi 1 yılda yapılabilir. Ve en önemlisi — aşağıda göreceğiniz gibi — **RL kaybetse bile proje başarılı olur.**

---

## 5. Proje Önerisi

### 5.1 Başlık

**TR:** Kuantum Manyetometre Kontrolünde Pekiştirmeli Öğrenme: Cihaz Sapmalarına Karşı Gürbüzlük Kıyaslaması ve Yorumlanabilir Protokol Damıtımı

**EN:** Reinforcement Learning for Quantum Magnetometer Control: A Robustness Benchmark under Device Variation and Interpretable Protocol Distillation

### 5.2 Araştırma Sorusu

> RL ile keşfedilen kuantum algılama kontrol protokolleri, gerçekçi cihaz sapmaları altında klasik optimal kontrol ve elle tasarlanmış dizilere göre gerçekten üstün müdür — ve bu protokoller, performanslarını kaybetmeden gömülü donanımda çalışabilecek kadar sadeleştirilebilir mi?

Bu soru güzel çünkü **her cevabı yayınlanabilir.** Evet ise: RL'in pratik değerini gösterdiniz. Hayır ise: alanın gizli bir zaafını ortaya çıkardınız ve elinizde bunu ölçen ilk araç var.

### 5.3 Üç Katkı

**K1 — QSenseBench: Gürültü-parametrize açık kıyaslama ortamı**

Gymnasium arayüzüne uyumlu, QuTiP tabanlı bir kuantum manyetometre kontrol ortamı ailesi. Ayırt edici özelliği: her bölümde (episode) cihaz parametreleri yapılandırılabilir dağılımlardan örnekleniyor:

- T2\* (dekoherans süresi) — nominal değerin ±%X'i
- Detuning (frekans kayması)
- Darbe genliği hatası (kalibrasyon hatası)
- Statik alan ofseti
- Okuma (readout) gürültüsü

Üç zorluk seviyesi: `nominal` (sapma yok), `realistic` (deneysel literatürden alınan sapmalar), `harsh` (agresif sapmalar). Ayrıca **eğitim dağılımı ile test dağılımını ayırma** desteği — genellemeyi dürüstçe ölçmek için.

*Bu neden özgün:* Mevcut çalışmalar gürbüzlüğü rapor ediyorsa bile herkes kendi ad-hoc kurulumunu kullanıyor. Sonuçlar karşılaştırılamıyor. Standart bir eksen yok.

**K2 — Gürbüzlük kıyaslaması: RL vs. klasik optimal kontrol vs. elle tasarım**

Sistematik karşılaştırma. Yarışmacılar:

| Yöntem | Tip |
|---|---|
| Ramsey | Elle tasarlanmış, temel |
| CPMG, XY8 | Elle tasarlanmış, dinamik ayrıştırma |
| GRAPE | Klasik gradyan tabanlı optimal kontrol |
| CRAB | Klasik, kesikli baz |
| PPO | RL, on-policy |
| SAC | RL, off-policy, sürekli aksiyon |
| PPO + domain randomization | RL, gürbüzleştirilmiş |

Kritik nokta: performansı tek bir noktada değil, **parametre ızgarası üzerinde** raporluyoruz. Çıktı: "gürbüzlük eğrileri" — parametre sapması arttıkça performans nasıl düşüyor. Hem fidelity hem hassasiyet (η) metriğiyle.

*Bu neden özgün:* Kuantum kapıları için benzeri yapıldı; kuantum *algılama* için sistematik olarak yapılmadı. Ve hassasiyet metriğiyle hiç yapılmadı.

**K3 — Sembolik damıtma: kara kutudan gömülebilir protokole**

Eğitilmiş RL politikasını üç forma damıtıyoruz:
- Karar ağacı (VIPER yaklaşımı)
- Kapalı formda sembolik ifade (PySR ile)
- Küçültülmüş sinir ağı (nicelemeli/quantized)

Dağılım kaymasını yönetmek için DAgger kullanılıyor. Üç eksende ölçüyoruz: **performans korunumu × yorumlanabilirlik × çıkarım maliyeti** (parametre sayısı, FLOP, tahmini gecikme).

Sonra soruyoruz: bu damıtılmış politika bir mikrodenetleyicide çalışabilir mi? Bu, taşınabilir bir manyetometrenin içine RL politikası koymanın önkoşulu.

*Bu neden özgün:* Yorumlanabilir RL damıtımı robotikte var, kuantum algılamada yok. Ve "gömülebilirlik" analizi sanayi köprüsünü kuruyor.

### 5.4 Neden Bu Üçü Birlikte Bir Hikâye

> RL daha iyi algılama protokolleri buluyor — ama ancak gerçek cihaz sapmalarına dayanırsa ve sensörün kendi üzerinde çalışabilirse bir işe yarar. Biz ikisini de ölçen kıyaslamayı ve ikisini de sağlayan damıtma hattını kuruyoruz.

Tek cümlede anlatılabiliyor. Bu, iyi bir projenin işaretidir.

---

## 6. Teknik Tasarım

### 6.1 MDP Formülasyonu

```
Durum (state):
  - Spinin mevcut durumu (Bloch vektörü: ⟨Sx⟩, ⟨Sy⟩, ⟨Sz⟩)
  - Geçen zaman / kalan bütçe
  - Son k aksiyonun geçmişi
  - [gürbüz varyantta] tahmini cihaz parametreleri veya ölçüm geçmişi

Aksiyon (action):
  - Kesikli mod: {X(π/2), X(π), Y(π/2), Y(π), bekle(Δt), ölç}
  - Sürekli mod: (genlik, faz, süre) ∈ ℝ³

Geçiş (transition):
  - QuTiP mesolve() ile Lindblad evrimi
  - Cihaz parametreleri bölüm başında dağılımdan örneklenir

Ödül (reward):
  - Ana: hassasiyet iyileşmesi (Fisher bilgisi tabanlı)
  - Yardımcı: hedef duruma fidelity
  - Ceza: toplam darbe süresi, aşırı genlik, pürüzsüzlük ihlali

Bölüm sonu:
  - Zaman bütçesi dolduğunda veya ajan "ölç" seçtiğinde
```

### 6.2 Teknoloji Yığını

| Katman | Araç | Not |
|---|---|---|
| Kuantum simülasyon | **QuTiP 5** | Olgun, iyi dokümante, `mesolve` yeter |
| Klasik optimal kontrol | **QuTiP-QOC** veya **QuOCS** | GRAPE/CRAB baseline'ları hazır geliyor |
| RL ortamı | **Gymnasium** | Standart arayüz |
| RL algoritmaları | **Stable-Baselines3** | PPO, SAC hazır. Kendi algoritmanızı yazmayın |
| Deney takibi | **Weights & Biases** veya **MLflow** | Ücretsiz katman yeter |
| Sembolik regresyon | **PySR** | Kapalı form formül çıkarımı |
| Karar ağacı damıtma | **scikit-learn** + kendi DAgger döngünüz | |
| Görselleştirme/demo | **Streamlit** veya **Gradio** | Bloch küresi animasyonu QuTiP'te hazır |
| Reprodüksiyon | **Docker** + `environment.yml` + sabit tohumlar | Jüri ve hakem için kritik |

**Donanım:** Dizüstü bilgisayar yeterli. GPU işi hızlandırır ama şart değil. Google Colab ücretsiz katmanı fazlasıyla yeter. Bu, bütçe savunmanızı kolaylaştırır.

### 6.3 Metrikler

| Metrik | Ne ölçer | Neden önemli |
|---|---|---|
| Hassasiyet η (T/√Hz) | Sensörün gerçek performansı | **Ana metrik.** Sanayinin baktığı sayı |
| Fidelity F | Durum hazırlama kalitesi | Literatürle karşılaştırma için |
| Gürbüzlük alanı | Sapma ızgarası üzerinde ortalama performans | K2'nin ana çıktısı |
| En kötü durum performansı | Izgaradaki minimum | Güvenlik-kritik uygulamalar için |
| Örnek verimliliği | Yakınsama için gereken bölüm sayısı | Pratik uygulanabilirlik |
| Damıtma sadakati | Damıtılmış ≈ orijinal politika mı | K3'ün kalite ölçüsü |
| Model boyutu / FLOP | Gömülebilirlik | Sanayi köprüsü |

---

## 7. İş Paketleri ve 12 Aylık Takvim

### WP0 — Temel Kurulum (Ay 1–2)
- Fizik temeli: Bloch küresi, Rabi salınımı, Ramsey, T1/T2, Lindblad. *(Kaynak: Nielsen & Chuang Böl. 2 + QuTiP tutorial'ları + arXiv:2112.07453 "Tutorial on Optimal Control and RL for Quantum Technologies" — Jupyter defterleri açık kaynak)*
- QuTiP kurulumu, Ramsey ve CPMG dizilerinin elle simülasyonu
- **Kilometre taşı:** Cooke & Czischek (PRA 2025) sonucunun kaba reprodüksiyonu
- **Çıktı:** Çalışan not defteri + ilk Bloch küresi animasyonu

> Bu iş paketini TÜBİTAK başvurusundan **önce** bitirin. Ön-sonuç göstermek kabul şansını ciddi artırır.

### WP1 — QSenseBench v0.1 (Ay 3–4)
- Gymnasium ortamı: tek spin, kesikli + sürekli aksiyon
- Domain randomization katmanı, yapılandırma dosyasıyla
- Üç zorluk seviyesi tanımı, deneysel literatürden parametre aralıkları
- Birim testleri, dokümantasyon, `pip install` edilebilir paket
- **Çıktı:** GitHub'da yayınlanmış v0.1

### WP2 — Baseline'lar (Ay 4–5)
- Ramsey, CPMG, XY8 implementasyonu
- GRAPE ve CRAB (QuTiP-QOC üzerinden)
- Hepsinin nominal koşulda kalibrasyonu ve doğrulanması
- **Çıktı:** Baseline sonuç tablosu

### WP3 — RL Eğitimi (Ay 5–7)
- PPO ve SAC eğitimi (Stable-Baselines3)
- Hiperparametre taraması
- Domain randomization'lı ve'sız varyantlar
- Her koşuda ≥5 rastgele tohum *(tek tohumla sonuç raporlamak hakemleri kızdırır)*
- **Çıktı:** Eğitilmiş politika seti + öğrenme eğrileri

### WP4 — Gürbüzlük Kıyaslaması (Ay 7–9)
- Parametre ızgarası üzerinde tüm yöntemlerin değerlendirilmesi
- Gürbüzlük eğrileri, ısı haritaları
- Ablasyon çalışmaları: hangi bileşen ne kadar katkı sağlıyor
- İstatistiksel anlamlılık testleri
- **Çıktı:** Projenin ana bulgu seti. Buradan makale çıkar.

### WP5 — Sembolik Damıtma (Ay 9–10)
- DAgger veri toplama döngüsü
- Karar ağacı, PySR sembolik ifade, nicelemeli ağ
- Performans/yorumlanabilirlik/maliyet üçlü analizi
- Gömülü dağıtım maliyet tahmini
- **Çıktı:** Damıtılmış politikalar + karşılaştırma tablosu + (varsa) okunabilir formül

### WP6 — Yayın ve Yaygınlaştırma (Ay 10–12)
- Streamlit interaktif demo (Bloch küresi + canlı metrikler)
- arXiv ön baskısı
- Repo cilalama: README, örnekler, reprodüksiyon talimatları, lisans
- Konferans/dergi gönderimi
- TÜBİTAK sonuç raporu + bitirme projesi savunması

### WP7 — Uzatma Hedefi (Ay 11–12, opsiyonel)
**Many-body teması buraya geri geliyor:** Ortamı N adet etkileşen spine (NV topluluğu, dipolar etkileşimli) genişletme. Bu, gerçek bir many-body kontrol problemidir ve manyetometrelerin "etkileşim-limitli rejimi" olarak literatürde tanımlıdır. Zaman kalırsa yapılır, kalmazsa "gelecek çalışma" olur. **Ana projeyi hiçbir şekilde riske atmaz.**

### Görsel Takvim

```
Ay:        1  2  3  4  5  6  7  8  9  10 11 12
WP0 Temel  ██ ██
WP1 Ortam        ██ ██
WP2 Baseline        ██ ██
WP3 RL                 ██ ██ ██
WP4 Kıyas                    ██ ██ ██
WP5 Damıtma                        ██ ██
WP6 Yayın                             ██ ██ ██
WP7 Uzatma(opsiyonel)                    ░░ ░░
```

---

## 8. Risk Analizi ve B Planları

Bu bölümü proje önerinize aynen koyun. Hakemler dürüst risk analizini sever.

| # | Risk | Olasılık | Etki | B Planı |
|---|---|---|---|---|
| R1 | RL, GRAPE'i yenemez | **Orta** | Düşük | **Bu bir sorun değil, bir bulgudur.** Makalenin çerçevesi "RL ne zaman kazanır, ne zaman kaybeder" olur. Benchmark katkısı (K1) zaten ayakta. Negatif sonuçlu dürüst çalışmalar iyi karşılanır. |
| R2 | Fizik öğrenme eğrisi beklenenden dik | Orta | Orta | WP0'ı 3 aya uzatın. Danışman + fizik bölümünden bir yüksek lisans öğrencisiyle haftalık 30 dk görüşme ayarlayın. QuTiP tutorial'ları çok iyi. |
| R3 | Eğitim yakınsamıyor | Orta | Orta | Kesikli aksiyon uzayına düşün (çok daha kolay). Ödülü basitleştirin. Müfredat öğrenmesi (kolay→zor) ekleyin. Stable-Baselines3 varsayılan hiperparametreleri genelde çalışır. |
| R4 | Sembolik damıtma anlamlı formül üretmez | Orta | Düşük | Karar ağacı yeter — o da yorumlanabilir. Sembolik regresyon bonus. Ayrıca "damıtılamıyor olması" da bir bulgudur. |
| R5 | Benzer bir makale çıkar | Düşük-Orta | Orta | Alan hızlı ama benchmark+gürbüzlük+damıtma üçlüsü dar bir niş. Çıkarsa: onu baseline yapın, farkınızı vurgulayın. Aylık arXiv taraması yapın. |
| R6 | Hesaplama yetersiz | Düşük | Düşük | Sistem küçük, dizüstü yeter. Colab yedek. |
| R7 | Ekip üyesi ayrılır | Orta | Orta | İş paketlerini baştan ayırın, her şeyi Git'te tutun, kimse tek başına kritik bilgi taşımasın. |
| R8 | 2209-B için sanayi ortağı bulunamaz | Orta | Yüksek | **2209-A'ya başvurun.** Proje A için de tamamen uygun. Bkz. Bölüm 12. |

**Projenin en güçlü özelliği:** R1'e dikkat edin. Ana hipotez çürüse bile proje çıktı üretir. Bu, öğrenci projelerinde nadir bir lükstür ve planın tasarımında bilinçli bir tercihtir.

---

## 9. Kademeli Başarı Kriterleri

Bunları proje önerinize koyun. "Şunu hedefliyoruz" demek yerine kademe tanımlamak profesyonel görünür.

**Minimum başarı (bu olmazsa proje başarısız):**
- QSenseBench çalışıyor, GitHub'da, dokümante
- En az 3 baseline + 2 RL algoritması, nominal ve gürültülü koşulda değerlendirilmiş
- Gürbüzlük eğrileri üretilmiş
- TÜBİTAK sonuç raporu + bitirme savunması tamam

**Hedef başarı (gerçekçi hedef):**
- Yukarıdakiler + en az bir koşulda RL'in baseline'ları anlamlı şekilde geçtiği veya geçemediğinin net gösterimi
- Sembolik damıtma çalışıyor, performans korunum oranı ölçülmüş
- arXiv ön baskısı yayınlanmış
- İnteraktif demo çalışıyor
- Bir workshop veya ulusal konferansa kabul

**İddialı başarı (bonus):**
- Q1/Q2 dergiye kabul (*Machine Learning: Science and Technology*, *Quantum Science and Technology*, *Quantum Machine Intelligence*)
- NeurIPS/ICLR "ML and the Physical Sciences" workshop kabulü
- Repo'nun başkaları tarafından kullanılması (yıldız, fork, issue)
- WP7 many-body uzantısı tamamlanmış

---

## 10. Hedef Yayın Yerleri (Gerçekçi Merdiven)

| Seviye | Yer | Gerçekçilik |
|---|---|---|
| Isınma | SIU, ASYU, INISTA (ulusal) | Yüksek — ilk sonuçları buraya |
| Sağlam hedef | *Machine Learning: Science and Technology* (IOP, Q1, açık erişim) | **En iyi eşleşme.** Benchmark+ampirik çalışmalara açık |
| Sağlam hedef | *Quantum Machine Intelligence* (Springer) | İyi eşleşme |
| Sağlam hedef | *Quantum Science and Technology* (IOP) | Fizik ağırlıklı, biraz zor |
| İddialı | NeurIPS / ICLR **ML4PS Workshop** | Ulaşılabilir, prestijli, hakemli |
| İddialı | ICML **AI4Science Workshop** | Ulaşılabilir |
| Çok iddialı | NeurIPS/ICML/ICLR ana track | Hedef olarak koymayın. Olursa bonus. |

**Strateji:** Önce arXiv'e koyun (ücretsiz, hemen görünürlük, öncelik hakkı). Sonra workshop. Sonra dergi. Aynı iş üç kademede değerlendirilebilir.

---

## 11. Sanayi Bağlantısı ve Yaygın Etki

Bu bölüm 2209-B için zorunlu, 2209-A için de puan getirir. Ve iddialarınızın hepsi belgelenebilir:

**Ulusal bağlam (proje önerinizde atıf verin):**

- Savunma Sanayii Başkanlığı **Kuantum Programı** kapsamında bugüne kadar kuantum hesaplama, **algılama** ve haberleşme alanlarında 16 proje başlatıldı. Program hedefleri arasında "**sinyal bağımsız navigasyon**" ve "hassas sensör teknolojileri" açıkça yer alıyor.
- **TÜBİTAK'ın EUREKA Xecs 2026 Uygulamalı Kuantum Teknolojileri Çağrısı**, kuantum algılama başlığı altında "tıbbi teşhis ve görüntüleme, hassas navigasyon, jeolojik araştırmalar ve uzay uygulamaları"na odaklanıyor ve açıkça "**boyut küçültme**" ile "**makine öğrenmesi destekli çözümler**"i kapsama alıyor. **Sizin projeniz bu iki maddenin tam kesişimi.**
- **ASELSAN KUANTAL** (Kuantum Araştırma Laboratuvarı), TOBB ETÜ yerleşkesinde faaliyette.
- **TÜBİTAK UME** (Ulusal Metroloji Enstitüsü) manyetometre üretiyor — İMECE-2 ve İMECE-3 uyduları için manyetometre çalışmaları 2025'te başladı. Kuantum metroloji tarafında da aktif.
- Bosch gibi sanayi oyuncuları NV manyetometre + ML konusunda yayın yapıyor — problem sanayi tarafından da öncelikli görülüyor.

**Yaygın etki argümanınız:**

> Kuantum manyetometreler, GPS'in kullanılamadığı ortamlarda navigasyon, yeraltı/sualtı anomali tespiti ve tıbbi görüntüleme için kritik. Bu sensörlerin sahaya inmesindeki temel engellerden biri, laboratuvarda optimize edilen kontrol protokollerinin gerçek cihazlardaki parametre sapmaları altında performans kaybetmesi ve adaptif kontrol için gereken hesaplama yükünün taşınabilir donanıma sığmaması. Bu proje her iki soruna da doğrudan yönelen açık kaynak bir altyapı ve yöntem sunuyor.

**Somut çıktılar (yaygın etki tablosuna yazın):**
- Açık kaynak yazılım paketi (MIT/Apache lisansı)
- Ön baskı + hakemli yayın
- İnteraktif demo (eğitim amaçlı da kullanılabilir)
- Reprodüksiyon paketi

---

## 12. 2209-A mı, 2209-B mi?

**2209-A** (genel araştırma): Sanayi ortağı gerekmez. Bu proje A için tamamen uygun ve **daha güvenli seçenek**.

**2209-B** (sanayiye yönelik): Bir sanayi kuruluşuyla resmi işbirliği + firmadan bir danışman gerekir. Kabul edilirse prestij ve bütçe daha yüksek, CV'de daha güçlü durur. Ama **ortak bulamazsanız başvuru geçersiz olur.**

**Önerim:** Sanayi ortağı görüşmelerini şimdi başlatın. 3 ay içinde bağlayıcı bir taahhüt alamazsanız 2209-A'ya dönün. Projenin bilimsel içeriği ikisinde de aynı kalıyor — sadece çerçeveleme değişiyor. Bu, planın esnek olduğu anlamına gelir; sizi kilitlemez.

**Ortak adayları (araştırılması gereken, garanti değil):** ASELSAN (KUANTAL), TÜBİTAK UME, TOBB ETÜ Kuantum Teknolojileri Araştırma Laboratuvarı, kuantum alanında çalışan teknopark firmaları. Danışman hocanızın mevcut bağlantıları en hızlı yoldur — önce ona sorun.

---

## 13. Bütçe Taslağı (~9.000 TL çerçevesinde)

| Kalem | Tahmini | Gerekçe |
|---|---|---|
| Bulut hesaplama kredisi | 2.000 TL | Parametre taramaları için; Colab Pro veya benzeri |
| Konferans kayıt (ulusal) | 3.000 TL | Sonuçların yaygınlaştırılması |
| Kitap / çevrimiçi kurs | 1.500 TL | Kuantum kontrol ve RL kaynakları |
| Açık erişim yayın katkısı | 2.000 TL | Kısmi APC desteği |
| Sarf / kırtasiye | 500 TL | |

**Not:** Donanım talebi yapmayın. "Mevcut kişisel bilgisayarlarla ve ücretsiz bulut kaynaklarıyla yürütülebilir" demek, yapılabilirlik puanınızı artırır — hakem "bunlar ne istediğini biliyor" der.

---

## 14. İlk 30 Gün: Somut Adımlar

Başvuru yazmadan önce bunları yapın. Ön-sonuç, başvurunuzun en güçlü silahıdır.

**Hafta 1**
- QuTiP kurun, resmi tutorial'ları çalıştırın
- arXiv:2112.07453'ün Jupyter defterlerini indirip çalıştırın (açık kaynak)
- Bloch küresinde tek spin dinamiğini kendiniz simüle edin

**Hafta 2**
- Ramsey dizisini sıfırdan yazın, T2\* etkisini görselleştirin
- CPMG ekleyin, ikisini karşılaştırın
- Danışman hocayla ilk teknik toplantı — bu planı gösterin

**Hafta 3**
- Basit bir Gymnasium ortamı sarmalayın (tek spin, 4-5 kesikli aksiyon)
- Stable-Baselines3 PPO'yu üzerinde çalıştırın. Amaç mükemmel sonuç değil, **hattın uçtan uca çalıştığını görmek**
- Cooke & Czischek makalesini okuyun

**Hafta 4**
- Domain randomization'ın en basit halini ekleyin (sadece T2\* rastgele)
- RL vs Ramsey'i iki koşulda karşılaştırın: nominal ve gürültülü
- İlk grafiği üretin
- Özgünlük iddiasını tekrar doğrulayın (literatür + GitHub araması)

**30. gün çıktısı:** Elinizde bir grafik ve çalışan bir kod var. Başvuruya "ön çalışma bulguları" diye koyun. Bu, sizi başvuruların %90'ından ayırır.

---

*Bu plan Ağustos 2026 itibarıyla yapılan literatür taramasına dayanmaktadır. Özgünlük iddiaları başvuru öncesinde tekrar doğrulanmalıdır.*
