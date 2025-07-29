return {
  {
    'akinsho/bufferline.nvim',
    version = 'v4.*',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = 'VeryLazy',

    config = function()
      local bufferline = require 'bufferline'

      bufferline.setup {
        options = {
          mode = 'buffers',
          style_preset = bufferline.style_preset.default,
          themable = true,
          
          -- 基础功能配置
          numbers = function(opts)
            return string.format('%s', opts.ordinal)
          end,
          close_command = 'bdelete! %d',
          right_mouse_command = 'bdelete! %d',
          left_mouse_command = 'buffer %d',
          
          -- 指示器和图标
          indicator = {
            icon = '▎',
            style = 'icon',
          },
          buffer_close_icon = '󰅖',
          modified_icon = '●',
          close_icon = '󰅖',
          
          -- 显示设置
          show_buffer_icons = true,
          show_buffer_close_icons = true,
          show_close_icon = true,
          color_icons = true,
          
          -- 名称和大小限制
          max_name_length = 18,
          max_prefix_length = 15,
          truncate_names = true,
          tab_size = 18,
          
          -- LSP 诊断
          diagnostics = 'nvim_lsp',
          diagnostics_update_on_event = true,
          diagnostics_indicator = function(count, level)
            local icon = level:match('error') and ' ' or ' '
            return ' ' .. icon .. count
          end,
          
          -- 分隔符
          separator_style = 'slant',
          
          -- 过滤器 - 简化版本
          custom_filter = function(buf_number)
            local filetype = vim.bo[buf_number].filetype
            local bufname = vim.fn.bufname(buf_number)
            
            -- 排除特殊文件类型
            local excluded = {
              'qf', 'help', 'man', 'lspinfo', 'NvimTree', 'neo-tree', 
              'Trouble', 'alpha', 'dashboard', 'toggleterm'
            }
            
            for _, ft in ipairs(excluded) do
              if filetype == ft then
                return false
              end
            end
            
            -- 排除临时文件
            if bufname:match('^term://') or bufname:match('COMMIT_EDITMSG') then
              return false
            end
            
            return true
          end,
          
          -- 侧边栏偏移
          offsets = {
            {
              filetype = 'NvimTree',
              text = 'File Explorer',
              text_align = 'center',
              separator = true,
            },
            {
              filetype = 'neo-tree',
              text = 'Neo Tree',
              text_align = 'center',
              separator = true,
            },
          },
          
          -- 其他基础选项
          always_show_bufferline = true,
          show_tab_indicators = true,
          persist_buffer_sort = true,
          
          -- 悬停效果
          hover = {
            enabled = true,
            delay = 200,
            reveal = { 'close' }
          },
        },
      }
    end,
  },
}
