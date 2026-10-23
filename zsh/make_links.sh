#!/usr/bin/env sh
# Link ~/.zshenv to this repo's zsh/.zshenv (ZDOTDIR bootstrap). Idempotent.

set -eu

TARGET="${HOME}/.linux_environment/zsh/.zshenv"

# back up an existing real file (not an already-correct symlink)
if [ -e "${HOME}/.zshenv" ] && [ "$(readlink "${HOME}/.zshenv" 2>/dev/null || true)" != "$TARGET" ]; then
    cp "${HOME}/.zshenv" "${HOME}/.zshenv.bak-$(date +%Y%m%dT%H%M%S)"
fi

ln -sf "$TARGET" "${HOME}/.zshenv"
echo "${HOME}/.zshenv -> $TARGET"
