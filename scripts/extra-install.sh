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

install_font() {
  # Linux native: install Nerd Font for Powerline glyphs
  # WSL2: font is installed on Windows side, skip
  if grep -qi microsoft /proc/version 2>/dev/null; then
    echo "WSL2 detected — install font on Windows side (see README)"
    return
  fi
  local font_dir="$HOME/.local/share/fonts"
  if [ -f "$font_dir/MesloLGSNerdFont-Regular.ttf" ]; then
    echo "Meslo Nerd Font already installed"
    return
  fi
  mkdir -p "$font_dir"
  local url="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Meslo/S/Regular/MesloLGSNerdFont-Regular.ttf"
  wget -qO "$font_dir/MesloLGSNerdFont-Regular.ttf" "$url"
  fc-cache -f "$font_dir"
  echo "Meslo Nerd Font installed"
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
install_font
install_ohmyzsh
install_vimplug
install_vimplugins
