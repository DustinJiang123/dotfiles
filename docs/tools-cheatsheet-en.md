# Tool Cheatsheet

## Vim

### Basics
| Key | Action |
|-----|--------|
| `jj` / `jk` | Exit insert mode |
| `Space w` | Save |
| `Space q` | Quit |
| `Space Q` | Force quit |
| `Space x` | Save & quit |
| `Space Space` | Clear search highlight |

### Windows & Navigation
| Key | Action |
|-----|--------|
| `Ctrl+h/j/k/l` | Switch windows directionally |
| `Space bn` / `bp` | Next / previous buffer |
| `Space bd` | Close current buffer |

### File Browsing & Search
| Key | Action |
|-----|--------|
| `Space e` | Toggle NERDTree |
| `Ctrl+p` | Fuzzy search files |
| `Space ag` | Full-text search (ag/rg) |
| `Space h` | Search command history |

### Editing

**Surround**
| Operation | Result |
|-----------|--------|
| `ysiw"` | Wrap word in quotes `word` → `"word"` |
| `cs"'` | Change double to single quotes |
| `ds"` | Delete surrounding quotes |
| `cst<tag>` | Change surrounding HTML tag |

**Commentary**
| Operation | Result |
|-----------|--------|
| `gcc` | Toggle comment on current line |
| `gc` + selection | Toggle comment on selection |

**Repeat**
| Operation | Result |
|-----------|--------|
| `.` | Repeat last action (including surround/commentary) |

**Line Moving**
| Key | Result |
|-----|--------|
| `Alt+j` | Move line down |
| `Alt+k` | Move line up |
| `Alt+j/k` in visual mode | Move selected block |

**Git Integration**
| Command | Action |
|---------|--------|
| `:G` | Git status |
| `:Gdiff` | Diff vs staged |
| `:Gblame` | Blame |
| `:Glog` | Commit history |
| `:Gcommit` | Commit |
| Left gutter | `▎` marks added/modified/deleted lines |

### Config
| Key | Action |
|-----|--------|
| `Space ev` | Edit .vimrc |
| `Space sv` | Reload .vimrc |

---

## bat — Enhanced cat

```bash
cat file.txt          # View with syntax highlighting
cat -n file.txt       # Show line numbers
cat -l python file.py # Force language for highlighting
cat --theme=ansi      # Plain text output (for piping)
```

Default alias: `alias cat='batcat --paging=never'` (Ubuntu binary is `batcat`). Auto-disables color when piped.

---

## fzf — Fuzzy Finder

### Shell Usage
| Key | Action |
|-----|--------|
| `Ctrl+r` | Search command history |
| `Ctrl+t` | Search files/dirs, insert into command line |
| `Alt+c` | Search dirs and cd |

### Tips
- Fuzzy match — type fragments, don't need to be consecutive
- `Tab` to multi-select
- `Ctrl+↑/↓` to scroll preview

---

## zoxide (z) — Smart Directory Jumper

```bash
z part-of-path    # Jump to matching directory
zi part-of-path   # Interactive selection with preview
z foo/bar         # Multi-level fuzzy match
z                 # Go back to most recent directory
```

`z` tracks visited directories, ranks by **frequency + recency**.

```bash
cd ~/work/project-a
cd ~/work/project-b
z a        # → ~/work/project-a
z b        # → ~/work/project-b
z work     # → most-used work directory
```

---

## glow — Terminal Markdown Reader

```bash
glow                    # Interactive file picker
glow README.md          # View a file
glow -p README.md       # Plain text (no borders)
glow -s dark            # Dark theme
glow -w 80 README.md    # Wrap at 80 columns
```

**Keys:** `q` quit, `↑/↓` scroll, `PgUp/PgDn` page, `/` search

---

## eza — Modern ls

```bash
alias ls='eza --icons'
alias la='eza -la --icons --group-directories-first'
alias tree='eza --tree --icons'

eza -l                       # Detailed list with icons
eza -la                      # Include hidden files
eza -la --git                # Show Git status
eza -T                       # Tree view
eza -T -L 2                  # Tree view, depth 2
```

---

## fd — Modern find

```bash
alias fd='fdfind'            # Ubuntu binary name

fd keyword                  # Find files by name
fd PATTERN --exec cat       # Find and execute
fd --type d                 # Directories only
fd --type f                 # Files only
fd -H                       # Include hidden files
fd -e py                    # Filter by extension
```

Respects `.gitignore` by default. Much faster than `find`.

---

## jq — JSON Processor

```bash
curl api.example.com | jq '.'              # Pretty-print
cat data.json | jq '.users[0].name'        # Extract field
cat data.json | jq '.[] | select(.age>30)' # Filter
cat data.json | jq '{name, email}'         # Select fields
```

---

## tldr — Simplified Man Pages

```bash
tldr tar               # Common examples only
tldr git               # 50x shorter than man git
```

---

## gh — GitHub CLI

```bash
gh auth login              # Login
gh pr create               # Create PR
gh pr list                 # List PRs
gh issue view              # View issue
gh run watch               # Watch CI in real time
```

---

## btop — System Monitor

```bash
btop                       # CPU/memory/network/processes
```
Keys: `q` quit, `1-5` switch views, `f` filter processes

---

## dust — Disk Usage Analyzer

```bash
dust                   # Current directory
dust -d 1              # Depth 1
dust -r                # Reverse sort
```

(Downloaded from GitHub Releases)

---

## Quick Reference

```bash
source ~/.zshrc     # Reload shell config
space sv            # Reload .vimrc from within Vim
vim -c 'PlugInstall' -c 'qa!'    # Install/update Vim plugins
```
