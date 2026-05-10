# If you come from bash you might have to change your $PATH.
export PATH="$HOME/.local/bin:$PATH"

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load.
ZSH_THEME="agnoster"

# Which plugins would you like to load?
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# ---- nvm ---------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ---- aliases -----------------------------------------------------------

# bat: enhanced cat with syntax highlighting
alias cat='bat --paging=never'

# Claude Code shortcut
alias c='claude'

# eza: modern ls replacement
alias ls='eza --icons --group-directories-first'
alias la='eza -la --icons --group-directories-first'
alias tree='eza --tree --icons'

# fd: modern find replacement (Ubuntu binary is fdfind)
if command -v fd &>/dev/null; then
  # macOS / brew: binary is already called fd
  :
elif command -v fdfind &>/dev/null; then
  alias fd='fdfind'
fi

# zoxide: smart directory jumping
eval "$(zoxide init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ---- dotfiles management ------------------------------------------------
cfg() {
  case "${1:-}" in
    edit)   ${EDITOR:-vim} ~/dotfiles/home/.zshrc ;;
    reload) source ~/.zshrc ;;
    commit) shift; git -C ~/dotfiles add -A && git -C ~/dotfiles commit -m "${*}" && git -C ~/dotfiles push ;;
    *)      cd ~/dotfiles ;;
  esac
}
