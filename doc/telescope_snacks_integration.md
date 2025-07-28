# Telescope 与 Snacks.picker 融合配置指南

## 📋 概述

当前配置采用了 **Telescope** 和 **Snacks.picker** 的混合策略，充分发挥两者的优势：

- **Telescope**: 作为主要的模糊查找器，处理复杂搜索和扩展功能
- **Snacks.picker**: 作为轻量级补充，提供快速访问和内置功能

## 🎯 功能分工策略

### Telescope 负责的功能

#### 1. **复杂文件搜索**

```lua
-- 文件查找（带过滤器）
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
```

#### 2. **项目管理**

```lua
-- 项目列表（使用 telescope-projects 扩展）
vim.keymap.set('n', '<leader>sp', '<cmd>Telescope projects<CR>', { desc = '[S]earch [P]rojects' })
```

#### 3. **Node.js 模块搜索**

```lua
-- Node 模块搜索（专用扩展）
vim.keymap.set('n', '<leader>sm', function()
  require('telescope').extensions.node_modules.list({
    -- 自定义配置
  })
end, { desc = '[S]earch [M]odules' })
```

#### 4. **高级搜索功能**

```lua
-- 在打开的文件中搜索
vim.keymap.set('n', '<leader>s/', function()
  builtin.live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end, { desc = '[S]earch [/] in Open Files' })

-- 当前缓冲区模糊搜索
vim.keymap.set('n', '<leader>/', function()
  builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })
```

### Snacks.picker 负责的功能

#### 1. **快速文件访问**

```lua
-- 智能文件查找
{ '<leader><space>', function() Snacks.picker.smart() end, desc = 'Smart Find Files' }

-- 基础文件操作
{ '<leader>ff', function() Snacks.picker.files() end, desc = 'Find Files' }
{ '<leader>fr', function() Snacks.picker.recent() end, desc = 'Recent' }
{ '<leader>fc', function() Snacks.picker.files {cwd = vim.fn.stdpath 'config'} end, desc = 'Find Config File' }
```

#### 2. **Git 集成**

```lua
-- Git 相关操作
{ '<leader>gb', function() Snacks.picker.git_branches() end, desc = 'Git Branches' }
{ '<leader>gl', function() Snacks.picker.git_log() end, desc = 'Git Log' }
{ '<leader>gs', function() Snacks.picker.git_status() end, desc = 'Git Status' }
{ '<leader>gd', function() Snacks.picker.git_diff() end, desc = 'Git Diff (Hunks)' }
```

#### 3. **LSP 功能**

```lua
-- LSP 导航
{ 'gd', function() Snacks.picker.lsp_definitions() end, desc = 'Goto Definition' }
{ 'gr', function() Snacks.picker.lsp_references() end, desc = 'References' }
{ 'gI', function() Snacks.picker.lsp_implementations() end, desc = 'Goto Implementation' }
{ 'gy', function() Snacks.picker.lsp_type_definitions() end, desc = 'Goto T[y]pe Definition' }
```

#### 4. **系统功能**

```lua
-- 系统级搜索
{ '<leader>sh', function() Snacks.picker.help() end, desc = 'Help Pages' }
{ '<leader>sk', function() Snacks.picker.keymaps() end, desc = 'Keymaps' }
{ '<leader>sc', function() Snacks.picker.command_history() end, desc = 'Command History' }
{ '<leader>sd', function() Snacks.picker.diagnostics() end, desc = 'Diagnostics' }
```

## 🗝️ 快捷键分配表

### 主要快捷键前缀

| 前缀        | 功能域   | 主要工具           |
| ----------- | -------- | ------------------ |
| `<leader>s` | 搜索功能 | Telescope + Snacks |
| `<leader>f` | 文件操作 | Snacks.picker      |
| `<leader>g` | Git 操作 | Snacks.picker      |
| `g` + 字母  | LSP 导航 | Snacks.picker      |

### 详细快捷键映射

#### 🔍 搜索类 (`<leader>s`)

| 快捷键       | 功能         | 工具      | 描述                   |
| ------------ | ------------ | --------- | ---------------------- |
| `<leader>sf` | 文件搜索     | Telescope | 高级文件搜索（带过滤） |
| `<leader>sg` | 全局搜索     | Telescope | Live grep 搜索         |
| `<leader>sw` | 单词搜索     | Telescope | 搜索当前单词           |
| `<leader>s/` | 打开文件搜索 | Telescope | 在打开的文件中搜索     |
| `<leader>sh` | 帮助搜索     | Snacks    | 搜索帮助文档           |
| `<leader>sk` | 快捷键搜索   | Snacks    | 搜索快捷键             |
| `<leader>sc` | 命令历史     | Snacks    | 搜索命令历史           |
| `<leader>sd` | 诊断信息     | Snacks    | 搜索诊断信息           |
| `<leader>ss` | LSP 符号     | Snacks    | 搜索 LSP 符号          |
| `<leader>sp` | 项目列表     | Telescope | 项目管理               |
| `<leader>sm` | Node 模块    | Telescope | Node.js 模块搜索       |

#### 📁 文件类 (`<leader>f`)

| 快捷键       | 功能     | 工具   | 描述           |
| ------------ | -------- | ------ | -------------- |
| `<leader>ff` | 查找文件 | Snacks | 基础文件查找   |
| `<leader>fr` | 最近文件 | Snacks | 最近访问的文件 |
| `<leader>fc` | 配置文件 | Snacks | 查找配置文件   |
| `<leader>fg` | Git 文件 | Snacks | Git 跟踪的文件 |
| `<leader>fp` | 项目文件 | Snacks | 项目相关文件   |

#### 🌿 Git 类 (`<leader>g`)

| 快捷键       | 功能         | 工具   | 描述            |
| ------------ | ------------ | ------ | --------------- |
| `<leader>gb` | Git 分支     | Snacks | Git 分支管理    |
| `<leader>gl` | Git 日志     | Snacks | Git 提交日志    |
| `<leader>gs` | Git 状态     | Snacks | Git 状态查看    |
| `<leader>gd` | Git 差异     | Snacks | Git 差异查看    |
| `<leader>gf` | Git 文件日志 | Snacks | 文件的 Git 历史 |

#### 🎯 LSP 导航

| 快捷键 | 功能         | 工具   | 描述         |
| ------ | ------------ | ------ | ------------ |
| `gd`   | 转到定义     | Snacks | LSP 定义跳转 |
| `gr`   | 查找引用     | Snacks | LSP 引用查找 |
| `gI`   | 转到实现     | Snacks | LSP 实现跳转 |
| `gy`   | 转到类型定义 | Snacks | LSP 类型定义 |
| `gD`   | 转到声明     | Snacks | LSP 声明跳转 |

#### ⚡ 快速访问

| 快捷键            | 功能       | 工具      | 描述               |
| ----------------- | ---------- | --------- | ------------------ |
| `<leader><space>` | 智能查找   | Snacks    | 智能文件查找       |
| `<leader>,`       | 缓冲区列表 | Snacks    | 打开的缓冲区       |
| `<leader>/`       | 缓冲区搜索 | Telescope | 当前缓冲区模糊搜索 |
| `<leader>:`       | 命令历史   | Snacks    | 命令历史记录       |
| `<leader>n`       | 通知历史   | Snacks    | 通知历史记录       |
| `<leader>e`       | 文件浏览器 | Snacks    | 文件资源管理器     |

## ⚙️ 配置优化建议

### 1. **性能优化**

#### Telescope 配置优化

```lua
require('telescope').setup {
  defaults = {
    -- 忽略大型目录以提高性能
    file_ignore_patterns = {
      "node_modules/.*/dist",
      "node_modules/.*/test",
      "node_modules/.*/__tests__",
      "node_modules/.pnpm",
      "node_modules/.vite",
      "node_modules/.bin",
      "node_modules/.cache",
    }
  },
}
```

#### Snacks.picker 配置优化

```lua
picker = {
  enabled = true,
  -- 启用快速预览
  preview = {
    enabled = true,
    delay = 100,
  },
  -- 优化搜索性能
  search = {
    throttle = 50,
    min_chars = 2,
  },
}
```

### 2. **功能扩展**

#### 自定义 Telescope 扩展

```lua
-- 加载扩展
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')
pcall(require('telescope').load_extension, 'projects')
pcall(require('telescope').load_extension, 'node-modules')
```

#### Snacks.picker 自定义功能

```lua
-- 自定义 picker 函数
local function custom_config_picker()
  Snacks.picker.files {
    cwd = vim.fn.stdpath 'config',
    prompt_title = 'Neovim Config Files',
    find_command = { 'fd', '--type', 'f', '--hidden', '--exclude', '.git' },
  }
end

vim.keymap.set('n', '<leader>fC', custom_config_picker, { desc = 'Custom Config Picker' })
```

### 3. **主题统一**

#### Telescope 主题配置

```lua
require('telescope').setup {
  defaults = {
    -- 使用统一的主题
    layout_strategy = 'horizontal',
    layout_config = {
      horizontal = {
        prompt_position = 'top',
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
  },
}
```

## 🔄 迁移指南

### 从纯 Telescope 迁移

如果您之前只使用 Telescope，可以逐步迁移：

1. **保留核心 Telescope 功能**
   - 文件搜索 (`<leader>sf`)
   - 全局搜索 (`<leader>sg`)
   - 项目管理 (`<leader>sp`)

2. **逐步引入 Snacks.picker**
   - 从快速访问开始 (`<leader><space>`)
   - 添加 Git 功能 (`<leader>g*`)
   - 使用 LSP 导航 (`gd`, `gr` 等)

3. **调整快捷键习惯**
   - 使用 `<leader>f*` 进行文件操作
   - 使用 `<leader>s*` 进行搜索操作

### 从纯 Snacks.picker 迁移

如果您想从纯 Snacks.picker 迁移：

1. **保留 Snacks.picker 的优势**
   - 快速访问和导航
   - Git 集成功能
   - LSP 功能

2. **添加 Telescope 的高级功能**
   - 复杂搜索和过滤
   - 扩展插件支持
   - 自定义主题和布局

## 🎨 自定义配置示例

### 创建统一的搜索入口

```lua
-- 创建一个统一的搜索菜单
local function search_menu()
  local actions = {
    { '📁 Files (Telescope)', function() require('telescope.builtin').find_files() end },
    { '🔍 Grep (Telescope)', function() require('telescope.builtin').live_grep() end },
    { '⚡ Smart (Snacks)', function() Snacks.picker.smart() end },
    { '📋 Buffers (Snacks)', function() Snacks.picker.buffers() end },
    { '🌿 Git Status (Snacks)', function() Snacks.picker.git_status() end },
    { '📚 Help (Snacks)', function() Snacks.picker.help() end },
  }

  vim.ui.select(actions, {
    prompt = 'Search Menu:',
    format_item = function(item) return item[1] end,
  }, function(choice)
    if choice then choice[2]() end
  end)
end

vim.keymap.set('n', '<leader>S', search_menu, { desc = 'Search Menu' })
```

### 智能快捷键切换

```lua
-- 根据文件类型智能选择工具
local function smart_find_files()
  local ft = vim.bo.filetype
  if ft == 'javascript' or ft == 'typescript' or ft == 'vue' then
    -- 对于前端项目，使用 Telescope 的 node_modules 扩展
    require('telescope').extensions.node_modules.list()
  else
    -- 其他情况使用 Snacks.picker
    Snacks.picker.smart()
  end
end

vim.keymap.set('n', '<leader>F', smart_find_files, { desc = 'Smart Find Files' })
```

## 📊 性能对比

| 功能           | Telescope | Snacks.picker | 推荐使用  |
| -------------- | --------- | ------------- | --------- |
| **启动速度**   | 中等      | 快            | Snacks    |
| **搜索性能**   | 优秀      | 优秀          | 平分      |
| **扩展性**     | 极强      | 中等          | Telescope |
| **内存占用**   | 中等      | 低            | Snacks    |
| **配置复杂度** | 高        | 低            | Snacks    |
| **功能丰富度** | 极高      | 高            | Telescope |

## 🔧 故障排除

### 常见问题

1. **快捷键冲突**

   ```lua
   -- 检查快捷键冲突
   :verbose map <leader>sf
   ```

2. **性能问题**

   ```lua
   -- 检查插件加载时间
   :Lazy profile
   ```

3. **功能不可用**
   ```lua
   -- 检查插件状态
   :checkhealth telescope
   :lua print(vim.inspect(Snacks.picker))
   ```

### 调试技巧

```lua
-- 启用详细日志
vim.g.telescope_debug = true
Snacks.debug.enable()

-- 查看配置
:Telescope builtin
:lua Snacks.picker.help()
```

## 📝 总结

这种混合配置策略充分发挥了两个工具的优势：

- **Telescope** 处理复杂搜索和扩展功能
- **Snacks.picker** 提供快速访问和轻量级操作
- **统一的快捷键体系** 确保用户体验的一致性
- **性能优化** 在功能和速度之间找到平衡

通过合理的功能分工和快捷键分配，用户可以享受到两个工具的最佳特性，同时避免功能重复和性能浪费。

