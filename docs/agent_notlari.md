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

### Faz 14v4 (19 Ağustos 2026) - Kanban Regresyonu ve ID->Label Mapping
- **Faz 12.5**: Fix Batch v4 (Kanban regresyonu, raw ID temizliği, Reopen iş akışı).
- **Faz 12.6**: Fix Batch v5 (XSS Double-Escape, Rules Label Mapping ve Edit, SystemAuditLog Ayrışımı).
- **Faz 12.7**: Audit 500 Root Cause Resolution (Schema Drift Migration, Null-Safe UI, Test Coverage).
- **Faz 12.8**: Fix Batch v6 (Status Semantics, Tickets UI Final Sweep, Rule Toggle with Audit).
- **Faz 12.9**: Fix Batch v7 (Event Delegation, Audit UI Null-Safety, Regression Tests).
- **Faz 12.10**: Fix Batch v8 (CERRAHİ: Rule Edit Delegation payload okuma düzeltmesi, Reopen Matrisi için DataSeeder Upsert Yapısı, Smoke Script).
- **Faz 12.11**: Fix Batch v9 (Ticket Edit w/ Per-Field Audit, Dev-Only AutoSeed, Kapsamlı Audit Policy).
- **Faz 12.12**: Fix Batch v10 (In-Place Ticket Editing, Dynamic Field Validation, No-Op Audit Tracking, Timeline Activity).
- **Faz 12.13**: Fix Batch v11 (Tickets Chip Filters Delegation, Shared Preview Modal for Kanban & Dashboard).
- **Faz 12.14**: Fix Batch v12 (Knowledge Base Authoring UI, Data Seeder KB articles, Hero Contrast, kb-article.html ViewCount integration).
- **Faz 12.15**: Fix Batch v13 (RBAC ve Rol Yönetimi, Data Seeder Demo Kimlikleri, Permission Matrix UI, JWT üzerinden dinamik menü rendering, Kapsamlı Rol/Permission Yetkilendirme).
- **Faz 14**: Fix Batch v14 (Clickable KPI Cards, Drill-Down Modals, Dashboard Surveys Endpoint, A11y enhancements).
- **Kanban Regresyon Çözümü:** `window.api.getLookup()` çağrısı `api.js` dosyasına eklendi ve `kanban.html` içerisinde fallback (defensive rendering) eklendi.
- **ID to Label Mapping:** `tickets.html`, `dashboard.html` (Recent Tickets), `ticket-detail.html`, ve `audit-log.html` üzerinde ham ID gösterimleri kaldırılarak lookup üzerinden gelen Name karşılıkları yazıldı.
- **Assign UI:** `ticket-detail.html` içerisine kullanıcı atama (Assign) dropdown'ı eklendi.
- **Audit ve Dashboard Workload:** AuditLog filter dto'sunda int id yerine "ITS-1" okuyabilmesi için `Ticket (string)`'e geçildi. DashboardService takım yükü'nde ise, henüz bilet atanmamış aktif kullanıcıları (0) listeye dâhil edecek GroupJoin eklendi.

## COMPLIANCE AUDIT BATCH
- **Hedef:** PDF staj dokümanı gereksinimlerine (Compliance) tam uygunluk.
- **Yapılanlar:** `DataSeeder.cs` içerisinde Grup sayısı 4'e çıkarıldı. Admin sidebar linkleri `config.manage` yetkisine bağlandı (Tüm sayfalara entegre edildi). Transfer UI özelliği `ticket-detail.html` içerisine eklendi. Responsive (Hamburger menü, grid stack, overflow) tasarımı `design-system.css` ve `ui.js` içerisine eklendi. `varsayimlar.md` oluşturularak i18n kararı belgelendi. README.md tamamen yenilendi.
- **Durum:** Tamamlandı (✅).

## FIX BATCH v15
- **Hedef:** Undo Pattern, KB Aksiyonları, Görünürlük (Visibility) düzeltmesi ve Kanban Scroll izolasyonu.
- **Yapılanlar:** `KnowledgeBaseService.cs` içerisinde `isStaff` kontrolü `ticket.edit` içerecek şekilde düzeltildi (Temsilcilerin internal/draft makale görmesi için). `ui.js` içerisine `showUndoToast` animasyonlu olarak eklendi. `kb-article.html` sayfasına yönetici (kb.manage) için Edit/Publish/Delete aksiyon bar'ı entegre edildi ve Undo ile bağlandı. `kanban.html` CSS'i sayfa scroll'unu durdurup board'un (viewport) yatay scroll almasını sağlayacak şekilde `height: calc(100vh - 150px)` ile ezildi. Unit testler çalıştırılarak onaylandı.
- **Durum:** Tamamlandı (✅).

## FIX BATCH v16
- **Hedef:** Kanban Kolon Sırası (Kişisel) ve Avatar Yetki Paneli.
- **Yapılanlar:** `/api/auth/me` uç noktasına `Overrides` eklendi. UI (ui.js) içerisinde sağ üstteki avatar için tıklamayla açılan "Benim Yetkilerim" modal paneli kodlandı; override edilen yetkilere rozet eklendi. `kanban.html` sayfasında HTML5 Drag & Drop (dataTransfer 'column') ile kolon başlıklarına sıralama özelliği kazandırıldı, sıra `kanban.colorder.{userId}` olarak localStorage'a bağlandı.
- **Durum:** Tamamlandı (✅).

## FIX BATCH v17
- **Hedef:** Kanban "null" gösterge temizliği ve SuperAdmin Sidebar regresyonu.
- **Yapılanlar:** Kanban'da kolon sürüklenirken beliren "null" yazısı, dataset hedefi düzeltilerek ve şeffaf dragImage (1x1 pixel) atanarak çözüldü. SuperAdmin hesaplarında sidebar linklerinin kaybolması sorunu (fail-closed token parse) çözüldü; `/api/me` üzerinden async veri çekilip token claims yalnızca fallback olarak kullanıldı. `docs/varsayimlar.md` içerisine RBAC Yetki-Özellik matrisi tablo olarak eklendi.
- **Durum:** Tamamlandı (✅).

## FIX BATCH v18
- **Hedef:** Org Admin Sayfaları (6 sayfa) Runtime kanıtı, Event Delegation ve Drag Visual Feedback.
- **Yapılanlar:** Eksik olan `CategoriesController` oluşturuldu ve tüm `/api/categories`, `/api/projects` vb. org uç noktalarının runtime GET 200 ve POST yanıtları curl testiyle doğrulandı. 6 admin sayfasındaki (Projects, Categories, Depts, Groups, Users, Roles) tüm inline `onclick=` işleyicileri temizlenerek `data-action=` mimarisine ve Event Delegation pattern'ine geçirildi. Silme işlemleri v15 undo toast deseniyle (`showUndoToast`) güncellendi. `kanban.html` ve `design-system.css` içerisine kolon ve bilet sürükleme anında görsel geri bildirim (affordance) sağlaması için `.dragging` (opacity) ve `.drag-over` (outline) class'ları native DnD olaylarına eklendi. Öğrenme raporu (ogrenme-notlari.md) "Kodda var vs Runtime'da var" maddesiyle güncellendi.
- **Durum:** Tamamlandı (✅).

## FIX BATCH v19
- **Hedef:** Final Cleanup 6 — EF Async Sweep, CSS Blocker, JS Strict Numbers, A11y Label Sweep.
- **Yapılanlar:** `DataSeeder.cs` ve diğer altyapı sınıflarında `DbContext` üzerinde yapılan tüm senkron sorgular (`.Any()`, `.FirstOrDefault()`, vb.) performans ve thread-starvation önlemi gereği `.AnyAsync()`, `.FirstOrDefaultAsync()` ile asenkron hale getirildi (In-memory `ToList()` istisnaları hariç). `design-system.css` içerisindeki hatalı çıplak `-var(--sidebar-width)` sözdizimi geçerli `calc()` metoduna geçirildi. `wwwroot/` genelindeki `parseInt` ve `isNaN` global metotları Type Coercion tuzaklarını önlemek için katı `Number.parseInt` ve `Number.isNaN` karşılıklarına taşındı. Etiketsiz form inputları/select'ler (örn. `groups.html`, `kb-article.html`) WCAG uygunluğu için `<label for="">` veya `aria-label` ile erişilebilir kılındı. Unit Testler çalıştırılarak regülasyonlar doğrulandı. Öğrenme Raporu (`ogrenme-notlari.md`) Sync-over-Async antipattern ve JS Type Coercion notlarıyla güncellendi.
- **Durum:** Tamamlandı (✅).
- Repo-wide Sweeps: Fixed empty catches, top-level awaits, and dataset APIs globally across all web files. 
- Refactored `TicketService` and `DataSeeder` for lower cyclomatic complexity by abstracting validation logic and conditional loop logic into separate helper methods.
- Avoid repeating findings: if something needs fixing, apply it comprehensively using `grep` instead of line-by-line fixes.

- One-Off Script Rule: Helper/one-off Python scripts for refactoring (like fix_*.py or sweep.py) MUST NOT be kept in the repository because they trigger SonarQube issues and pollute the codebase. Execute them from outside the repo (e.g., /tmp/) or delete them immediately after use.
- Clean Code Sweeps: Empty catch blocks must not exist; always log the error or use a user toast.
- Accessibility: Ensure all heading tags (e.g., `<h3>`) contain meaningful text, not just aria-labels on empty tags.

- Complexity Management: Nested ternaries inside loops are anti-patterns. Always extract mapping/conditional logic to static helpers or independent functions.
- HTML Semantics: Do not use `div role="group"`. Always use `<fieldset>` with an `<legend>` element (even if visually hidden via `.sr-only` or CSS) for better screen-reader accessibility.
- Top-Level Await: Always use `<script type="module">` for top-level scripts when calling async functions to avoid unhandled promises at page load.

- Final Cleanup 11 — Kapanış: Functions generating HTML must return it. Never leak DOM updates into mapping/building functions if they are supposed to return strings. Consistent return contracts are necessary for clean architecture. 
- Top-level await is standard for modern ES modules in `wwwroot`.

- Final Cleanup 12 — DRY & Zero Complexity: 
  - Centralized all frontend logic for basic admin CRUD tables into `crud-page.js` (Config-Driven Factory). 
  - Standardized backend basic entities to inherit from `CrudControllerBase<TDto, TCreateDto, TUpdateDto>`.
  - Removed duplicated query filter chains between `ReportService` and `TicketService` by moving them to `TicketQueryHelpers`.

- Final Cleanup 13 — Skeleton DRY & Final Bugfixes:
  - Extracted the entire HTML skeleton (toolbar, table, modal structure) into `crud-page.js` to leave HTML files with only `<div id="crudRoot"></div>`.
  - Changed `CrudControllerBase` to `CrudControllerBase<TDto>` to keep generic parameters to ≤2.
  - Eliminated high complexity inside `crud-page.js` by extracting `renderTable`, `submitForm`, and `wireActions`.

- Final Cleanup 14 — TAM KAPANIŞ:
  - Addressed the final 7 mechanical bugs.
  - Implemented strict ReDoS prevention in `EmailIngestionService` with `TimeSpan.FromSeconds(2)` on regular expressions and proper `RegexMatchTimeoutException` handling.
  - Reduced optional chaining and ternary complexities across UI rendering code.

- Final Cleanup 15 — Grep-Gated Yöntem:
  - Diskte var olan düzeltmelerin SonarQube cache/branch senkronizasyon problemleri nedeniyle taramalara yansımadığı durumlarda `grep`/`sed` kullanılarak disk doğrulaması yapıldı.
  - Phase 14'te yapılan düzeltmelerin (where TDto, ReDoS timeout, nested-ternary iptali) diskte fiziksel olarak mevcut olduğu teyit edildi.

- Final Cleanup 16 — `crud-page.js` Complexity:
  - Böl-Yönet (Divide & Conquer) taktiği ile 15-20 satırlık JS metotları (`renderTable`, `submitForm`, `wireActions`) daha ufak parçalara ayrıldı (`buildCellHtml`, `populateForm`, `getFormData`, `persistData`, `performUndoableDelete`).
  - JS içindeki kullanılmayan destructured değişkenler silindi ve empty-catch bloklarına console.error + toast error handling mekanizması kuruldu.
