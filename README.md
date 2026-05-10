# dotfiles

Personal shell, editor, and tooling configuration. One-command setup on any fresh machine.

## Quick start

```bash
git clone https://github.com/luishangge/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

Open a new terminal or `source ~/.zshrc`.

## What's included

| Config | File | 
|--------|------|
| Shell (zsh) | `home/.zshrc` |
| Vim | `home/.vimrc` |
| Profile | `home/.profile` |
| Tool cheatsheet | `docs/tools-cheatsheet.md` |
| Package list | `packages.txt` (Linux) / `Brewfile` (macOS) |

## Tools installed

**Shell:** zsh + oh-my-zsh + zoxide + fzf + bat  
**Editing:** vim + 10 plugins (NERDTree, fzf, fugitive, surround, commentary, gruvbox...)  
**CLI:** eza, fd, jq, glow, gh, tldr, btop, dust  
**Aliases:** `c` → claude, `ls` → eza, `cat` → bat, `fd` → fdfind

## Updating

Edit files in `~/dotfiles/home/`, then run `./install.sh` to re-link. Commit and push to sync across machines.

## Dry run

```bash
DRY_RUN=true ./install.sh
```
