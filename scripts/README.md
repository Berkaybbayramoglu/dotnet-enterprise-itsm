# 🛠️ ITSM Tool — Geliştirici Betikleri (Scripts)

Bu dizin, projenin yerel geliştirme, test, duman testi (smoke test) ve CI/CD süreçlerini otomatikleştiren standart yardımcı betikleri içerir.

---

## 📜 Mevcut Betikler

### 1. `test-coverage.sh`
Tüm 353 birim testini çalıştırır ve Coverlet aracılığıyla katman bazlı (Domain, Application, Infrastructure, API) satır ve dal kapsamı raporunu (`coverage.opencover.xml`) oluşturur.

```bash
./scripts/test-coverage.sh
```

### 2. `run-dev.sh`
Geliştirme ortamında API ve statik web sunucusunu `http://localhost:5246` adresinde başlatır. Çıkış yapıldığında (`Ctrl+C`) çalışan arka plan süreçlerini otomatik olarak güvenle sonlandırır.

```bash
./scripts/run-dev.sh
```

### 3. `smoke.sh`
Sistem ayağa kalktıktan sonra temel kimlik doğrulama ve API uç noktalarını otomatik olarak test eden duman testi betiğidir.

```bash
./scripts/smoke.sh
```
