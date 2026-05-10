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
| Shell | Oh My Zsh + agnoster theme + syntax highlighting + autosuggestions |
| Navigation | zoxide (smart `cd`) + fzf + `..` `...` `....` shortcuts |
| Productivity | `mkd` (mkdir+cd), `tre` (tree), `server` (HTTP), `fs` (size), `bat`, `eza`, `fd` |
| Editor | Vim + 10 plugins (NERDTree, fugitive, fzf.vim, etc.) |
| Tools | jq, glow, gh, tldr, btop, dust, tmux, `dataurl`, `myip`, `cleanup` |

## 🚀 Quick Start

```bash
git clone https://github.com/DustinJiang123/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The installer will:
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
# ~/.extra — sourced by dotfiles, never committed
export GITHUB_TOKEN="ghp_xxx"
alias work="cd ~/projects/secret-project"
```



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
