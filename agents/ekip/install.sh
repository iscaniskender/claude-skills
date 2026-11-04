#!/usr/bin/env sh
# Geliştirme ekibini kurar:
#   - subagent'ları    ~/.claude/agents/   altına
#   - /ekip komutunu    ~/.claude/commands/ altına bağlar.
# Kullanım:
#   sh install.sh                  -> ajanları ve /ekip komutunu kurar
#   sh install.sh /proje/yolu      -> ayrıca izin kısıtlarını o projenin
#                                     .claude/settings.json dosyasına ekler. Projede
#                                     .claude/ekip.local.json ya da .claude/ekip.json varsa
#                                     oradaki korumalı dallara push da yasaklanır.
set -e
src=$(cd "$(dirname "$0")" && pwd)
c="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
mkdir -p "$c/agents" "$c/commands"

# Sembolik link: repo 'git pull' ile güncellendiğinde ajanlar da güncellenir.
# Link kurulamazsa kopyalar.
link() { ln -sf "$1" "$2" 2>/dev/null || cp "$1" "$2"; }

for f in "$src"/*.md; do
  n=$(basename "$f")
  [ "$n" = "README.md" ] && continue
  link "$f" "$c/agents/$n"
  echo "  ajan:  $n"
done

link "$src/komut/ekip.md" "$c/commands/ekip.md"
echo "  komut: /ekip"

if [ -n "$1" ]; then
  py=$(command -v python3 || command -v python || true)
  if [ -z "$py" ]; then
    echo "  UYARI: python bulunamadı; izinler eklenmedi. izinler.json içeriğini"
    echo "         $1/.claude/settings.json dosyasına elle ekleyin."
  else
    "$py" -I - "$1" "$src/izinler.json" <<'P'
import json, os, sys
proje, kaynak = sys.argv[1], sys.argv[2]
p = os.path.join(proje, ".claude", "settings.json")
os.makedirs(os.path.dirname(p), exist_ok=True)
d = json.load(open(p, encoding="utf-8")) if os.path.exists(p) else {}
ek = json.load(open(kaynak, encoding="utf-8"))["permissions"]

# Proje ayarındaki korumalı dallara push yasağı
for ad in ("ekip.local.json", "ekip.json"):
    f = os.path.join(proje, ".claude", ad)
    if os.path.exists(f):
        ayar = json.load(open(f, encoding="utf-8"))
        dallar = list(ayar.get("korumaliDallar") or [])
        if ayar.get("anaDal") and ayar["anaDal"] not in dallar:
            dallar.append(ayar["anaDal"])
        for dal in dallar:
            ek["deny"] += [f"Bash(git push * {dal})", f"Bash(git push * {dal} *)",
                           f"Bash(git push *:{dal})", f"Bash(git push *:{dal} *)"]
        print(f"  korumalı dallar ({ad}): {', '.join(dallar)}")
        break

izin = d.setdefault("permissions", {})
for anahtar in ("deny", "ask"):
    liste = izin.setdefault(anahtar, [])
    for kural in ek[anahtar]:
        if kural not in liste:
            liste.append(kural)
json.dump(d, open(p, "w", encoding="utf-8"), indent=2, ensure_ascii=False)
P
    echo "  izinler eklendi: $1/.claude/settings.json"
  fi
fi

echo "ekip kuruldu. Kullanım: /ekip [s|m|l] <iş>  ·  /ekip incele <hedef>  ·  /ekip analiz <soru>"
