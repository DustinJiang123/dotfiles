# dotfiles

> 个人终端环境，一条命令搞定。

[English](README.md) | [中文](README.zh-CN.md)

<p align="center">
  <img src="https://img.shields.io/badge/平台-Linux%20%7C%20macOS%20%7C%20WSL2-blue" alt="Platform">
  <img src="https://img.shields.io/badge/Shell-zsh%20%7C%20bash-yellow" alt="Shell">
  <img src="https://img.shields.io/badge/许可-MIT-green" alt="License">
</p>

---

## 💡 设计理念

- **安全优先** — 永不覆盖你的配置文件，只在末尾追加一行 `source`
- **交互式** — 勾选需要的功能，不需要的直接跳过
- **可重复执行** — 跑十遍结果一样
- **全程可视** — 每次修改前自动创建时间戳备份

## ✨ 功能一览

| 分类 | 内容 |
|------|------|
| Shell | Oh My Zsh + Powerlevel10k（或 agnoster）+ 语法高亮 + 自动补全建议 |
| 导航 | zoxide（智能跳转）+ fzf + `..` `...` `....` 快捷返回 |
| 效率工具 | `mkd`（创建并进入）、`tre`（树状查看）、`server`（HTTP 服务）、`fs`（大小统计）、`bat`、`eza`、`fd` |
| 编辑器 | Vim + 插件（NERDTree、fugitive、fzf.vim 等） |
| 其他 | jq、glow、gh、tldr、btop、dust、tmux、`dataurl`、`myip`、`cleanup` |
| 历史 | 10 万条历史，追加即时写入，多会话共享 |
| 分层 | 主题/历史/配色/插件每层都可独立关闭 |

## 📋 环境准备

安装脚本会尽量自动安装所有工具，但少数包可能不在你的系统源里。建议提前手动装好基础工具——装不上不影响整体安装，脚本遇到缺失会跳过并提示。

### Ubuntu / Debian

```bash
sudo apt update
sudo apt install -y zsh git vim tmux curl wget
sudo apt install -y bat btop fd-find fzf fonts-powerline jq zoxide
# 以下在老旧/太新的系统上可能没有，见下方故障排除
sudo apt install -y eza glow tealdeer gh
```

### macOS

```bash
brew install bash git zsh vim tmux curl wget
brew install bat btop fd fzf jq zoxide
# 其余由 Brewfile 托管
```

### Arch Linux

```bash
sudo pacman -S zsh git vim tmux curl wget
sudo pacman -S bat btop fd fzf jq zoxide eza glow tealdeer github-cli
```

### CentOS / RHEL

```bash
sudo dnf install -y zsh git vim tmux curl wget
sudo dnf install -y bat btop fzf jq zoxide
# eza 不在 EPEL 源里，从 GitHub Release 安装
# glow、tealdeer 同上
```

## 🔧 故障排除

个别包不在某些发行版源里，以下是逐包备用安装方案：

| 包 | 备用安装 |
|----|----------|
| eza | `wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \| sudo tee /etc/apt/keyrings/gierens.asc && echo "deb [signed-by=/etc/apt/keyrings/gierens.asc] http://deb.gierens.de stable main" \| sudo tee /etc/apt/sources.list.d/gierens.list && sudo apt update && sudo apt install -y eza` |
| glow | `curl -L https://github.com/charmbracelet/glow/releases/latest/download/glow_Linux_x86_64.tar.gz \| tar -xz -C /usr/local/bin glow` |
| tealdeer | `pip3 install tldr` 或 `cargo install tealdeer` |
| gh | `type -p curl >/dev/null && sudo curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg -o /etc/apt/keyrings/githubcli.gpg && echo "deb [signed-by=/etc/apt/keyrings/githubcli.gpg] https://cli.github.com/packages stable main" \| sudo tee /etc/apt/sources.list.d/github-cli.list && sudo apt update && sudo apt install -y gh` |
| dust | 安装脚本会自动从 GitHub Release 下载安装 |

## 🚀 快速开始

```bash
git clone https://github.com/DustinJiang123/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

### macOS

macOS 自带的 bash 是 3.2 版本，需要先装新版 bash：

```bash
brew install bash
```

然后执行同上 clone + install 步骤。安装脚本会自动识别 macOS，用 `brew` 替代 `apt`。

### 安装流程

1. 选择语言（中文 / English）
2. 交互式菜单 — 输入序号切换选项，回车确认
3. 每步标注风险等级，执行前需确认
4. 完成后输出摘要和备份路径

打开新终端，或执行 `source ~/.zshrc`。

## 🔧 安装步骤

| 步骤 | 风险 | 说明 |
|------|------|------|
| 1. 系统软件包 | 中 | 通过 `apt`（Linux）或 `brew`（macOS）安装 |
| 2. Shell 配置 | 低 | 在 `~/.zshrc` 末尾追加 source 行 |
| 3. Oh My Zsh | 中 | 下载安装 Oh My Zsh 框架 |
| 4. Zsh 插件 | 低 | clone autosuggestions 和 syntax-highlighting |
| 5. 额外工具 | 中 | dust、vim-plug、Vim 插件 |
| 6. Nerd Font | 低 | Meslo 字体（WSL2 跳过，需在 Windows 端手动安装） |

每步执行前会展示完整命令，修改文件前会创建备份。

## 🛡️ 安全保障

采用 **source 机制**，不用符号链接：

```
~/.zshrc          ← 你的本地配置（Oh My Zsh、nvm 等）
    ↓ source
~/dotfiles/home/.zshrc  ← 本项目管理的配置（别名、插件、工具）
```

- `~/.zshrc` 原有内容毫发无损 — 只追加一行
- 备份存放在 `~/.dotfiles-backups/<时间戳>/`
- 删除末行 source 即可彻底卸载

`~/.zshrc` 顶部有给 AI 助手的注释，告诉它们应编辑 dotfiles 副本而非本文件。

## 📁 目录结构

```
dotfiles/
├── install.sh              # 交互式安装脚本（中英双语）
├── README.md               # 英文 README
├── README.zh-CN.md         # 中文 README
├── packages.txt             # apt 包清单
├── Brewfile                 # macOS 包清单
├── home/
│   ├── .zshrc               # Shell 配置（别名、插件、cfg 命令）
│   ├── .vimrc               # Vim 配置 + 10 个插件
│   └── .profile             # 路径配置
├── scripts/
│   └── extra-install.sh     # dust、vim-plug、字体等扩展安装
├── docs/
│   ├── tools-cheatsheet.md      # 工具速查手册（中文）
│   └── tools-cheatsheet-en.md   # 工具速查手册（English）
```

## 📅 日常使用

```bash
cfg help         # 查看所有命令
cfg edit         # 编辑 dotfiles 配置
cfg reload       # 立即生效
cfg status       # 查看变更
cfg diff         # 查看具体改动
cfg log          # 查看提交历史
cfg backup       # 备份当前 ~/.zshrc
cfg commit "消息" # 提交到 git（不自动 push）
cfg push         # 推送到 GitHub（会先确认）
```

### 私人配置

创建 `~/.extra` 存放不想公开的内容：

```bash
cp ~/dotfiles/home/.extra.example ~/.extra
# 然后编辑 ~/.extra
```

`~/.extra` 由 `home/.zshrc` 在最后 source，可以覆盖一切默认值。
完整模板见 `home/.extra.example`。

### 分层开关

`home/.zshrc` 拆成了若干层，每层都能独立关闭。在 `~/.zshrc` 的 `source`
行**之前**设置即可：

```bash
# 跳过 OMZ 主题/插件层 —— 适用于你自己已经在用 p10k 或其他 prompt 框架
export DOTFILES_SKIP_THEME=1

# 分别跳过历史 / EZA_COLORS / BAT_THEME
export DOTFILES_SKIP_HISTORY=1
export DOTFILES_SKIP_COLORS=1

# 在 dotfiles 默认插件之外追加你需要的插件
export DOTFILES_EXTRA_PLUGINS=(z docker zsh-completions zsh-history-substring-search)

[ -f ~/dotfiles/home/.zshrc ] && source ~/dotfiles/home/.zshrc
```

主题层启用时，dotfiles 会自动识别：

1. 优先用 `powerlevel10k`（若 `$ZSH/custom/themes/powerlevel10k` 存在）
2. 否则回退到 `agnoster`

两个主题都开箱即用。p10k 模式下，如果你没有自己的 `~/.p10k.zsh`，
会加载仓库里的 `home/.p10k.zsh` 作为默认。



## 🖥️ 平台支持

| 平台 | 状态 |
|------|------|
| Ubuntu / Debian | 完整支持（`apt`） |
| macOS | 完整支持（`brew`） |
| WSL2 | 完整支持（`apt`）；字体需在 Windows 端安装 |
| 其他 Linux | 需手动安装软件包 |

## 🔠 字体

**agnoster** 主题需要 Powerline 字体。原生 Linux 下安装脚本会自动安装。

**WSL2 用户** — 字体必须装在 Windows 端：
1. 下载 [Meslo Nerd Font](https://www.nerdfonts.com/font-downloads)
2. 右键 `.ttf` → 安装
3. Windows Terminal → 设置 → 外观 → 字体 → 输入 `MesloLGS Nerd Font`

## 📄 许可

MIT
