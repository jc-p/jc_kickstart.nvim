return {
  {
    'akinsho/bufferline.nvim',
    version = 'v4.*', -- 锁定兼容版本
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- 强制声明依赖
    event = 'VeryLazy', -- 延迟加载优化性能

    config = function()
      local bufferline = require 'bufferline'

      -- 美化配置：自定义颜色主题
      local colors = {
        bg = '#1e1e2e',
        fg = '#cdd6f4',
        bg_alt = '#313244',
        blue = '#89b4fa',
        green = '#a6e3a1',
        yellow = '#f9e2af',
        red = '#f38ba8',
        orange = '#fab387',
        purple = '#cba6f7',
        cyan = '#94e2d5',
        grey = '#6c7086',
        dark_grey = '#45475a',
      }

      local options = {
        mode = 'buffers', -- 显示缓冲区而非标签页
        style_preset = bufferline.style_preset.default,
        themable = true,
        -- 美化配置：显示缓冲区编号
        numbers = function(opts)
          return string.format('%s', opts.ordinal)
        end,
        close_command = 'bdelete! %d',
        right_mouse_command = 'bdelete! %d',
        left_mouse_command = 'buffer %d',
        middle_mouse_command = nil,
        -- 美化配置：现代化指示器
        indicator = {
          icon = '󰅂', -- 更现代的指示器图标
          style = 'icon',
        },
        -- 美化配置：更精美的图标
        buffer_close_icon = '󰅙',
        modified_icon = '󰷈',
        close_icon = '󰅖',
        left_trunc_marker = '󰍞',
        right_trunc_marker = '󰍟',
        -- 美化配置：智能文件名格式化
        name_formatter = function(buf)
          -- 为特殊文件类型添加图标前缀
          local name = buf.name
          local path = buf.path
          
          -- 处理特殊文件
          if name:match('%.config') then
            return '󰒓 ' .. name
          elseif name:match('package%.json') then
            return '󰎙 ' .. name
          elseif name:match('%.md$') then
            return '󰍔 ' .. name
          elseif name:match('%.lua$') then
            return '󰢱 ' .. name
          elseif name:match('%.js$') or name:match('%.ts$') then
            return '󰌞 ' .. name
          elseif name:match('%.vue$') then
            return '󰡄 ' .. name
          elseif path and path:match('node_modules') then
            return '📦 ' .. name
          end
          
          return name
        end,
        max_name_length = 20, -- 增加名称长度限制
        max_prefix_length = 15,
        truncate_names = true,
        tab_size = 20, -- 增加标签大小
        diagnostics = 'nvim_lsp',
        diagnostics_update_on_event = true,
        -- 美化配置：自定义诊断指示器
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local icon = level:match('error') and '󰅚' or level:match('warning') and '󰀪' or '󰋽'
          return ' ' .. icon .. count
        end,
        -- 美化配置：图标和分隔符设置
        get_element_icon = function(element)
          local icon, hl = require('nvim-web-devicons').get_icon_by_filetype(element.filetype, { default = false })
          return icon, hl
        end,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        color_icons = true,
        -- 美化配置：自定义分隔符
        separator_style = { '│', '│' }, -- 使用竖线分隔符
        -- 美化配置：固定标签图标
        icon_pinned = '󰐃',
        -- 美化配置：智能过滤器
        custom_filter = function(buf_number, buf_numbers)
          local filetype = vim.bo[buf_number].filetype
          local bufname = vim.fn.bufname(buf_number)
          
          -- 过滤掉不需要显示的文件类型
          local excluded_filetypes = {
            'qf', 'help', 'man', 'lspinfo', 'spectre_panel',
            'startify', 'dashboard', 'packer', 'neogitstatus',
            'NvimTree', 'neo-tree', 'Trouble', 'alpha', 'lir',
            'Outline', 'symbols-outline', 'toggleterm'
          }
          
          for _, ft in ipairs(excluded_filetypes) do
            if filetype == ft then
              return false
            end
          end
          
          -- 过滤掉临时文件和特殊缓冲区
          if bufname:match('^term://') or bufname:match('COMMIT_EDITMSG') then
            return false
          end
          
          return true
        end,
        -- 美化配置：侧边栏偏移设置
        offsets = {
          {
            filetype = 'NvimTree',
            text = '󰉋 File Explorer',
            text_align = 'center',
            separator = true,
            highlight = 'Directory',
          },
          {
            filetype = 'neo-tree',
            text = '󰉋 Neo Tree',
            text_align = 'center',
            separator = true,
            highlight = 'Directory',
          },
          {
            filetype = 'Outline',
            text = '󰘦 Symbols Outline',
            text_align = 'center',
            separator = true,
            highlight = 'TSType',
          },
        },
      }

      -- 美化配置：其他选项设置
      options.show_tab_indicators = true
      options.show_duplicate_prefix = true
      options.duplicates_across_groups = false
      options.persist_buffer_sort = true
      options.move_wraps_at_ends = false
      options.enforce_regular_tabs = false
      options.always_show_bufferline = true
      options.auto_toggle_bufferline = true
      
      -- 美化配置：悬停效果
      options.hover = {
        enabled = true,
        delay = 150, -- 减少延迟，提升响应性
        reveal = { 'close' }
      }
      
      -- 美化配置：智能排序
      options.sort_by = function(buffer_a, buffer_b)
        -- 优先显示当前工作目录的文件
        local cwd = vim.fn.getcwd()
        local a_in_cwd = buffer_a.path:find(cwd, 1, true) == 1
        local b_in_cwd = buffer_b.path:find(cwd, 1, true) == 1
        
        if a_in_cwd and not b_in_cwd then
          return true
        elseif not a_in_cwd and b_in_cwd then
          return false
        end
        
        -- 其次按文件类型排序
        local a_ext = buffer_a.path:match('%.([^%.]+)$') or ''
        local b_ext = buffer_b.path:match('%.([^%.]+)$') or ''
        
        if a_ext ~= b_ext then
          return a_ext < b_ext
        end
        
        -- 最后按文件名排序
        return buffer_a.name < buffer_b.name
      end
      
      -- 美化配置：快速选择字母表
      options.pick = {
        alphabet = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP1234567890',
      }

      -- 美化配置：自定义高亮组
      local highlights = {
        fill = {
          bg = colors.bg,
        },
        background = {
          fg = colors.grey,
          bg = colors.bg_alt,
        },
        buffer_visible = {
          fg = colors.fg,
          bg = colors.bg_alt,
        },
        buffer_selected = {
          fg = colors.fg,
          bg = colors.bg,
          bold = true,
          italic = false,
        },
        tab = {
          fg = colors.grey,
          bg = colors.bg_alt,
        },
        tab_selected = {
          fg = colors.blue,
          bg = colors.bg,
        },
        tab_close = {
          fg = colors.red,
          bg = colors.bg_alt,
        },
        close_button = {
          fg = colors.grey,
          bg = colors.bg_alt,
        },
        close_button_visible = {
          fg = colors.grey,
          bg = colors.bg_alt,
        },
        close_button_selected = {
          fg = colors.red,
          bg = colors.bg,
        },
        indicator_selected = {
          fg = colors.blue,
          bg = colors.bg,
        },
        modified = {
          fg = colors.yellow,
          bg = colors.bg_alt,
        },
        modified_visible = {
          fg = colors.yellow,
          bg = colors.bg_alt,
        },
        modified_selected = {
          fg = colors.green,
          bg = colors.bg,
        },
        duplicate_selected = {
          fg = colors.purple,
          bg = colors.bg,
          italic = true,
        },
        duplicate_visible = {
          fg = colors.purple,
          bg = colors.bg_alt,
          italic = true,
        },
        duplicate = {
          fg = colors.purple,
          bg = colors.bg_alt,
          italic = true,
        },
        separator = {
          fg = colors.dark_grey,
          bg = colors.bg_alt,
        },
        separator_selected = {
          fg = colors.dark_grey,
          bg = colors.bg,
        },
        separator_visible = {
          fg = colors.dark_grey,
          bg = colors.bg_alt,
        },
        offset_separator = {
          fg = colors.dark_grey,
          bg = colors.bg,
        },
      }

      bufferline.setup {
        options = options,
        highlights = highlights,
      }
    end,
  },
}
