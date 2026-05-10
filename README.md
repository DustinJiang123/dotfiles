# dotfiles

个人终端环境一键部署。换电脑、重装系统后一条命令恢复全部配置。

## 快速开始

```bash
git clone https://github.com/DustinJiang123/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

运行后：
1. 选择语言（中文/英文）
2. 勾选需要的操作（每项标注了风险等级）
3. 确认后逐项执行，修改前自动备份

打开新终端或执行 `source ~/.zshrc`。

## 安全设计

**绝不覆盖你的配置文件。** 采用 source 机制而非符号链接：

- `~/.zshrc` 保持你的本地配置不变
- 脚本只在末尾追加一行 `source ~/dotfiles/home/.zshrc`
- 所有修改操作前创建时间戳备份到 `~/.dotfiles-backups/`

## 包含内容

| 配置 | 文件 |
|------|------|
| Shell (zsh) | `home/.zshrc` |
| Vim | `home/.vimrc` |
| Profile | `home/.profile` |
| 工具速查手册 | `docs/tools-cheatsheet.md` |
| 包清单 | `packages.txt` (Linux) / `Brewfile` (macOS) |

## 安装的工具

**Shell：** zsh + oh-my-zsh + zsh-autosuggestions + zsh-syntax-highlighting + zoxide + fzf  
**编辑器：** vim + 10 个插件（NERDTree、fzf、fugitive、surround、commentary、gruvbox 等）  
**命令行：** eza、bat、fd、jq、glow、gh、tldr、btop、dust  
**别名：** `c` → claude、`ls` → eza、`cat` → batcat、`fd` → fdfind

## 跨平台

- Linux：apt 安装 + `packages.txt`
- macOS：`Brewfile` 待完善
- Windows：通过 WSL2 使用本项目

## 字体

agnoster 主题需要 Powerline 字体。

**WSL2 用户：** 字体须装在 Windows 侧。下载 [Meslo Nerd Font](https://www.nerdfonts.com/font-downloads)，安装 `.ttf` 后，在 Windows Terminal 设置 → 外观 → 字体 中输入 `MesloLGS Nerd Font`。

## 日常维护

用 `cfg` 命令管理配置，不要直接改文件：

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

配置的分工见 `~/.zshrc` 顶部的注释说明。
