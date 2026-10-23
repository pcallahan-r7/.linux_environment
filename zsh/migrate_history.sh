#!/usr/bin/env sh
# Move zsh history out of the repo to ${XDG_STATE_HOME:-~/.local/state}/zsh/history,
# recovering and merging any history stranded in .zsh_sessions/ by Apple Terminal's
# per-session history (and by the old HISTSIZE truncation bug).
#
# Idempotent: safe to re-run; duplicate entries are never added twice.
# Run once per machine after pulling this repo: sh zsh/migrate_history.sh

set -eu

REPO_ZSH_DIR="$(cd "$(dirname "$0")" && pwd)"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/zsh"
TARGET="$STATE_DIR/history"
STAMP="$(date +%Y%m%dT%H%M%S)"

command -v python3 >/dev/null 2>&1 || { echo "error: python3 is required" >&2; exit 1; }

# shellcheck disable=SC2174
mkdir -m 700 -p "$STATE_DIR"

# Back up the target if it already has content (re-run / pre-existing history).
if [ -s "$TARGET" ]; then
    cp "$TARGET" "$TARGET.bak-$STAMP"
    echo "backed up existing $TARGET -> $TARGET.bak-$STAMP"
fi

# Merge every history source we can find into $TARGET:
# repo .zsh_history, its backups, Apple Terminal session files, and the target itself.
TARGET="$TARGET" REPO_ZSH_DIR="$REPO_ZSH_DIR" python3 <<'EOF'
import glob, os, re

header = re.compile(rb'^: (\d+):(\d+);')

def parse(path):
    """Return [(epoch, raw_entry_bytes)] for EXTENDED_HISTORY files.
    Continuation lines of multi-line commands stay attached to their header."""
    with open(path, 'rb') as f:
        data = f.read()
    entries, cur = [], None
    for line in data.split(b'\n'):
        m = header.match(line)
        if m:
            if cur is not None:
                entries.append(cur)
            cur = [int(m.group(1)), line]
        elif cur is not None:
            cur[1] += b'\n' + line
        elif line:
            entries.append([0, line])  # plain, non-extended line
    if cur is not None:
        entries.append(cur)
    return [(e[0], e[1]) for e in entries if e[1].strip()]

target = os.environ['TARGET']
repo = os.environ['REPO_ZSH_DIR']
sources = sorted(
    glob.glob(os.path.join(repo, '.zsh_sessions', '*.history'))
    + glob.glob(os.path.join(repo, '.zsh_sessions', '*.historynew'))
    + glob.glob(os.path.join(repo, '.zsh_history.bak-*'))
) + [os.path.join(repo, '.zsh_history'), target]

all_entries = []
for p in sources:
    if os.path.isfile(p):
        all_entries.extend(parse(p))

# Drop exact duplicates (same timestamp + text) from overlapping sources.
seen, unique = set(), []
for e in all_entries:
    if e not in seen:
        seen.add(e)
        unique.append(e)
unique.sort(key=lambda e: e[0])

# Collapse consecutive identical commands, keeping the most recent timestamp.
def cmd_of(raw):
    m = header.match(raw)
    return raw[m.end():] if m else raw

result = []
for ts, raw in unique:
    if result and cmd_of(result[-1][1]) == cmd_of(raw):
        result[-1] = (ts, raw)
    else:
        result.append((ts, raw))

fd = os.open(target, os.O_WRONLY | os.O_CREAT | os.O_TRUNC, 0o600)
with os.fdopen(fd, 'wb') as f:
    f.write(b'\n'.join(raw for _, raw in result) + b'\n')
os.chmod(target, 0o600)
print(f'merged {len(all_entries)} entries from {len(sources)} sources '
      f'-> {len(result)} unique entries in {target}')
EOF

# Retire the repo copy so nothing in the repo holds command history.
if [ -f "$REPO_ZSH_DIR/.zsh_history" ]; then
    mv "$REPO_ZSH_DIR/.zsh_history" "$REPO_ZSH_DIR/.zsh_history.bak-$STAMP-migrated"
    echo "moved repo .zsh_history -> .zsh_history.bak-$STAMP-migrated (delete when confident)"
fi

echo "done. new shells will use $TARGET (via HISTFILE in .zshrc)"
