-- 缩进线 - 炫酷彩色版本 (已禁用，使用 snacks.indent + snacks.scope)
return {
  'lukas-reineke/indent-blankline.nvim',
  enabled = false, -- 禁用以避免与 snacks.indent 冲突
  main = 'ibl',
  event = 'VeryLazy',
  opts = function()
    -- 定义彩色高亮组
    local highlight = {
      'RainbowRed',
      'RainbowYellow',
      'RainbowBlue',
      'RainbowOrange',
      'RainbowGreen',
      'RainbowViolet',
      'RainbowCyan',
    }

    -- 创建高亮组
    local hooks = require 'ibl.hooks'
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, 'RainbowRed', { fg = '#E06C75' })
      vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#E5C07B' })
      vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#61AFEF' })
      vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#D19A66' })
      vim.api.nvim_set_hl(0, 'RainbowGreen', { fg = '#98C379' })
      vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#C678DD' })
      vim.api.nvim_set_hl(0, 'RainbowCyan', { fg = '#56B6C2' })
    end)

    return {
      indent = {
        char = '▏', -- 更细的缩进线字符
        tab_char = '▏',
        highlight = highlight,
      },
      scope = {
        enabled = true,
        show_start = true,
        show_end = true,
        highlight = highlight,
        char = '▎', -- 作用域使用稍粗的线
      },
      exclude = {
        filetypes = {
          'help',
          'alpha',
          'dashboard',
          'neo-tree',
          'Trouble',
          'trouble',
          'lazy',
          'mason',
          'notify',
          'toggleterm',
          'lazyterm',
        },
      },
    }
  end,
}