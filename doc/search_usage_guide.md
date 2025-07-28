# 🔍 搜索功能使用指南

## 📋 概述

当前配置采用了**精简模式**，只显示最常用的搜索功能快捷键，隐藏了不常用的功能以减少认知负担。

- **精简模式**: 6 个常用搜索快捷键 + 9 个 Telescope 核心功能
- **完整模式**: 23 个完整搜索快捷键
- **已隐藏**: 17 个不常用功能

---

## 🚀 快速开始

### 最常用的 5 个快捷键

1. **`<leader><space>`** - ⚡ 智能文件查找（最快）
2. **`<leader>sg`** - 🔍 全局搜索（代码搜索）
3. **`<leader>,`** - 📋 缓冲区切换（文件间跳转）
4. **`<leader>sf`** - 📁 高级文件搜索（复杂查找）
5. **`<leader>sw`** - 🎯 搜索当前单词（代码导航）

### 基础工作流

```
查找文件 → <leader><space> 或 <leader>sf
搜索代码 → <leader>sg
搜索单词 → <leader>sw
切换文件 → <leader>,
当前文件搜索 → <leader>/
```

---

## 🎯 详细功能说明

### 📁 文件查找类

| 快捷键 | 功能 | 使用场景 |
|--------|------|----------|
| `<leader><space>` | 智能文件查找 | 最快速的文件查找，智能排序 |
| `<leader>sf` | 高级文件搜索 | 需要复杂过滤条件的文件查找 |
| `<leader>s.` | 最近文件 | 查找最近访问过的文件 |
| `<leader>sn` | Neovim 配置文件 | 快速编辑配置文件 |

### 🔍 内容搜索类

| 快捷键 | 功能 | 使用场景 |
|--------|------|----------|
| `<leader>sg` | 全局搜索 | 在整个项目中搜索文本 |
| `<leader>sw` | 搜索当前单词 | 查找光标下单词的所有出现 |
| `<leader>s/` | 打开文件搜索 | 在已打开的文件中搜索 |
| `<leader>/` | 当前文件搜索 | 在当前文件内模糊搜索 |

### 🏷️ 系统功能类

| 快捷键 | 功能 | 使用场景 |
|--------|------|----------|
| `<leader>sh` | 帮助搜索 | 查找 Vim/Neovim 帮助文档 |
| `<leader>sk` | 快捷键搜索 | 查找所有可用的快捷键 |
| `<leader>sc` | 命令历史 | 查找之前执行过的命令 |
| `<leader>sd` | 诊断信息 | 查看 LSP 错误和警告 |

### 🎯 代码导航类

| 快捷键 | 功能 | 使用场景 |
|--------|------|----------|
| `<leader>ss` | LSP 符号 | 在当前文件中查找函数、变量等 |
| `<leader>sS` | 工作区符号 | 在整个项目中查找符号 |
| `gd` | 转到定义 | 跳转到符号定义处 |
| `gr` | 查找引用 | 查找符号的所有引用 |

### 📦 项目管理类

| 快捷键 | 功能 | 使用场景 |
|--------|------|----------|
| `<leader>sp` | 项目列表 | 在多个项目间切换 |
| `<leader>sm` | Node 模块搜索 | 查找 Node.js 依赖模块 |
| `<leader>sr` | 恢复搜索 | 恢复上次的搜索结果 |

---

## 🔧 模式切换

### 切换到完整模式

如果需要使用更多高级功能，可以切换到完整模式：

```vim
" 方法 1: 使用快捷键
<leader>st

" 方法 2: 使用命令
:SearchToggle

" 方法 3: 使用 Lua
:lua require('custom.search_toggle').set_full_mode()
```

### 查看当前状态

```vim
" 查看当前模式状态
<leader>s?

" 查看详细统计
:SearchStats

" 使用命令
:SearchStatus
```

### 打开搜索菜单

```vim
" 打开交互式搜索菜单
<leader>S

" 使用命令
:SearchMenu
```

---

## 💡 使用技巧

### 🎯 高效搜索策略

1. **文件查找优先级**:
   ```
   <leader><space> → 日常文件查找
   <leader>sf → 复杂条件查找
   <leader>s. → 最近文件快速访问
   ```

2. **代码搜索策略**:
   ```
   <leader>sg → 全局文本搜索
   <leader>sw → 当前单词搜索
   <leader>ss → 符号搜索
   ```

3. **问题排查策略**:
   ```
   <leader>sd → 查看诊断信息
   <leader>sh → 查找帮助文档
   <leader>sk → 查找快捷键
   ```

### 🔥 组合使用

1. **快速代码导航**:
   ```
   <leader>sw → 搜索当前单词
   gd → 跳转到定义
   gr → 查看所有引用
   <C-o> → 返回原位置
   ```

2. **项目文件管理**:
   ```
   <leader>sp → 切换项目
   <leader><space> → 查找文件
   <leader>, → 切换缓冲区
   ```

3. **学习和帮助**:
   ```
   <leader>sh → 搜索帮助
   <leader>sk → 搜索快捷键
   <leader>sc → 查看命令历史
   ```

### 📚 学习路径

#### 🟢 初学者（第 1 周）
掌握这 3 个核心快捷键：
- `<leader><space>` - 查找文件
- `<leader>sg` - 全局搜索
- `<leader>,` - 切换缓冲区

#### 🟡 进阶用户（第 2-3 周）
再学习这 4 个实用快捷键：
- `<leader>sf` - 高级文件搜索
- `<leader>sw` - 搜索当前单词
- `<leader>/` - 当前文件搜索
- `<leader>sh` - 搜索帮助

#### 🔴 高级用户（第 4 周+）
掌握完整的搜索体系：
- 所有 LSP 相关搜索
- 项目管理功能
- 诊断和调试功能
- 模式切换和自定义

---

## 🛠️ 自定义配置

### 添加个人快捷键

在 `~/.config/nvim/lua/custom/` 目录下创建个人配置：

```lua
-- ~/.config/nvim/lua/custom/my_search.lua
local function my_search_config()
  -- 添加个人常用的搜索快捷键
  vim.keymap.set('n', '<leader>sP', function()
    require('telescope.builtin').find_files({
      cwd = '~/Projects',
      prompt_title = 'My Projects'
    })
  end, { desc = '搜索我的项目' })
end

my_search_config()
```

### 创建搜索模板

```lua
-- 创建常用搜索模板
local function create_search_templates()
  local templates = {
    vue_files = function()
      require('telescope.builtin').find_files({
        find_command = { 'fd', '--type', 'f', '--extension', 'vue' }
      })
    end,
    
    js_functions = function()
      require('telescope.builtin').live_grep({
        default_text = 'function ',
        type_filter = 'js'
      })
    end,
  }
  
  -- 绑定快捷键
  vim.keymap.set('n', '<leader>sv', templates.vue_files, { desc = '搜索 Vue 文件' })
  vim.keymap.set('n', '<leader>sj', templates.js_functions, { desc = '搜索 JS 函数' })
end
```

---

## 🔍 故障排除

### 常见问题

1. **快捷键不生效**
   ```vim
   " 检查快捷键是否被其他插件占用
   :verbose map <leader>sg
   
   " 重新加载搜索配置
   :lua require('custom.search_toggle').set_essential_mode()
   ```

2. **搜索结果为空**
   ```vim
   " 检查当前工作目录
   :pwd
   
   " 检查 ripgrep 是否安装
   :!rg --version
   ```

3. **切换模式失败**
   ```vim
   " 查看错误信息
   :messages
   
   " 手动重新加载
   :lua package.loaded['custom.search_toggle'] = nil
   :lua require('custom.search_toggle')
   ```

### 性能优化

1. **大项目搜索优化**
   ```lua
   -- 在 telescope 配置中添加
   defaults = {
     file_ignore_patterns = {
       "node_modules/.*",
       ".git/.*",
       "dist/.*",
       "build/.*"
     }
   }
   ```

2. **搜索速度优化**
   ```lua
   -- 调整搜索参数
   live_grep = {
     additional_args = function()
       return { "--hidden", "--smart-case" }
     end
   }
   ```

---

## 📚 相关文档

- [搜索功能精简版快捷键](./search_keymaps_essential.md)
- [完整快捷键速查表](./keymaps_cheatsheet.md)
- [Telescope 与 Snacks.picker 融合配置](./telescope_snacks_integration.md)
- [配置优化器使用指南](../lua/custom/config_optimizer.lua)

---

**🎉 恭喜！** 你现在已经掌握了高效的搜索功能配置。记住：**先掌握核心功能，再逐步扩展**！