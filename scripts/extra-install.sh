#!/usr/bin/env bash
# Extra tool installers — each function is idempotent and confirms before acting.
# Called by install.sh. Can also run standalone:  bash scripts/extra-install.sh
set -euo pipefail

DOTFILES_LANG="${DOTFILES_LANG:-en}"

# ---- i18n (subset — install.sh has the full set) -------------------------

declare -A T

case "$DOTFILES_LANG" in
  zh)
    T=(
      [dust_exists]="dust 已安装"
      [dust_installing]="正在安装 dust (磁盘使用分析器)..."
      [dust_ok]="dust 安装完成"
      [dust_fail]="dust 安装失败"
      [dust_arch]="不支持当前架构，跳过 dust"
      [vimplug_exists]="vim-plug 已安装"
      [vimplug_installing]="正在安装 vim-plug..."
      [vimplug_ok]="vim-plug 安装完成"
      [vimplug_fail]="vim-plug 安装失败"
      [vimplugins_installing]="正在安装 Vim 插件..."
      [vimplugins_ok]="Vim 插件安装完成"
      [vimplugins_skip]="未安装 vim-plug，跳过"
      [font_wsl]="WSL2 环境，请在 Windows 端安装字体（详见 README）"
      [font_exists]="Meslo Nerd Font 已安装"
      [font_installing]="正在安装 Meslo Nerd Font..."
      [font_ok]="字体安装完成"
      [font_fail]="字体安装失败"
      [omz_exists]="Oh My Zsh 已安装"
      [omz_skip]="跳过"
    ) ;;
  *)
    T=(
      [dust_exists]="dust already installed"
      [dust_installing]="Installing dust (disk usage analyzer)..."
      [dust_ok]="dust installed"
      [dust_fail]="dust installation failed"
      [dust_arch]="Unsupported architecture, skipping dust"
      [vimplug_exists]="vim-plug already installed"
      [vimplug_installing]="Installing vim-plug..."
      [vimplug_ok]="vim-plug installed"
      [vimplug_fail]="vim-plug installation failed"
      [vimplugins_installing]="Installing Vim plugins..."
      [vimplugins_ok]="Vim plugins installed"
      [vimplugins_skip]="vim-plug not found, skipping"
      [font_wsl]="WSL2 detected, install font on Windows side (see README)"
      [font_exists]="Meslo Nerd Font already installed"
      [font_installing]="Installing Meslo Nerd Font..."
      [font_ok]="Font installed"
      [font_fail]="Font installation failed"
      [omz_exists]="Oh My Zsh already installed"
      [omz_skip]="skip"
    ) ;;
esac

# ---- helpers -------------------------------------------------------------

is_wsl() { grep -qi microsoft /proc/version 2>/dev/null; }

# ---- installers ----------------------------------------------------------

install_dust() {
  if command -v dust &>/dev/null; then
    echo "  ✓ ${T[dust_exists]}"
    return 0
  fi

  echo "  => ${T[dust_installing]}"

  local url
  case "$(uname -m)" in
    x86_64)  url="https://github.com/bootandy/dust/releases/latest/download/dust-x86_64-unknown-linux-gnu.tar.gz" ;;
    aarch64) url="https://github.com/bootandy/dust/releases/latest/download/dust-aarch64-unknown-linux-gnu.tar.gz" ;;
    *)
      echo "  ! ${T[dust_arch]}"
      return 0
      ;;
  esac

  local tmp
  tmp=$(mktemp -d)
  if curl -fsSL "$url" -o "$tmp/dust.tar.gz"; then
    tar -xzf "$tmp/dust.tar.gz" -C "$tmp"
    mkdir -p "$HOME/.local/bin"
    find "$tmp" -name dust -type f -exec mv {} "$HOME/.local/bin/dust" \; 2>/dev/null || true
    chmod +x "$HOME/.local/bin/dust"
    rm -rf "$tmp"
    echo "  ✓ ${T[dust_ok]}"
  else
    echo "  ✗ ${T[dust_fail]}"
    rm -rf "$tmp"
    return 1
  fi
}

install_vimplug() {
  local plug="$HOME/.vim/autoload/plug.vim"
  if [ -f "$plug" ]; then
    echo "  ✓ ${T[vimplug_exists]}"
    return 0
  fi

  echo "  => ${T[vimplug_installing]}"
  if curl -fLo "$plug" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim; then
    echo "  ✓ ${T[vimplug_ok]}"
  else
    echo "  ✗ ${T[vimplug_fail]}"
    return 1
  fi
}

install_vimplugins() {
  if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    echo "  ! ${T[vimplugins_skip]}"
    return 0
  fi

  echo "  => ${T[vimplugins_installing]}"
  if vim -c 'PlugInstall' -c 'qa!' 2>/dev/null; then
    echo "  ✓ ${T[vimplugins_ok]}"
  else
    echo "  ! Vim plugin install may have issues — check manually"
  fi
}

install_ohmyzsh() {
  if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "  ✓ ${T[omz_exists]}"
    return 0
  fi

  echo "  => Downloading and installing Oh My Zsh..."
  if sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc; then
    echo "  ✓ Oh My Zsh installed"

    # Ensure dotfiles source line survives OMZ install
    local source_line='[ -f ~/dotfiles/home/.zshrc ] && source ~/dotfiles/home/.zshrc'
    if ! grep -qF "source ~/dotfiles/home/.zshrc" "$HOME/.zshrc" 2>/dev/null; then
      echo "" >> "$HOME/.zshrc"
      echo "# Dotfiles" >> "$HOME/.zshrc"
      echo "$source_line" >> "$HOME/.zshrc"
      echo "  ✓ Restored dotfiles source line in ~/.zshrc"
    fi
    return 0
  else
    echo "  ✗ Oh My Zsh installation failed"
    return 1
  fi
}

install_font() {
  if is_wsl; then
    echo "  ! ${T[font_wsl]}"
    return 0
  fi

  local font_dir="$HOME/.local/share/fonts"
  if [ -f "$font_dir/MesloLGSNerdFont-Regular.ttf" ]; then
    echo "  ✓ ${T[font_exists]}"
    return 0
  fi

  echo "  => ${T[font_installing]}"
  mkdir -p "$font_dir"

  local font_url="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Meslo/S/Regular/MesloLGSNerdFont-Regular.ttf"
  if curl -fsSL "$font_url" -o "$font_dir/MesloLGSNerdFont-Regular.ttf"; then
    fc-cache -f "$font_dir" 2>/dev/null || true
    echo "  ✓ ${T[font_ok]}"
  else
    echo "  ✗ ${T[font_fail]}"
    return 1
  fi
}

install_zsh_plugins() {
  local custom_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "  ! Oh My Zsh not installed, ${T[omz_skip]}"
    return 0
  fi

  mkdir -p "$custom_dir"

  local plugins=(
    "zsh-autosuggestions|https://github.com/zsh-users/zsh-autosuggestions"
    "zsh-syntax-highlighting|https://github.com/zsh-users/zsh-syntax-highlighting"
  )

  for p in "${plugins[@]}"; do
    local name="${p%%|*}"
    local url="${p##*|}"
    local dir="$custom_dir/$name"

    if [ -d "$dir" ]; then
      echo "  ✓ $name: ${T[vimplug_exists]}"
    else
      echo "  => Installing $name..."
      git clone --depth=1 "$url" "$dir" && echo "  ✓ $name: ${T[dust_ok]}" || echo "  ✗ $name: ${T[dust_fail]}"
    fi
  done
}

# ---- main (standalone mode) ----------------------------------------------

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo "Extra installs"
  echo "=============="
  install_dust
  install_vimplug
  install_vimplugins
  install_zsh_plugins
  install_font
  echo ""
  echo "Done."
fi
