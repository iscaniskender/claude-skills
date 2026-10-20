#!/usr/bin/env sh
# Installs the i-have-adhd skill and its always-on SessionStart hook into ~/.claude.
set -e
src=$(cd "$(dirname "$0")" && pwd)
c="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
mkdir -p "$c/skills" "$c/hooks"
rm -rf "$c/skills/i-have-adhd" && cp -R "$src" "$c/skills/i-have-adhd"
cp "$src/always-on.sh" "$c/hooks/i-have-adhd-always-on" && chmod +x "$c/hooks/i-have-adhd-always-on"
touch "$c/.i-have-adhd-always"
python3 -I - "$c/settings.json" <<'P'
import json,os,sys
p=sys.argv[1]
d=json.load(open(p)) if os.path.exists(p) else {}
cmd='"$HOME/.claude/hooks/i-have-adhd-always-on"'
ss=d.setdefault('hooks',{}).setdefault('SessionStart',[])
if not any(cmd in h.get('command','') for e in ss for h in e.get('hooks',[])):
    ss.append({"matcher":"startup|resume|clear|compact","hooks":[{"type":"command","command":cmd,"timeout":5}]})
    json.dump(d,open(p,'w'),indent=2,ensure_ascii=False)
P
echo "i-have-adhd installed. Turn off: delete $c/.i-have-adhd-always"
