return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy', -- 延迟加载以提升启动性能
  priority = 100, -- 降低优先级，让核心功能先加载
  dependencies = { 'nvim-tree/nvim-web-devicons' }, -- 确保图标依赖
  init = function()
    -- 性能优化：减少初始化开销
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      vim.o.statusline = ' '
    else
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    -- 性能优化：缓存 require 调用
    local lualine_require = require 'lualine_require'
    lualine_require.require = require

    vim.o.laststatus = vim.g.lualine_laststatus

    -- 美化配置：自定义颜色主题
    local colors = {
      bg = '#202328',
      fg = '#bbc2cf',
      yellow = '#ECBE7B',
      cyan = '#008080',
      darkblue = '#081633',
      green = '#98be65',
      orange = '#FF8800',
      violet = '#a9a1e1',
      magenta = '#c678dd',
      blue = '#51afef',
      red = '#ec5f67',
      grey = '#5c6370',
    }

    -- 美化配置：自定义主题
    local custom_theme = {
      normal = {
        a = { fg = colors.bg, bg = colors.blue, gui = 'bold' },
        b = { fg = colors.fg, bg = colors.grey },
        c = { fg = colors.fg, bg = colors.bg },
      },
      insert = {
        a = { fg = colors.bg, bg = colors.green, gui = 'bold' },
        b = { fg = colors.fg, bg = colors.grey },
      },
      visual = {
        a = { fg = colors.bg, bg = colors.violet, gui = 'bold' },
        b = { fg = colors.fg, bg = colors.grey },
      },
      replace = {
        a = { fg = colors.bg, bg = colors.red, gui = 'bold' },
        b = { fg = colors.fg, bg = colors.grey },
      },
      command = {
        a = { fg = colors.bg, bg = colors.yellow, gui = 'bold' },
        b = { fg = colors.fg, bg = colors.grey },
      },
      inactive = {
        a = { fg = colors.grey, bg = colors.bg, gui = 'bold' },
        b = { fg = colors.grey, bg = colors.bg },
        c = { fg = colors.grey, bg = colors.bg },
      },
    }

    local opts = {
      options = {
        theme = custom_theme, -- 使用自定义主题
        globalstatus = vim.o.laststatus == 3,
        -- 性能优化：减少刷新频率
        refresh = {
          statusline = 1000, -- 1秒刷新一次
          tabline = 1000,
          winbar = 1000,
        },
        disabled_filetypes = {
          statusline = { 'dashboard', 'alpha', 'ministarter', 'neo-tree' },
        },
        -- 美化配置：现代化分隔符
        component_separators = { left = '│', right = '│' },
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = {
          {
            'mode',
            -- 美化配置：自定义模式显示
            fmt = function(str)
              local mode_map = {
                ['NORMAL'] = '󰀘 NORMAL',
                ['INSERT'] = '󰏫 INSERT',
                ['VISUAL'] = '󰈈 VISUAL',
                ['V-LINE'] = '󰈈 V-LINE',
                ['V-BLOCK'] = '󰈈 V-BLOCK',
                ['COMMAND'] = ' COMMAND',
                ['REPLACE'] = '󰛔 REPLACE',
                ['TERMINAL'] = ' TERMINAL',
              }
              return mode_map[str] or str
            end,
            separator = { right = '' },
            padding = { left = 1, right = 1 },
          },
        },
        lualine_b = {
          {
            'branch',
            icon = '󰊢', -- 美化配置：更现代的 Git 分支图标
            color = { fg = colors.violet, gui = 'bold' },
            fmt = function(str)
              if #str > 20 then
                return str:sub(1, 17) .. '...' -- 限制分支名长度
              end
              return str
            end,
            separator = { right = '' },
            padding = { left = 1, right = 1 },
          },
        },

        lualine_c = {
          {
            'diagnostics',
            -- 美化配置：更精美的诊断图标
            symbols = {
              error = '󰅚 ',
              warn = '󰀪 ',
              info = '󰋽 ',
              hint = '󰌶 ',
            },
            -- 美化配置：自定义诊断颜色
            diagnostics_color = {
              error = { fg = colors.red },
              warn = { fg = colors.yellow },
              info = { fg = colors.cyan },
              hint = { fg = colors.blue },
            },
            colored = true,
            update_in_insert = false,
            always_visible = false,
            separator = '',
            padding = { left = 1, right = 1 },
          },
          {
            'filetype',
            icon_only = true,
            separator = '',
            padding = { left = 0, right = 1 },
            colored = true,
          },
          {
            'filename',
            path = 1, -- 显示相对路径，更简洁
            -- 美化配置：更现代的文件状态图标
            symbols = {
              modified = '󰷈 ',
              readonly = '󰌾 ',
              unnamed = '󰎞 [No Name]',
              newfile = '󰎔 [New]',
            },
            color = { fg = colors.fg, gui = 'bold' },
            file_status = true,
            newfile_status = true,
            shorting_target = 40,
            -- 美化配置：路径格式化
            path_formatter = function(path)
              -- 简化路径显示，突出重要部分
              if path:match('node_modules') then
                return path:gsub('.*/node_modules/', '📦 ')
              end
              return path
            end,
            separator = '',
            padding = { left = 0, right = 1 },
          },
        },
        lualine_x = {
          -- 美化配置：LSP 状态显示
          {
            function()
              local clients = vim.lsp.get_clients({ bufnr = 0 })
              if #clients == 0 then
                return '󰅚 No LSP'
              end
              local client_names = {}
              for _, client in ipairs(clients) do
                table.insert(client_names, client.name)
              end
              return '󰒋 ' .. table.concat(client_names, ', ')
            end,
            color = { fg = colors.green },
            separator = '',
            padding = { left = 1, right = 1 },
          },
          -- 美化配置：调试状态
          {
            function()
              if not package.loaded['dap'] then
                return ''
              end
              local dap = require 'dap'
              if dap.status then
                local status = dap.status()
                return status and status ~= '' and ('󰃤 ' .. status) or ''
              end
              return ''
            end,
            cond = function()
              return package.loaded['dap'] ~= nil
            end,
            color = { fg = colors.orange },
            separator = '',
            padding = { left = 1, right = 1 },
          },
          -- 美化配置：插件更新状态
          {
            function()
              if not package.loaded['lazy'] then
                return ''
              end
              local lazy_status = require 'lazy.status'
              if lazy_status.updates then
                local updates = lazy_status.updates()
                return updates and updates ~= '' and ('󰚰 ' .. updates) or ''
              end
              return ''
            end,
            cond = function()
              if not package.loaded['lazy'] then
                return false
              end
              local lazy_status = require 'lazy.status'
              return lazy_status.has_updates and lazy_status.has_updates()
            end,
            color = { fg = colors.orange },
            separator = '',
            padding = { left = 1, right = 1 },
          },
          -- 美化配置：Git 差异显示
          {
            'diff',
            symbols = {
              added = '󰐕 ',
              modified = '󰏬 ',
              removed = '󰍵 ',
            },
            diff_color = {
              added = { fg = colors.green },
              modified = { fg = colors.yellow },
              removed = { fg = colors.red },
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added or 0,
                  modified = gitsigns.changed or 0,
                  removed = gitsigns.removed or 0,
                }
              end
              return nil
            end,
            cond = function()
              return vim.b.gitsigns_status_dict ~= nil
            end,
            separator = '',
            padding = { left = 1, right = 1 },
          },
        },
        lualine_y = {
          -- 美化配置：文件编码和格式
          {
            'encoding',
            fmt = function(str)
              return str:upper()
            end,
            color = { fg = colors.cyan },
            separator = '',
            padding = { left = 1, right = 1 },
          },
          {
            'fileformat',
            symbols = {
              unix = '󰌽 LF',
              dos = '󰌾 CRLF',
              mac = '󰌿 CR',
            },
            color = { fg = colors.cyan },
            separator = { left = '' },
            padding = { left = 1, right = 1 },
          },
          -- 美化配置：进度和位置
          {
            'progress',
            fmt = function(str)
              return '󰉸 ' .. str
            end,
            color = { fg = colors.blue },
            separator = '',
            padding = { left = 1, right = 0 },
          },
          {
            'location',
            fmt = function(str)
              return '󰍒 ' .. str
            end,
            color = { fg = colors.blue },
            padding = { left = 1, right = 1 },
          },
        },
        lualine_z = {
          -- 美化配置：时间显示
          {
            function()
              return '󰥔 ' .. os.date '%H:%M'
            end,
            color = { fg = colors.bg, bg = colors.blue, gui = 'bold' },
            separator = { left = '' },
            padding = { left = 1, right = 1 },
          },
        },
      },
      extensions = { 'lazy' },
    }

    return opts
  end,
}

