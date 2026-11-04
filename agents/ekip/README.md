# ekip — Modlu Geliştirme Ekibi

Ana Claude Code oturumu **Takım Lideri** olur, uzmanlar subagent olarak çalışır.
Ekip, işin boyutuna göre üç modda kod yazar; ayrıca kod yazmadan **inceleme** ve
**analiz** yapabilir. Amaç, gereken en az sayıda ajanla ve küçük bir bağlamla işi bitirmek.

```
S: Lider (KK-1) → Kod Uzmanı (test + düzeltme) → İnceleyici (hafif) → Teslim
M: Lider (spec) → Kod Uzmanı (plan) → Lider onayı → aynı Kod Uzmanı (testler → kod)
   → İnceleyici → Teslim
L: PRD Uzmanı → Lider onayı → Mimar → Test Uzmanı → Kod Uzmanı → Test denetimi
   → (Güvenlik ∥ Kod Kontrol) → Lider → Teslim
İnceleme: hedef (dal / PR / çalışma ağacı) → İnceleyici (l: ∥ Güvenlik) → rapor
Analiz:   soru → Kod Uzmanı (salt okunur) → (l: İnceleyici kanıt doğrulaması) → rapor
```

| İş | Ne zaman | Subagent çağrısı |
|---|---|---|
| S | Net hata, yeni özellik/uç nokta/şema değişikliği yok | 2 |
| M (varsayılan) | Geri kalan her şey | 2 (+ plan sonrası devam) |
| L | Auth/yetki, ödeme, kişisel veri, şemayı değiştiren migration, yeni servis, çok modüllü iş | 6 |
| incele | Bir dalı, PR'ı ya da commit edilmemiş değişiklikleri sadece incelemek | 1 (l: 2) |
| analiz | Kodu değiştirmeden "neden böyle / hata nereden" sorusu | 1 (l: 2) |

## Proje ayarı: ana dal ve korumalı dallar
Lider her işte projedeki `.claude/ekip.local.json` (yerel, öncelikli) ya da `.claude/ekip.json`
(paylaşılan) dosyasını okur. Dosya yoksa ana dalı tahmin eder, sana sorar ve istersen kaydeder.
Örnek: [`ekip.ornek.json`](ekip.ornek.json)

```json
{
  "anaDal": "master-preprod",
  "korumaliDallar": ["master", "master-preprod", "develop", "release/*"],
  "build": "dotnet build",
  "test": "dotnet test",
  "notlar": "Stored procedure'ler Database/StoredProcedures altında."
}
```
- İş dalları `anaDal`'dan açılır, PR'lar `anaDal`'a açılır.
- Ajanlar korumalı dallara commit atmaz. `install.sh <proje yolu>` çalıştırılınca bu dallara
  push ayrıca izin kuralıyla engellenir (ayar değişirse bir kez yeniden çalıştır).

## Veritabanı kuralları
- Migration, `.sql` ve stored procedure dosyaları yazılır, **çalıştırılmaz**.
- Her değişikliğin geri alma yolu olur (`Down()` ya da `<ad>_geri_al.sql`).
- Yıkıcı işlem (DROP, TRUNCATE, WHERE'siz DELETE/UPDATE, tip daraltma) spec açıkça
  istemedikçe yazılmaz.
- Stored procedure imzası değişirse tüm çağıranlar güncellenir.
- İnceleyici ve Kod Kontrol bunları ayrı bir "Veritabanı" maddesiyle kontrol eder; teslimde
  çalıştırılacak ve geri alınacak script'ler ile dağıtım sırası yazılır.

## Token ve hız için alınan önlemler
- **Dosya üzerinden devir:** spec, plan, tasarım, harita, rapor ve test logu `.ekip/<iş>/`
  altında durur. Lider prompt'a tam metin değil dosya yolu koyar, ajanlar en fazla 150
  kelimelik özet döner. `.ekip/` yerel olarak `.git/info/exclude`'a eklenir, commit edilmez.
- **Harita:** depoyu ilk okuyan ajan (Kod Uzmanı ya da Mimar) dokunulan bölgenin kısa
  haritasını yazar; sonraki ajanlar depoyu yeniden taramaz.
- **Plan kapısı + devam:** M'de Kod Uzmanı önce plan çıkarıp durur. Lider onaylayınca aynı
  ajan kaldığı yerden devam eder, depoyu yeniden okumaz.
- **Test bağımsızlığı commit sırasıyla:** önce "test:" commit'i, sonra uygulama. İnceleyici
  testlerin sonradan değiştirilmediğini git geçmişinden kontrol eder.
- **Tek build:** tam build/test'i Kod Uzmanı bir kez çalıştırır ve logu yazar; inceleyiciler
  sadece değişen alanın testlerini çalıştırır.
- **Model/effort:** Kod ve inceleme Sonnet/medium. Opus sadece L modunda (Mimar, Güvenlik)
  ve `incele l`'de Güvenlik için. Ajanlarda `maxTurns`, `omitClaudeMd` (proje CLAUDE.md'sini
  ajan kendisi okur, global dosya yüklenmez) ve 1 saatlik önbellek (`experimental.cacheTtl`) ayarlı.
- **Revizyon:** en fazla 2 tur; L'de sadece RET veren inceleyici yeniden çalışır.

## Dosyalar
| Dosya | Rol | Nerede | Model / effort |
|---|---|---|---|
| `komut/ekip.md` | Takım Lideri (`/ekip` komutu) | hepsi | oturum modeli |
| `kod-uzmani.md` | Kod Uzmanı | S M L, analiz | sonnet / medium |
| `inceleyici.md` | İnceleyici (kalite + test + veritabanı + güvenlik) | S M, incele, analiz l | sonnet / medium |
| `prd-uzmani.md` | PRD Uzmanı | L | sonnet / low |
| `mimar.md` | Mimar | L | opus / medium |
| `test-uzmani.md` | Test Uzmanı (önce testler, sonra denetim) | L | sonnet / medium |
| `guvenlik-uzmani.md` | Güvenlik Uzmanı | L, incele l | opus / medium |
| `kod-kontrol.md` | Kod Kontrol Uzmanı | L | sonnet / medium |
| `yayin-uzmani.md` | Yayın Uzmanı (push + PR, yalnız iş sahibi isteyince) | hepsi | haiku / low |
| `izinler.json` | Proje izin kısıtları (merge, main'e push, Azure'a yazma yasak) | – | – |
| `ekip.ornek.json` | Proje ayarı örneği (ana dal, korumalı dallar, build/test) | – | – |

## Kurulum
```bash
git clone https://github.com/iscaniskender/claude-skills ~/PROJECTS/claude-skills
sh ~/PROJECTS/claude-skills/agents/ekip/install.sh                 # ajanlar + /ekip
sh ~/PROJECTS/claude-skills/agents/ekip/install.sh ~/repos/proje   # + o projeye izin kısıtları
```
Ajanlar ve komut sembolik link olarak bağlanır; `git pull` sonrası yeniden kurulum gerekmez.
Yeni bir ajan dosyası eklendiğinde ya da projenin korumalı dalları değiştiğinde kurulumu bir
kez yeniden çalıştır.

`omitClaudeMd` için Claude Code v2.1.271+, `experimental.cacheTtl` için v2.1.248+ gerekir;
eski sürümler bu alanları sessizce yok sayar.

## Kullanım
```
/ekip azure 1234                      # mod Lider tarafından seçilir
/ekip s azure 1234                    # modu sen seçersin
/ekip l Ödeme ekranına 3D Secure ekle
/ekip Fatura listesine tarih filtresi ekle, varsayılan son 30 gün olsun

/ekip incele feature/odeme-filtre     # dalı ana dala göre incele
/ekip incele pr 42                    # GitHub ya da Azure PR'ı incele
/ekip incele calisma                  # commit edilmemiş değişiklikleri incele
/ekip incele l pr 42                  # + Güvenlik Uzmanı ile derin inceleme

/ekip analiz Docker build neden publish adımında patlıyor?
/ekip analiz l Ödeme listesi neden iki kez geliyor?   # + kanıt doğrulaması
```
İnceleme ve analiz işlerinde `.ekip/` dışında hiçbir dosya değişmez, dal değiştirilmez,
PR'a yorum yazılmaz.

Lider ana oturumdur ve en sık çalışan parçadır; oturumu Sonnet ile ve orta effort'la
açmak ayrıca tasarruf sağlar.

Azure işleri için `az` CLI + `azure-devops` eklentisi ve okuma yetkili PAT gerekir.
