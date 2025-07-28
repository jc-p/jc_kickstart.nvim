return {
  {
    'windwp/nvim-autopairs',
    enabled = false,
    config = function()
      require('nvim-autopairs').setup {
	enable_check_bracket_line = false,
	ignored_next_char = '[$w%.]',
        disable_filetype = { 'TelescopePrompt', 'vim' },
        fast_wrap = {
          map = '<M-e>', -- Alt+e 快速跳出括号
          chars = { '{', '[', '(', '"', "'" },
          pattern = [=[[%'%"%)%>%]%)%}%,]]=],
          end_key = '$',
          keys = 'qwertyuiopzxcvbnmasdfghjkl',
          check_comma = true,
          highlight = 'Search',
        },
      }
    end,
  },
}
