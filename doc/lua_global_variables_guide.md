# Lua 全局变量声明指南

## 概述

在 Lua 中声明全局变量有多种方法，特别是在 Neovim 配置中，需要遵循一些最佳实践来避免命名冲突和提高代码可维护性。

## 全局变量声明方法

### 1. 直接赋值（基础方法）

```lua
-- 直接声明全局变量
global_var = "Hello World"
my_config = { theme = "dark", font_size = 14 }
```

### 2. 使用 _G 表（推荐方法）

```lua
-- 使用 _G 表显式声明全局变量
_G.Snacks = require('snacks')
_G.vim = vim
_G.my_custom_function = function()
    print("This is a global function")
end
```

### 3. 在 Neovim 中使用 vim.g（Neovim 特有）

```lua
-- 使用 vim.g 存储 Neovim 全局变量
vim.g.snacks_global = true
vim.g.my_theme = "tokyonight"
vim.g.my_globals = {
    snacks = 'Snacks',
    editor = 'neovim'
}
```

## 实际应用示例

### 在 options.lua 中的声明

```lua
local opt = vim.opt

-- 全局变量声明
-- 声明 Snacks 为全局变量，方便在整个配置中使用
vim.g.snacks_global = true
_G.Snacks = require('snacks')

-- 声明 vim 相关的全局变量
_G.vim = vim

-- 自定义全局变量命名空间
vim.g.my_globals = {
  snacks = 'Snacks',
  editor = 'neovim'
}
```

### 在其他文件中使用

```lua
-- 在任何其他 Lua 文件中使用全局变量
if _G.Snacks then
    _G.Snacks.notify("Hello from Snacks!")
end

-- 使用 vim.g 中的变量
if vim.g.snacks_global then
    print("Snacks is globally available")
end

-- 访问自定义命名空间
local my_editor = vim.g.my_globals.editor
print("Using editor: " .. my_editor)
```

## 最佳实践

### 1. 使用命名空间避免冲突

```lua
-- 好的做法：使用命名空间
vim.g.myconfig = {
    theme = "dark",
    plugins = {
        snacks = true,
        telescope = true
    }
}

-- 避免的做法：直接使用通用名称
-- theme = "dark"  -- 可能与其他插件冲突
```

### 2. 模块化全局变量

```lua
-- 创建一个专门的全局变量模块
local M = {}

-- 初始化全局变量
function M.setup()
    _G.MyConfig = {
        snacks = require('snacks'),
        theme = vim.g.my_theme or "default",
        utils = {
            notify = function(msg)
                if _G.MyConfig.snacks then
                    _G.MyConfig.snacks.notify(msg)
                else
                    print(msg)
                end
            end
        }
    }
end

return M
```

### 3. 条件性全局变量

```lua
-- 只在需要时声明全局变量
if not _G.Snacks then
    local ok, snacks = pcall(require, 'snacks')
    if ok then
        _G.Snacks = snacks
        vim.g.snacks_available = true
    else
        vim.g.snacks_available = false
        vim.notify("Snacks not available", vim.log.levels.WARN)
    end
end
```

## 注意事项

1. **避免全局污染**：尽量使用命名空间或 `vim.g` 来避免污染全局环境
2. **性能考虑**：全局变量访问比局部变量慢，不要过度使用
3. **调试友好**：使用描述性的变量名，便于调试和维护
4. **插件兼容性**：确保全局变量名不与其他插件冲突

## 检查全局变量

```lua
-- 检查全局变量是否存在
if _G.Snacks then
    print("Snacks is available globally")
end

-- 列出所有自定义全局变量
for k, v in pairs(_G) do
    if type(k) == "string" and k:match("^[A-Z]") then
        print("Global variable: " .. k .. " = " .. tostring(v))
    end
end

-- 检查 vim.g 中的变量
for k, v in pairs(vim.g) do
    if k:match("^my_") then
        print("Vim global: " .. k .. " = " .. tostring(v))
    end
end
```

## 实际配置示例

### 在 options.lua 中的基础设置

```lua
-- /Users/pengjiecheng/.config/nvim/lua/custom/options.lua
local opt = vim.opt

-- 全局变量声明
-- 声明 vim 相关的全局变量（这个总是可用的）
_G.vim = vim

-- 自定义全局变量命名空间
vim.g.my_globals = {
  snacks = 'Snacks',
  editor = 'neovim'
}

-- Snacks 全局变量将在插件加载后设置
vim.g.snacks_global = false -- 初始状态为 false，插件加载后会设置为 true
```

### 在插件配置中设置 Snacks 全局变量

```lua
-- /Users/pengjiecheng/.config/nvim/lua/custom/plugins/snacks.lua
return {
  {
    'folke/snacks.nvim',
    -- ... 其他配置
    init = function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function()
          -- 设置 Snacks 为全局变量
          _G.Snacks = require('snacks')
          vim.g.snacks_global = true
          
          -- 其他初始化代码...
        end,
      })
    end,
  },
}
```

### 使用全局变量的示例模块

```lua
-- /Users/pengjiecheng/.config/nvim/lua/custom/global_vars_example.lua
local M = {}

-- 智能通知函数，优先使用 Snacks
function M.smart_notify(message, level)
  level = level or "info"
  
  if _G.Snacks and _G.Snacks.notifier then
    _G.Snacks.notifier.notify(message, level)
  elseif _G.vim and _G.vim.notify then
    _G.vim.notify(message, _G.vim.log.levels.INFO)
  else
    print(string.format("[%s] %s", level:upper(), message))
  end
end

return M
```

## 测试结果

运行测试命令 `:TestGlobals` 或快捷键 `<leader>tg` 的结果：

```
=== 全局变量状态检查 ===
Snacks 全局状态: 已启用
✅ _G.Snacks: 可用
✅ _G.vim: 可用
✅ vim.g.snacks_global: 可用
✅ vim.g.my_globals: 可用

=== 功能测试 ===
✅ Snacks 全局变量可用
✅ vim 全局变量可用
编辑器: neovim
Snacks 标识: Snacks
```

## 可用的测试命令和快捷键

| 命令/快捷键 | 功能 | 描述 |
|-------------|------|------|
| `:TestGlobals` | 运行全局变量测试 | 检查所有全局变量状态 |
| `<leader>tg` | 快捷键测试 | 同上 |
| `<leader>tn` | 测试通知 | 测试智能通知功能 |
| `<leader>tf` | 智能文件选择 | 测试文件选择器 |

## 总结

在 Neovim 配置中声明全局变量时：
- 优先使用 `vim.g` 存储 Neovim 特定的全局变量
- 使用 `_G` 表声明真正的 Lua 全局变量
- 采用命名空间避免冲突
- 考虑性能和可维护性
- 添加适当的错误处理和检查
- 在插件加载后设置插件相关的全局变量
- 提供测试功能来验证全局变量的可用性