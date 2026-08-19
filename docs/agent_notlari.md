BÖLÜM 1 — PROJE KİMLİĞİ
====================================================
- Turkcell staj projesi: ITSM Tool (Berkay Bayramoğlu). Faz 0-14 tamamlandı.
- Stack: .NET 8 / C#, PostgreSQL, vanilla HTML/CSS/JS frontend.
- Solution: ItsTool.Domain/Application/Infrastructure/API/Web + tests/ItsTool.UnitTests.
- Vizyon: configuration-driven ITSM.
- Ortam: API http://localhost:5246 | Web http://localhost:5139 | login admin/Admin123!

BÖLÜM 2 — ÖNCE OKU (HAFIZAN)
====================================================
Faz 14 (Workflow, Kanban Modal, Dashboard):
- Workflow transition seed idempotent hale getirildi (DataSeeder.cs). Count kontrolü eklendi, eksiği varsa (14'ten az ise) tamamen resetlenip full matris yükleniyor.
- TicketService.cs'te projeye özel workflow ararken OrderByDescending kullanılarak Global Fallback (ProjectId null) sağlandı.
- DashboardService.cs içerisinde EF Core count işleminin 0 dönmesini önlemek için .Include() eklendi.
- Kanban UI'da drag ve click çakışması önlenip karta tıklayınca Preview Modal açılması kodlandı.

### Faz 14v2 (19 Ağustos 2026) - Kök Neden Analizi ve Düzeltmeler (Dashboard, Transitions, UI)
- **Dashboard Kök Neden Çözümü:** `DashboardController`'daki token'dan ID okuma kodu, yanlış olan `"UserId"` string'i yerine `ClaimTypes.NameIdentifier` ("sub") okuyacak şekilde güncellendi. EF Core Include zannedilen sorun aslında ID 0 okuduğu için RequestUserId=0 filtrelemesi yapmasından ibaretti.
- **Workflow Transitions:** `DataSeeder.cs` içerisinde seeder'ın transitions UPSERT blokları, projedeki "hiç workflow yok" koşulunun (`!_context.Workflows.Any()`) dışına alındı ve tam 14 olasılıklı transition matrisi idompetent (gerekirse eskiyi temizleyip kuracak) şekilde entegre edildi.
- **Kanban Modal & Field Edit:** UI tarafında modal JavaScript fonksiyonları ve HTML tasarımları entegre edilerek drag-click çakışmaları ve frontend API bağlamaları (PUT, showPreview vs.) aktif edildi.

### Faz 14v3 (19 Ağustos 2026) - UX Polish, HCI Dashboard ve Tam Transition Matrisi
- **Transition Matrisi:** 19 olasılıklı (tüm olası geri dönüşleri ve reopen koşullarını içeren) tam state-machine matrisi seed edildi.
- **Dashboard HCI:** 6 KPI kartı yatayda, takiben sınırlandırılmış (260px) grafikler ve 'Takım Yükü' (agent-workload), 'Son Talepler' listesi oluşturuldu.
- **Kanban Modal:** ID'ler yerine kullanıcı adlarının ve pill tasarımlarının gösterilmesi (Lookup Cache yardımıyla) sağlandı.
