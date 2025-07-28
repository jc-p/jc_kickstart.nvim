return {
  {
    'numToStr/Comment.nvim',
    opts = {
      -- add any options here
      ---Add a space b/w comment and the line
      padding = true,
      ---Whether the cursor should stay at its position
      sticky = true,
      ---Lines to be ignored while (un)comment
      ignore = nil,
      ---LHS of toggle mappings in NORMAL mode
      toggler = {
        ---Line-comment toggle keymap
        line = 'gcc',
        ---Block-comment toggle keymap
        block = 'gbc',
      },
      ---LHS of operator-pending mappings in NORMAL and VISUAL mode
      opleader = {
        ---Line-comment keymap
        line = 'gc',
        ---Block-comment keymap
        block = 'gb',
      },
      ---LHS of extra mappings
      extra = {
        ---Add comment on the line above
        above = 'gcO',
        ---Add comment on the line below
        below = 'gco',
        ---Add comment at the end of line
        eol = 'gcA',
      },
      ---Enable keybindings
      ---NOTE: If given `false` then the plugin won't create any mappings
      mappings = {
        ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
        basic = true,
        ---Extra mapping; `gco`, `gcO`, `gcA`
        extra = true,
      },
      ---Function to call before (un)comment
      pre_hook = function(ctx)
        -- 为特定文件类型设置注释字符串
        local ft = vim.bo.filetype

        -- 处理特殊文件类型的注释
        if ft == 'development' then
          -- 尝试检测文件内容来确定合适的注释符号
          local line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] or ''

          -- 根据文件内容特征选择注释符号
          if line:match '<.*>' then
            return '<!-- %s -->'
          elseif line:match '^import' or line:match '^from' then
            return '# %s'
          elseif line:match '^function' or line:match '^var' then
            return '// %s'
          else
            -- 默认使用 # 注释，适用于大多数脚本语言
            return '# %s'
          end
        end
      end,
      ---Function to call after (un)comment
      post_hook = nil,
    },
  },
  {
    'folke/ts-comments.nvim',
    event = 'VeryLazy',
    opts = {},
  },
}
