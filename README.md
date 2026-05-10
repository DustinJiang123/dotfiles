# dotfiles

> Personal terminal environment, one command away.

[English](README.md) | [中文](README.zh-CN.md)

<p align="center">
  <img src="https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20WSL2-blue" alt="Platform">
  <img src="https://img.shields.io/badge/shell-zsh%20%7C%20bash-yellow" alt="Shell">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="License">
</p>

---

## 💡 Philosophy

- **Safe by default** — never overwrites your configs; appends a single `source` line
- **Interactive** — choose what to install, skip what you don't need
- **Idempotent** — run it ten times, same result
- **Visible** — every modification creates a timestamped backup

## ✨ Features

| Category | What you get |
|----------|-------------|
| Shell | Oh My Zsh + Powerlevel10k (or agnoster) + syntax highlighting + autosuggestions |
| Navigation | zoxide (smart `cd`) + fzf + `..` `...` `....` shortcuts |
| Productivity | `mkd` (mkdir+cd), `tre` (tree), `server` (HTTP), `fs` (size), `bat`, `eza`, `fd` |
| Editor | Vim + plugins (NERDTree, fugitive, fzf.vim, etc.) |
| Tools | jq, glow, gh, tldr, btop, dust, tmux, `dataurl`, `myip`, `cleanup` |
| History | 100k entries, append-immediately, share between sessions |
| Layered | Each layer (theme/history/colors/plugins) can be disabled per-machine |

## 🚀 Quick Start

### Linux / WSL2

```bash
git clone https://github.com/DustinJiang123/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

### macOS

macOS ships with bash 3.2 which the installer cannot use, so install a newer bash first:

```bash
brew install bash
git clone https://github.com/DustinJiang123/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The installer auto-detects macOS and will:
- Use Homebrew (via `Brewfile`) instead of `apt`
- Skip the Linux-side font download (the Brewfile cask handles fonts via `~/Library/Fonts`)
- Skip the Linux-only `dust` binary download (installed via `brew install dust` in the Brewfile)

### What the installer does

1. Ask your language preference
2. Show an interactive menu — toggle items with numbers, Enter to confirm
3. Run each step with a risk label and a confirmation prompt
4. Print a summary with backup locations

Open a new terminal, or run `source ~/.zshrc`.

## 🔧 Installer Steps

| Step | Risk | Description |
|------|------|-------------|
| 1. System packages | Medium | Installs via `apt` (Linux) or `brew` (macOS) |
| 2. Shell config | Low | Appends a `source` line to `~/.zshrc` |
| 3. Oh My Zsh | Medium | Downloads and installs the OMZ framework |
| 4. Zsh plugins | Low | Clones autosuggestions and syntax-highlighting |
| 5. Extra tools | Medium | dust, vim-plug, vim plugins |
| 6. Nerd Font | Low | Meslo Nerd Font (skipped on WSL2 — install manually) |

All steps show the exact command before running and create backups before modifying files.

## 🛡️ Safe by Design

We use a **source-based** approach, not symlinks:

```
~/.zshrc          ← Your local config (Oh My Zsh, nvm, etc.)
    ↓ source
~/dotfiles/home/.zshrc  ← Managed by this repo (aliases, plugins, tools)
```

- Your `~/.zshrc` stays intact — only one line is appended
- Backups go to `~/.dotfiles-backups/<timestamp>/`
- Remove the `source` line to uninstall completely

The top of `~/.zshrc` includes a comment for AI assistants, telling them to edit the dotfiles copy instead.

## 📁 What's Inside

```
dotfiles/
├── install.sh              # Interactive installer (zh/en)
├── README.md               # This file (English)
├── README.zh-CN.md         # Chinese README
├── packages.txt             # apt packages
├── Brewfile                 # macOS packages
├── home/
│   ├── .zshrc               # Shell config (aliases, plugins, cfg helper)
│   ├── .vimrc               # Vim config + 10 plugins
│   └── .profile             # Path setup
├── scripts/
│   └── extra-install.sh     # Dust, vim-plug, Nerd Font, etc.
├── docs/
│   ├── tools-cheatsheet.md      # Quick reference (Chinese)
│   └── tools-cheatsheet-en.md   # Quick reference (English)
```

## 📅 Daily Use

```bash
cfg help         # Show all commands
cfg edit         # Edit dotfiles config
cfg reload       # Apply changes immediately
cfg status       # See what changed
cfg diff         # Review the diff
cfg log          # View commit history
cfg backup       # Backup current ~/.zshrc
cfg commit "msg" # Commit (no auto-push)
cfg push         # Push to GitHub (with confirmation)
```

### Private configs

Create `~/.extra` for anything you don't want in a public repo:

```bash
cp ~/dotfiles/home/.extra.example ~/.extra
# then edit ~/.extra
```

`~/.extra` is sourced last by `home/.zshrc`, so it can override anything.
See `home/.extra.example` for the full template.

### Per-layer opt-out

`home/.zshrc` is split into layers you can disable individually. Set
these in your `~/.zshrc` **before** the dotfiles `source` line:

```bash
# Skip the OMZ theme/plugin layer entirely — useful if you load p10k
# or another prompt yourself, or maintain your own plugin list.
export DOTFILES_SKIP_THEME=1

# Skip history defaults / EZA_COLORS / BAT_THEME independently
export DOTFILES_SKIP_HISTORY=1
export DOTFILES_SKIP_COLORS=1

# Add extra OMZ plugins on top of the dotfiles defaults
export DOTFILES_EXTRA_PLUGINS=(z docker zsh-completions zsh-history-substring-search)

[ -f ~/dotfiles/home/.zshrc ] && source ~/dotfiles/home/.zshrc
```

When the theme layer is enabled, dotfiles auto-detects:

1. `powerlevel10k` if it's installed under `$ZSH/custom/themes/powerlevel10k`
2. `agnoster` as the fallback

Both themes work out of the box; for p10k, the bundled `home/.p10k.zsh`
is loaded if you don't have your own `~/.p10k.zsh` already.



## 🖥️ Platform Support

| Platform | Status |
|----------|--------|
| Ubuntu / Debian | Full support (`apt`) |
| macOS | Full support (`brew`) |
| WSL2 | Full support (`apt`); font on Windows side |
| Other Linux | Manual package install |

## 🔠 Font

The **agnoster** theme requires a Powerline-patched font. The installer handles this for native Linux.

**WSL2 users** — install the font on Windows:
1. Download [Meslo Nerd Font](https://www.nerdfonts.com/font-downloads)
2. Right-click `.ttf` → Install
3. Windows Terminal → Settings → Appearance → Font → `MesloLGS Nerd Font`

## 📄 License

MIT
