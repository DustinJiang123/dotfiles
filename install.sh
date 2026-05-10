#!/usr/bin/env bash
# Dotfiles installer — interactive, safe, i18n-ready
#
# Requires bash 4+ (for associative arrays). macOS ships bash 3.2 by default,
# so we re-exec under a newer bash if available.
if [ -z "${BASH_VERSION:-}" ] || [ "${BASH_VERSINFO[0]:-0}" -lt 4 ]; then
  for newer_bash in /opt/homebrew/bin/bash /usr/local/bin/bash; do
    if [ -x "$newer_bash" ]; then
      exec "$newer_bash" "$0" "$@"
    fi
  done
  echo "ERROR: This installer requires bash 4 or newer." >&2
  echo "  Current bash: ${BASH_VERSION:-not bash}" >&2
  echo "" >&2
  echo "On macOS, install a newer bash with:" >&2
  echo "  brew install bash" >&2
  echo "" >&2
  echo "Then re-run: ./install.sh" >&2
  exit 1
fi

set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backups/$(date +%Y%m%d-%H%M%S)"

# ---- i18n ----------------------------------------------------------------

declare -A T
declare -A SELECTED

set_lang() {
  case "${1:-}" in
    zh)
      T=(
        # Title & global
        [title]="🧰 Dotfiles 安装程序"
        [safety_note]="安全原则：本脚本不会替换你的任何配置文件，只在末尾追加 source 行。所有覆盖操作前都会创建时间戳备份。"
        [backup_dir]="本次备份目录"
        [choose_lang]="请选择语言 / Select Language:"
        [lang_zh]="中文"
        [lang_en]="English"
        [press_enter]="按回车继续..."
        [exiting]="退出安装。"
        [dry_run_note]="[预览模式] 不会实际修改系统"

        # Menu
        [menu_title]="请选择要执行的操作（输入序号选择，输入 a 全选，输入 q 退出）："
        [menu_item_1]="安装系统软件包"
        [menu_desc_1]="通过 apt 安装 git zsh vim bat eza fzf 等工具"
        [menu_risk_1]="中"
        [menu_item_2]="配置 shell 环境"
        [menu_desc_2]="在 ~/.zshrc 末尾追加 source 行（不覆盖原文件）"
        [menu_risk_2]="低"
        [menu_item_3]="安装 Oh My Zsh"
        [menu_desc_3]="从网络下载安装 Oh My Zsh 框架"
        [menu_risk_3]="中"
        [menu_item_4]="安装 Oh My Zsh 插件"
        [menu_desc_4]="安装 zsh-autosuggestions 和 zsh-syntax-highlighting"
        [menu_risk_4]="低"
        [menu_item_5]="安装额外工具"
        [menu_desc_5]="dust, vim-plug, vim 插件等"
        [menu_risk_5]="中"
        [menu_item_6]="安装 Nerd Font"
        [menu_desc_6]="Meslo Nerd Font（WSL2 下跳过，需在 Windows 端安装）"
        [menu_risk_6]="低"
        [menu_all]="全部选中"
        [menu_none]="全部取消"
        [menu_confirm]="确认执行"

        # Steps
        [step_prefix]="步骤"
        [running]="正在执行"
        [skip]="跳过"
        [done]="完成"
        [failed]="失败"
        [already]="已就绪"
        [backup_saved]="备份已保存到"

        # Step 1: apt
        [apt_title]="安装系统软件包"
        [apt_checking]="检查系统包管理器..."
        [apt_not_found]="未找到 apt 包管理器，跳过。"
        [apt_will_install]="将通过 apt 安装以下软件包："
        [apt_cmd]="即将执行的命令"
        [apt_confirm]="是否继续？[y/N]"
        [apt_updating]="正在更新软件包列表..."
        [apt_installing]="正在安装软件包..."
        [apt_ok]="软件包安装完成。"
        [apt_fail]="软件包安装失败，请检查上面的错误信息。"

        # Step 2: shell config
        [shell_title]="配置 shell 环境"
        [shell_source_line]="要追加的 source 行"
        [shell_will_add]="将在以下文件末尾追加 source 行："
        [shell_exists]="该行已存在，跳过。"
        [shell_backup_first]="先备份当前文件..."
        [shell_added]="已追加 source 行。"
        [shell_restore]="如需回滚，备份在"

        # Step 3: Oh My Zsh
        [omz_title]="安装 Oh My Zsh"
        [omz_exists]="Oh My Zsh 已安装，跳过。"
        [omz_installing]="正在下载并安装 Oh My Zsh..."
        [omz_note]="注意：安装脚本会修改 ~/.zshrc。我们将在此之后修复它。"
        [omz_ok]="Oh My Zsh 安装完成。"
        [omz_fix]="修复 ~/.zshrc 中的 source 行..."
        [omz_fail]="Oh My Zsh 安装失败。"

        # Step 4: zsh plugins
        [plugin_title]="安装 Oh My Zsh 插件"
        [plugin_installing]="正在安装插件..."
        [plugin_ok]="已安装"
        [plugin_exists]="已存在，跳过"

        # Step 5: extra tools
        [extra_title]="安装额外工具"
        [extra_dust]="dust (磁盘使用分析器)"
        [extra_vimplug]="vim-plug (Vim 插件管理器)"
        [extra_vimplugins]="Vim 插件"
        [extra_dust_ok]="dust 安装完成。"
        [extra_dust_exists]="dust 已安装。"
        [extra_vimplug_ok]="vim-plug 安装完成。"
        [extra_vimplug_exists]="vim-plug 已安装。"
        [extra_vimplugins_ok]="Vim 插件安装完成。"
        [extra_skip]="未安装 vim-plug，跳过插件安装。"

        # Step 6: font
        [font_title]="安装 Nerd Font"
        [font_wsl]="检测到 WSL2 环境，请在 Windows 端手动安装字体。"
        [font_wsl_guide]="下载地址：https://www.nerdfonts.com/font-downloads （搜索 Meslo）"
        [font_wsl_guide2]="下载后右键 .ttf 安装，然后在 Windows Terminal 设置中将 WSL 字体设为 'MesloLGS NF'"
        [font_exists]="Meslo Nerd Font 已安装，跳过。"
        [font_installing]="正在下载并安装 Meslo Nerd Font..."
        [font_ok]="字体安装完成。"
        [font_fail]="字体安装失败，可手动下载。"

        # Summary
        [summary_title]="安装摘要"
        [summary_success]="成功"
        [summary_skipped]="跳过"
        [summary_failed]="失败"
        [summary_backups]="备份文件列表"
        [summary_no_backups]="（无备份，未修改任何文件）"
        [summary_next]="下一步"
        [summary_restart]="请打开新终端，或运行：source ~/.zshrc"
        [summary_font_wsl]="请确保在 Windows 端安装了 Nerd Font，否则 agnoster 主题会显示乱码。"
      ) ;;
    en)
      T=(
        # Title & global
        [title]="🧰 Dotfiles Installer"
        [safety_note]="Safety principle: This script will NOT replace any of your config files. It only appends a source line at the end. Timestamped backups are created before any modification."
        [backup_dir]="Backup directory"
        [choose_lang]="请选择语言 / Select Language:"
        [lang_zh]="中文"
        [lang_en]="English"
        [press_enter]="Press Enter to continue..."
        [exiting]="Exiting."
        [dry_run_note]="[Dry-run mode] No changes will be made"

        # Menu
        [menu_title]="Select operations to perform (enter numbers, 'a' for all, 'q' to quit):"
        [menu_item_1]="Install system packages"
        [menu_desc_1]="Install git zsh vim bat eza fzf and more via apt"
        [menu_risk_1]="Medium"
        [menu_item_2]="Configure shell"
        [menu_desc_2]="Append source line to ~/.zshrc (does not overwrite)"
        [menu_risk_2]="Low"
        [menu_item_3]="Install Oh My Zsh"
        [menu_desc_3]="Download and install Oh My Zsh framework"
        [menu_risk_3]="Medium"
        [menu_item_4]="Install Oh My Zsh plugins"
        [menu_desc_4]="Install zsh-autosuggestions and zsh-syntax-highlighting"
        [menu_risk_4]="Low"
        [menu_item_5]="Install extra tools"
        [menu_desc_5]="dust, vim-plug, vim plugins"
        [menu_risk_5]="Medium"
        [menu_item_6]="Install Nerd Font"
        [menu_desc_6]="Meslo Nerd Font (skipped on WSL2, install on Windows)"
        [menu_risk_6]="Low"
        [menu_all]="Select all"
        [menu_none]="Deselect all"
        [menu_confirm]="Confirm"

        # Steps
        [step_prefix]="Step"
        [running]="Running"
        [skip]="Skip"
        [done]="Done"
        [failed]="Failed"
        [already]="Already done"
        [backup_saved]="Backup saved to"

        # Step 1: apt
        [apt_title]="Install System Packages"
        [apt_checking]="Checking package manager..."
        [apt_not_found]="apt not found, skipping."
        [apt_will_install]="The following packages will be installed via apt:"
        [apt_cmd]="Command to run"
        [apt_confirm]="Continue? [y/N]"
        [apt_updating]="Updating package lists..."
        [apt_installing]="Installing packages..."
        [apt_ok]="Package installation complete."
        [apt_fail]="Package installation failed. Check errors above."

        # Step 2: shell config
        [shell_title]="Configure Shell"
        [shell_source_line]="Source line to append"
        [shell_will_add]="Will append source line to:"
        [shell_exists]="Line already exists, skipping."
        [shell_backup_first]="Backing up current file first..."
        [shell_added]="Source line appended."
        [shell_restore]="To rollback, backup is at"

        # Step 3: Oh My Zsh
        [omz_title]="Install Oh My Zsh"
        [omz_exists]="Oh My Zsh already installed, skipping."
        [omz_installing]="Downloading and installing Oh My Zsh..."
        [omz_note]="Note: the installer may modify ~/.zshrc. We'll fix it afterwards."
        [omz_ok]="Oh My Zsh installed."
        [omz_fix]="Fixing source line in ~/.zshrc..."
        [omz_fail]="Oh My Zsh installation failed."

        # Step 4: zsh plugins
        [plugin_title]="Install Oh My Zsh Plugins"
        [plugin_installing]="Installing plugins..."
        [plugin_ok]="Installed"
        [plugin_exists]="Already exists, skipping"

        # Step 5: extra tools
        [extra_title]="Install Extra Tools"
        [extra_dust]="dust (disk usage analyzer)"
        [extra_vimplug]="vim-plug (Vim plugin manager)"
        [extra_vimplugins]="Vim plugins"
        [extra_dust_ok]="dust installed."
        [extra_dust_exists]="dust already installed."
        [extra_vimplug_ok]="vim-plug installed."
        [extra_vimplug_exists]="vim-plug already installed."
        [extra_vimplugins_ok]="Vim plugins installed."
        [extra_skip]="vim-plug not installed, skipping plugin install."

        # Step 6: font
        [font_title]="Install Nerd Font"
        [font_wsl]="WSL2 detected. Font must be installed on Windows side."
        [font_wsl_guide]="Download from: https://www.nerdfonts.com/font-downloads (search Meslo)"
        [font_wsl_guide2]="Install the .ttf, then set WSL font to 'MesloLGS NF' in Windows Terminal settings."
        [font_exists]="Meslo Nerd Font already installed, skipping."
        [font_installing]="Downloading and installing Meslo Nerd Font..."
        [font_ok]="Font installed."
        [font_fail]="Font installation failed. You can install it manually."

        # Summary
        [summary_title]="Installation Summary"
        [summary_success]="Success"
        [summary_skipped]="Skipped"
        [summary_failed]="Failed"
        [summary_backups]="Backup files"
        [summary_no_backups]="(none — no files were modified)"
        [summary_next]="Next step"
        [summary_restart]="Open a new terminal, or run: source ~/.zshrc"
        [summary_font_wsl]="Make sure Nerd Font is installed on Windows, or the agnoster theme will show garbled characters."
      ) ;;
  esac
}

# ---- helpers -------------------------------------------------------------

# Colors
C_RESET='\033[0m'
C_BOLD='\033[1m'
C_RED='\033[31m'
C_GREEN='\033[32m'
C_YELLOW='\033[33m'
C_BLUE='\033[34m'
C_CYAN='\033[36m'
C_DIM='\033[2m'

info()  { echo -e "${C_BLUE}==>${C_RESET} $*"; }
ok()    { echo -e "${C_GREEN}  ✓${C_RESET} $*"; }
warn()  { echo -e "${C_YELLOW}  ⚠${C_RESET} $*"; }
fail()  { echo -e "${C_RED}  ✗${C_RESET} $*"; }
step_header() {
  echo ""
  echo -e "${C_BOLD}${C_CYAN}━━━ ${T[step_prefix]} $1: ${T[$2]} ━━━${C_RESET}"
}

backup_file() {
  local f="$1"
  mkdir -p "$BACKUP_DIR"
  cp "$f" "$BACKUP_DIR/$(basename "$f")"
  ok "${T[backup_saved]}: $BACKUP_DIR/$(basename "$f")"
}

is_wsl() {
  grep -qi microsoft /proc/version 2>/dev/null
}

is_macos() {
  [ "$(uname -s)" = "Darwin" ]
}

# ---- step functions ------------------------------------------------------

step_packages() {
  step_header "1" "apt_title"

  if command -v apt &>/dev/null; then
    # ── Linux / apt ────────────────────────────────────
    echo ""
    echo "${T[apt_will_install]}"
    echo ""
    grep -v '^#' "$DOTFILES/packages.txt" | sed 's/^/  - /'
    echo ""
    echo "  sudo apt update && sudo apt install [packages]"
    echo ""

    read -r -p "${T[apt_confirm]} " yn
    if [[ ! "$yn" =~ ^[Yy] ]]; then
      warn "${T[skip]}"
      return 2
    fi

    info "${T[apt_updating]}"
    sudo apt update -qq || true

    info "${T[apt_installing]}"
    local failed_pkgs=()
    local pkg
    while IFS= read -r pkg; do
      [ -z "$pkg" ] && continue
      [[ "$pkg" =~ ^[[:space:]]*# ]] && continue
      if sudo apt install -y "$pkg" >/dev/null 2>&1; then
        ok "$pkg"
      else
        warn "$pkg — not available, skipping"
        failed_pkgs+=("$pkg")
      fi
    done < <(grep -v '^#' "$DOTFILES/packages.txt")

    if [ ${#failed_pkgs[@]} -eq 0 ]; then
      ok "${T[apt_ok]}"
      return 0
    else
      warn "${T[apt_ok]} (skipped: ${failed_pkgs[*]})"
      return 0
    fi

  elif command -v brew &>/dev/null; then
    # ── macOS / Homebrew ───────────────────────────────
    echo ""
    echo "Will install the following via Homebrew:"
    echo ""
    if [ -f "$DOTFILES/Brewfile" ] && grep -qv '^#' "$DOTFILES/Brewfile"; then
      grep -v '^#' "$DOTFILES/Brewfile" | grep -v '^[[:space:]]*$' | sed 's/^/  /'
    fi
    echo ""
    echo "  brew bundle --file=$DOTFILES/Brewfile"
    echo ""

    read -r -p "${T[apt_confirm]} " yn
    if [[ ! "$yn" =~ ^[Yy] ]]; then
      warn "${T[skip]}"
      return 2
    fi

    info "Updating Homebrew..."
    brew update

    info "Installing packages..."
    if brew bundle --file="$DOTFILES/Brewfile"; then
      ok "${T[apt_ok]}"
      return 0
    else
      fail "${T[apt_fail]}"
      return 1
    fi

  else
    fail "No supported package manager found (apt or brew)."
    return 1
  fi
}

step_shell() {
  step_header "2" "shell_title"

  local source_line='[ -f ~/dotfiles/home/.zshrc ] && source ~/dotfiles/home/.zshrc'
  local targets=()

  for rc in "$HOME/.zshrc" "$HOME/.bashrc"; do
    local name=$(basename "$rc")
    if [ -f "$rc" ]; then
      targets+=("$rc")
    fi
  done

  if [ ${#targets[@]} -eq 0 ]; then
    warn "未找到 ~/.zshrc 或 ~/.bashrc，创建一个新的 ~/.zshrc"
    echo "$source_line" > "$HOME/.zshrc"
    ok "已创建 ~/.zshrc"
    return 0
  fi

  for rc in "${targets[@]}"; do
    local name=$(basename "$rc")

    if grep -qF "source ~/dotfiles/home/.zshrc" "$rc" 2>/dev/null; then
      ok "$name: ${T[shell_exists]}"
      continue
    fi

    echo ""
    echo "${T[shell_will_add]}: $rc"
    echo "  ${T[shell_source_line]}: $source_line"

    backup_file "$rc"

    echo "" >> "$rc"
    echo "# Dotfiles — added by install.sh" >> "$rc"
    echo "$source_line" >> "$rc"
    ok "$name: ${T[shell_added]}"
  done
  return 0
}

step_omz() {
  step_header "3" "omz_title"

  if [ -d "$HOME/.oh-my-zsh" ]; then
    ok "${T[omz_exists]}"
    return 0
  fi

  warn "${T[omz_note]}"
  info "${T[omz_installing]}"

  if sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc; then
    ok "${T[omz_ok]}"

    # Ensure source line is still in .zshrc (OMZ may have replaced it)
    local source_line='[ -f ~/dotfiles/home/.zshrc ] && source ~/dotfiles/home/.zshrc'
    if ! grep -qF "source ~/dotfiles/home/.zshrc" "$HOME/.zshrc" 2>/dev/null; then
      info "${T[omz_fix]}"
      echo "" >> "$HOME/.zshrc"
      echo "# Dotfiles — restored after Oh My Zsh install" >> "$HOME/.zshrc"
      echo "$source_line" >> "$HOME/.zshrc"
      ok "${T[shell_added]}"
    fi
    return 0
  else
    fail "${T[omz_fail]}"
    return 1
  fi
}

step_plugins() {
  step_header "4" "plugin_title"

  local custom_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    warn "Oh My Zsh 未安装，跳过插件安装。"
    return 2
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
      ok "$name: ${T[plugin_exists]}"
    else
      info "${T[plugin_installing]} $name..."
      git clone --depth=1 "$url" "$dir" && ok "$name: ${T[plugin_ok]}" || fail "$name: ${T[failed]}"
    fi
  done
  return 0
}

step_extra() {
  step_header "5" "extra_title"

  # --- dust ---
  if command -v dust &>/dev/null; then
    ok "${T[extra_dust_exists]}"
  else
    info "${T[plugin_installing]} ${T[extra_dust]}..."
    local arch
    arch=$(uname -m)
    local dust_url

    case "$arch" in
      x86_64)  dust_url="https://github.com/bootandy/dust/releases/latest/download/dust-x86_64-unknown-linux-gnu.tar.gz" ;;
      aarch64) dust_url="https://github.com/bootandy/dust/releases/latest/download/dust-aarch64-unknown-linux-gnu.tar.gz" ;;
      *)
        warn "不支持架构 $arch，跳过 dust。"
        ;;
    esac

    if [ -n "${dust_url:-}" ]; then
      local tmp
      tmp=$(mktemp -d)
      if curl -fsSL "$dust_url" -o "$tmp/dust.tar.gz" 2>/dev/null; then
        tar -xzf "$tmp/dust.tar.gz" -C "$tmp"
        mkdir -p "$HOME/.local/bin"
        mv "$tmp"/dust-*/dust "$HOME/.local/bin/dust" 2>/dev/null || true
        chmod +x "$HOME/.local/bin/dust"
        rm -rf "$tmp"
        ok "${T[extra_dust_ok]}"
      else
        fail "dust: ${T[failed]}"
        rm -rf "$tmp"
      fi
    fi
  fi

  # --- vim-plug ---
  if [ -f "$HOME/.vim/autoload/plug.vim" ]; then
    ok "${T[extra_vimplug_exists]}"
  else
    info "${T[plugin_installing]} vim-plug..."
    if curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim; then
      ok "${T[extra_vimplug_ok]}"
    else
      fail "vim-plug: ${T[failed]}"
    fi
  fi

  # --- vim plugins ---
  if [ -f "$HOME/.vim/autoload/plug.vim" ]; then
    info "${T[plugin_installing]} ${T[extra_vimplugins]}..."
    vim -c 'PlugInstall' -c 'qa!' 2>/dev/null && ok "${T[extra_vimplugins_ok]}" || warn "Vim 插件安装可能有误，请手动检查。"
  else
    warn "${T[extra_skip]}"
  fi

  return 0
}

step_font() {
  step_header "6" "font_title"

  if is_wsl; then
    warn "${T[font_wsl]}"
    echo "  ${T[font_wsl_guide]}"
    echo "  ${T[font_wsl_guide2]}"
    return 0
  fi

  local font_dir="$HOME/.local/share/fonts"
  if [ -f "$font_dir/MesloLGSNerdFont-Regular.ttf" ]; then
    ok "${T[font_exists]}"
    return 0
  fi

  info "${T[font_installing]}"
  mkdir -p "$font_dir"

  local font_url="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Meslo/S/Regular/MesloLGSNerdFont-Regular.ttf"
  if curl -fsSL "$font_url" -o "$font_dir/MesloLGSNerdFont-Regular.ttf"; then
    fc-cache -f "$font_dir" 2>/dev/null || true
    ok "${T[font_ok]}"
  else
    fail "${T[font_fail]}"
    return 1
  fi
  return 0
}

# ---- menu ----------------------------------------------------------------

show_menu() {
  echo ""
  echo -e "${C_BOLD}${T[menu_title]}${C_RESET}"
  echo ""
  for i in $(seq 1 6); do
    local item="menu_item_$i"
    local desc="menu_desc_$i"
    local risk="menu_risk_$i"
    local mark="${SELECTED[$i]:- }"
    local risk_color="$C_YELLOW"
    case "${T[$risk]}" in
      "低"|"Low") risk_color="$C_GREEN" ;;
      "中"|"Medium") risk_color="$C_YELLOW" ;;
      "高"|"High") risk_color="$C_RED" ;;
    esac
    echo -e "  ${C_BOLD}[${mark}]${C_RESET} $i. ${T[$item]}"
    echo -e "     ${C_DIM}${T[$desc]}${C_RESET}  ${risk_color}[${T[risk_label]}: ${T[$risk]}]${C_RESET}"
    echo ""
  done
}

run_menu() {
  for i in $(seq 1 6); do SELECTED[$i]="✓"; done

  while true; do
    show_menu
    read -r -p "> " choice

    case "$choice" in
      q|Q)
        echo "${T[exiting]}"
        exit 0
        ;;
      a|A)
        for i in $(seq 1 6); do SELECTED[$i]="✓"; done
        ;;
      n|N)
        for i in $(seq 1 6); do SELECTED[$i]=" "; done
        ;;
      "")
        break
        ;;
      *)
        # Toggle: single number, or space/comma-separated numbers
        for num in ${choice//,/ }; do
          if [[ "$num" =~ ^[1-6]$ ]]; then
            if [ "${SELECTED[$num]}" = "✓" ]; then
              SELECTED[$num]=" "
            else
              SELECTED[$num]="✓"
            fi
          fi
        done
        ;;
    esac
  done
}

# ---- main ----------------------------------------------------------------

main() {
  echo ""
  echo -e "${C_BOLD}${C_CYAN}╔════════════════════════════════════════╗${C_RESET}"
  echo -e "${C_BOLD}${C_CYAN}║     Dotfiles Installer                ║${C_RESET}"
  echo -e "${C_BOLD}${C_CYAN}╚════════════════════════════════════════╝${C_RESET}"
  echo ""

  # Default language (so T has keys before user picks)
  set_lang en

  # Language selection
  echo "${T[choose_lang]}"
  echo "  [1] ${T[lang_zh]}"
  echo "  [2] ${T[lang_en]}"
  echo ""
  read -r -p "> " lang_choice

  case "$lang_choice" in
    1) set_lang zh ;;
    *) set_lang en ;;
  esac

  echo ""

  # Safety note
  echo -e "${C_BOLD}━━━ 🔒 ━━━${C_RESET}"
  echo -e "${C_YELLOW}${T[safety_note]}${C_RESET}"
  echo -e "${C_BOLD}${T[backup_dir]}: ${BACKUP_DIR}${C_RESET}"
  echo ""

  # Menu
  T[risk_label]=$( [[ "$lang_choice" = "1" ]] && echo "风险" || echo "Risk" )
  run_menu

  # Summary of what will be done
  echo ""
  info "即将执行以下操作："
  for i in $(seq 1 6); do
    if [ "${SELECTED[$i]}" = "✓" ]; then
      local item="menu_item_$i"
      echo -e "  ${C_GREEN}▶${C_RESET} ${T[$item]}"
    fi
  done
  echo ""
  read -r -p "$( [[ "$lang_choice" = "1" ]] && echo "确认执行？[Y/n] " || echo "Proceed? [Y/n] ")" confirm
  if [[ "$confirm" =~ ^[Nn] ]]; then
    echo "${T[exiting]}"
    exit 0
  fi

  # Execute steps
  local results=()
  local steps=(step_packages step_shell step_omz step_plugins step_extra step_font)

  for i in $(seq 0 5); do
    if [ "${SELECTED[$((i+1))]}" = "✓" ]; then
      if "${steps[$i]}"; then
        results[$i]="ok"
      else
        results[$i]="failed"
      fi
    else
      results[$i]="skip"
    fi
  done

  # Summary
  echo ""
  echo -e "${C_BOLD}${C_CYAN}╔════════════════════════════════════════╗${C_RESET}"
  echo -e "${C_BOLD}${C_CYAN}║     ${T[summary_title]}                    ║${C_RESET}"
  echo -e "${C_BOLD}${C_CYAN}╚════════════════════════════════════════╝${C_RESET}"
  echo ""

  local step_names=("apt_title" "shell_title" "omz_title" "plugin_title" "extra_title" "font_title")
  for i in $(seq 0 5); do
    local name="${step_names[$i]}"
    case "${results[$i]}" in
      ok)     echo -e "  ${C_GREEN}✓${C_RESET} ${T[$name]}" ;;
      skip)   echo -e "  ${C_YELLOW}⏭${C_RESET} ${T[$name]} — ${T[skip]}" ;;
      failed) echo -e "  ${C_RED}✗${C_RESET} ${T[$name]} — ${T[failed]}" ;;
    esac
  done

  echo ""
  echo -e "${C_BOLD}${T[backup_dir]}:${C_RESET}"
  if [ -d "$BACKUP_DIR" ] && [ "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]; then
    ls -1 "$BACKUP_DIR"
  else
    echo "  ${T[summary_no_backups]}"
  fi

  echo ""
  echo -e "${C_BOLD}${T[summary_next]}:${C_RESET}"
  echo "  ${T[summary_restart]}"
  if is_wsl && [[ " ${results[*]} " =~ "ok" ]] && command -v zsh &>/dev/null; then
    echo "  ${T[summary_font_wsl]}"
  fi
  echo ""

  echo -e "${C_GREEN}${T[done]}!${C_RESET}"
}

main
