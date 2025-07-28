# 🔄 搜索功能重构总结

## 📋 概述

本次重构将搜索功能从 **Telescope + Snacks 混合模式** 调整为 **Snacks 主导模式**，只保留 Telescope 的 `<leader>sm` (Node 模块搜索) 功能，其他搜索功能全部使用 Snacks.picker 实现。

## 🎯 重构目标

1. **简化配置**: 减少工具重复，统一搜索体验
2. **提升性能**: Snacks.picker 启动更快，内存占用更低
3. **保持功能**: 确保所有常用搜索功能都可用
4. **优化快捷键**: 重新整理快捷键布局，提高使用效率

---

## 🔧 主要变更

### 1. **Telescope 配置简化**

**变更前**:
```lua
-- 大量被注释的 Telescope 快捷键
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
-- ... 更多快捷键
vim.keymap.set('n', '<leader>sn', function()
  builtin.find_files { cwd = vim.fn.stdpath 'config' }
end, { desc = '[S]earch [N]eovim files' })
vim.keymap.set('n', '<leader>sm', function()
  require('telescope').extensions.node_modules.list { ... }
end, { desc = '[S]earch node_[M]odules' })
```

**变更后**:
```lua
-- 只保留 node_modules 搜索功能，其他搜索功能使用 Snacks
vim.keymap.set('n', '<leader>sm', function()
  require('telescope').extensions.node_modules.list {
    search_dirs = { './node_modules', '../node_modules', '../../node_modules' },
    depth = 2, -- 限制搜索深度
  }
end, { desc = '[S]earch node_[M]odules' })
```

### 2. **search_toggle.lua 重构**

#### 精简模式快捷键 (essential_keymaps)

| 快捷键 | 功能 | 工具 | 描述 |
|--------|------|------|------|
| `<leader>sf` | 📁 查找文件 | Snacks | 基础文件搜索 |
| `<leader>sg` | 🔍 全局搜索 | Snacks | 全局文本搜索 |
| `<leader>sw` | 🎯 搜索当前单词 | Snacks | 搜索光标下单词 |
| `<leader>sr` | 📄 最近文件 | Snacks | 最近访问文件 |
| `<leader>sb` | 📋 缓冲区列表 | Snacks | 打开的缓冲区 |
| `<leader>sc` | 📜 命令历史 | Snacks | 命令历史记录 |
| `<leader>sd` | 🩺 诊断信息 | Snacks | LSP 诊断信息 |
| `<leader>sh` | 📚 帮助搜索 | Snacks | Vim 帮助文档 |
| `<leader>sk` | ⌨️ 快捷键搜索 | Snacks | 快捷键映射 |
| `<leader>ss` | 🏷️ LSP 符号 | Snacks | 当前文件符号 |

#### 完整模式新增功能

| 快捷键 | 功能 | 工具 | 描述 |
|--------|------|------|------|
| `<leader>sn` | ⚙️ 配置文件 | Snacks | Neovim 配置文件 |
| `<leader>sS` | 🌐 工作区符号 | Snacks | 工作区所有符号 |
| `<leader>sl` | 📄 缓冲区行 | Snacks | 当前缓冲区行搜索 |
| `<leader>sL` | 📍 位置列表 | Snacks | 位置列表 |
| `<leader>sM` | 🏷️ 标记 | Snacks | Vim 标记 |

### 3. **新增快速访问快捷键**

在 `init.lua` 中新增了以下快捷键:

#### 核心快速访问
```lua
-- 智能文件查找
vim.keymap.set('n', '<leader><space>', function() Snacks.picker.smart() end, { desc = '⚡ 智能查找文件' })

-- 缓冲区快速切换
vim.keymap.set('n', '<leader>,', function() Snacks.picker.buffers() end, { desc = '📋 缓冲区列表' })

-- 当前缓冲区搜索
vim.keymap.set('n', '<leader>/', function() Snacks.picker.lines() end, { desc = '🔍 当前缓冲区搜索' })
```

#### Git 相关快捷键
```lua
vim.keymap.set('n', '<leader>gb', function() Snacks.picker.git_branches() end, { desc = '🌿 Git 分支' })
vim.keymap.set('n', '<leader>gl', function() Snacks.picker.git_log() end, { desc = '📜 Git 日志' })
vim.keymap.set('n', '<leader>gs', function() Snacks.picker.git_status() end, { desc = '📊 Git 状态' })
vim.keymap.set('n', '<leader>gf', function() Snacks.picker.git_files() end, { desc = '📁 Git 文件' })
```

#### LSP 导航快捷键
```lua
vim.keymap.set('n', 'gd', function() Snacks.picker.lsp_definitions() end, { desc = '🎯 转到定义' })
vim.keymap.set('n', 'gr', function() Snacks.picker.lsp_references() end, { desc = '🔗 查找引用' })
vim.keymap.set('n', 'gI', function() Snacks.picker.lsp_implementations() end, { desc = '🔧 转到实现' })
vim.keymap.set('n', 'gy', function() Snacks.picker.lsp_type_definitions() end, { desc = '📝 类型定义' })
```

### 4. **搜索菜单更新**

`create_search_menu()` 函数已更新，反映新的快捷键配置:

```lua
local actions = {
  { '⚡ 智能查找文件', function() Snacks.picker.smart() end },
  { '📁 查找文件', function() Snacks.picker.files() end },
  { '🔍 全局搜索', function() Snacks.picker.grep() end },
  { '🎯 搜索当前单词', function() Snacks.picker.grep_word() end },
  { '📄 最近文件', function() Snacks.picker.recent() end },
  { '📋 缓冲区列表', function() Snacks.picker.buffers() end },
  { '📦 Node 模块 (Telescope)', function() require('telescope').extensions.node_modules.list() end },
  { '⚙️ 配置文件', function() Snacks.picker.files { cwd = vim.fn.stdpath('config') } end },
  -- ... 更多选项
}
```

---

## 📊 快捷键对比表

### 核心搜索功能对比

| 功能 | 重构前 | 重构后 | 变化 |
|------|--------|--------|------|
| 文件搜索 | `<leader>sf` (Telescope) | `<leader>sf` (Snacks) | ✅ 工具切换 |
| 全局搜索 | `<leader>sg` (Telescope) | `<leader>sg` (Snacks) | ✅ 工具切换 |
| 单词搜索 | `<leader>sw` (Telescope) | `<leader>sw` (Snacks) | ✅ 工具切换 |
| 帮助搜索 | `<leader>sh` (Telescope) | `<leader>sh` (Snacks) | ✅ 工具切换 |
| 快捷键搜索 | `<leader>sk` (Telescope) | `<leader>sk` (Snacks) | ✅ 工具切换 |
| 诊断信息 | `<leader>sd` (Telescope) | `<leader>sd` (Snacks) | ✅ 工具切换 |
| Node 模块 | `<leader>sm` (Telescope) | `<leader>sm` (Telescope) | ✅ 保持不变 |
| 配置文件 | `<leader>sn` (Telescope) | `<leader>sn` (Snacks) | ✅ 工具切换 |

### 新增快捷键

| 快捷键 | 功能 | 工具 | 状态 |
|--------|------|------|------|
| `<leader><space>` | 智能查找文件 | Snacks | 🆕 新增 |
| `<leader>,` | 缓冲区列表 | Snacks | 🆕 新增 |
| `<leader>/` | 当前缓冲区搜索 | Snacks | 🆕 新增 |
| `<leader>gb` | Git 分支 | Snacks | 🆕 新增 |
| `<leader>gl` | Git 日志 | Snacks | 🆕 新增 |
| `<leader>gs` | Git 状态 | Snacks | 🆕 新增 |
| `<leader>gf` | Git 文件 | Snacks | 🆕 新增 |
| `gd` | 转到定义 | Snacks | 🆕 新增 |
| `gr` | 查找引用 | Snacks | 🆕 新增 |
| `gI` | 转到实现 | Snacks | 🆕 新增 |
| `gy` | 类型定义 | Snacks | 🆕 新增 |

---

## 🚀 性能优化效果

### 启动性能
- **减少插件依赖**: 大部分搜索功能不再依赖 Telescope
- **更快的初始化**: Snacks.picker 启动速度更快
- **内存占用降低**: 减少了重复功能的内存开销

### 用户体验
- **统一的界面**: 大部分搜索功能使用相同的 UI
- **一致的快捷键**: 保持原有的快捷键习惯
- **功能完整性**: 所有原有功能都得到保留

---

## 🔧 使用指南

### 1. **基础搜索工作流**

```bash
# 智能文件查找（最常用）
<leader><space>

# 全局文本搜索
<leader>sg

# 查找特定文件
<leader>sf

# 切换缓冲区
<leader>,
```

### 2. **Git 工作流**

```bash
# 查看 Git 状态
<leader>gs

# 切换分支
<leader>gb

# 查看提交历史
<leader>gl

# 查找 Git 跟踪的文件
<leader>gf
```

### 3. **LSP 导航工作流**

```bash
# 转到定义
gd

# 查找引用
gr

# 转到实现
gI

# 查看类型定义
gy
```

### 4. **搜索模式切换**

```bash
# 切换精简/完整模式
<leader>st

# 显示搜索菜单
<leader>S

# 查看搜索状态
<leader>s?
```

---

## 📚 相关命令

### 用户命令
- `:SearchToggle` - 切换搜索模式
- `:SearchStatus` - 显示搜索模式状态
- `:SearchMenu` - 打开搜索菜单
- `:SearchStats` - 显示搜索功能统计

### 调试命令
```lua
-- 检查当前模式
:lua print(require('custom.search_toggle').get_mode())

-- 查看使用统计
:lua vim.print(require('custom.search_toggle').get_usage_stats())

-- 重新加载搜索配置
:lua package.loaded['custom.search_toggle'] = nil
:lua require('custom.search_toggle')
```

---

## 🔍 故障排除

### 常见问题

1. **快捷键不生效**
   ```vim
   " 检查快捷键冲突
   :verbose map <leader>sf
   
   " 重新加载配置
   :lua require('custom.search_toggle').set_essential_mode()
   ```

2. **Snacks 功能不可用**
   ```vim
   " 检查 Snacks 状态
   :lua print(vim.inspect(Snacks.picker))
   
   " 检查插件加载
   :Lazy
   ```

3. **Node 模块搜索失败**
   ```vim
   " 检查 Telescope 扩展
   :Telescope
   
   " 重新加载扩展
   :lua require('telescope').load_extension('node-modules')
   ```

---

## 📈 后续优化建议

### 1. **性能监控**
- 定期检查启动时间变化
- 监控内存使用情况
- 收集用户使用数据

### 2. **功能扩展**
- 考虑添加更多 Git 相关功能
- 扩展 LSP 导航能力
- 优化搜索结果展示

### 3. **用户体验**
- 收集用户反馈
- 优化快捷键布局
- 改进搜索菜单设计

---

## 📝 总结

本次重构成功实现了以下目标:

✅ **简化配置**: 减少了工具重复，统一使用 Snacks.picker  
✅ **保持功能**: 所有原有搜索功能都得到保留  
✅ **优化性能**: 减少启动时间和内存占用  
✅ **改善体验**: 提供更一致的用户界面  
✅ **扩展功能**: 新增了 Git 和 LSP 相关快捷键  

**核心变化**: Telescope 只保留 `<leader>sm` (Node 模块搜索)，其他搜索功能全部使用 Snacks.picker 实现，同时新增了大量快速访问快捷键，提升了整体的使用效率。