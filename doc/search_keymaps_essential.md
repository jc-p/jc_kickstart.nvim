# 🔍 常用搜索功能快捷键 (`<leader>s*`)

## 📋 核心搜索功能

### 🎯 最常用的搜索快捷键

| 快捷键 | 功能 | 工具 | 描述 | 使用频率 |
|--------|------|------|------|----------|
| `<leader>sf` | 📁 文件搜索 | Telescope | 高级文件搜索（带过滤器） | ⭐⭐⭐⭐⭐ |
| `<leader>sg` | 🔍 全局搜索 | Telescope | Live grep 实时搜索 | ⭐⭐⭐⭐⭐ |
| `<leader>sw` | 🎯 单词搜索 | Telescope | 搜索当前光标下的单词 | ⭐⭐⭐⭐ |
| `<leader>s/` | 📂 打开文件搜索 | Telescope | 在已打开的文件中搜索 | ⭐⭐⭐⭐ |
| `<leader>sh` | 📚 帮助搜索 | Snacks | 搜索 Vim 帮助文档 | ⭐⭐⭐ |
| `<leader>sk` | ⌨️ 快捷键搜索 | Snacks | 搜索所有快捷键映射 | ⭐⭐⭐ |
| `<leader>sc` | 📜 命令历史 | Snacks | 搜索命令历史记录 | ⭐⭐⭐ |
| `<leader>sd` | 🩺 诊断信息 | Snacks | 搜索 LSP 诊断信息 | ⭐⭐⭐ |

### 🚀 快速访问（非 `<leader>s` 前缀）

| 快捷键 | 功能 | 工具 | 描述 | 使用频率 |
|--------|------|------|------|----------|
| `<leader><space>` | ⚡ 智能查找 | Snacks | 智能文件查找 | ⭐⭐⭐⭐⭐ |
| `<leader>,` | 📋 缓冲区列表 | Snacks | 快速切换缓冲区 | ⭐⭐⭐⭐⭐ |
| `<leader>/` | 🔍 缓冲区搜索 | Telescope | 当前缓冲区模糊搜索 | ⭐⭐⭐⭐ |

---

## 🔧 进阶搜索功能

### 📦 项目和模块搜索

| 快捷键 | 功能 | 工具 | 描述 | 使用频率 |
|--------|------|------|------|----------|
| `<leader>sp` | 📦 项目列表 | Telescope | 项目管理和切换 | ⭐⭐⭐ |
| `<leader>sm` | 📦 Node 模块 | Telescope | 搜索 Node.js 模块 | ⭐⭐ |
| `<leader>sr` | 🔄 恢复搜索 | Telescope | 恢复上次的搜索 | ⭐⭐ |
| `<leader>s.` | 🕐 最近文件 | Telescope | 搜索最近访问的文件 | ⭐⭐⭐ |
| `<leader>sn` | ⚙️ Neovim 文件 | Telescope | 搜索 Neovim 配置文件 | ⭐⭐ |

### 🏷️ LSP 符号搜索

| 快捷键 | 功能 | 工具 | 描述 | 使用频率 |
|--------|------|------|------|----------|
| `<leader>ss` | 🏷️ LSP 符号 | Snacks | 搜索当前文件的 LSP 符号 | ⭐⭐⭐ |
| `<leader>sS` | 🌐 工作区符号 | Snacks | 搜索整个工作区的 LSP 符号 | ⭐⭐ |

---

## 🎨 使用建议

### 💡 记忆技巧

1. **核心搜索流程**:
   ```
   <leader>sf → 查找文件（Files）
   <leader>sg → 全局搜索（Grep）
   <leader>sw → 搜索单词（Word）
   <leader>s/ → 在打开文件中搜索
   ```

2. **快速访问流程**:
   ```
   <leader><space> → 最快的文件查找
   <leader>, → 最快的缓冲区切换
   <leader>/ → 当前文件内搜索
   ```

3. **帮助和调试流程**:
   ```
   <leader>sh → 搜索帮助文档
   <leader>sk → 搜索快捷键
   <leader>sd → 搜索诊断信息
   ```

### 🔥 最高频使用的 5 个快捷键

1. `<leader><space>` - 智能文件查找（最常用）
2. `<leader>sg` - 全局搜索（代码搜索必备）
3. `<leader>,` - 缓冲区切换（文件间跳转）
4. `<leader>sf` - 高级文件搜索（复杂查找）
5. `<leader>sw` - 搜索当前单词（代码导航）

### 📚 学习路径

#### 🟢 初学者（掌握这 3 个就够用）
- `<leader><space>` - 查找文件
- `<leader>sg` - 全局搜索
- `<leader>,` - 切换缓冲区

#### 🟡 进阶用户（再学这 4 个）
- `<leader>sf` - 高级文件搜索
- `<leader>sw` - 搜索当前单词
- `<leader>/` - 当前文件搜索
- `<leader>sh` - 搜索帮助

#### 🔴 高级用户（完整掌握）
- `<leader>s/` - 在打开文件中搜索
- `<leader>sk` - 搜索快捷键
- `<leader>sc` - 命令历史
- `<leader>sd` - 诊断信息

---

## 🔧 自定义配置

### 创建个人常用搜索菜单

```lua
-- 在 ~/.config/nvim/lua/custom/search_menu.lua 中添加
local function create_search_menu()
  local actions = {
    { '⚡ 智能查找文件', function() Snacks.picker.smart() end },
    { '🔍 全局搜索', function() require('telescope.builtin').live_grep() end },
    { '📁 高级文件搜索', function() require('telescope.builtin').find_files() end },
    { '🎯 搜索当前单词', function() require('telescope.builtin').grep_string() end },
    { '📋 缓冲区列表', function() Snacks.picker.buffers() end },
    { '📚 搜索帮助', function() Snacks.picker.help() end },
  }
  
  vim.ui.select(actions, {
    prompt = '🔍 选择搜索功能:',
    format_item = function(item) return item[1] end,
  }, function(choice)
    if choice then choice[2]() end
  end)
end

-- 绑定到 <leader>S
vim.keymap.set('n', '<leader>S', create_search_menu, { desc = '搜索菜单' })
```

### 快速切换搜索工具

```lua
-- 在 Telescope 和 Snacks 之间快速切换
local use_telescope = true

local function toggle_search_tool()
  use_telescope = not use_telescope
  local tool = use_telescope and 'Telescope' or 'Snacks'
  vim.notify('搜索工具切换到: ' .. tool, vim.log.levels.INFO)
end

vim.keymap.set('n', '<leader>st', toggle_search_tool, { desc = '切换搜索工具' })
```

---

## 📊 性能对比

| 功能 | Telescope | Snacks.picker | 推荐 |
|------|-----------|---------------|------|
| 文件搜索 | 🟡 功能丰富但较慢 | 🟢 快速简洁 | 混合使用 |
| 全局搜索 | 🟢 强大的 grep 功能 | 🟡 基础功能 | Telescope |
| 缓冲区切换 | 🟡 功能完整 | 🟢 轻量快速 | Snacks |
| LSP 导航 | 🟡 需要配置 | 🟢 开箱即用 | Snacks |
| 项目管理 | 🟢 专业插件支持 | 🟡 基础功能 | Telescope |

---

## 🚫 已隐藏的不常用功能

<details>
<summary>点击查看完整的搜索功能列表</summary>

### 不常用的搜索功能（已隐藏）

| 快捷键 | 功能 | 描述 | 隐藏原因 |
|--------|------|------|----------|
| `<leader>s"` | 寄存器搜索 | 搜索寄存器内容 | 使用频率低 |
| `<leader>sa` | 自动命令搜索 | 搜索自动命令 | 高级功能 |
| `<leader>sb` | 缓冲区行搜索 | 搜索缓冲区行 | 功能重复 |
| `<leader>sB` | 多缓冲区搜索 | 在多个缓冲区中搜索 | 复杂功能 |
| `<leader>sC` | 命令搜索 | 搜索可用命令 | 使用频率低 |
| `<leader>sD` | 缓冲区诊断 | 当前缓冲区诊断 | 功能重复 |
| `<leader>sH` | 高亮搜索 | 搜索高亮组 | 开发功能 |
| `<leader>si` | 图标搜索 | 搜索图标 | 装饰功能 |
| `<leader>sj` | 跳转列表 | 搜索跳转历史 | 使用频率低 |
| `<leader>sl` | 位置列表 | 搜索位置列表 | 高级功能 |
| `<leader>sm` | 标记搜索 | 搜索标记 | 使用频率低 |
| `<leader>sM` | 手册页搜索 | 搜索 man 页面 | 系统功能 |
| `<leader>sq` | 快速修复列表 | 搜索快速修复 | 高级功能 |
| `<leader>sR` | 恢复搜索 | 恢复上次搜索 | 功能重复 |
| `<leader>su` | 撤销历史 | 搜索撤销历史 | 使用频率低 |
| `<leader>uC` | 配色方案 | 搜索配色方案 | 配置功能 |

</details>

---

## 📚 相关文档

- [完整快捷键速查表](./keymaps_cheatsheet.md)
- [Telescope 与 Snacks.picker 融合配置](./telescope_snacks_integration.md)
- [配置优化器使用指南](../lua/custom/config_optimizer.lua)

---

**💡 提示**: 建议先掌握核心的 8 个搜索快捷键，熟练后再根据需要学习进阶功能！