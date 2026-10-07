#!/usr/bin/env bash
# Dotfiles for a Refrag Coder workspace (Ubuntu). Coder runs this on every workspace start
# (Settings → Parameters → Dotfiles URL = this repo, branch refrag/coder). Idempotent.
# Only $HOME survives a restart, so system packages and the login shell are re-applied each time.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  mkdir -p "$(dirname "$2")"
  if [ -e "$2" ] && [ ! -L "$2" ]; then mv "$2" "$2.backup"; echo "dotfiles: moved $2 to $2.backup"; fi
  ln -sfn "$DIR/$1" "$2"
}

# 1. Shell and editor. The workspace image ships these once Refrag/docker-fleet adds them;
#    until then, install them here.
packages=(zsh zsh-autosuggestions zsh-syntax-highlighting fzf vim)
missing=()
for p in "${packages[@]}"; do dpkg -s "$p" >/dev/null 2>&1 || missing+=("$p"); done
if [ ${#missing[@]} -gt 0 ]; then
  echo "dotfiles: installing ${missing[*]}"
  { sudo apt-get update -qq && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq "${missing[@]}" >/dev/null; } \
    || echo "dotfiles: could not install ${missing[*]}, continuing" >&2
fi
if command -v zsh >/dev/null && [ "$(getent passwd "$USER" | cut -d: -f7)" != "$(command -v zsh)" ]; then
  sudo chsh -s "$(command -v zsh)" "$USER" && echo "dotfiles: login shell is now zsh" || true
fi

# 2. Config files. ~/.gitconfig is NOT linked: the workspace startup script writes a GitHub token
#    into it, which must never land in this public repo. Git also reads ~/.config/git/config.
link zshrc "$HOME/.zshrc"
link zshenv "$HOME/.zshenv"
link aliases "$HOME/.aliases"
link vimrc "$HOME/.vimrc"
link gitconfig "$HOME/.config/git/config"
# Identity also goes into ~/.gitconfig, which wins over ~/.config/git/config, so a default the
# workspace may write there cannot shadow it.
git config --global user.name "$(git config -f "$DIR/gitconfig" user.name)"
git config --global user.email "$(git config -f "$DIR/gitconfig" user.email)"

# docker-fleet's submodules sit on working branches ahead of their pins; keep them out of the
# fleet root's git status. Inside each submodule, git status is unaffected.
fleet="$HOME/docker-fleet"
if [ -f "$fleet/.gitmodules" ]; then
  git -C "$fleet" config -f .gitmodules --get-regexp '^submodule\..*\.path$' | while read -r _ path; do
    git -C "$fleet" config "submodule.$path.ignore" all
  done
fi

mkdir -p "$HOME/.zsh/completions" "$HOME/.zsh/cache"
command -v herdr >/dev/null && herdr completion zsh > "$HOME/.zsh/completions/_herdr" 2>/dev/null || true
command -v gh >/dev/null && gh completion -s zsh > "$HOME/.zsh/completions/_gh" 2>/dev/null || true

# 3. Claude Code: the team defaults from Refrag/dotfiles first, then mine on top (mine win).
team="$HOME/.cache/refrag-dotfiles"
if git -C "$team" pull -q --ff-only 2>/dev/null || git clone -q --depth 1 https://github.com/Refrag/dotfiles.git "$team"; then
  bash "$team/install.sh"
fi
settings="$HOME/.claude/settings.json"
mkdir -p "$HOME/.claude"
[ -f "$settings" ] || echo '{}' > "$settings"
jq -s '.[0] * .[1]' "$settings" "$DIR/.claude/settings.json" > "$settings.tmp" && mv "$settings.tmp" "$settings"
echo "dotfiles: merged Claude Code settings"
