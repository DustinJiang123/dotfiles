# ── dotfiles/.zshrc ──────────────────────────────────────────────────────
# This file is meant to be sourced from ~/.zshrc, NOT symlinked.
# Your ~/.zshrc should contain this line at the end:
#   [ -f ~/dotfiles/home/.zshrc ] && source ~/dotfiles/home/.zshrc
# ──────────────────────────────────────────────────────────────────────────

# ---- PATH ----------------------------------------------------------------
export PATH="$HOME/.local/bin:$PATH"

# ---- Oh My Zsh -----------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"

if [ -f "$ZSH/oh-my-zsh.sh" ]; then
  ZSH_THEME="agnoster"

  # Only load plugins that actually exist
  plugins=(git)

  local custom_plugins="$ZSH/custom/plugins"
  [ -d "$custom_plugins/zsh-autosuggestions" ] && plugins+=(zsh-autosuggestions)
  [ -d "$custom_plugins/zsh-syntax-highlighting" ] && plugins+=(zsh-syntax-highlighting)

  source "$ZSH/oh-my-zsh.sh"
else
  echo "ℹ Oh My Zsh not found at $ZSH — run install.sh to set it up" >&2
fi

# ---- nvm -----------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# ---- aliases -------------------------------------------------------------

# bat (Ubuntu binary is batcat)
if command -v batcat &>/dev/null; then
  alias cat='batcat --paging=never'
elif command -v bat &>/dev/null; then
  alias cat='bat --paging=never'
fi

# eza: modern ls
if command -v eza &>/dev/null; then
  alias ls='eza --icons --group-directories-first'
  alias la='eza -la --icons --group-directories-first'
  alias tree='eza --tree --icons'
fi

# fd: modern find (Ubuntu binary is fdfind)
if command -v fdfind &>/dev/null; then
  alias fd='fdfind'
elif command -v fd &>/dev/null; then
  : # already fd
fi

# Claude Code shortcut
command -v claude &>/dev/null && alias c='claude'

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
      git -C ~/dotfiles push --dry-run && \
        read -r "?Push to origin? [y/N] " yn && \
        [[ "$yn" =~ ^[Yy] ]] && \
        git -C ~/dotfiles push
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
# Put machine-specific or secret configs here.
# This file is NOT tracked by the dotfiles repo.
[ -f ~/.extra ] && source ~/.extra
