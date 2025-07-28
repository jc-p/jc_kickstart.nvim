# Snacks.nvim 插件冲突整理报告

## 概述

本文档记录了为使用 `snacks.nvim` 而进行的插件冲突整理工作。`snacks.nvim` 是一个现代化的 Neovim 插件集合，提供了多种实用功能，但与现有配置中的一些插件存在功能重叠。

## 冲突插件及处理方案

### 1. Dashboard 冲突

**冲突插件**: `goolord/alpha-nvim`
**文件位置**: `/lua/custom/plugins/startup_perf.lua`
**处理方案**: 禁用 alpha-nvim，使用 snacks.dashboard
**状态**: ✅ 已禁用

```lua
-- 在 startup_perf.lua 中添加了 enabled = false
{
  "goolord/alpha-nvim",
  enabled = false, -- 禁用以避免与 snacks.dashboard 冲突
  -- ...
}
```

### 2. 文件浏览器冲突

**冲突插件**: `nvim-neo-tree/neo-tree.nvim`
**文件位置**: `/lua/kickstart/plugins/neo-tree.lua`
**处理方案**: 禁用 neo-tree，使用 snacks.explorer
**状态**: ✅ 已禁用

```lua
-- 在 neo-tree.lua 中添加了 enabled = false
{
  'nvim-neo-tree/neo-tree.nvim',
  enabled = false, -- 禁用以避免与 snacks.explorer 冲突
  -- ...
}
```

### 3. 缩进指示器冲突

**冲突插件**: `lukas-reineke/indent-blankline.nvim`
**文件位置**: `/lua/kickstart/plugins/indent_line.lua`
**处理方案**: 禁用 indent-blankline，使用 snacks.indent + snacks.scope
**状态**: ✅ 已禁用

```lua
-- 在 indent_line.lua 中添加了 enabled = false
{
  'lukas-reineke/indent-blankline.nvim',
  enabled = false, -- 禁用以避免与 snacks.indent 冲突
  -- ...
}
```

### 4. 通知系统冲突

**冲突插件**: `folke/noice.nvim`
**文件位置**: `/lua/custom/plugins/noice.lua`
**处理方案**: 禁用 noice.nvim，使用 snacks.notifier
**状态**: ✅ 已禁用

```lua
-- 在 noice.lua 中添加了 enabled = false
{
  'folke/noice.nvim',
  enabled = false, -- 禁用以避免与 snacks.notifier 冲突
  -- ...
}
```

### 5. 状态栏兼容性调整

**相关插件**: `nvim-lualine/lualine.nvim`
**文件位置**: `/lua/custom/plugins/lualine.lua`
**处理方案**: 保留 lualine，但移除对 noice 的依赖，与 snacks.statuscolumn 共存
**状态**: ✅ 已调整

- 移除了 lualine 中对 noice 的状态显示组件
- 添加了 `snacks_dashboard` 到禁用文件类型列表
- 添加了兼容性注释

## Snacks.nvim 配置详情

### 启用的功能模块

- ✅ **animate**: 动画效果
- ✅ **bigfile**: 大文件处理
- ✅ **dashboard**: 启动面板 (替代 alpha-nvim)
- ✅ **explorer**: 文件浏览器 (替代 neo-tree)
- ✅ **indent**: 缩进指示器 (替代 indent-blankline)
- ✅ **input**: 输入增强
- ❌ **picker**: 选择器 (保持禁用，使用 telescope)
- ✅ **notifier**: 通知系统 (替代 noice.nvim)
- ✅ **quickfile**: 快速文件操作
- ✅ **scope**: 作用域高亮 (配合 indent 使用)
- ✅ **scroll**: 平滑滚动
- ✅ **statuscolumn**: 状态列 (与 lualine 共存)
- ✅ **words**: 单词高亮

### 新增快捷键

| 快捷键 | 功能 | 描述 |
|--------|------|------|
| `<leader>.` | Snacks.scratch() | 切换便签 |
| `<leader>S` | Snacks.scratch.select() | 选择便签 |
| `<leader>n` | Snacks.notifier.show_history() | 通知历史 |
| `<leader>bd` | Snacks.bufdelete() | 删除缓冲区 |
| `<leader>cR` | Snacks.rename.rename_file() | 重命名文件 |
| `<leader>gB` | Snacks.gitbrowse() | Git 浏览 |
| `<leader>gb` | Snacks.git.blame_line() | Git Blame 浮窗 |
| `<leader>gf` | Snacks.lazygit.log_file() | Lazygit 当前文件 |
| `<leader>gg` | Snacks.lazygit() | Lazygit |
| `<leader>gl` | Snacks.lazygit.log() | Lazygit 日志 |
| `<leader>un` | Snacks.notifier.hide() | 隐藏通知 |
| `<c-/>` | Snacks.terminal() | 切换终端 |
| `<c-_>` | Snacks.terminal() | 切换终端 |
| `<leader>N` | Neovim 新闻 | 显示 Neovim 新闻 |

## 新增插件

为了满足特定需求，新增了以下插件：

### Git 集成增强

**相关插件**: `lewis6991/gitsigns.nvim`
**文件位置**: `/lua/kickstart/plugins/gitsigns.lua`
**功能**: Git 集成，包括标记、导航和 Git Blame 功能
**状态**: ✅ 已配置

**Git Blame 功能**:
- 默认开启当前行 blame 信息显示（虚拟文本）
- 显示格式：`<author>, <date> - <summary>`
- 150ms 延迟显示，避免频繁更新

**快捷键**:
| 快捷键 | 命令 | 描述 |
|--------|------|------|
| `]c` | gitsigns.nav_hunk('next') | 跳转到下一个 Git 更改 |
| `[c` | gitsigns.nav_hunk('prev') | 跳转到上一个 Git 更改 |
| `<leader>tb` | gitsigns.toggle_current_line_blame | 切换当前行 blame 显示 |
| `<leader>tD` | gitsigns.preview_hunk_inline | 切换显示删除的行 |

## 保留的插件

以下插件与 snacks.nvim 无冲突，继续保留使用：

- `nvim-telescope/telescope.nvim` - 模糊查找器
- `nvim-lualine/lualine.nvim` - 状态栏 (已调整兼容性)
- `akinsho/bufferline.nvim` - 缓冲区标签栏
- `lewis6991/gitsigns.nvim` - Git 标记
- `folke/which-key.nvim` - 快捷键提示

- 其他 LSP、语法高亮、编辑增强插件

## 测试建议

1. **重启 Neovim** 以确保所有配置生效
2. **测试启动面板** - 检查 snacks.dashboard 是否正常显示
3. **测试文件浏览** - 使用 snacks.explorer 浏览文件
4. **测试缩进显示** - 检查 snacks.indent 和 snacks.scope 是否正常工作
5. **测试通知系统** - 检查 snacks.notifier 是否正常显示通知
6. **测试状态栏** - 确认 lualine 与 snacks.statuscolumn 无冲突
7. **测试 Git 功能**:
   - 打开一个 Git 仓库中的文件，检查是否自动显示当前行 git blame 虚拟文本
   - 使用 `<leader>tb` 切换当前行 blame 显示
   - 使用 `<leader>gb` 测试 snacks.nvim 的浮窗 git blame
   - 使用 `]c` 和 `[c` 测试 Git 更改导航
   - 使用 `<leader>tD` 测试显示删除的行

## 回滚方案

如果遇到问题，可以通过以下方式回滚：

1. 将所有被禁用的插件的 `enabled = false` 改为 `enabled = true`
2. 将 snacks.nvim 的 `enabled` 设置为 `false`
3. 重启 Neovim

## 更新日期

- **创建日期**: 2024年
- **最后更新**: 2024年
- **作者**: pengjiecheng