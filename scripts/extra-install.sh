#!/usr/bin/env bash
# Install tools not available in default apt repos

set -euo pipefail

install_dust() {
  if command -v dust &>/dev/null; then
    echo "dust already installed: $(dust --version)"
    return
  fi
  local latest
  latest=$(curl -sL "https://api.github.com/repos/bootandy/dust/releases/latest" \
    | grep -o '"tag_name": *"[^"]*"' | head -1 | sed 's/.*"\(.*\)".*/\1/')
  local url="https://github.com/bootandy/dust/releases/download/${latest}/dust-${latest}-x86_64-unknown-linux-gnu.tar.gz"
  local tmp=$(mktemp -d)
  wget -qO "$tmp/dust.tar.gz" "$url"
  tar -xzf "$tmp/dust.tar.gz" -C "$tmp"
  mv "$tmp/dust-${latest}-x86_64-unknown-linux-gnu/dust" "$HOME/.local/bin/dust"
  chmod +x "$HOME/.local/bin/dust"
  rm -rf "$tmp"
  echo "dust $(dust --version) installed"
}

install_ohmyzsh() {
  if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh already installed"
    return
  fi
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

install_vimplug() {
  local plug="$HOME/.vim/autoload/plug.vim"
  if [ -f "$plug" ]; then
    echo "vim-plug already installed"
    return
  fi
  curl -fLo "$plug" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  echo "vim-plug installed"
}

install_vimplugins() {
  vim -c 'PlugInstall' -c 'qa!'
  echo "vim plugins installed"
}

# Run all extra installs
install_dust
install_ohmyzsh
install_vimplug
install_vimplugins
