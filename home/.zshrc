# ── dotfiles/.zshrc ──────────────────────────────────────────────────────
# This file is meant to be sourced from ~/.zshrc, NOT symlinked.
# Your ~/.zshrc should contain this line at the end:
#   [ -f ~/dotfiles/home/.zshrc ] && source ~/dotfiles/home/.zshrc
#
# Layered, opt-out design — set any of these BEFORE the source line in
# your ~/.zshrc to skip a specific layer:
#
#   DOTFILES_SKIP_THEME=1     skip OMZ theme/plugin loading entirely
#                             (e.g. when you load p10k yourself or use a
#                              completely different prompt framework)
#   DOTFILES_SKIP_HISTORY=1   skip the history defaults
#   DOTFILES_SKIP_COLORS=1    skip EZA_COLORS / BAT_THEME defaults
#
# To add EXTRA Oh My Zsh plugins on top of the dotfiles defaults, set:
#   DOTFILES_EXTRA_PLUGINS=(z docker zsh-completions zsh-history-substring-search)
# ──────────────────────────────────────────────────────────────────────────

# ---- PATH ----------------------------------------------------------------
export PATH="$HOME/.local/bin:$PATH"

# ---- Oh My Zsh + theme + plugins (opt-out via DOTFILES_SKIP_THEME) -------
export ZSH="$HOME/.oh-my-zsh"

if [ -z "${DOTFILES_SKIP_THEME:-}" ] && [ -f "$ZSH/oh-my-zsh.sh" ]; then
  # Theme: prefer powerlevel10k if installed, fall back to agnoster.
  # Users can override by setting ZSH_THEME before sourcing this file.
  if [ -z "${ZSH_THEME:-}" ]; then
    if [ -d "$ZSH/custom/themes/powerlevel10k" ]; then
      ZSH_THEME="powerlevel10k/powerlevel10k"
    else
      ZSH_THEME="agnoster"
    fi
  fi

  # Powerlevel10k instant prompt (must come before sourcing oh-my-zsh).
  if [[ "$ZSH_THEME" == powerlevel10k/* ]]; then
    if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
      source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    fi
  fi

  # Plugins — start with curated defaults, then add anything the user
  # asked for via DOTFILES_EXTRA_PLUGINS, and only enable plugins whose
  # files actually exist on disk so a missing one doesn't break the shell.
  local _custom_plugins="$ZSH/custom/plugins"
  plugins=(git)
  [ -d "$_custom_plugins/zsh-autosuggestions" ] && plugins+=(zsh-autosuggestions)
  [ -d "$_custom_plugins/zsh-syntax-highlighting" ] && plugins+=(zsh-syntax-highlighting)

  if [ -n "${DOTFILES_EXTRA_PLUGINS:-}" ]; then
    local _p
    for _p in "${DOTFILES_EXTRA_PLUGINS[@]}"; do
      if [ -d "$_custom_plugins/$_p" ] || [ -d "$ZSH/plugins/$_p" ]; then
        plugins+=("$_p")
      fi
    done
  fi

  # Recommended for zsh-autosuggestions
  export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

  source "$ZSH/oh-my-zsh.sh"

  # p10k user config (loaded after OMZ so theme is active)
  if [[ "$ZSH_THEME" == powerlevel10k/* ]]; then
    # Prefer the user's own ~/.p10k.zsh, fall back to the dotfiles copy.
    if [ -f "$HOME/.p10k.zsh" ]; then
      source "$HOME/.p10k.zsh"
    elif [ -f "$HOME/dotfiles/home/.p10k.zsh" ]; then
      source "$HOME/dotfiles/home/.p10k.zsh"
    fi
  fi
elif [ -z "${DOTFILES_SKIP_THEME:-}" ]; then
  echo "ℹ Oh My Zsh not found at $ZSH — run install.sh to set it up" >&2
fi

# ---- nvm -----------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# ---- history (opt-out via DOTFILES_SKIP_HISTORY) -------------------------
if [ -z "${DOTFILES_SKIP_HISTORY:-}" ]; then
  export HISTSIZE=100000
  export SAVEHIST=100000
  setopt INC_APPEND_HISTORY   # append history immediately
  setopt SHARE_HISTORY        # share history across sessions
fi

# ---- navigation shortcuts -------------------------------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# ---- aliases -------------------------------------------------------------

# sudo with alias expansion (trailing space allows next-word alias expansion)
alias sudo='sudo '

# bat: modern cat (Ubuntu → batcat, macOS/brew → bat)
if command -v batcat &>/dev/null; then
  alias cat='batcat --paging=never'
elif command -v bat &>/dev/null; then
  alias cat='bat --paging=never'
fi

# eza: modern ls (with git status when available)
if command -v eza &>/dev/null; then
  alias ls='eza --icons --git --group-directories-first'
  alias ll='eza -l --icons --git --group-directories-first --time-style=long-iso'
  alias la='eza -la --icons --git --group-directories-first'
  alias tree='eza --tree --icons --level=2'
fi

# fd: modern find (Ubuntu → fdfind, macOS → fd)
if command -v fdfind &>/dev/null; then
  alias fd='fdfind'
fi

# PATH debugging
alias path='echo -e ${PATH//:/\\n}'

# Claude Code shortcut
command -v claude &>/dev/null && alias c='claude'

# shell reload
alias reload='exec ${SHELL} -l'

# ---- colors (opt-out via DOTFILES_SKIP_COLORS) ---------------------------
if [ -z "${DOTFILES_SKIP_COLORS:-}" ]; then
  # Universal Dracula-ish color scheme for eza
  export EZA_COLORS="\
uu=36:\
uR=31:\
un=35:\
gu=37:\
da=2;34:\
ur=34:\
uw=95:\
ux=36:\
ue=36:\
gr=34:\
gw=35:\
gx=36:\
tr=34:\
tw=35:\
tx=36:\
xx=95:"

  # bat theme — only set if bat is present and user hasn't overridden
  if [ -z "${BAT_THEME:-}" ] && (command -v bat &>/dev/null || command -v batcat &>/dev/null); then
    export BAT_THEME="TwoDark"
  fi
fi

# ---- functions ------------------------------------------------------------

# Create directory and enter it
mkd() {
  mkdir -p "$@" && cd "${@:$#}" || return 1
}

# File/directory size
fs() {
  if du -b /dev/null &>/dev/null 2>&1; then
    local arg=-sbh
  else
    local arg=-sh
  fi
  if [ -z "$*" ]; then
    du $arg ./*
  else
    du $arg "$@"
  fi
}

# Start HTTP server in current directory (port 8000 or custom)
server() {
  local port="${1:-8000}"
  if command -v python3 &>/dev/null; then
    python3 -m http.server "$port"
  elif command -v python &>/dev/null; then
    python -m SimpleHTTPServer "$port"
  else
    echo "No Python found" >&2
    return 1
  fi
}

# Enhanced tree (ignores .git, node_modules; respects .gitignore if available)
tre() {
  if command -v eza &>/dev/null; then
    eza --tree --icons -a -I '.git|node_modules|.cache' --git-ignore "$@" | less -R
  elif command -v tree &>/dev/null; then
    tree -aC -I '.git|node_modules|.cache' "$@" | less -R
  else
    echo "Install eza or tree first" >&2
    return 1
  fi
}

# Recursively delete .DS_Store files
cleanup() {
  find "${1:-.}" -type f -name '*.DS_Store' -ls -delete
}

# Convert file to base64 data URL
dataurl() {
  if [ -z "$1" ]; then
    echo "Usage: dataurl <file>" >&2
    return 1
  fi
  local mime
  mime=$(file -b --mime-type "$1")
  echo "data:${mime};base64,$(base64 -i "$1")"
}

# Get public IP
myip() {
  curl -s https://ipinfo.io/ip && echo
}

# ISO week number
week() {
  date +%V
}

# ---- tools ---------------------------------------------------------------

# zoxide
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ---- dotfiles management -------------------------------------------------
cfg() {
  case "${1:-}" in
    edit)
      ${EDITOR:-vim} ~/dotfiles/home/.zshrc
      ;;
    reload)
      source ~/.zshrc
      ;;
    backup)
      local bak="$HOME/.zshrc.bak.$(date +%Y%m%d%H%M%S)"
      cp ~/.zshrc "$bak"
      echo "Backed up ~/.zshrc → $bak"
      ;;
    commit)
      shift
      if [ -z "${1:-}" ]; then
        echo "Usage: cfg commit <message>" >&2
        return 1
      fi
      git -C ~/dotfiles add -A
      git -C ~/dotfiles commit -m "$*" || return 1
      echo "Committed. To push, run: git -C ~/dotfiles push"
      ;;
    push)
      git -C ~/dotfiles push --dry-run || return 1
      local yn
      read -r "yn?Push to origin? [y/N] "
      [[ "$yn" =~ ^[Yy] ]] && git -C ~/dotfiles push
      ;;
    status)
      git -C ~/dotfiles status
      ;;
    diff)
      git -C ~/dotfiles diff
      ;;
    log)
      git -C ~/dotfiles log --oneline -10
      ;;
    help|--help|-h)
      echo "cfg — dotfiles 管理快捷命令"
      echo ""
      echo "  cfg          进入 ~/dotfiles 目录"
      echo "  cfg edit     编辑 ~/dotfiles/home/.zshrc"
      echo "  cfg reload   重新加载配置（立即生效）"
      echo "  cfg status   查看文件变更状态"
      echo "  cfg diff     查看具体改动内容"
      echo "  cfg log      查看提交历史"
      echo "  cfg backup   备份当前 ~/.zshrc"
      echo "  cfg commit   git commit（不自动 push）"
      echo "  cfg push     推送到 GitHub（会确认）"
      ;;
    *)
      cd ~/dotfiles || return 1
      ;;
  esac
}

# ---- private extras (not tracked by git) ---------------------------------
# Put machine-specific PATH, secrets, work-only aliases, etc. here.
# This file is NOT tracked by the dotfiles repo. See .extra.example.
[ -f ~/.extra ] && source ~/.extra
