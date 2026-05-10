# dotfiles

> 个人终端环境，一条命令搞定。

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
| Shell | Oh My Zsh + agnoster 主题 + 语法高亮 + 自动补全建议 |
| 导航 | zoxide（智能跳转）+ fzf（模糊搜索） |
| 效率工具 | `bat`（语法高亮 cat）、`eza`（现代 ls）、`fd`（现代 find） |
| 编辑器 | Vim + 10 个插件（NERDTree、fugitive、fzf.vim 等） |
| 其他 | jq、glow、gh、tldr、btop、dust、tmux |

## 🚀 快速开始

```bash
git clone https://github.com/DustinJiang123/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

安装流程：
1. 选择语言（中文 / English）
2. 交互式菜单 — 输入序号切换选项，回车确认
3. 每步标注风险等级，执行前需确认
4. 完成后输出摘要和备份路径

打开新终端，或执行 `source ~/.zshrc`。

## 🔧 安装步骤

| 步骤 | 风险 | 说明 |
|------|------|------|
| 1. 系统软件包 | 中 | 通过 `apt` 安装 `packages.txt` 中的工具 |
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
├── Brewfile                 # macOS 包清单（待完善）
├── home/
│   ├── .zshrc               # Shell 配置（别名、插件、cfg 命令）
│   ├── .vimrc               # Vim 配置 + 10 个插件
│   └── .profile             # 路径配置
├── scripts/
│   └── extra-install.sh     # dust、vim-plug、字体等扩展安装
└── docs/
    └── tools-cheatsheet.md  # 工具速查手册
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

## 🖥️ 平台支持

| 平台 | 状态 |
|------|------|
| Ubuntu / Debian | 完整支持 |
| macOS | Brewfile（待完善） |
| WSL2 | 完整支持；字体需在 Windows 端安装 |
| 其他 Linux | 需手动安装软件包 |

## 🔠 字体

**agnoster** 主题需要 Powerline 字体。原生 Linux 下安装脚本会自动安装。

**WSL2 用户** — 字体必须装在 Windows 端：
1. 下载 [Meslo Nerd Font](https://www.nerdfonts.com/font-downloads)
2. 右键 `.ttf` → 安装
3. Windows Terminal → 设置 → 外观 → 字体 → 输入 `MesloLGS Nerd Font`

## 📄 许可

MIT
