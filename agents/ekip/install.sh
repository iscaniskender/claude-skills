#!/usr/bin/env sh
# Geliştirme ekibini kurar:
#   - 6 subagent'i      ~/.claude/agents/   altina
#   - /ekip komutunu    ~/.claude/commands/ altina baglar.
# Kullanim:
#   sh install.sh                  -> ajanlari ve /ekip komutunu kurar
#   sh install.sh /proje/yolu      -> ayrica izin kisitlarini o projenin
#                                     .claude/settings.json dosyasina ekler
set -e
src=$(cd "$(dirname "$0")" && pwd)
c="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
mkdir -p "$c/agents" "$c/commands"

# Sembolik link: repo 'git pull' ile guncellendiginde ajanlar da guncellenir.
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
  p="$1/.claude/settings.json"
  mkdir -p "$1/.claude"
  python3 -I - "$p" "$src/izinler.json" <<'P'
import json, os, sys
p, src = sys.argv[1], sys.argv[2]
d = json.load(open(p)) if os.path.exists(p) else {}
add = json.load(open(src))["permissions"]
perms = d.setdefault("permissions", {})
for key in ("deny", "ask"):
    lst = perms.setdefault(key, [])
    for rule in add[key]:
        if rule not in lst:
            lst.append(rule)
json.dump(d, open(p, "w"), indent=2, ensure_ascii=False)
P
  echo "  izinler eklendi: $p"
fi

echo "ekip kuruldu. Kullanim: /ekip azure <no>  veya  /ekip <is anlatimi>"
