-- Noice.nvim 配置 - 提供美观的命令行界面
-- 与 Snacks notifier 配合使用：Noice 负责 cmdline，Snacks 负责通知
return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  enabled = true, -- 启用以提供浮动命令行
  dependencies = { 'MunifTanjim/nui.nvim' }, -- 移除 nvim-notify 依赖
  opts = {
    -- 禁用通知功能，使用 Snacks notifier
    messages = {
      enabled = false, -- 禁用消息通知
    },
    notify = {
      enabled = false, -- 禁用通知功能
    },
    
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
    
    -- 启用浮动命令行功能
    cmdline = {
      enabled = true,
      view = 'cmdline_popup', -- 使用弹出式命令行
      opts = {
        win_options = {
          winhighlight = {
            Normal = 'Normal',
            FloatBorder = 'DiagnosticInfo',
          },
        },
      },
      format = {
        cmdline = { pattern = '^:', icon = '❯', lang = 'vim' },
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
    
    -- 弹出菜单配置
    popupmenu = {
      enabled = true,
      backend = 'nui', -- 使用 nui 后端
    },
    
    -- 路由配置 - 将通知重定向到 Snacks
    routes = {
      {
        filter = {
          event = 'notify',
        },
        opts = { skip = true }, -- 跳过通知，让 Snacks 处理
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
        opts = { skip = true }, -- 跳过这些消息
      },
    },
    
    -- 视图配置
    views = {
      cmdline_popup = {
        position = {
          row = 5,
          col = '50%',
        },
        size = {
          width = 60,
          height = 'auto',
        },
        border = {
          style = 'rounded',
          padding = { 0, 1 },
        },
        filter_options = {},
        win_options = {
          winhighlight = 'NormalFloat:NormalFloat,FloatBorder:FloatBorder',
        },
      },
      popupmenu = {
        relative = 'editor',
        position = {
          row = 8,
          col = '50%',
        },
        size = {
          width = 60,
          height = 10,
        },
        border = {
          style = 'rounded',
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = { Normal = 'Normal', FloatBorder = 'DiagnosticInfo' },
        },
      },
    },
  },
  
  -- 快捷键配置
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
      '<leader>snl',
      function()
        require('noice').cmd('last')
      end,
      desc = 'Noice Last Message',
    },
    {
      '<leader>snh',
      function()
        require('noice').cmd('history')
      end,
      desc = 'Noice History',
    },
    {
      '<leader>sna',
      function()
        require('noice').cmd('all')
      end,
      desc = 'Noice All',
    },
    {
      '<leader>snd',
      function()
        require('noice').cmd('dismiss')
      end,
      desc = 'Dismiss All',
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