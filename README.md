# claude-skills

Claude Code için kullandığım agent skill'lerinin merkezi deposu. Birden fazla bilgisayarda Claude Code kullandığım için bu repo, tüm makinelerde aynı skill setinin senkron kalmasını sağlıyor.

## Kurulum (yeni bir bilgisayarda)

```bash
git clone git@github.com:iscaniskender/claude.git ~/.claude/skills
```

Zaten dolu bir `~/.claude/skills` klasörü varsa önce mevcut içeriği yedekleyin, sonra klonlayın. Güncelleme almak için:

```bash
cd ~/.claude/skills && git pull
```

## Skill Listesi

### Giriş / Yönlendirme

| Skill | Ne zaman kullanılır |
|---|---|
| [`using-superpowers`](using-superpowers) | Herhangi bir konuşmaya başlarken; skill'lerin nasıl bulunup çağrılacağını belirler, herhangi bir yanıttan (açıklayıcı sorular dahil) önce skill çağrımını zorunlu kılar. |
| [`using-agent-skills`](using-agent-skills) | Agent skill'lerini keşfeder ve çağırır; hangi skill'in mevcut göreve uyduğunu belirleyen meta-skill. |
| [`context-engineering`](context-engineering) | Yeni bir oturuma başlarken, agent çıktı kalitesi düştüğünde veya görevler arası geçişte context/rules dosyalarını optimize eder. |
| [`brainstorming`](brainstorming) | Herhangi bir yaratıcı çalışmadan (özellik oluşturma, bileşen ekleme, davranış değiştirme) önce kullanıcı niyetini, gereksinimleri ve tasarımı keşfeder. |
| [`interview-me`](interview-me) | Belirsiz isteklerde kullanıcının gerçekte ne istediğini tek tek sorularla ~%95 güvene ulaşana kadar çıkarır. |
| [`idea-refine`](idea-refine) | Ham fikirleri, ıraksak ve yakınsak düşünmeyle net ve uygulanabilir kavramlara dönüştürür; varsayımları plana geçmeden stres testine tabi tutar. |
| [`doubt-driven-development`](doubt-driven-development) | Önemli her kararı, kesinleşmeden önce taze bağlamlı, adversarial bir incelemeye tabi tutar (üretim/güvenlik/geri döndürülemez işlemler gibi yüksek riskli durumlarda). |
| [`karpathy-guidelines`](karpathy-guidelines) | LLM'lerin yaygın kodlama hatalarını azaltmak için davranış kuralları: aşırı karmaşıklaştırmama, cerrahi değişiklikler, varsayımları açığa çıkarma, doğrulanabilir başarı kriterleri tanımlama. |

### Planlama

| Skill | Ne zaman kullanılır |
|---|---|
| [`spec-driven-development`](spec-driven-development) | Kod yazmadan önce spec oluşturur; yeni proje/özellik/önemli değişiklik başlarken veya gereksinimler net değilken kullanılır. |
| [`planning-and-task-breakdown`](planning-and-task-breakdown) | Spec veya net gereksinimler varken işi sıralı, uygulanabilir görevlere böler. |
| [`writing-plans`](writing-plans) | Çok adımlı bir görev için spec/gereksinim varken, koda dokunmadan önce plan yazar. |
| [`executing-plans`](executing-plans) | Yazılı bir uygulama planını, inceleme kontrol noktalarıyla ayrı bir oturumda yürütür. |
| [`incremental-implementation`](incremental-implementation) | Birden fazla dosyayı etkileyen her özellik/değişikliği artımlı olarak teslim eder; büyük bir kod bloğu tek seferde yazılacaksa devreye girer. |

### Uygulama

| Skill | Ne zaman kullanılır |
|---|---|
| [`test-driven-development`](test-driven-development) | Herhangi bir mantık uygularken, hata düzeltirken veya davranış değiştirirken testlerle geliştirmeyi yönetir. |
| [`source-driven-development`](source-driven-development) | Her uygulama kararını resmi dokümantasyona dayandırır; framework/kütüphane ile doğruluk önemliyse kullanılır. |
| [`api-and-interface-design`](api-and-interface-design) | Kararlı API ve arayüz tasarımına rehberlik eder (REST/GraphQL uç noktaları, modüller arası tip sözleşmeleri, frontend-backend sınırları). |
| [`frontend-ui-engineering`](frontend-ui-engineering) | Üretim kalitesinde, erişilebilir, responsive kullanıcı arayüzleri inşa eder; WCAG gereksinimlerini karşılar. |
| [`subagent-driven-development`](subagent-driven-development) | Bağımsız görevleri içeren uygulama planlarını mevcut oturumda subagent'larla yürütür. |
| [`dispatching-parallel-agents`](dispatching-parallel-agents) | Paylaşılan durum veya sıralı bağımlılık olmadan çalışılabilecek 2+ bağımsız görev olduğunda kullanılır. |
| [`using-git-worktrees`](using-git-worktrees) | Mevcut çalışma alanından izolasyon gerektiren özellik çalışmalarına başlarken izole bir çalışma alanı sağlar. |

### Kalite ve İnceleme

| Skill | Ne zaman kullanılır |
|---|---|
| [`code-review-and-quality`](code-review-and-quality) | Herhangi bir değişiklik ana dala birleştirilmeden önce çok eksenli kod incelemesi yapar. |
| [`code-simplification`](code-simplification) | Davranışı değiştirmeden netlik için kodu sadeleştirir; kod çalışıyor ama gereksiz karmaşıklaşmışsa kullanılır. |
| [`requesting-code-review`](requesting-code-review) | Görevleri tamamlarken, büyük özellikler uygularken veya birleştirmeden önce işin gereksinimleri karşıladığını doğrulamak için kullanılır. |
| [`receiving-code-review`](receiving-code-review) | Kod inceleme geri bildirimi alırken, öneriler net değilse veya teknik olarak şüpheliyse, körü körüne uygulamak yerine teknik titizlik ve doğrulama gerektirir. |
| [`verification-before-completion`](verification-before-completion) | İş bitti/düzeltildi/geçti demeden, commit/PR açmadan önce doğrulama komutlarını çalıştırıp çıktıyı onaylamayı zorunlu kılar. |
| [`debugging-and-error-recovery`](debugging-and-error-recovery) | Testler başarısız olduğunda, build bozulduğunda veya beklenmeyen davranışlarda sistematik kök neden analizi yapar. |
| [`security-and-hardening`](security-and-hardening) | Kullanıcı girdisi, kimlik doğrulama, veri depolama veya dış entegrasyonlarla çalışırken kodu güvenlik açıklarına karşı sağlamlaştırır. |
| [`performance-optimization`](performance-optimization) | Frontend, backend, sorgular ve veritabanlarında performansı optimize eder; N+1 sorgu, Core Web Vitals gibi durumlarda kullanılır. |
| [`browser-testing-with-devtools`](browser-testing-with-devtools) | Chrome DevTools MCP üzerinden gerçek tarayıcılarda test yapar; DOM inceleme, konsol hataları, ağ istekleri, performans profili gerektirdiğinde kullanılır (chrome-devtools MCP sunucusu gerektirir). |

### Sürüm Kontrolü ve Teslimat

| Skill | Ne zaman kullanılır |
|---|---|
| [`git-workflow-and-versioning`](git-workflow-and-versioning) | Commit, branch, çakışma çözümü, paralel iş akışları, sürüm bump'ı, etiketleme ve changelog yazımını yapılandırır. |
| [`finishing-a-development-branch`](finishing-a-development-branch) | Uygulama tamamlandığında, tüm testler geçtiğinde; merge/PR/temizlik seçeneklerini yapılandırılmış şekilde sunar. |
| [`ci-cd-and-automation`](ci-cd-and-automation) | CI/CD pipeline kurulumunu otomatikleştirir; kalite kapılarını, test çalıştırıcılarını, deployment stratejilerini yapılandırır. |
| [`shipping-and-launch`](shipping-and-launch) | Production'a deploy hazırlığı yapar: pre-launch checklist, monitoring kurulumu, aşamalı rollout, rollback stratejisi. |
| [`deprecation-and-migration`](deprecation-and-migration) | Eski sistemleri/API'leri kaldırırken veya kullanıcıları bir uygulamadan diğerine taşırken yönetir. |
| [`observability-and-instrumentation`](observability-and-instrumentation) | Logging, metrik, tracing, alerting ekler; production'da çalışan özelliklerin kanıtlanabilir olmasını sağlar. |
| [`documentation-and-adrs`](documentation-and-adrs) | Mimari kararları, API değişikliklerini, özellik teslimatlarını belgeler; gelecekteki mühendisler/agent'lar için bağlam kaydeder. |

### Diğer

| Skill | Ne zaman kullanılır |
|---|---|
| [`FlowForge`](FlowForge) | Süreç, mimari veya kavramları çizmek/görselleştirmek istendiğinde (akış şeması, mimari diyagramı, karşılaştırma diyagramı vb.) kullanılır. Grafik/plot istekleri veya sanatsal görsel istekleri için değildir. |
| [`graphify`](graphify) | Herhangi bir girdiyi (kod, döküman, makale, görsel, video) kalıcı bir bilgi grafiğine dönüştürür; kod tabanı, mimari veya dosya ilişkileri hakkında soru sorulduğunda, özellikle `graphify-out/` mevcutsa kullanılır. Tetikleyici: `/graphify`. |
| [`codebase-memory`](codebase-memory) | Yapısal kod sorguları için kod bilgi grafiğini kullanır: mimariyi keşfetme, çağıran/çağrılan izleme, etki analizi, ölü kod, Cypher sorguları. |
| [`i-have-adhd`](i-have-adhd) | Çıktıyı ADHD'li okuyucuya göre şekillendirir: ilk satır yapılacak eylem, numaralı adımlar, tek somut sonraki adım. `/i-have-adhd` ile açılır, "stop adhd mode" ile kapanır. Always-on hook için `sh i-have-adhd/install.sh` (skill + hook + `settings.json` girdisini kurar). |
| [`test-driven-development-2`](test-driven-development-2) | `test-driven-development`'ın alternatif sürümü (aynı `name`, daha kısa açıklama); hangisini kullanacağına göre birini seç. |
| [`writing-skills`](writing-skills) | Yeni skill oluştururken, mevcut skill'leri düzenlerken veya dağıtımdan önce skill'lerin çalıştığını doğrularken kullanılır. |

---

*Bu repo `AllSkills.zip` (2026-08-06 tarihli) içeriğinden 2026-08-21'de oluşturulmuştur. Skill setinde değişiklik olursa hem ilgili skill klasörünü hem bu README'yi güncelleyin.*

*2026-08-21: `graphify` skill'i `~/.claude/skills`'ten eklendi.*

*2026-10-21: `i-have-adhd`, `codebase-memory` ve `test-driven-development-2` eklendi. `api-and-interface-design`, `security-and-hardening` ve `source-driven-development` repodaki yeni sürümleriyle yerel `~/.claude/skills` ile eşitlendi. `synced/` klasörü (Claude uygulaması tarafından yönetilir) bilerek dışarıda bırakıldı.*
