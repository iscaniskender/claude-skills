# ekip — Modlu Geliştirme Ekibi

Ana Claude Code oturumu **Takım Lideri** olur, uzmanlar subagent olarak çalışır.
Ekip, işin boyutuna göre üç modda çalışır. Amaç, gereken en az sayıda ajanla ve küçük
bir bağlamla işi bitirmek.

```
S: Lider (KK-1) → Kod Uzmanı (test + düzeltme) → İnceleyici (hafif) → Teslim
M: Lider (spec) → Kod Uzmanı (plan) → Lider onayı → aynı Kod Uzmanı (testler → kod)
   → İnceleyici → Teslim
L: PRD Uzmanı → Lider onayı → Mimar → Test Uzmanı → Kod Uzmanı → Test denetimi
   → (Güvenlik ∥ Kod Kontrol) → Lider → Teslim
```

| Mod | Ne zaman | Subagent çağrısı |
|---|---|---|
| S | Net hata, yeni özellik/uç nokta/veri modeli yok | 2 |
| M (varsayılan) | Geri kalan her şey | 2 (+ plan sonrası devam) |
| L | Auth/yetki, ödeme, kişisel veri, migration, yeni servis, çok modüllü iş | 7 |

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
- **Model/effort:** Kod ve inceleme Sonnet/medium. Opus sadece L modunda (Mimar, Güvenlik).
  Ajanlarda `maxTurns`, `omitClaudeMd` (proje CLAUDE.md'sini ajan kendisi okur, global
  dosya yüklenmez) ve 1 saatlik önbellek (`experimental.cacheTtl`) ayarlı.
- **Revizyon:** en fazla 2 tur; L'de sadece RET veren inceleyici yeniden çalışır.

## Dosyalar
| Dosya | Rol | Mod | Model / effort |
|---|---|---|---|
| `komut/ekip.md` | Takım Lideri (`/ekip` komutu) | S M L | oturum modeli |
| `kod-uzmani.md` | Kod Uzmanı | S M L | sonnet / medium |
| `inceleyici.md` | İnceleyici (kalite + test + güvenlik) | S M | sonnet / medium |
| `prd-uzmani.md` | PRD Uzmanı | L | sonnet / low |
| `mimar.md` | Mimar | L | opus / medium |
| `test-uzmani.md` | Test Uzmanı (önce testler, sonra denetim) | L | sonnet / medium |
| `guvenlik-uzmani.md` | Güvenlik Uzmanı | L | opus / medium |
| `kod-kontrol.md` | Kod Kontrol Uzmanı | L | sonnet / medium |
| `yayin-uzmani.md` | Yayın Uzmanı (push + PR, yalnız iş sahibi isteyince) | hepsi | haiku / low |
| `izinler.json` | Proje izin kısıtları (merge, main'e push, PR birleştirme/onay, Azure'a yazma yasak) | – | – |

`izinler.json` komut önekiyle eşleşir; bayrağı sona koyan varyantlar (örn. `git push origin x
--force-with-lease`, `az repos pr create --auto-complete`) kuralları aşar. Bu durumlarda
`git push:*` için ask kuralı ve Yayın Uzmanı'nın prompt yasakları koruyucudur.

## Kurulum
```bash
git clone https://github.com/iscaniskender/claude-skills ~/PROJECTS/claude-skills
sh ~/PROJECTS/claude-skills/agents/ekip/install.sh                 # ajanlar + /ekip
sh ~/PROJECTS/claude-skills/agents/ekip/install.sh ~/repos/proje   # + o projeye izin kısıtları
```
Ajanlar ve komut sembolik link olarak bağlanır; `git pull` sonrası yeniden kurulum gerekmez.
Yeni bir ajan dosyası eklendiğinde (örn. `inceleyici.md`) kurulumu bir kez yeniden çalıştır.

`omitClaudeMd` için Claude Code v2.1.271+, `experimental.cacheTtl` için v2.1.248+ gerekir;
eski sürümler bu alanları sessizce yok sayar.

## Kullanım
```
/ekip azure 1234                      # mod Lider tarafından seçilir
/ekip s azure 1234                    # modu sen seçersin
/ekip l Ödeme ekranına 3D Secure ekle
/ekip Fatura listesine tarih filtresi ekle, varsayılan son 30 gün olsun
```
Lider ana oturumdur ve en sık çalışan parçadır; oturumu Sonnet ile ve orta effort'la
açmak ayrıca tasarruf sağlar.

Azure işleri için `az` CLI + `azure-devops` eklentisi ve okuma yetkili PAT gerekir.
