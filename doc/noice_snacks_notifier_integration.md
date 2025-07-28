# Noice + Snacks Notifier 集成方案

## 概述

本文档提供了将 `noice.nvim` 的 cmdline 功能与 `snacks.nvim` 的 notifier 功能结合使用的完整配置方案。这种组合可以让你享受到：

- **Noice cmdline**: 美观的命令行界面、搜索界面、LSP 文档显示
- **Snacks notifier**: 现代化的通知系统，与 Snacks 生态系统完美集成

## 配置方案

### 1. 启用 Snacks Notifier

首先在 `snacks.lua` 中启用 notifier 模块：

```lua
-- /Users/pengjiecheng/.config/nvim/lua/custom/plugins/snacks.lua
notifier = {
    enabled = true,
    timeout = 3000,
    width = { min = 40, max = 0.4 },
    height = { min = 1, max = 0.6 },
    margin = { top = 0, right = 1, bottom = 0 },
    padding = true,
    sort = { "level", "added" },
    level = vim.log.levels.TRACE,
    icons = {
        error = " ",
        warn = " ",
        info = " ",
        debug = " ",
        trace = " ",
    },
    keep = function(notif)
        return vim.fn.getcmdpos() > 0
    end,
},
```

### 2. 修改 Noice 配置

修改 `noice.lua` 配置，禁用通知功能但保留 cmdline：

```lua
-- /Users/pengjiecheng/.config/nvim/lua/custom/plugins/noice.lua
return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  enabled = true, -- 保持启用
  dependencies = { 'MunifTanjim/nui.nvim' }, -- 移除 nvim-notify 依赖
  opts = {
    -- 保留 LSP 相关功能
    lsp = {
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true,
      },
      hover = { enabled = true },
      signature = { enabled = true },
      message = { enabled = false }, -- 禁用 LSP 消息通知
      documentation = {
        view = 'hover',
        opts = {
          lang = 'markdown',
          replace = true,
          render = 'plain',
          format = { '{message}' },
        },
      },
    },
    
    -- 保留 cmdline 功能
    cmdline = {
      enabled = true,
      view = 'cmdline_popup',
      format = {
        cmdline = { pattern = '^', icon = '❯', lang = 'vim' },
        search_down = { kind = 'search', pattern = '^/', icon = '🔍', lang = 'regex' },
        search_up = { kind = 'search', pattern = '^%?', icon = '🔍', lang = 'regex' },
        filter = { pattern = '^:%s*!', icon = '$', lang = 'bash' },
        lua = {
          pattern = { '^:%s*lua%s+', '^:%s*lua%s*=%s*', '^:%s*=%s*' },
          icon = '',
          lang = 'lua',
        },
        help = { pattern = '^:%s*he?l?p?%s+', icon = '' },
      },
    },
    
    -- 禁用消息和通知功能
    messages = { enabled = false },
    notify = { enabled = false },
    
    -- 保留弹出菜单
    popupmenu = {
      enabled = true,
      backend = 'nui',
    },
    
    -- 保留预设但调整通知相关
    presets = {
      bottom_search = false,
      command_palette = true,
      long_message_to_split = false, -- 禁用长消息分割
      inc_rename = false,
      lsp_doc_border = true,
    },
    
    -- 路由配置：将通知重定向到 Snacks
    routes = {
      {
        filter = {
          event = 'notify',
        },
        view = 'mini', -- 使用最小视图或完全跳过
        opts = { skip = true },
      },
      {
        filter = {
          event = 'msg_show',
          any = {
            { find = '%d+L, %d+B' },
            { find = '; after #%d+' },
            { find = '; before #%d+' },
            { find = '%d fewer lines' },
            { find = '%d more lines' },
          },
        },
        opts = { skip = true },
      },
    },
  },
  
  -- 保留有用的快捷键，移除通知相关的
  keys = {
    {
      '<S-Enter>',
      function()
        require('noice').redirect(vim.fn.getcmdline())
      end,
      mode = 'c',
      desc = 'Redirect Cmdline',
    },
    {
      '<c-f>',
      function()
        if not require('noice.lsp').scroll(4) then
          return '<c-f>'
        end
      end,
      silent = true,
      expr = true,
      desc = 'Scroll Forward',
      mode = { 'i', 'n', 's' },
    },
    {
      '<c-b>',
      function()
        if not require('noice.lsp').scroll(-4) then
          return '<c-b>'
        end
      end,
      silent = true,
      expr = true,
      desc = 'Scroll Backward',
      mode = { 'i', 'n', 's' },
    },
  },
}
```

### 3. 设置 vim.notify 重定向

在 `init.lua` 或适当的配置文件中添加：

```lua
-- 重定向 vim.notify 到 Snacks notifier
vim.defer_fn(function()
  if _G.Snacks and _G.Snacks.notifier then
    vim.notify = function(msg, level, opts)
      return _G.Snacks.notifier.notify(msg, level, opts)
    end
  end
end, 100)
```

## 功能分工

### Noice 负责
- ✅ 命令行界面美化 (`cmdline`)
- ✅ 搜索界面美化 (`search`)
- ✅ LSP 悬停文档 (`lsp.hover`)
- ✅ LSP 签名帮助 (`lsp.signature`)
- ✅ 弹出菜单 (`popupmenu`)
- ✅ 文档滚动功能

### Snacks Notifier 负责
- ✅ 所有通知消息
- ✅ 错误和警告提示
- ✅ 插件状态通知
- ✅ LSP 诊断通知
- ✅ 系统消息通知

## 快捷键配置

在 `snacks.lua` 中添加通知相关快捷键：

```lua
-- 通知管理快捷键
{
  '<leader>un',
  function() Snacks.notifier.hide() end,
  desc = '隐藏所有通知'
},
{
  '<leader>uN',
  function() Snacks.notifier.show_history() end,
  desc = '显示通知历史'
},
{
  '<leader>ud',
  function() 
    Snacks.notifier.hide()
    -- 同时清除 noice 历史（如果需要）
    pcall(function() require('noice').cmd('dismiss') end)
  end,
  desc = '清除所有通知'
},
```

## 优势分析

### 这种组合的优势

1. **最佳用户体验**
   - Noice 的美观命令行界面
   - Snacks 的现代化通知系统

2. **功能互补**
   - Noice 专注于命令行和 LSP 界面
   - Snacks 专注于通知和状态管理

3. **性能优化**
   - 避免功能重复
   - 减少插件冲突
   - 更好的资源利用

4. **维护便利**
   - 两个插件都有活跃维护
   - 配置相对独立

### 与完全使用 Noice 的对比

| 功能 | Noice 完整版 | Noice + Snacks |
|------|-------------|----------------|
| 命令行美化 | ✅ | ✅ |
| 通知系统 | ✅ | ✅ (更现代) |
| LSP 集成 | ✅ | ✅ |
| 与 Snacks 集成 | ❌ | ✅ |
| 配置复杂度 | 中等 | 稍高 |
| 性能 | 良好 | 更好 |

## 迁移步骤

1. **备份当前配置**
   ```bash
   cp ~/.config/nvim/lua/custom/plugins/noice.lua ~/.config/nvim/lua/custom/plugins/noice.lua.bak
   ```

2. **修改 Snacks 配置**
   - 启用 `notifier` 模块
   - 添加通知相关快捷键

3. **修改 Noice 配置**
   - 禁用 `messages` 和 `notify`
   - 保留 `cmdline` 和 `lsp` 功能
   - 添加路由重定向

4. **添加 vim.notify 重定向**
   - 在 `init.lua` 中添加重定向代码

5. **测试功能**
   - 测试命令行界面
   - 测试通知功能
   - 测试 LSP 功能

6. **调整配置**
   - 根据使用体验微调

## 故障排除

### 常见问题

1. **通知不显示**
   - 检查 Snacks notifier 是否启用
   - 确认 vim.notify 重定向是否生效

2. **命令行样式异常**
   - 检查 Noice cmdline 配置
   - 确认没有其他插件冲突

3. **LSP 文档不显示**
   - 检查 Noice lsp 配置
   - 确认 LSP 服务器正常运行

### 调试命令

```lua
-- 检查 Snacks notifier 状态
:lua print(vim.inspect(_G.Snacks and _G.Snacks.notifier))

-- 测试通知功能
:lua Snacks.notifier.notify("测试通知", "info")

-- 检查 vim.notify 重定向
:lua print(vim.inspect(vim.notify))

-- 检查 Noice 状态
:Noice stats
```

## 结论

这种配置方案充分发挥了两个插件的优势：
- **Noice** 提供美观的命令行和 LSP 界面
- **Snacks Notifier** 提供现代化的通知系统

通过合理的配置分工，可以获得最佳的用户体验，同时避免功能冲突和性能问题。这是一个推荐的配置方案，特别适合已经在使用 Snacks 生态系统的用户。