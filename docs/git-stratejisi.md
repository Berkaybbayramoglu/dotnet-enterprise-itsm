# Git Branch ve Commit Stratejisi

## Branch Stratejisi (GitHub Flow / Git Flow Hibriti)
- **`main`:** Canlı ortam (production) kodunu temsil eder. Her zaman kararlı ve derlenebilir olmalıdır. `main` branch'ine doğrudan commit atılmaz, sadece PR (Pull Request) veya Merge ile kod alınır.
- **`develop`:** Geliştirme ortamının ana dalıdır. Tüm yeni özellikler önce burada toplanır. Uygulamanın entegre edilmiş en güncel halidir.
- **`feature/*`:** Yeni bir işlev geliştirileceğinde `develop` branch'inden türetilir. Örn: `feature/ticket-assignment`, `feature/user-roles`.
- **`hotfix/*`:** Canlıda (`main`) veya testte acil bir hata çıktığında müdahale etmek için kullanılır. Örn: `hotfix/login-crash`.

## Commit Disiplini
- "Küçük, anlamlı ve sık" commit kuralı esastır. Günde tek bir devasa commit yerine, her tamamlanan küçük adımda commit atılmalıdır.
- Kod çalışmayan durumdayken push yapılmamalıdır (WIP commitler hariç).

## Commit Mesaj Formatı (Conventional Commits)
Logların temiz okunabilmesi için aşağıdaki yapı takip edilecektir:
- `feat:` Yeni bir özellik (Örn: `feat: add SLA breach calculation algorithm`)
- `fix:` Bir hatanın düzeltilmesi (Örn: `fix: resolve status transition bug`)
- `docs:` Dokümantasyon değişiklikleri (Örn: `docs: update ERD and architecture diagram`)
- `refactor:` Mevcut kodun işlevini değiştirmeden iyileştirilmesi (Örn: `refactor: extract token generation to separate service`)
- `test:` Eksik testlerin eklenmesi (Örn: `test: add unit tests for assignment rules`)
- `chore:` Derleme süreci, bağımlılık güncellemeleri veya araç değişiklikleri (Örn: `chore: update EF Core packages`)

## PR (Pull Request) Yaklaşımı
Özellik tamamlandığında feature branch'inden `develop` branch'ine Pull Request açılır.
Mümkünse SonarQube analizi bu aşamada tetiklenerek kalite kapısından (Quality Gate) geçmesi sağlanır.
