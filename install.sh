#!/usr/bin/env bash
# Dotfiles installer — safe to run multiple times
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
DRY_RUN="${DRY_RUN:-false}"

info()  { echo -e "\033[1;34m==>\033[0m $*"; }
ok()    { echo -e "\033[1;32m  ✓\033[0m $*"; }
skip()  { echo -e "\033[1;33m  ⏭\033[0m $*"; }
err()   { echo -e "\033[1;31m  ✗\033[0m $*"; }

link() {
  # link src dest — symlink with backup if existing file differs
  local src="$1" dest="$2"
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    skip "already linked: $dest"
    return
  fi
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    if diff -q "$dest" "$src" &>/dev/null; then
      skip "identical content, replacing with symlink: $dest"
      rm -f "$dest"
    else
      local bak="${dest}.bak.$(date +%Y%m%d%H%M%S)"
      mv "$dest" "$bak"
      ok "backup: $bak"
    fi
  fi
  [ "$DRY_RUN" = "true" ] && { ok "[dry] ln -s $src $dest"; return; }
  ln -s "$src" "$dest"
  ok "linked: $dest -> $src"
}

install_apt() {
  if ! command -v apt &>/dev/null; then
    err "apt not found, skipping system packages"
    return
  fi
  info "Installing apt packages..."
  [ "$DRY_RUN" = "true" ] && return
  sudo apt update -qq
  sudo apt install -y $(grep -v '^#' "$DOTFILES/packages.txt" | tr '\n' ' ')
  ok "apt packages done"
}

# ---- Main ----------------------------------------------------------------

info "Detected OS: $(uname -s)"

if [ "$(uname -s)" = "Linux" ]; then
  install_apt
else
  info "macOS detected — use 'brew bundle --file=Brewfile' to install packages"
fi

info "Linking dotfiles..."
for f in "$DOTFILES"/home/.*; do
  [ -f "$f" ] || continue
  name=$(basename "$f")
  link "$f" "$HOME/$name"
done

info "Running extra installs..."
[ "$DRY_RUN" = "false" ] && bash "$DOTFILES/scripts/extra-install.sh"

echo ""
info "All done. Start a new shell or run: source ~/.zshrc"
