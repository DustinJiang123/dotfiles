# dotfiles

个人终端环境一键部署。换电脑、重装系统后一条命令恢复全部配置。

## 快速开始

```bash
git clone https://github.com/DustinJiang123/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

打开新终端或执行 `source ~/.zshrc`。

## 包含内容

| 配置 | 文件 |
|------|------|
| Shell (zsh) | `home/.zshrc` |
| Vim | `home/.vimrc` |
| Profile | `home/.profile` |
| 工具速查手册 | `docs/tools-cheatsheet.md` |
| 包清单 | `packages.txt` (Linux) / `Brewfile` (macOS) |

## 安装的工具

**Shell：** zsh + oh-my-zsh + zoxide + fzf + bat  
**编辑器：** vim + 10 个插件（NERDTree、fzf、fugitive、surround、commentary、gruvbox 等）  
**命令行：** eza、fd、jq、glow、gh、tldr、btop、dust  
**别名：** `c` → claude、`ls` → eza、`cat` → bat、`fd` → fdfind、`cfg` → 编辑 dotfiles

## 跨平台

- Linux：自动 apt 安装 + `packages.txt`
- macOS：`Brewfile` 待完善
- Windows：通过 WSL2 使用本项目

## 日常维护

编辑 `~/dotfiles/home/` 下的文件，提交推送即可同步到其他机器。

```bash
cfg              # 进入 dotfiles 目录
cfg edit         # 打开 zshrc 编辑
cfg reload       # 重载 shell 配置
cfg commit "消息" # 提交并推送
```

## 试运行

```bash
DRY_RUN=true ./install.sh
```
