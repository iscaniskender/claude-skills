# ekip — Sekiz Rollü Geliştirme Ekibi

Ana Claude Code oturumu **Takım Lideri** olur; altı uzman subagent olarak çalışır.
İş `[DURUM: ...]` etiketleriyle sırayla devredilir, iki inceleyici paralel çalışır.

```
YENI-IS → PRD Uzmanı → Lider onayı → Mimar → Test Uzmanı → Kod Uzmanı
→ (Güvenlik ∥ Kod Kontrol) → Lider → Teslim
Hızlı yol (net hata kaydı): YENI-IS → Test Uzmanı → Kod Uzmanı → incelemeler → Teslim
```

## Dosyalar
| Dosya | Rol | Model |
|---|---|---|
| `komut/ekip.md` | Takım Lideri (`/ekip` komutu, orkestratör) | oturum modeli |
| `prd-uzmani.md` | PRD Uzmanı | sonnet |
| `mimar.md` | Mimar | opus |
| `test-uzmani.md` | Test Uzmanı | sonnet |
| `kod-uzmani.md` | Kod Uzmanı | sonnet |
| `guvenlik-uzmani.md` | Güvenlik Uzmanı | opus |
| `kod-kontrol.md` | Kod Kontrol Uzmanı | sonnet |
| `yayin-uzmani.md` | Yayın Uzmanı (push + PR, yalnız iş sahibi isteyince) | sonnet |
| `izinler.json` | Proje izin kısıtları (merge, main'e push, Azure'a yazma yasak) | – |

## Kurulum
```bash
git clone https://github.com/iscaniskender/claude-skills ~/PROJECTS/claude-skills
sh ~/PROJECTS/claude-skills/agents/ekip/install.sh                 # ajanlar + /ekip
sh ~/PROJECTS/claude-skills/agents/ekip/install.sh ~/repos/proje   # + o projeye izin kısıtları
```
Ajanlar ve komut sembolik link olarak bağlanır; `git pull` sonrası yeniden kurulum gerekmez.

## Kullanım
```
/ekip azure 1234
/ekip Fatura listesine tarih filtresi ekle, varsayılan son 30 gün olsun
```
Azure işleri için `az` CLI + `azure-devops` eklentisi ve okuma yetkili PAT gerekir.
