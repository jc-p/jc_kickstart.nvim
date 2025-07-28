# project.nvim 使用指南

## 简介

`project.nvim` 是一个 Neovim 项目管理插件，它可以自动检测和切换项目目录，并与 Telescope 集成以提供项目导航功能。

## 配置说明

当前配置位于 `/Users/pengjiecheng/.config/nvim/lua/custom/plugins/init.lua` 中：

```lua
-- 项目管理
{
  'ahmedkhalf/project.nvim',
  event = 'VeryLazy',
  opts = {
    manual_mode = false,
    detection_methods = { 'lsp', 'pattern' },
    patterns = {
      '.git',
      '_darcs',
      '.hg',
      '.bzr',
      '.svn',
      'Makefile',
      'package.json',
    },
    ignore_lsp = {},
    exclude_dirs = {},
    show_hidden = false,
    silent_chdir = true,
    scope_chdir = 'global',
  },
  config = function(_, opts)
    require('project_nvim').setup(opts)
  end,
},
```

### 配置选项说明

- `manual_mode`: 设置为 `false` 表示自动检测项目
- `detection_methods`: 项目检测方法，包括 LSP 和模式匹配
- `patterns`: 用于检测项目的文件或目录模式
- `show_hidden`: 是否显示隐藏文件
- `silent_chdir`: 切换目录时是否静默执行
- `scope_chdir`: 切换目录的作用域

## 使用方法

### 快捷键

已添加快捷键 `<leader>sp` 用于打开项目列表：

```lua
keymap("n", "<leader>sp", "<cmd>Telescope projects<CR>", { desc = "[S]earch [P]rojects" })
```

### 基本功能

1. **自动检测项目**：当你打开 Neovim 时，插件会自动检测当前目录是否为项目
2. **项目历史记录**：插件会记录你访问过的项目
3. **快速切换项目**：使用 `<leader>sp` 打开项目列表，选择要切换的项目

### 常见操作

- 打开项目列表：`<leader>sp`
- 在项目列表中，使用上下键选择项目
- 按 `Enter` 在当前窗口打开选中的项目
- 按 `Ctrl+v` 在垂直分割窗口中打开项目
- 按 `Ctrl+x` 在水平分割窗口中打开项目
- 按 `Ctrl+t` 在新标签页中打开项目
- 按 `d` 从历史记录中删除项目

## 故障排除

如果 `project.nvim` 没有正常工作，请检查：

1. 确保 Telescope 已正确加载 projects 扩展：
   ```lua
   pcall(require('telescope').load_extension, 'projects')
   ```

2. 确保项目目录中包含配置的检测模式文件（如 .git、package.json 等）

3. 尝试手动调用：
   ```vim
   :Telescope projects
   ```

## 高级用法

### 手动添加项目

你可以通过 Lua 函数手动添加项目：

```lua
require('project_nvim.project').add(path, pattern)
```

### 自定义项目排序

可以在 Telescope 配置中自定义项目排序方式。

### 与其他插件集成

`project.nvim` 可以与 `auto-session` 等插件集成，实现项目级别的会话管理。