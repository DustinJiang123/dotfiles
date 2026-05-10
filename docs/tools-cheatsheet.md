# 工具速查手册

## Vim 配置

### 基础操作
| 快捷键 | 功能 |
|--------|------|
| `jj` / `jk` | 插入模式 → 普通模式 |
| `Space w` | 保存 |
| `Space q` | 退出 |
| `Space Q` | 强制退出 |
| `Space x` | 保存并退出 |
| `Space Space` | 取消搜索高亮 |

### 窗口与导航
| 快捷键 | 功能 |
|--------|------|
| `Ctrl+h/j/k/l` | 按方向切换窗口 |
| `Space bn` / `bp` | 下一个 / 上一个 buffer |
| `Space bd` | 关闭当前 buffer |

### 文件浏览与搜索
| 快捷键 | 功能 |
|--------|------|
| `Space e` | 切换 NERDTree 文件树 |
| `Ctrl+p` | 模糊搜索当前目录文件 |
| `Space ag` | 全文搜索（内容关键字） |
| `Space h` | 搜索 vim 命令历史 |

### 编辑增强

**Surround（包裹/修改成对符号）**
| 操作 | 效果 |
|------|------|
| `ysiw"` | 给当前词加双引号 `word` → `"word"` |
| `cs"'` | 把双引号改成单引号 `"word"` → `'word'` |
| `ds"` | 删除双引号 `"word"` → `word` |
| `cst<tag>` | 把 HTML 标签改成另一个 |

**Commentary（注释）**
| 操作 | 效果 |
|------|------|
| `gcc` | 注释 / 取消注释当前行 |
| `gc`（可视模式选中后按） | 注释选中区域 |

**Repeat（用 `.` 重复更复杂的操作）**
| 操作 | 效果 |
|------|------|
| `.` | 重复上次操作（包括 surround/commentary） |

**行移动**
| 快捷键 | 效果 |
|--------|------|
| `Alt+j` | 当前行下移一行 |
| `Alt+k` | 当前行上移一行 |
| `Alt+j/k`（可视模式选中后） | 整块移动 |

**Git 集成**
| 操作 | 功能 |
|------|------|
| `:G` | Git 状态（类似 `git status`） |
| `:Gdiff` | 对比当前文件与暂存区的差异 |
| `:Gblame` | Git blame 查看 |
| `:Glog` | 查看文件提交历史 |
| `:Gcommit` | 提交 |
| 编辑器左侧列 | `▎` 标记表示新增/修改/删除的行 |

### 配置管理
| 快捷键 | 功能 |
|--------|------|
| `Space ev` | 编辑 .vimrc |
| `Space sv` | 重新加载 .vimrc |

---

## bat — 增强版 cat

```bash
cat file.txt          # 带语法高亮查看文件
cat -n file.txt       # 显示行号
cat -l python file.py # 强制指定语言
cat --theme=ansi      # 无颜色输出（管道用）
```

默认别名已设 `alias cat='batcat --paging=never'`（Ubuntu 下二进制名为 `batcat`），管道时自动不输出颜色。

---

## fzf — 模糊搜索

### Shell 中使用
| 快捷键 | 功能 |
|--------|------|
| `Ctrl+r` | 搜索历史命令 |
| `Ctrl+t` | 在当前目录搜索文件/目录，插入到命令行 |
| `Alt+c` | 搜索目录并 cd 进入 |

### 常用技巧
- 输入关键字即可模糊匹配，不要求连续
- 选中后 `Tab` 可多选
- 预览窗口用 `Ctrl+↑/↓` 滚动

---

## zoxide (z) — 目录跳转

```bash
z part-of-path    # 跳转到匹配的目录
zi part-of-path   # 交互式选择（有预览）
z foo/bar         # 支持多级模糊
z                 # 回到最近的目录（类似 cd -）
```

`z` 自动记录你去过的目录，按**频率 + 时效**排序。去过一次就能跳。

```bash
cd ~/work/project-a
cd ~/work/project-b
z a        # → ~/work/project-a
z b        # → ~/work/project-b
z work     # → 最常去的 work 目录
```

---

## glow — 终端 Markdown 阅读器

```bash
glow                    # 交互式选择文件
glow README.md          # 查看文件
glow -p README.md       # 纯文本渲染（无边框）
glow -s dark            # 暗色主题
glow -w 80 README.md    # 指定宽度 80 列
```

**快捷键：** `q` 退出，`↑/↓` 滚动，`PgUp/PgDn` 翻页，`/` 搜索

---

## eza — 增强版 ls

```bash
alias ls='eza --icons'
alias la='eza -la --icons --group-directories-first'
alias tree='eza --tree --icons'

eza -l                       # 详细列表 + 图标
eza -la                      # 含隐藏文件
eza -la --git                # 含 Git 状态标记
eza -T                       # 树状展示目录
eza -T -L 2                  # 树状，限深 2 层
```

---

## fd — 增强版 find

```bash
alias fd='fdfind'            # Ubuntu 下二进制名

fd keyword                  # 找文件名含 keyword 的文件
fd PATTERN --exec cat       # 找到后执行命令
fd --type d                 # 只找目录
fd --type f                 # 只找文件
fd -H                       # 包含隐藏文件
fd -e py                    # 只找 .py 扩展名
```

默认忽略 `.gitignore` 里的内容，比 find 快很多。

---

## jq — JSON 处理

```bash
curl api.example.com | jq '.'              # 格式化输出
cat data.json | jq '.users[0].name'        # 取字段
cat data.json | jq '.[] | select(.age>30)' # 过滤
cat data.json | jq '{name, email}'         # 提取多字段
```

---

## tldr — 精简 man

```bash
tldr tar               # 只看常用示例
tldr git               # 比 man git 精简 50 倍
```

---

## gh — GitHub CLI

```bash
gh auth login              # 登录
gh pr create               # 创建 PR
gh pr list                 # 列出 PR
gh issue view              # 查看 issue
gh run watch               # 实时看 CI 运行
```

---

## btop — 系统监视器

```bash
btop                       # 启动，CPU/内存/网络/进程全屏监控
```
快捷键：`q` 退出，`1-5` 切换视图，`f` 过滤进程

---

## dust — 磁盘空间分析

```bash
dust                   # 当前目录空间统计
dust -d 1              # 深度 1 层
dust -r                # 倒序排列
```

（需从 GitHub Releases 下载 binary）

---

## 快速参考

```bash
source ~/.zshrc     # 重载 shell 配置
space sv            # vim 里重载 .vimrc
vim -c 'PlugInstall' -c 'qa!'    # 安装/更新 vim 插件
```
