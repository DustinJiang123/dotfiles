# 项目状态汇总

## 当前阶段

v1.0 — 核心功能完整，已可在新机器上通过 `./install.sh` 一键部署。

## 仓库

https://github.com/DustinJiang123/dotfiles

## 做了什么

### Shell 环境
- Oh My Zsh + Powerlevel10k（自动检测，降级 agnoster）
- zsh-autosuggestions / zsh-syntax-highlighting
- 模块化 .zshrc，支持 `DOTFILES_SKIP_*` 按机器选择性关闭
- ~/.extra 私有配置文件
- ~/.extra.example 模板

### 别名与函数
| 等快捷键 | 作用 |
|----------|------|
| `c` | 启动 Claude Code |
| `cat` | bat 语法高亮 |
| `ls` / `la` / `ll` / `tree` | eza 增强版 |
| `fd` | fd-find 替换 find |
| `..` / `...` / `....` | 快速返回上级目录 |
| `reload` | 重载 shell |
| `mkd` | 创建目录并进入 |
| `tre` | 树状浏览（忽略 .git） |
| `server` | 启动 HTTP 静态服务 |
| `fs` | 文件/目录大小快查 |
| `dataurl` | 文件转 base64 data URL |
| `myip` | 查看公网 IP |
| `cleanup` | 递归删除 .DS_Store |

### Vim
- 11 个插件（NERDTree、fugitive、fzf.vim、gruvbox、indentLine、lightline 等）
- 自定义快捷键（Space 前缀）
- 安装脚本自动配置 vim-plug
- .vimrc source 机制

### 工具清单
bat, eza, fd, fzf, zoxide, jq, glow, gh, tldr, btop, dust, tmux

### 安装脚本
- 交互式菜单（中英双语）
- 每步标注风险等级
- 修改前自动备份到 `~/.dotfiles-backups/`
- source 模式（不覆盖原文件，只追加一行）
- 跨平台：Linux (apt) + macOS (brew)
- 可重复执行（幂等）

### 文档
- 中英双语 README
- 各发行版环境准备 + 故障排除指南
- 工具速查手册

## 已知不足

| 问题 | 说明 | 优先级 |
|------|------|--------|
| Vim 插件安装依赖网络 | `vim -c 'PlugInstall'` 从 GitHub clone，国内云服务器可能超时 | 中 |
| macOS 未实测 | Brewfile 写好了但没在 Mac 上跑过 | 中 |
| .vimrc 仍用 symlink 思维 | vim 的 source 机制已加入，但 vim 插件装在本机 ~/.vim/ 下，不在 dotfiles 目录管理范围内 | 低 |
| 缺少一键卸载 | 只能手动删 source 行 | 低 |
| 没有自动化测试 | 靠人工 dry run 验证 | 低 |
| 代理支持 | 国内服务器装包可能需要走代理，目前没处理 | 低 |

## 未来可做

1. **brew 实测** — 找台 Mac 跑一遍完整的 install.sh，修坑
2. **bootstrap 模式** — 无人值守安装 `./install.sh --yes`，跳过所有确认
3. **vscode/cursor 配置同步** — settings.json + keybindings.json
4. **tmux 配置** — .tmux.conf（当前只有默认配置）
5. **CI 测试** — GitHub Actions 自动 dry run 验证脚本不报错
6. **国内镜像** — 包下载增加 ghproxy 备选 URL，解决火山云等场景的网络问题
